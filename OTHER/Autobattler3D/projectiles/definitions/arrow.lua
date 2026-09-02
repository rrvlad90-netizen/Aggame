return {
  id = 'arrow',
  name = 'Arrow',

  visible = true,

  trajectory = 'straight',
  hitMode = 'target',
  spriteMode = 'directional',

  speed = 28,
  arcHeight = 0,

  damageMinimum = 25,
  damageMaximum = 35,
  damageType = 'normal',

  radius = 0,
  friendlyFire = false,
  damageFalloff = 'uniform',

  alpha = 1,
  scale = .65,

  canvas = {
    width = 64,
    height = 64
  },

  trail = {
    enabled = false
  },

  animations = {
    flight = {
      fps = 1,
      loop = true,

      frames = {
        'sprites/projectiles/arrow1.png'
      }
    },

    impact = {
      fps = 12,
      loop = false,

      frames = {
        'sprites/projectiles/arrow2.png'
      }
    }
  }
}