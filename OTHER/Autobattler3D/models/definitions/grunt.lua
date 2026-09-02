local TEXTURE =
  'models/grunt/Grunt_Skin.png'


-- Создаёт три части указанной анимации.
local function createParts(animationName)
  local parts = {}

  for partIndex = 1, 3 do
    parts[#parts + 1] = {
      id = 'body' .. partIndex,

      path = string.format(
        'models/grunt/orc%d%s.md3',
        partIndex,
        animationName
      ),

      texture = TEXTURE,
      zOffset = 0
    }
  end

  return parts
end


return {
  id = 'grunt',
  format = 'md3',

  scale = .013,
  yOffset = .35,
  rotationOffset = math.rad(98.3),

  solid = true,

  collider = {
    type = 'circle',
    radius = .25
  },

  sourceFrameBase = 1,
  defaultModelSet = 'attack1',
  defaultAnimation = 'idle',

	lod = {
		enabled = true,

		sprite =
		  'sprites/units/empty.png',

		distance = 55,
		hysteresis = 5,

		canvas = {
		  width = 256,
		  height = 256
		},

		scale = 3,
		yOffset = 1.35,
		alpha = 1,
		alphaCutoff = .1
	  },

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
    },

    fall = {
      start = 'fall_start',
      airborne = 'fall_in_air',
      land = 'fall_land'
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
      lastFrame = 11,
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
      lastFrame = 15,
      fps = 15,
      loop = false
    },

    death = {
      modelSet = 'death',
      firstFrame = 1,
      lastFrame = 25,
      fps = 12,
      loop = false
    },

    fall_start = {
      modelSet = 'death',
      firstFrame = 1,
      lastFrame = 15,
      fps = 25,
      loop = false
    },

    fall_in_air = {
      modelSet = 'death',
      firstFrame = 16,
      lastFrame = 16,
      fps = 1,
      loop = true
    },

    fall_land = {
      modelSet = 'death',
      firstFrame = 17,
      lastFrame = 25,
      fps = 25,
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

    'death',

    'fall_start',
    'fall_in_air',
    'fall_land'
  }
}