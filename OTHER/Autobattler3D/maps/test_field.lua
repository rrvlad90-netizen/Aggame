return {
  id = 'test_field',
  name = 'Test Field',

  description =
    'A wide battlefield with three routes for each army.',

  preview = nil,

field = {
  width = 120,
  length = 96,
  floorY = 0,
  floorThickness = .2,

ground = {
  texture = 'textures/GRASS1.png',
  tileSize = 24,
  visualWidth = 600,
  visualLength = 600
},

  sky = {
    texture =
      'textures/SKY1.png',

    radius = 300,
    alpha = 1
  }
},
  squads = {
    player = {
      slot = 'dragon1',

      groups = {
        {
          count = 30,
          x = -25,
          z = 25,
          defaultRoute =
            'player_left'
        },

        {
          count = 30,
          x = 0,
          z = 18,
          defaultRoute =
            'player_center'
        },

        {
          count = 30,
          x = 25,
          z = 25,
          defaultRoute =
            'player_right'
        }
      }
    },

    enemy = {
		slot = 'light_infantry',
        --slot = 'dragon1',
	    --slot = 'light_infantry',
		--slot = 'catapult
		--slot = 'giant1',
      groups = {
        {
          count = 30,
          x = -25,
          z = -25,
          defaultRoute =
            'enemy_left'
        },

        {
          count = 30,
          x = 0,
          z = -18,
          defaultRoute =
            'enemy_center'
        },

        {
          count = 30,
          x = 25,
          z = -25,
          defaultRoute =
            'enemy_right'
        }
      }
    }
  },

	decors = {
	  {
		model = 'tree1',
		position = { -52, 0, -34 },
		offset = { 0, 0, 0 },
		yaw = .3,
		scale = .02,
		alpha = 1,
		solid = true,
		radius = 1.2
	  },

	  {
		model = 'tree2',
		position = { -55, 0, -5 },
		yaw = 1.4,
		scale = .022,
		alpha = .98,
		solid = true,
		radius = 1.3
	  },

	  {
		model = 'tree3',
		position = { -51, 0, 29 },
		yaw = 2.6,
		scale = .019,
		alpha = 1,
		solid = true,
		radius = 1.2
	  },

	  {
		model = 'tree4',
		position = { 52, 0, -32 },
		yaw = 4.1,
		scale = .021,
		alpha = 1,
		solid = true,
		radius = 1.3
	  },

	  {
		model = 'tree1',
		position = { 55, 0, -3 },
		yaw = 5.2,
		scale = .018,
		alpha = .95,
		solid = true,
		radius = 1.2
	  },

	  {
		model = 'tree3',
		position = { 51, 0, 31 },
		yaw = 3.5,
		scale = .022,
		alpha = 1,
		solid = true,
		radius = 1.3
	  },

	  {
		model = 'tree2',
		position = { -39, 0, 42 },
		yaw = 2,
		scale = .019,
		alpha = 1,
		solid = false,
		radius = 1.2
	  },

	  {
		model = 'tree4',
		position = { 40, 0, -43 },
		yaw = .8,
		scale = .021,
		alpha = 1,
		solid = false,
		radius = 1.3
	  }
	},

  routes = {
    player = {
      {
        id = 'player_left',
        name = 'Left Route',
        width = 20,

        endpoint = {
          x = -25,
          z = -40
        },

        points = {
          { x = -25, z = 12 },
          { x = -25, z = -10 },
          { x = -25, z = -25 },
          { x = -25, z = -40 }
        }
      },

      {
        id = 'player_center',
        name = 'Center Route',
        width = 18,

        endpoint = {
          x = 0,
          z = -40
        },

        points = {
          { x = 0, z = 8 },
          { x = 0, z = -10 },
          { x = 0, z = -25 },
          { x = 0, z = -40 }
        }
      },

      {
        id = 'player_right',
        name = 'Right Route',
        width = 20,

        endpoint = {
          x = 25,
          z = -40
        },

        points = {
          { x = 25, z = 12 },
          { x = 25, z = -10 },
          { x = 25, z = -25 },
          { x = 25, z = -40 }
        }
      }
    },

    enemy = {
      {
        id = 'enemy_left',
        name = 'Left Route',
        width = 20,

        endpoint = {
          x = -25,
          z = 40
        },

        points = {
          { x = -25, z = -12 },
          { x = -25, z = 10 },
          { x = -25, z = 25 },
          { x = -25, z = 40 }
        }
      },

      {
        id = 'enemy_center',
        name = 'Center Route',
        width = 18,

        endpoint = {
          x = 0,
          z = 40
        },

        points = {
          { x = 0, z = -8 },
          { x = 0, z = 10 },
          { x = 0, z = 25 },
          { x = 0, z = 40 }
        }
      },

      {
        id = 'enemy_right',
        name = 'Right Route',
        width = 20,

        endpoint = {
          x = 25,
          z = 40
        },

        points = {
          { x = 25, z = -12 },
          { x = 25, z = 10 },
          { x = 25, z = 25 },
          { x = 25, z = 40 }
        }
      }
    }
  }
}