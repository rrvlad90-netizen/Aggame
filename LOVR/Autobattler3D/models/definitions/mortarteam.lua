local TEXTURE =
  'models/mortarteam/MortarTeam.jpg'


-- Создаёт четыре части расчёта.
local function createParts(animation)
  local parts = {}

  for index = 0, 3 do
    parts[#parts + 1] = {
      id = 'member' .. index,

      path = string.format(
        'models/mortarteam/mortira%d%s.md3',
        index,
        animation
      ),

      texture = TEXTURE
    }
  end

  return parts
end


return {
  id = 'mortarteam',
  format = 'md3',

  scale = .011,
  yOffset = .35,
  rotationOffset = math.rad(98.3),

  solid = true,

  collider = {
    type = 'circle',
    radius = .75
  },

  sourceFrameBase = 1,
  defaultModelSet = 'attack',
  defaultAnimation = 'idle',

  modelSets = {
    walk = {
      parts = createParts('walk')
    },

    attack = {
      parts = createParts('att')
    },

    death = {
      parts = createParts('death')
    }
  },

  battleAnimations = {
    idle = 'idle',
    forward = 'walk',
    backward = 'walk',
    sideways = 'walk',

    attacks = {},

    ranged = {
      start = 'missile_start',
      fire = 'missile_fire',
      finish = 'missile_end'
    },

    deaths = {
      'death'
    }
  },

  animations = {
    idle = {
      modelSet = 'attack',
      firstFrame = 1,
      lastFrame = 1,
      fps = 1,
      loop = true
    },

    walk = {
      modelSet = 'walk',
      firstFrame = 1,
      lastFrame = 16,
      fps = 12,
      loop = true
    },

    missile_start = {
      modelSet = 'attack',
      firstFrame = 1,
      lastFrame = 15,
      fps = 12,
      loop = false
    },

    missile_fire = {
      modelSet = 'attack',
      firstFrame = 16,
      lastFrame = 16,
      fps = 12,
      loop = false
    },

    missile_end = {
      modelSet = 'attack',
      firstFrame = 16,
      lastFrame = 31,
      fps = 12,
      loop = false
    },

    death = {
      modelSet = 'death',
      firstFrame = 1,
      lastFrame = 24,
      fps = 14,
      loop = false
    }
  },

  preloadAnimations = {
    'idle',
    'walk',

    'missile_start',
    'missile_fire',
    'missile_end',

    'death'
  }
}