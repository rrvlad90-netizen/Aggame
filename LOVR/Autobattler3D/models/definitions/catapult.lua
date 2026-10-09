return {
  id = 'catapult',
  format = 'md3',

  scale = .014,
  yOffset = .35,
  rotationOffset = math.rad(98.3),

  solid = true,

  collider = {
    type = 'circle',
    radius = .9
  },

  sourceFrameBase = 1,
  defaultModelSet = 'attack',
  defaultAnimation = 'idle',

  modelSets = {
    walk = {
      parts = {
        {
          id = 'catapult',

          path =
            'models/catapult/catapultwalk.md3',

          textures = {
            [1] =
              'models/catapult/catapult.jpg',

            [2] =
              'models/catapult/catapult2.jpg'
          }
        }
      }
    },

    attack = {
      parts = {
        {
          id = 'catapult',

          path =
            'models/catapult/catapultatt.md3',

          textures = {
            [1] =
              'models/catapult/catapult.jpg',

            [2] =
              'models/catapult/catapult2.jpg'
          }
        }
      }
    },

    death = {
      parts = {
        {
          id = 'catapult',

          path =
            'models/catapult/catapultdeath.md3',

          textures = {
            [1] =
              'models/catapult/catapult.jpg',

            [2] =
              'models/catapult/catapult2.jpg'
          }
        }
      }
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
      lastFrame = 14,
      fps = 10,
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