local Binary = require('src.md3.binary')

local Md3Loader = {}
local materialCache = {}


local vertexFormat = {
  { 'VertexPosition', 'f32x3' },
  { 'VertexNormal', 'sn10x3' },
  { 'VertexUV', 'f32x2' },
  { 'VertexUV2', 'un16x2' },
  { 'VertexColor', 'un8x4' }
}


-- Преобразует нормаль MD3 в вектор.
local function decodeNormal(
  firstByte,
  secondByte
)
  local latitude =
    firstByte * math.pi * 2 / 255

  local longitude =
    secondByte * math.pi * 2 / 255

  local x =
    math.cos(latitude) *
    math.sin(longitude)

  local y =
    math.sin(latitude) *
    math.sin(longitude)

  local z =
    math.cos(longitude)

  return x, y, z
end


-- Преобразует координаты MD3 в LÖVR.
local function convertPosition(
  x,
  y,
  z,
  zOffset
)
  return x, z + zOffset, -y
end


-- Преобразует нормаль MD3 в LÖVR.
local function convertNormal(x, y, z)
  return x, z, -y
end


-- Загружает и кэширует материал.
local function loadMaterial(texturePath)
  if not texturePath then
    return nil
  end

  if materialCache[texturePath] then
    return materialCache[texturePath]
  end

  local texture =
    lovr.graphics.newTexture(
      texturePath
    )

  local material =
    lovr.graphics.newMaterial({
      texture = texture
    })

  materialCache[texturePath] =
    material

  return material
end


-- Возвращает текстуру поверхности.
local function getSurfaceTexture(
  texturePaths,
  surfaceIndex,
  surfaceName
)
  if type(texturePaths) == 'string' then
    return texturePaths
  end

  if type(texturePaths) ~= 'table' then
    return nil
  end

  return
    texturePaths[surfaceName]
    or texturePaths[surfaceIndex]
    or texturePaths.default
end


-- Проверяет индекс вершины.
local function isValidVertexIndex(
  index,
  vertexCount
)
  return
    index >= 1
    and index <= vertexCount
end


-- Читает постоянные данные поверхности.
local function readSurfaceData(
  reader,
  surfaceOffset,
  texturePath,
  zOffset
)
  local identifier =
    reader:string(
      surfaceOffset,
      4
    )

  assert(
    identifier == 'IDP3',
    'Invalid MD3 surface'
  )

  local name =
    reader:string(
      surfaceOffset + 4,
      64
    )

  local frameCount =
    reader:i32(
      surfaceOffset + 72
    )

  local vertexCount =
    reader:i32(
      surfaceOffset + 80
    )

  local triangleCount =
    reader:i32(
      surfaceOffset + 84
    )

  local trianglesOffset =
    reader:i32(
      surfaceOffset + 88
    )

  local textureCoordinatesOffset =
    reader:i32(
      surfaceOffset + 96
    )

  local verticesOffset =
    reader:i32(
      surfaceOffset + 100
    )

  local surfaceEndOffset =
    reader:i32(
      surfaceOffset + 104
    )

  assert(
    frameCount > 0,
    'MD3 surface has no frames: ' ..
    name
  )

  assert(
    vertexCount > 0,
    'MD3 surface has no vertices: ' ..
    name
  )

  local textureCoordinates = {}

  for vertexIndex =
    0,
    vertexCount - 1
  do
    local offset =
      surfaceOffset +
      textureCoordinatesOffset +
      vertexIndex * 8

    textureCoordinates[
      vertexIndex + 1
    ] = {
      reader:f32(offset),
      reader:f32(offset + 4)
    }
  end

  local expandedIndices = {}
  local skippedTriangles = 0

  for triangleIndex =
    0,
    triangleCount - 1
  do
    local offset =
      surfaceOffset +
      trianglesOffset +
      triangleIndex * 12

    local first =
      reader:i32(offset) + 1

    local second =
      reader:i32(offset + 4) + 1

    local third =
      reader:i32(offset + 8) + 1

    local valid =
      isValidVertexIndex(
        first,
        vertexCount
      )
      and isValidVertexIndex(
        second,
        vertexCount
      )
      and isValidVertexIndex(
        third,
        vertexCount
      )

    if valid then
      expandedIndices[
        #expandedIndices + 1
      ] = first

      expandedIndices[
        #expandedIndices + 1
      ] = second

      expandedIndices[
        #expandedIndices + 1
      ] = third
    else
      skippedTriangles =
        skippedTriangles + 1
    end
  end

  print(string.format(
    'MD3 "%s": vertices=%d, triangles=%d, skipped=%d',
    name,
    vertexCount,
    triangleCount,
    skippedTriangles
  ))

  return {
    name = name,
    reader = reader,

    surfaceOffset =
      surfaceOffset,

    verticesOffset =
      verticesOffset,

    frameCount =
      frameCount,

    vertexCount =
      vertexCount,

    textureCoordinates =
      textureCoordinates,

    expandedIndices =
      expandedIndices,

    zOffset =
      zOffset,

    material =
      loadMaterial(texturePath),

    nextSurfaceOffset =
      surfaceOffset +
      surfaceEndOffset
  }
end


-- Создаёт вершины поверхности
-- для указанного кадра.
local function createSurfaceVertices(
  surface,
  frame
)
  assert(
    frame >= 0
    and frame < surface.frameCount,
    string.format(
      'Surface "%s" has no frame %d',
      surface.name,
      frame
    )
  )

  local vertices = {}

  for expandedIndex, sourceIndex in ipairs(
    surface.expandedIndices
  ) do
    local sourceVertexIndex =
      sourceIndex - 1

    local vertexOffset =
      surface.surfaceOffset +
      surface.verticesOffset +
      (
        frame *
        surface.vertexCount +
        sourceVertexIndex
      ) * 8

    local md3X =
      surface.reader:i16(
        vertexOffset
      ) / 64

    local md3Y =
      surface.reader:i16(
        vertexOffset + 2
      ) / 64

    local md3Z =
      surface.reader:i16(
        vertexOffset + 4
      ) / 64

    local normalX,
      normalY,
      normalZ =
      decodeNormal(
        surface.reader:u8(
          vertexOffset + 6
        ),
        surface.reader:u8(
          vertexOffset + 7
        )
      )

    local x, y, z =
      convertPosition(
        md3X,
        md3Y,
        md3Z,
        surface.zOffset
      )

    normalX,
      normalY,
      normalZ =
      convertNormal(
        normalX,
        normalY,
        normalZ
      )

    local uv =
      surface.textureCoordinates[
        sourceIndex
      ]

    vertices[expandedIndex] = {
      -- VertexPosition.
      x,
      y,
      z,

      -- VertexNormal.
      normalX,
      normalY,
      normalZ,

      -- VertexUV.
      uv[1],
      uv[2],

      -- VertexUV2.
      0,
      0,

      -- VertexColor.
      1,
      1,
      1,
      1
    }
  end

  return vertices
end


-- Создаёт неизменяемый Mesh
-- одного кадра поверхности.
local function createSurfaceFrame(
  surfaceData,
  frame
)
  local vertices =
    createSurfaceVertices(
      surfaceData,
      frame
    )

  local mesh =
    lovr.graphics.newMesh(
      vertexFormat,
      vertices,
      'gpu',
      'triangles'
    )

  mesh:setBoundingBox(
    -10000, 10000,
    -10000, 10000,
    -10000, 10000
  )

  if surfaceData.material then
    mesh:setMaterial(
      surfaceData.material
    )
  end

  return {
    data = surfaceData,
    mesh = mesh,
    frame = frame
  }
end


-- Загружает данные MD3-файла.
function Md3Loader.loadData(
  modelPath,
  texturePaths,
  zOffset
)
  texturePaths =
    texturePaths or {}

  zOffset =
    zOffset or 0

  local data, errorMessage =
    lovr.filesystem.read(
      modelPath
    )

  assert(
    data,
    string.format(
      'Unable to read MD3 "%s": %s',
      modelPath,
      tostring(errorMessage)
    )
  )

  local reader =
    Binary.new(data)

  local identifier =
    reader:string(0, 4)

  local version =
    reader:i32(4)

  assert(
    identifier == 'IDP3',
    modelPath ..
    ' is not an MD3 file'
  )

  assert(
    version == 15,
    'Unsupported MD3 version: ' ..
    tostring(version)
  )

  local frameCount =
    reader:i32(76)

  local surfaceCount =
    reader:i32(84)

  local surfaceOffset =
    reader:i32(100)

  local result = {
    path = modelPath,
    frameCount = frameCount,
    surfaces = {},

    -- Готовые кадры создаются один раз
    -- и разделяются всеми экземплярами.
    frameCache = {}
  }

  for surfaceIndex =
    1,
    surfaceCount
  do
    local surfaceName =
      reader:string(
        surfaceOffset + 4,
        64
      )

    local texturePath =
      getSurfaceTexture(
        texturePaths,
        surfaceIndex,
        surfaceName
      )

    local surface =
      readSurfaceData(
        reader,
        surfaceOffset,
        texturePath,
        zOffset
      )

    result.surfaces[
      #result.surfaces + 1
    ] = surface

    surfaceOffset =
      surface.nextSurfaceOffset
  end


  -- Проверяет номер кадра.
  function result:validateFrame(frame)
    assert(
      frame >= 0
      and frame < self.frameCount,
      string.format(
        '"%s" has no frame %d',
        self.path,
        frame
      )
    )
  end


  -- Создаёт или возвращает
  -- общий закэшированный кадр.
  function result:getFrame(frame)
    self:validateFrame(frame)

    if self.frameCache[frame] then
      return self.frameCache[frame]
    end

    local frameData = {
      frame = frame,
      surfaces = {}
    }

    for _, surfaceData in ipairs(
      self.surfaces
    ) do
      frameData.surfaces[
        #frameData.surfaces + 1
      ] = createSurfaceFrame(
        surfaceData,
        frame
      )
    end

    self.frameCache[frame] =
      frameData

    return frameData
  end


  -- Заранее создаёт один кадр.
  function result:preloadFrame(frame)
    self:getFrame(frame)
  end


  -- Заранее создаёт диапазон кадров.
  function result:preloadFrames(
    firstFrame,
    lastFrame
  )
    firstFrame =
      firstFrame or 0

    lastFrame =
      lastFrame or
      self.frameCount - 1

    for frame =
      firstFrame,
      lastFrame
    do
      self:getFrame(frame)
    end
  end


  -- Возвращает число готовых кадров.
  function result:getCachedFrameCount()
    local count = 0

    for _ in pairs(
      self.frameCache
    ) do
      count = count + 1
    end

    return count
  end


  -- Создаёт лёгкий экземпляр MD3.
  -- Mesh больше не создаётся для
  -- каждого отдельного монстра.
  function result:createInstance()
    local instance = {
      data = self,
      currentFrame = nil,
      currentFrameData = nil
    }


    -- Выбирает общий готовый кадр.
    function instance:setFrame(frame)
      if
        self.currentFrame == frame
        and self.currentFrameData
      then
        return
      end

      self.currentFrameData =
        self.data:getFrame(frame)

      self.currentFrame =
        frame
    end


    -- Рисует поверхности
    -- выбранного общего кадра.
    function instance:draw(
      pass,
      x,
      y,
      z,
      scale,
      yaw,
      defaultMaterial,
      alpha,
	  tint
    )
      if not self.currentFrameData then
        return
      end

      local drawAlpha = alpha

      if drawAlpha == nil then
        drawAlpha = 1
      end

	  local drawTint = tint or { 1, 1, 1, 1 }

      for _, surface in ipairs(
        self.currentFrameData.surfaces
      ) do
        if surface.data.material then
          surface.mesh:setMaterial(
            surface.data.material
          )

          pass:setMaterial(
            surface.data.material
          )

        elseif defaultMaterial then
          pass:setMaterial(
            defaultMaterial
          )
        end

		pass:setColor(
		  drawTint[1],
		  drawTint[2],
		  drawTint[3],
		  (drawTint[4] or 1) *
			drawAlpha
		)
        pass:draw(
          surface.mesh,

          x or 0,
          y or 0,
          z or 0,

          scale or 1,

          yaw or 0,
          0, 1, 0
        )
      end

      pass:setColor(
        1,
        1,
        1,
        1
      )

      if defaultMaterial then
        pass:setMaterial(
          defaultMaterial
        )
      end
    end


    -- Нулевой кадр нужен как
    -- безопасное начальное состояние.
    instance:setFrame(0)

    return instance
  end


  return result
end


return Md3Loader