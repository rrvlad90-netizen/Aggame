local BuildingFactory = {}


-- Копирует описание части MD3-модели.
local function copyPart(part)
  return {
    id = part.id,
    path = part.path,
    texture = part.texture,
    textures = part.textures,

    frameOffset =
      part.frameOffset or 0,

    zOffset =
      part.zOffset or 0
  }
end


-- Собирает список частей здания.
local function createParts(settings)
  local parts = {}

  if settings.parts then
    for _, part in ipairs(
      settings.parts
    ) do
      parts[#parts + 1] =
        copyPart(part)
    end

    return parts
  end

  parts[1] = {
    id = 'building',

    path =
      assert(
        settings.path,
        'Building model has no path'
      ),

    texture = settings.texture,
    textures = settings.textures,

    frameOffset = 0,

    zOffset =
      settings.zOffset or 0
  }

  return parts
end


-- Создаёт описание статичной MD3-модели здания.
function BuildingFactory.create(settings)
  assert(
    settings.id,
    'Building model has no id'
  )

  local modelSet = {
    parts = createParts(settings)
  }

  return {
    id = settings.id,
    format = 'md3',

    scale = settings.scale or 1,
    yOffset = settings.yOffset or 0,

    rotationOffset =
      settings.rotationOffset or 0,

    solid = true,

    collider = {
      type = 'circle',

      radius =
        settings.colliderRadius or 3
    },

    sourceFrameBase = 1,
    defaultModelSet = 'idle',
    defaultAnimation = 'idle',

    preloadAnimations = {
      'idle'
    },

    modelSets = {
      idle = modelSet
    },

    battleAnimations = {
      idle = 'idle'
    },

    animations = {
      idle = {
        modelSet = 'idle',
        firstFrame = 1,
        lastFrame = 1,
        fps = 1,
        loop = true
      }
    }
  }
end


return BuildingFactory