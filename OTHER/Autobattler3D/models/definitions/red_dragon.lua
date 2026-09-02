local BODY_TEXTURE =
  'models/RDragon/RedDragon_Skin.png'

local HEAD_TEXTURE =
  'models/RDragon/KORI_Nozdormu1.png'


-- Создаёт две части дракона.
local function createParts(animation)
  return {
    {
      id = 'body',

      path = string.format(
        'models/RDragon/drbody%s.md3',
        animation
      ),

      texture = BODY_TEXTURE
    },

    {
      id = 'head',

      path = string.format(
        'models/RDragon/drhead%s.md3',
        animation
      ),

      texture = HEAD_TEXTURE
    }
  }
end


return {
  id = 'red_dragon',
  format = 'md3',

  scale = .015,
  yOffset = 0,
  rotationOffset = math.rad(98.3),

  solid = false,

  collider = {
    type = 'circle',
    radius = .2
  },

  sourceFrameBase = 1,
  defaultModelSet = 'fly',
  defaultAnimation = 'fly',

  modelSets = {
    fly = {
      parts = createParts('fly')
    },

    attack = {
      parts = createParts('att')
    }
  },

  battleAnimations = {
    idle = 'fly',
    forward = 'fly',
    backward = 'fly',
    sideways = 'fly',

    attacks = {
      {
        start = 'melee_start',
        hit = 'melee_hit',
        finish = 'melee_end'
      }
    },

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
    fly = {
      modelSet = 'fly',
      firstFrame = 1,
      lastFrame = 11,
      fps = 16,
      loop = true
    },

    melee_start = {
      modelSet = 'attack',
      firstFrame = 1,
      lastFrame = 7,
      fps = 15,
      loop = false
    },

    melee_hit = {
      modelSet = 'attack',
      firstFrame = 8,
      lastFrame = 8,
      fps = 15,
      loop = false
    },

    melee_end = {
      modelSet = 'attack',
      firstFrame = 9,
      lastFrame = 16,
      fps = 15,
      loop = false
    },

    missile_start = {
      modelSet = 'attack',
      firstFrame = 1,
      lastFrame = 7,
      fps = 15,
      loop = false
    },

    missile_fire = {
      modelSet = 'attack',
      firstFrame = 8,
      lastFrame = 8,
      fps = 15,
      loop = false
    },

    missile_end = {
      modelSet = 'attack',
      firstFrame = 9,
      lastFrame = 16,
      fps = 15,
      loop = false
    },

    death = {
      modelSet = 'attack',
      firstFrame = 1,
      lastFrame = 5,
      fps = 19,
      loop = true
    }
  },

  preloadAnimations = {
    'fly',

    'melee_start',
    'melee_hit',
    'melee_end',

    'missile_start',
    'missile_fire',
    'missile_end',

    'death'
  }
}