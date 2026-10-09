local TEXTURE =
  'models/ogre/OgreYellow_Body.jpg'


-- Создаёт части модели огра.
local function createParts(animation)
  local weaponAnimation = animation

  if animation == 'att1' then
    weaponAnimation = 'at1'
  elseif animation == 'att2' then
    weaponAnimation = 'at2'
  end

  return {
    {
      id = 'body1',

      path = string.format(
        'models/ogre/ogre1%s.md3',
        animation
      ),

      texture = TEXTURE
    },

    {
      id = 'body2',

      path = string.format(
        'models/ogre/ogre2%s.md3',
        animation
      ),

      texture = TEXTURE
    },

    {
      id = 'body3',

      path = string.format(
        'models/ogre/ogre3%s.md3',
        animation
      ),

      texture = TEXTURE
    },

    {
      id = 'weapon',

      path = string.format(
        'models/ogre/ogreweapon%s.md3',
        weaponAnimation
      ),

      texture = TEXTURE
    }
  }
end


return {
  id = 'ogre',
  format = 'md3',

  scale = .02,
  yOffset = .35,
  rotationOffset = math.rad(98.3),

  solid = true,

  collider = {
    type = 'circle',
    radius = 1
  },

  sourceFrameBase = 1,
  defaultModelSet = 'attack1',
  defaultAnimation = 'idle',

  modelSets = {
    walk = {
      parts = createParts('walk')
    },

    attack1 = {
      parts = createParts('att1')
    },

    attack2 = {
      parts = createParts('att2')
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
      lastFrame = 16,
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
      lastFrame = 31,
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