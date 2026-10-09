return {
  id = 'elfwarrior',
  format = 'md3',

	zOffset = 0,
	yOffset = .35,
	scale = .025,
	rotationOffset = -29.7,

  solid = true,

  collider = {
    type = 'circle',
    radius = .3
  },

  sourceFrameBase = 1,
  defaultModelSet = 'default',
  defaultAnimation = 'idle',

  modelSets = {
    default = {
      parts = {
        {
          id = 'elfwarrior',

          path =
            'models/elfwarrior/elfwarrior.md3',

			textures = {
			  -- l_spines2: upper.tga
			  [1] = 'models/elfwarrior/upper.png',

			  -- l_lower: lower.tga
			  [2] = 'models/elfwarrior/lower.png',

			  -- l_spines: upper.tga
			  [3] = 'models/elfwarrior/upper.png',

			  -- u_body: upper.tga
			  [4] = 'models/elfwarrior/upper.png',

			  -- u_body: torso.tga
			  [5] = 'models/elfwarrior/torso.png',

			  -- u_ears: torso.tga
			  [6] = 'models/elfwarrior/torso.png',

			  -- u_hair: hair.tga
			  [7] = 'models/elfwarrior/hair.png'
			},

          zOffset = 0
        }
      }
    }
  },
  
	  battleAnimations = {
	  idle = 'idle',
	  forward = 'runForward',
	  backward = 'runBackward',
	  sideways = 'strafe',

	  attacks = {
		{
		  start = 'start_melee',
		  hit = 'hit_melee',
		  finish = 'end_melee'
		}
	  },

	  deaths = {
		'death1',
		'death2'
	  }
	},

	animations = {
	  death1 = {
		firstFrame = 1,
		lastFrame = 31,
		fps = 12,
		loop = false
	  },

	  death2 = {
		firstFrame = 32,
		lastFrame = 62,
		fps = 12,
		loop = false
	  },

	  deathHeavy = {
		firstFrame = 63,
		lastFrame = 93,
		fps = 12,
		loop = false
	  },

	  taunt = {
		firstFrame = 94,
		lastFrame = 134,
		fps = 12,
		loop = false
	  },
	  
	 start_melee = {
		firstFrame = 135,
		lastFrame = 140,
		fps = 17,
		loop = false
	  },
	  
	 hit_melee = {
		firstFrame = 141,
		lastFrame = 141,
		fps = 17,
		loop = false,
		playSound = 'models/elfwarrior/sounds/melee_hit.wav'
	  },
	  
	 end_melee = {
		firstFrame = 142,
		lastFrame = 144,
		fps = 17,
		loop = false
	  },
	  
	  castMagic = {
		firstFrame = 135,
		lastFrame = 144,
		fps = 17,
		loop = false
	  },

	  taunt2 = {
		firstFrame = 145,
		lastFrame = 155,
		fps = 12,
		loop = false
	  },

	  block = {
		firstFrame = 156,
		lastFrame = 156,
		fps = 1,
		loop = true
	  },

	  sit = {
		firstFrame = 157,
		lastFrame = 157,
		fps = 1,
		loop = true
	  },

	  crouchMove = {
		firstFrame = 158,
		lastFrame = 164,
		fps = 10,
		loop = true
	  },

	  walk = {
		firstFrame = 165,
		lastFrame = 181,
		fps = 12,
		loop = true
	  },

	  runForward = {
		firstFrame = 182,
		lastFrame = 189,
		fps = 16,
		loop = true
	  },

	  runBackward = {
		firstFrame = 190,
		lastFrame = 198,
		fps = 16,
		loop = true
	  },

	  jumpStart = {
		firstFrame = 210,
		lastFrame = 214,
		fps = 14,
		loop = false
	  },

	  airborne = {
		firstFrame = 215,
		lastFrame = 215,
		fps = 1,
		loop = true
	  },
	  
	  near_land = {
		firstFrame = 216,
		lastFrame = 220,
		fps = 14,
		loop = false
	  },

	  landing = {
		firstFrame = 221,
		lastFrame = 225,
		fps = 15,
		loop = false
	  },
	  
	  start_melee_air = {
		  firstFrame = 231,
		  lastFrame = 234,
		  fps = 25,
		  loop = false,

		  playSound =
			'models/elfwarrior/sounds/melee_start.wav'
		},

		hit_melee_air = {
		  firstFrame = 235,
		  lastFrame = 235,
		  fps = 25,
		  loop = false,

		  playSound =
			'models/elfwarrior/sounds/melee_hit.wav'
		},

		end_melee_air = {
		  firstFrame = 236,
		  lastFrame = 241,
		  fps = 25,
		  loop = false
		},
		
		
		start_jump_back = {
		  firstFrame = 231,
		  lastFrame = 240,
		  fps = 25,
		  loop = false
		},

		back_airborne = {
		  firstFrame = 241,
		  lastFrame = 241,
		  fps = 1,
		  loop = true
		},

		start_back_landing = {
		  firstFrame = 242,
		  lastFrame = 242,
		  fps = 25,
		  loop = false
		},

		back_landing = {
		  firstFrame = 243,
		  lastFrame = 245,
		  fps = 25,
		  loop = false
		},

	  idleShort = {
		firstFrame = 226,
		lastFrame = 229,
		fps = 6,
		loop = true
	  },

	  backflip = {
		firstFrame = 230,
		lastFrame = 240,
		fps = 16,
		loop = false
	  },

	  backflipLanding = {
		firstFrame = 241,
		lastFrame = 245,
		fps = 12,
		loop = false
	  },

	  -- Основная стойка.
	  idle = {
		firstFrame = 246,
		lastFrame = 259,
		fps = 12,
		loop = true
	  },

	  sittingIdle = {
		firstFrame = 260,
		lastFrame = 269,
		fps = 7,
		loop = true
	  },

	  strafe = {
		firstFrame = 270,
		lastFrame = 278,
		fps = 12,
		loop = true
	  },
	  
	 runBackward = {
	  firstFrame = 190,
	  lastFrame = 198,
	  fps = 16,
	  loop = true
	},
},

--  frame = 245,
	sourceFrameBase = 1,
	defaultAnimation = 'idle',

	preloadAnimations = {
	  'idle',
	  'runForward',
	  'runBackward',
	  'strafe',

	  'start_melee',
	  'hit_melee',
	  'end_melee',

	  'death1',
	  'death2'
	},
}