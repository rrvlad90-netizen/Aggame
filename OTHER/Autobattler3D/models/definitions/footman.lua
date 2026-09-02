return {
  id = 'footman',
  format = 'md3',

  scale = .012,
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
      parts = {
        {
          id = 'body1',
          path =
            'models/footman/foot1walk.md3',
          texture =
            'models/footman/footm.png',
          zOffset = 0
        },

        {
          id = 'body2',
          path =
            'models/footman/foot2walk.md3',
          texture =
            'models/footman/footm.png',
          zOffset = 0
        }
      }
    },

    attack1 = {
      parts = {
        {
          id = 'body1',
          path =
            'models/footman/foot1att1.md3',
          texture =
            'models/footman/footm.png',
          zOffset = 0
        },

        {
          id = 'body2',
          path =
            'models/footman/foot2att1.md3',
          texture =
            'models/footman/footm.png',
          zOffset = 0
        }
      }
    },

    attack2 = {
      parts = {
        {
          id = 'body1',
          path =
            'models/footman/foot1att2.md3',
          texture =
            'models/footman/footm.png',
          zOffset = 0
        },

        {
          id = 'body2',
          path =
            'models/footman/foot2att2.md3',
          texture =
            'models/footman/footm.png',
          zOffset = 0
        }
      }
    },

    death = {
      parts = {
        {
          id = 'body1',
          path =
            'models/footman/foot1death.md3',
          texture =
            'models/footman/footm.png',
          zOffset = 0
        },

        {
          id = 'body2',
          path =
            'models/footman/foot2death.md3',
          texture =
            'models/footman/footm.png',
          zOffset = 0
        }
      }
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
      lastFrame = 13,
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
      lastFrame = 15,
      fps = 12,
      loop = false
    },

    fall_start = {
      modelSet = 'death',
      firstFrame = 1,
      lastFrame = 4,
      fps = 15,
      loop = false
    },

    fall_in_air = {
      modelSet = 'death',
      firstFrame = 5,
      lastFrame = 5,
      fps = 1,
      loop = true
    },

    fall_land = {
      modelSet = 'death',
      firstFrame = 6,
      lastFrame = 15,
      fps = 15,
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