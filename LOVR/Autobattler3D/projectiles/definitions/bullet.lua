return {
  id = 'bullet',
  name = 'Bullet',

  -- Логический снаряд существует,
  -- но сам визуально не рисуется.
  visible = false,

  trajectory = 'straight',
  hitMode = 'target',
  spriteMode = 'directional',

  speed = 80,
  arcHeight = 0,

  damageMinimum = 20,
  damageMaximum = 30,
  damageType = 'normal',

  radius = 0,
  friendlyFire = false,
  damageFalloff = 'uniform',

  alpha = 0,
  scale = 0,

  trail = {
    enabled = false
  },

  muzzleSmoke = {
    enabled = true,

    count = 9,

    color = {
      .72, .72, .68, .55
    },

    lifetimeMinimum = .35,
    lifetimeMaximum = .7,

    speedMinimum = .35,
    speedMaximum = 1.25,

    scaleMinimum = .25,
    scaleMaximum = .55,

    growthMinimum = .7,
    growthMaximum = 1.3
  },

  animations = {
    flight = {
      fps = 1,
      loop = true,
      frames = {}
    },

    impact = {
      fps = 1,
      loop = false,
      frames = {}
    }
  }
}