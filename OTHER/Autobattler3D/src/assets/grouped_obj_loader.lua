local GroupedObjLoader = {}

local materialCache = {}

local vertexFormat = {
  { 'VertexPosition', 'f32x3' },
  { 'VertexNormal', 'f32x3' },
  { 'VertexUV', 'f32x2' },
  { 'VertexUV2', 'un16x2' },
  { 'VertexColor', 'un8x4' }
}


-- Загружает и кэширует материал.
local function loadMaterial(path)
  if materialCache[path] then
    return materialCache[path]
  end

  local texture =
    lovr.graphics.newTexture(path)

  local material =
    lovr.graphics.newMaterial({
      texture = texture
    })

  materialCache[path] = material

  return material
end


-- Преобразует индекс OBJ.
local function resolveIndex(
  index,
  count
)
  index = tonumber(index)

  if not index then
    return nil
  end

  if index < 0 then
    return count + index + 1
  end

  return index
end


-- Разбирает ссылку вершины.
local function parseFaceReference(
  reference,
  positionCount,
  uvCount,
  normalCount
)
  local positionIndex,
    uvIndex,
    normalIndex =
    reference:match(
      '^(-?%d+)/?(-?%d*)/?(-?%d*)$'
    )

  assert(
    positionIndex,
    'Invalid OBJ face: ' ..
    tostring(reference)
  )

  return {
    position =
      resolveIndex(
        positionIndex,
        positionCount
      ),

    uv =
      resolveIndex(
        uvIndex,
        uvCount
      ),

    normal =
      resolveIndex(
        normalIndex,
        normalCount
      )
  }
end


-- Создаёт вершину Mesh.
local function createVertex(
  reference,
  positions,
  uvs,
  normals,
  flipV
)
  local position =
    assert(
      positions[
        reference.position
      ],
      'Invalid OBJ position index'
    )

  local uv =
    uvs[reference.uv]
    or {
      0, 0
    }

  local normal =
    normals[reference.normal]
    or {
      0, 1, 0
    }

  local textureV = uv[2]

  if flipV then
    textureV = 1 - textureV
  end

  return {
    position[1],
    position[2],
    position[3],

    normal[1],
    normal[2],
    normal[3],

    uv[1],
    textureV,

    0,
    0,

    1,
    1,
    1,
    1
  }
end


-- Возвращает группу геометрии.
local function getGroup(
  groups,
  groupOrder,
  groupName,
  materialName
)
  groupName =
    groupName or 'default'

  materialName =
    materialName or 'default'

  local key =
    groupName ..
    ':' ..
    materialName

  if groups[key] then
    return groups[key]
  end

  local group = {
    name = groupName,
    materialName = materialName,
    vertices = {}
  }

  groups[key] = group

  groupOrder[
    #groupOrder + 1
  ] = group

  return group
end


-- Добавляет треугольник.
local function addTriangle(
  group,
  first,
  second,
  third,
  positions,
  uvs,
  normals,
  flipV
)
  group.vertices[
    #group.vertices + 1
  ] = createVertex(
    first,
    positions,
    uvs,
    normals,
    flipV
  )

  group.vertices[
    #group.vertices + 1
  ] = createVertex(
    second,
    positions,
    uvs,
    normals,
    flipV
  )

  group.vertices[
    #group.vertices + 1
  ] = createVertex(
    third,
    positions,
    uvs,
    normals,
    flipV
  )
end


-- Загружает OBJ по группам geoset.
function GroupedObjLoader.load(
  definition
)
  local contents, errorMessage =
    lovr.filesystem.read(
      definition.path
    )

  assert(
    contents,
    string.format(
      'Unable to read OBJ "%s": %s',
      definition.path,
      tostring(errorMessage)
    )
  )

  local positions = {}
  local uvs = {}
  local normals = {}

  local groups = {}
  local groupOrder = {}

  local currentGroup = 'default'
  local currentMaterial = 'default'

  local flipV =
    definition.flipV ~= false

  for rawLine in contents:gmatch(
    '[^\r\n]+'
  ) do
    local line =
      rawLine:gsub('#.*$', '')

    local command, arguments =
      line:match(
        '^%s*(%S+)%s*(.-)%s*$'
      )

    if command == 'v' then
      local x, y, z =
        arguments:match(
          '([^%s]+)%s+([^%s]+)%s+([^%s]+)'
        )

      positions[#positions + 1] = {
        assert(tonumber(x)),
        assert(tonumber(y)),
        assert(tonumber(z))
      }

    elseif command == 'vt' then
      local u, v =
        arguments:match(
          '([^%s]+)%s+([^%s]+)'
        )

      uvs[#uvs + 1] = {
        assert(tonumber(u)),
        assert(tonumber(v))
      }

    elseif command == 'vn' then
      local x, y, z =
        arguments:match(
          '([^%s]+)%s+([^%s]+)%s+([^%s]+)'
        )

      normals[#normals + 1] = {
        assert(tonumber(x)),
        assert(tonumber(y)),
        assert(tonumber(z))
      }

    elseif
      command == 'o'
      or command == 'g'
    then
      currentGroup =
        arguments:match('%S+')
        or 'default'

    elseif command == 'usemtl' then
      currentMaterial =
        arguments:match('%S+')
        or 'default'

    elseif command == 'f' then
      local references = {}

      for reference in arguments:gmatch(
        '%S+'
      ) do
        references[
          #references + 1
        ] = parseFaceReference(
          reference,
          #positions,
          #uvs,
          #normals
        )
      end

      if #references >= 3 then
        local group =
          getGroup(
            groups,
            groupOrder,
            currentGroup,
            currentMaterial
          )

        for index = 2,
          #references - 1
        do
          addTriangle(
            group,
            references[1],
            references[index],
            references[index + 1],
            positions,
            uvs,
            normals,
            flipV
          )
        end
      end
    end
  end

  local asset = {
    kind = 'grouped_obj',
    definition = definition,
    parts = {}
  }

  for _, group in ipairs(
    groupOrder
  ) do
    if #group.vertices > 0 then
		local materialDescription =
		  definition.materials[
			group.name
		  ]
		  or definition.materials[
			group.materialName
		  ]
		  or definition.materials.default

		assert(
		  materialDescription,
		  string.format(
			'OBJ group "%s" has no texture',
			group.name
		  )
		)

	local texturePath
	local transparent = false

	if
	  type(materialDescription) ==
	  'table'
	then
	  texturePath =
		materialDescription.texture

	  transparent =
		materialDescription.transparent
		  == true
	else
	  texturePath =
		materialDescription
	end

      assert(
        texturePath,
        string.format(
          'OBJ group "%s" has no texture',
          group.name
        )
      )

      local mesh =
        lovr.graphics.newMesh(
          vertexFormat,
          group.vertices,
          'gpu',
          'triangles'
        )

      mesh:setBoundingBox(
        -10000, 10000,
        -10000, 10000,
        -10000, 10000
      )

      local material =
        loadMaterial(texturePath)

      mesh:setMaterial(material)

		asset.parts[
		  #asset.parts + 1
		] = {
		  name = group.name,
		  mesh = mesh,
		  material = material,
		  transparent = transparent
		}
    end
  end

  assert(
    #asset.parts > 0,
    'Grouped OBJ has no geometry: ' ..
    definition.path
  )

  return asset
end


return GroupedObjLoader