local MultiObjLoader = {}

local materialCache = {}


-- Загружает и кэширует материал.
local function getMaterial(texturePath)
  local key =
    texturePath or '__default'

  if materialCache[key] then
    return materialCache[key]
  end

  local settings = {}

  if texturePath then
    settings.texture =
      lovr.graphics.newTexture(
        texturePath
      )
  end

  local material =
    lovr.graphics.newMaterial(
      settings
    )

  materialCache[key] = material

  return material
end


-- Загружает составную OBJ-модель.
function MultiObjLoader.load(definition)
  local asset = {
    kind = 'grouped_obj',
    definition = definition,
    parts = {}
  }

  assert(
    definition.parts
    and #definition.parts > 0,
    'Multi OBJ model has no parts: ' ..
    tostring(definition.id)
  )

  for _, part in ipairs(
    definition.parts
  ) do
    local path =
      assert(
        part.path,
        'Multi OBJ part has no path'
      )

    asset.parts[
      #asset.parts + 1
    ] = {
      id = part.id,
      mesh =
        lovr.graphics.newModel(
          path
        ),

      material =
        getMaterial(
          part.texture
        ),

      transparent =
        part.transparent == true
    }
  end

  return asset
end


return MultiObjLoader