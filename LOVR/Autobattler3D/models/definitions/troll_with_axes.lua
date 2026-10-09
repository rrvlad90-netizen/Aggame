return {
  id = 'troll_with_axes',
  format = 'md3',

  scale = .012,
  yOffset = .35,
  rotationOffset = -29.7,

  solid = true,

  collider = {
    type = 'circle',
    radius = .55,
  },

  sourceFrameBase = 1,
  defaultModelSet = 'attack',
  defaultAnimation = 'idle',

  lod = {
    enabled = true,

    sprite = 'sprites/units/empty.png',

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
    attack = {
      parts = {
        {
          path =
            'models/troll/trollattpart1.md3',

          texture =
            'models/troll/ForestTroll.png'
        },

        {
          path =
            'models/troll/trollattpart2.md3',

          texture =
            'models/troll/ForestTroll.png'
        },

        {
          path =
            'models/troll/twatt.md3',

          texture =
            'models/troll/ForestTroll.png'
        }
      }
    },

    walk = {
      parts = {
        {
          path =
            'models/troll/trollwalkpart1.md3',

          texture =
            'models/troll/ForestTroll.png'
        },

        {
          path =
            'models/troll/trollwalkpart2.md3',

          texture =
            'models/troll/ForestTroll.png'
        },

        {
          path =
            'models/troll/twwalk.md3',

          texture =
            'models/troll/ForestTroll.png'
        }
      }
    },

    death = {
      parts = {
        {
          path =
            'models/troll/trolldeathpart1.md3',

          texture =
            'models/troll/ForestTroll.png'
        },

        {
          path =
            'models/troll/trolldeathpart2.md3',

          texture =
            'models/troll/ForestTroll.png'
        },

        {
          path =
            'models/troll/twdeath.md3',

          texture =
            'models/troll/ForestTroll.png'
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
        start = 'attack_start',
        hit = 'attack_hit',
        finish = 'attack_end'
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
      lastFrame = 14,
      fps = 15,
      loop = true
    },

    attack_start = {
      modelSet = 'attack',
      firstFrame = 1,
      lastFrame = 7,
      fps = 15,
      loop = false
    },

    attack_hit = {
      modelSet = 'attack',
      firstFrame = 8,
      lastFrame = 8,
      fps = 15,
      loop = false
    },

    attack_end = {
      modelSet = 'attack',
      firstFrame = 9,
      lastFrame = 12,
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
      lastFrame = 12,
      fps = 15,
      loop = false
    },

    death = {
      modelSet = 'death',
      firstFrame = 1,
      lastFrame = 11,
      fps = 15,
      loop = false
    }
  },

  preloadAnimations = {
    'idle',
    'walk',

    'attack_start',
    'attack_hit',
    'attack_end',

    'missile_start',
    'missile_fire',
    'missile_end',

    'death'
  }
}