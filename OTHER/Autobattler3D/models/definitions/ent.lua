local TEXTURE1 =
  'models/Ent/ancientprotector2_base1.png'

local TEXTURE2 =
  'models/Ent/ancientprotector2_base2.png'

local EYE_TEXTURE =
  'models/Ent/ancientprotector2_base1.png'


-- Создаёт части живого энта.
-- Глаза рисуются первыми, чтобы тело
-- не перекрывало совпадающую геометрию.
local function createLivingParts(animation)
  return {
    {
      id = 'eyes',

      path = string.format(
        'models/Ent/enteye%s.md3',
        animation
      ),

      texture = TEXTURE1
    },

    {
      id = 'body1',

      path = string.format(
        'models/Ent/ent1%s.md3',
        animation
      ),

      texture = TEXTURE1
    },

    {
      id = 'body2',

      path = string.format(
        'models/Ent/ent2%s.md3',
        animation
      ),

      texture = TEXTURE2
    }
  }
end


-- Создаёт модель смерти без глаз.
local function createDeathParts()
  return {
    {
      id = 'body1',

      path =
        'models/Ent/ent1death.md3',

      texture = TEXTURE1
    },

    {
      id = 'body2',

      path =
        'models/Ent/ent2death.md3',

      texture = TEXTURE2
    }
  }
end


return {
  id = 'ent',
  format = 'md3',

  scale = .01,
  yOffset = .35,
  rotationOffset = math.rad(98.3),

  solid = true,

  collider = {
    type = 'circle',
    radius = 1.1
  },

  sourceFrameBase = 1,
  defaultModelSet = 'attack1',
  defaultAnimation = 'idle',

  modelSets = {
    walk = {
      parts =
        createLivingParts('walk')
    },

    attack1 = {
      parts =
        createLivingParts('att1')
    },

    attack2 = {
      parts =
        createLivingParts('att2')
    },

    death = {
      parts =
        createDeathParts()
    }
  },

  battleAnimations = {
    idle = 'idle',
    forward = 'walk',
    backward = 'walk',
    sideways = 'walk',

    attacks = {
      {
        start = 'attack1_start',
        hit = 'attack1_hit',
        finish = 'attack1_end'
      },

      {
        start = 'attack2_start',
        hit = 'attack2_hit',
        finish = 'attack2_end'
      }
    },

    deaths = {
      'death'
    }
  },

  animations = {
    idle = {
      modelSet = 'attack1',
      firstFrame = 1,
      lastFrame = 1,
      fps = 1,
      loop = true
    },

    walk = {
      modelSet = 'walk',
      firstFrame = 1,
      lastFrame = 22,
      fps = 15,
      loop = true
    },

    attack1_start = {
      modelSet = 'attack1',
      firstFrame = 1,
      lastFrame = 7,
      fps = 15,
      loop = false
    },

    attack1_hit = {
      modelSet = 'attack1',
      firstFrame = 8,
      lastFrame = 8,
      fps = 15,
      loop = false
    },

    attack1_end = {
      modelSet = 'attack1',
      firstFrame = 9,
      lastFrame = 16,
      fps = 15,
      loop = false
    },

    attack2_start = {
      modelSet = 'attack2',
      firstFrame = 1,
      lastFrame = 7,
      fps = 15,
      loop = false
    },

    attack2_hit = {
      modelSet = 'attack2',
      firstFrame = 8,
      lastFrame = 8,
      fps = 15,
      loop = false
    },

    attack2_end = {
      modelSet = 'attack2',
      firstFrame = 9,
      lastFrame = 16,
      fps = 15,
      loop = false
    },

    death = {
      modelSet = 'death',
      firstFrame = 1,
      lastFrame = 11,
      fps = 12,
      loop = false
    }
  },

  preloadAnimations = {
    'idle',
    'walk',

    'attack1_start',
    'attack1_hit',
    'attack1_end',

    'attack2_start',
    'attack2_hit',
    'attack2_end',

    'death'
  }
}