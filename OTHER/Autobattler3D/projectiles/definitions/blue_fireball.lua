return {
  id = 'blue_fireball',
  name = 'Blue Fireball',

  visible = true,

  trajectory = 'arc',
  hitMode = 'point',
  spriteMode = 'billboard',

  speed = 15,
  arcHeight = 4,

  damageMinimum = 70,
  damageMaximum = 100,
  damageType = 'magic',

  radius = 3,
  friendlyFire = true,
  damageFalloff = 'uniform',
  launchOnKill = true,

  tint = {
    .3, .65, 1, 1
  },

  alpha = 1,
  scale = 1.15,

  trail = {
    enabled = true,
    count = 6,
    alpha = .25,
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