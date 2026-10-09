return {
  id = 'catapult_rock',
  name = 'Catapult Rock',

  visible = true,

  trajectory = 'arc',
  hitMode = 'point',
  spriteMode = 'billboard',

  speed = 15,
  arcHeight = 8,

  damageMinimum = 220,
  damageMaximum = 300,
  damageType = 'normal',

  radius = 4,
  friendlyFire = true,
  damageFalloff = 'uniform',
  launchOnKill = true,

  alpha = 1,
  scale = 1.6,

model = {
  path =
    'models/projectiles/catapult_rock.obj',

  texture =
    'models/catapult/catapult2.jpg',

  scale = .01,

  color = {
    1, 1, 1, 1
  },

  rotationSpeed = 6,

  rotationAxis = {
    1, .25, .4
  }
},

  trail = {
    enabled = true,
    count = 7,
    alpha = .25,
    scale = .65,
    spacing = .05
  },

  animations = {
    flight = {
      fps = 10,
      loop = true,

      frames = {
        'sprites/projectiles/Smoke1.png',
        'sprites/projectiles/Smoke2.png'
      }
    },

    impact = {
      fps = 10,
      loop = false,

      frames = {
        'sprites/projectiles/Smoke1.png',
        'sprites/projectiles/Smoke2.png'
      }
    }
  }
}