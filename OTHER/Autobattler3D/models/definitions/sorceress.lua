return {
  id = 'sorceress',
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
      parts = {
        {
          id = 'sorceress',

          path =
            'models/sorceress/sorceressfly.md3',

          texture =
            'models/sorceress/sorceress.jpg'
        }
      }
    },

    attack = {
      parts = {
        {
          id = 'sorceress',

          path =
            'models/sorceress/sorceressattack.md3',

          texture =
            'models/sorceress/sorceress.jpg'
        }
      }
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
      lastFrame = 4,
      fps = 12,
      loop = true,
      pingPong = true
    },

    melee_start = {
      modelSet = 'attack',
      firstFrame = 1,
      lastFrame = 3,
      fps = 6,
      loop = false
    },

    melee_hit = {
      modelSet = 'attack',
      firstFrame = 3,
      lastFrame = 3,
      fps = 7,
      loop = false
    },

    melee_end = {
      modelSet = 'attack',
      firstFrame = 2,
      lastFrame = 2,
      fps = 8,
      loop = false
    },

    missile_start = {
      modelSet = 'attack',
      firstFrame = 1,
      lastFrame = 3,
      fps = 15,
      loop = false
    },

    missile_fire = {
      modelSet = 'attack',
      firstFrame = 3,
      lastFrame = 3,
      fps = 15,
      loop = false
    },

    missile_end = {
      modelSet = 'attack',
      firstFrame = 2,
      lastFrame = 2,
      fps = 15,
      loop = false
    },

    death = {
      modelSet = 'attack',
      firstFrame = 1,
      lastFrame = 3,
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