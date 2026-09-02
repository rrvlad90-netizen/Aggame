return {
  id = 'cannon_orb',
  name = 'Cannon Orb',

  visible = true,

  trajectory = 'arc',
  hitMode = 'point',
  spriteMode = 'billboard',

  speed = 20,
  arcHeight = 6,

  damageMinimum = 180,
  damageMaximum = 240,
  damageType = 'normal',

  radius = 3.5,
  friendlyFire = true,
  damageFalloff = 'uniform',
  launchOnKill = true,

  alpha = 1,
  scale = 1.4,

model = {
  path =
    'models/projectiles/cannon_orb.obj',

  texture =
    'models/mortarteam/MortarTeam.jpg',

  scale = .015,
  
	pitchCurve = {
	  start = -4,
	  middle = 0,
	  finish = 61
	},

  color = {
    1, 1, 1, 1
  },

  rotationSpeed = 0
},

  trail = {
    enabled = true,
    count = 7,
    alpha = .28,
    scale = .55,
    spacing = .045
  },

  animations = {
    flight = {
      fps = 12,
      loop = true,

      frames = {
        'sprites/projectiles/Fire1.png',
        'sprites/projectiles/Fire2.png'
      }
    },

    impact = {
      fps = 12,
      loop = false,

      frames = {
        'sprites/projectiles/Explore1.png',
        'sprites/projectiles/Explore2.png'
      }
    }
  }
}