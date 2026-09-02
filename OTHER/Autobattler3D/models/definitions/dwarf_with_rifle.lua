return {
  id = 'dwarf_with_rifle',
  format = 'md3',

  scale = .015,
  yOffset = .35,
  rotationOffset = -29.7,

  solid = true,

  collider = {
    type = 'circle',
    radius = .4
  },

  sourceFrameBase = 1,
  defaultModelSet = 'attack',
  defaultAnimation = 'idle',

  modelSets = {
    attack = {
      parts = {
        {
          path =
            'models/rifleman/riflatt.md3',

          texture =
            'models/rifleman/HD_Rifleman.png'
        }
      }
    },

    walk = {
      parts = {
        {
          path =
            'models/rifleman/riflwalk.md3',

          texture =
            'models/rifleman/HD_Rifleman.png'
        }
      }
    },

    death = {
      parts = {
        {
          path =
            'models/rifleman/rifldeath.md3',

          texture =
            'models/rifleman/HD_Rifleman.png'
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
      lastFrame = 13,
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
      lastFrame = 14,
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
      lastFrame = 14,
      fps = 15,
      loop = false
    },

    death = {
      modelSet = 'death',
      firstFrame = 1,
      lastFrame = 19,
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