return {
  id = 'air_explosion',
  name = 'Air Explosion',

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
  scale = 2.2,

  trail = {
    enabled = false
  },

  animations = {
    flight = {
      fps = 1,
      loop = false,

      frames = {
        'sprites/projectiles/Explore1.png'
      }
    },

    impact = {
      fps = 10,
      loop = false,

      frames = {
        'sprites/projectiles/Explore1.png',
        'sprites/projectiles/Explore2.png'
      }
    }
  }
}