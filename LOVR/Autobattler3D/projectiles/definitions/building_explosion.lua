return {
  id = 'building_explosion',
  name = 'Building Explosion',

  visible = true,
  visualOnly = true,

  trajectory = 'straight',
  hitMode = 'point',
  spriteMode = 'billboard',

  speed = 1000,
  arcHeight = 0,

  damageMinimum = 0,
  damageMaximum = 0,
  damageType = 'normal',

  radius = 0,
  friendlyFire = false,

  alpha = 1,
  scale = 7,

  trail = {
    enabled = false
  },

  animations = {
    flight = {
      fps = 1,
      loop = false,

      frames = {
        'sprites/projectiles/Fire1.png'
      }
    },

    impact = {
      fps = 6,
      loop = false,

      frames = {
        'sprites/projectiles/Fire1.png',
        'sprites/projectiles/Fire2.png'
      }
    }
  }
}