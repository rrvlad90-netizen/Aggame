return {
  id = 'rider',
  format = 'md3',

  scale = .0135,
  yOffset = .35,
  rotationOffset = math.rad(98.3),

  solid = true,

  collider = {
    type = 'circle',
    radius = .25
  },

  sourceFrameBase = 1,
  defaultModelSet = 'walk',
  defaultAnimation = 'idle',

  modelSets = {
    walk = {
      parts = {
        {
          path =
            'models/rider/riderwalk.md3',

          texture =
            'models/rider/Wolf.jpg'
        }
      }
    },

    attack1 = {
      parts = {
        {
          path =
            'models/rider/rideratt1.md3',

          texture =
            'models/rider/Wolf.jpg'
        }
      }
    },

    attack2 = {
      parts = {
        {
          path =
            'models/rider/rideratt2.md3',

          texture =
            'models/rider/Wolf.jpg'
        }
      }
    },

    death = {
      parts = {
        {
          path =
            'models/rider/riderdeath.md3',

          texture =
            'models/rider/Wolf.jpg'
        }
      }
    }
  },

  battleAnimations = {
    idle = 'idle',
    forward = 'walk',
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
      lastFrame = 9,
      fps = 15,
      loop = true
    },

    attack1_start = {
      modelSet = 'attack1',
      firstFrame = 1,
      lastFrame = 6,
      fps = 15,
      loop = false
    },

    attack1_hit = {
      modelSet = 'attack1',
      firstFrame = 7,
      lastFrame = 7,
      fps = 15,
      loop = false
    },

    attack1_end = {
      modelSet = 'attack1',
      firstFrame = 8,
      lastFrame = 16,
      fps = 15,
      loop = false
    },

    attack2_start = {
      modelSet = 'attack2',
      firstFrame = 1,
      lastFrame = 6,
      fps = 15,
      loop = false
    },

    attack2_hit = {
      modelSet = 'attack2',
      firstFrame = 7,
      lastFrame = 7,
      fps = 15,
      loop = false
    },

    attack2_end = {
      modelSet = 'attack2',
      firstFrame = 8,
      lastFrame = 16,
      fps = 15,
      loop = false
    },

    death = {
      modelSet = 'death',
      firstFrame = 1,
      lastFrame = 29,
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

    'death'
  }
}