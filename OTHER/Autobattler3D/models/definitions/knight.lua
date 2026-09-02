return {
  id = 'knight',
  format = 'md3',

  scale = .0125,
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
            'models/knight/knightwalk.md3',

          textures = {
            [1] = 'models/knight/War3HD_Knight_Parts4.jpg',
            [2] = 'models/knight/War3HD_Knight_Parts3.jpg',
            [3] = 'models/knight/War3HD_Knight_Parts5.jpg',
            [4] = 'models/knight/War3HD_Knight_Parts5.jpg',
            [5] = 'models/knight/War3HD_Knight_Parts.jpg',
            [6] = 'models/knight/War3HD_Knight_Lance.jpg',
            [7] = 'models/knight/War3HD_Knight_Parts.jpg',
            [8] = 'models/knight/War3HD_Knight_HorseArmor.jpg',	
            [9] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [10] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [11] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [12] = 'models/knight/War3HD_Knight_Face.jpg',			
            [13] = 'models/knight/War3HD_Knight_Hair.jpg',
            [14] = 'models/knight/War3HD_Knight_Hair.jpg',
            [15] = 'models/knight/War3HD_Knight_Hair.jpg',
            [16] = 'models/knight/War3HD_Knight_Hair.jpg',
            [17] = 'models/knight/War3HD_Knight_Hair.jpg',
            [18] = 'models/knight/War3HD_Knight_Face.jpg',
            [19] = 'models/knight/War3HD_Knight_Circlet.jpg',
            [20] = 'models/knight/War3HD_Knight_Hair.jpg',	
            [21] = 'models/knight/War3HD_Knight_Parts.jpg',
            [22] = 'models/knight/War3HD_Knight_Shoulder.jpg',
            [23] = 'models/knight/War3HD_Knight_Shoulder.jpg',	
            [24] = 'models/knight/War3HD_Knight_Lion.jpg',
            [25] = 'models/knight/War3HD_Knight_Parts2.jpg',
            [26] = 'models/knight/War3HD_Knight_Lion.jpg',			
            [27] = 'models/knight/War3HD_Knight_Shoulder.jpg'			
          }
        }
      }
    },

    attack1 = {
      parts = {
        {
          path =
            'models/knight/knightatt1.md3',

          textures = {
            [1] = 'models/knight/War3HD_Knight_Parts4.jpg',
            [2] = 'models/knight/War3HD_Knight_Parts3.jpg',
            [3] = 'models/knight/War3HD_Knight_Parts5.jpg',
            [4] = 'models/knight/War3HD_Knight_Parts5.jpg',
            [5] = 'models/knight/War3HD_Knight_Parts.jpg',
            [6] = 'models/knight/War3HD_Knight_Lance.jpg',
            [7] = 'models/knight/War3HD_Knight_Parts.jpg',
            [8] = 'models/knight/War3HD_Knight_HorseArmor.jpg',	
            [9] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [10] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [11] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [12] = 'models/knight/War3HD_Knight_Face.jpg',			
            [13] = 'models/knight/War3HD_Knight_Hair.jpg',
            [14] = 'models/knight/War3HD_Knight_Hair.jpg',
            [15] = 'models/knight/War3HD_Knight_Hair.jpg',
            [16] = 'models/knight/War3HD_Knight_Hair.jpg',
            [17] = 'models/knight/War3HD_Knight_Hair.jpg',
            [18] = 'models/knight/War3HD_Knight_Face.jpg',
            [19] = 'models/knight/War3HD_Knight_Circlet.jpg',
            [20] = 'models/knight/War3HD_Knight_Hair.jpg',	
            [21] = 'models/knight/War3HD_Knight_Parts.jpg',
            [22] = 'models/knight/War3HD_Knight_Shoulder.jpg',
            [23] = 'models/knight/War3HD_Knight_Shoulder.jpg',	
            [24] = 'models/knight/War3HD_Knight_Lion.jpg',
            [25] = 'models/knight/War3HD_Knight_Parts2.jpg',
            [26] = 'models/knight/War3HD_Knight_Lion.jpg',			
            [27] = 'models/knight/War3HD_Knight_Shoulder.jpg'
          }
        }
      }
    },

    attack2 = {
      parts = {
        {
          path =
            'models/knight/knightatt2.md3',

          textures = {
            [1] = 'models/knight/War3HD_Knight_Parts4.jpg',
            [2] = 'models/knight/War3HD_Knight_Parts3.jpg',
            [3] = 'models/knight/War3HD_Knight_Parts5.jpg',
            [4] = 'models/knight/War3HD_Knight_Parts5.jpg',
            [5] = 'models/knight/War3HD_Knight_Parts.jpg',
            [6] = 'models/knight/War3HD_Knight_Lance.jpg',
            [7] = 'models/knight/War3HD_Knight_Parts.jpg',
            [8] = 'models/knight/War3HD_Knight_HorseArmor.jpg',	
            [9] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [10] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [11] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [12] = 'models/knight/War3HD_Knight_Face.jpg',			
            [13] = 'models/knight/War3HD_Knight_Hair.jpg',
            [14] = 'models/knight/War3HD_Knight_Hair.jpg',
            [15] = 'models/knight/War3HD_Knight_Hair.jpg',
            [16] = 'models/knight/War3HD_Knight_Hair.jpg',
            [17] = 'models/knight/War3HD_Knight_Hair.jpg',
            [18] = 'models/knight/War3HD_Knight_Face.jpg',
            [19] = 'models/knight/War3HD_Knight_Circlet.jpg',
            [20] = 'models/knight/War3HD_Knight_Hair.jpg',	
            [21] = 'models/knight/War3HD_Knight_Parts.jpg',
            [22] = 'models/knight/War3HD_Knight_Shoulder.jpg',
            [23] = 'models/knight/War3HD_Knight_Shoulder.jpg',	
            [24] = 'models/knight/War3HD_Knight_Lion.jpg',
            [25] = 'models/knight/War3HD_Knight_Parts2.jpg',
            [26] = 'models/knight/War3HD_Knight_Lion.jpg',			
            [27] = 'models/knight/War3HD_Knight_Shoulder.jpg'
          }
        }
      }
    },

    death = {
      parts = {
        {
          path =
            'models/knight/knightdeath.md3',

          textures = {
            [1] = 'models/knight/War3HD_Knight_Parts4.jpg',
            [2] = 'models/knight/War3HD_Knight_Parts3.jpg',
            [3] = 'models/knight/War3HD_Knight_Parts5.jpg',
            [4] = 'models/knight/War3HD_Knight_Parts5.jpg',
            [5] = 'models/knight/War3HD_Knight_Parts.jpg',
            [6] = 'models/knight/War3HD_Knight_Lance.jpg',
            [7] = 'models/knight/War3HD_Knight_Parts.jpg',
            [8] = 'models/knight/War3HD_Knight_HorseArmor.jpg',	
            [9] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [10] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [11] = 'models/knight/War3HD_Knight_HorseArmor.jpg',
            [12] = 'models/knight/War3HD_Knight_Face.jpg',			
            [13] = 'models/knight/War3HD_Knight_Hair.jpg',
            [14] = 'models/knight/War3HD_Knight_Hair.jpg',
            [15] = 'models/knight/War3HD_Knight_Hair.jpg',
            [16] = 'models/knight/War3HD_Knight_Hair.jpg',
            [17] = 'models/knight/War3HD_Knight_Hair.jpg',
            [18] = 'models/knight/War3HD_Knight_Face.jpg',
            [19] = 'models/knight/War3HD_Knight_Circlet.jpg',
            [20] = 'models/knight/War3HD_Knight_Hair.jpg',	
            [21] = 'models/knight/War3HD_Knight_Parts.jpg',
            [22] = 'models/knight/War3HD_Knight_Shoulder.jpg',
            [23] = 'models/knight/War3HD_Knight_Shoulder.jpg',	
            [24] = 'models/knight/War3HD_Knight_Lion.jpg',
            [25] = 'models/knight/War3HD_Knight_Parts2.jpg',
            [26] = 'models/knight/War3HD_Knight_Lion.jpg',			
            [27] = 'models/knight/War3HD_Knight_Shoulder.jpg'
          }
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
      lastFrame = 11,
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
      lastFrame = 36,
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