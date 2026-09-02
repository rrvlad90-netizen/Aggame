return {
  id = 'fireball',
  name = 'Fireball',

  visible = true,

  trajectory = 'arc',
  hitMode = 'point',
  spriteMode = 'billboard',

  speed = 14,
  arcHeight = 5,

  damageMinimum = 60,
  damageMaximum = 80,
  damageType = 'magic',

  radius = 4,
  friendlyFire = true,
  damageFalloff = 'uniform',

  alpha = 1,
  scale = 1.2,

  canvas = {
    width = 128,
    height = 128
  },

  trail = {
    enabled = true,
    count = 6,
    alpha = .24,
    scale = .8,
    spacing = .055
  },

  animations = {
    flight = {
      fps = 12,
      loop = true,

      frames = {
        'sprites/projectiles/QUPFA0.png',
        'sprites/projectiles/QUPFA1.png'
      }
    },

    impact = {
      fps = 14,
      loop = false,

      frames = {
        'sprites/projectiles/QUPFA2.png',
        'sprites/projectiles/QUPFA3.png'
      }
    }
  }
}