return {
  id = 'fortress_battle',
  name = 'Fortress Battle',

  description =
    'Destroy the enemy altar to win.',

  preview = nil,
  victoryCondition = 'altar',

  economy = {
    startingGold = 1000,
    incomeAmount = 25,
    incomeInterval = 1.20
  },

  field = {
    width = 120,
    length = 180,

    floorY = 0,
    floorThickness = .2,

    ground = {
      texture = 'textures/GRASS1.png',
      tileSize = 24,
      visualWidth = 600,
      visualLength = 600
    },

    sky = {
      texture = 'textures/SKY1.png',
      radius = 300,
      alpha = 1
    }
  },

  squads = {
    player = {
      slot = 'light_infantry',

      groups = {
        {
          count = 30,
          x = 0,
          z = 40,

          defaultRoute =
            'player_center'
        }
      }
    },

    enemy = {
      slot = 'light_infantry',

      groups = {
        {
          count = 30,
          x = 0,
          z = -60,

          defaultRoute =
            'enemy_center'
        }
      }
    }
  },

  buildings = {
    {
      id = 'player_altar',
      side = 'player',
      type = 'altar',

      x = 0,
      z = 59,
      yaw = math.pi,

      built = true,

      routeId = 'player_center',
	  spawnX = 0,
      spawnZ = 40
    },

    {
      id = 'player_barracks',
      side = 'player',
      type = 'barracks',

      x = -22,
      z = 49,
      yaw = math.pi,

      built = false,
--измените точки появления возле казарм
      routeId = 'player_center',
		spawnX = -22,
        spawnZ = 31
    },

    {
      id = 'player_tower',
      side = 'player',
      type = 'tower',

      x = 22,
      z = 46,
      yaw = math.pi,

      built = false,

      routeId = 'player_center'
    },

    {
      id = 'enemy_altar',
      side = 'enemy',
      type = 'altar',

      x = 0,
      z = -79,
      yaw = 0,

      built = true,

      routeId = 'enemy_center',
	   spawnX = 0,
       spawnZ = -60
    },

    {
      id = 'enemy_barracks',
      side = 'enemy',
      type = 'barracks',

      x = 22,
      z = -69,
      yaw = 0,

      built = false,

      routeId = 'enemy_center',
		spawnX = 22,
		spawnZ = -31
    },

    {
      id = 'enemy_tower',
      side = 'enemy',
      type = 'tower',

      x = -22,
      z = -66,
      yaw = 0,

      built = false,

      routeId = 'enemy_center'
    }
  },

  routes = {
    player = {
      {
        id = 'player_left',
        name = 'Left Route',
        width = 18,

        endpoint = {
          x = -8,
          z = -72
        },

        points = {
          { x = -20, z = 34 },
          { x = -30, z = 10 },
          { x = -22, z = -24 },
          { x = -8, z = -72 }
        }
      },

      {
        id = 'player_center',
        name = 'Center Route',
        width = 18,

        endpoint = {
          x = 0,
          z = -72
        },

        points = {
          { x = 0, z = 30 },
          { x = 0, z = 5 },
          { x = 0, z = -25 },
          { x = 0, z = -72 }
        }
      },

      {
        id = 'player_right',
        name = 'Right Route',
        width = 18,

        endpoint = {
          x = 8,
          z = -72
        },

        points = {
          { x = 20, z = 34 },
          { x = 30, z = 10 },
          { x = 22, z = -24 },
          { x = 8, z = -72 }
        }
      }
    },

    enemy = {
      {
        id = 'enemy_left',
        name = 'Left Route',
        width = 18,

        endpoint = {
          x = 8,
          z = 51
        },

        points = {
          { x = 20, z = -34 },
          { x = 30, z = -10 },
          { x = 22, z = 24 },
          { x = 8, z = 51 }
        }
      },

      {
        id = 'enemy_center',
        name = 'Center Route',
        width = 18,

        endpoint = {
          x = 0,
          z = 52
        },

        points = {
          { x = 0, z = -30 },
          { x = 0, z = -5 },
          { x = 0, z = 25 },
          { x = 0, z = 52 }
        }
      },

      {
        id = 'enemy_right',
        name = 'Right Route',
        width = 18,

        endpoint = {
          x = -8,
          z = 51
        },

        points = {
          { x = -20, z = -34 },
          { x = -30, z = -10 },
          { x = -22, z = 24 },
          { x = -8, z = 51 }
        }
      }
    }
  },

	enemyScript = {
	  duration = 280,

	  events = {
		-- Строительство
		{
		  time = 1,
		  action = 'build',
		  building = 'enemy_barracks'
		},
		{
		  time = 1,
		  action = 'build',
		  building = 'enemy_tower'
		},

		-- Две пехоты
		{
		  time = 15,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},
		{
		  time = 15,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},

		-- Через 5 секунд: два отряда стрелков
		{
		  time = 35,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'archer',
		  route = 'enemy_center'
		},
		{
		  time = 35,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'archer',
		  route = 'enemy_center'
		},

		-- Конница
		{
		  time = 45,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'cavalry',
		  route = 'enemy_center'
		},

		-- Две последовательные пехоты
		{
		  time = 55,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},
		{
		  time = 60,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},

		-- Великаны
		{
		  time = 70,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'giant1',
		  route = 'enemy_center'
		},

		-- Пехота и катапульты
		{
		  time = 80,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},
		{
		  time = 85,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'catapult',
		  route = 'enemy_center'
		},

		-- Два отряда стрелков
		{
		  time = 90,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'archer',
		  route = 'enemy_center'
		},
		{
		  time = 90,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'archer',
		  route = 'enemy_center'
		},

		-- Два отряда великанов и конница
		{
		  time = 140,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'giant1',
		  route = 'enemy_center'
		},
		{
		  time = 150,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'giant1',
		  route = 'enemy_center'
		},
		{
		  time = 160,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'cavalry',
		  route = 'enemy_center'
		},

		-- Пехота, затем ещё одна
		{
		  time = 165,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},
		{
		  time = 170,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},

		-- Через 20 секунд: пехота и стрелки
		{
		  time = 190,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},
		{
		  time = 190,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'archer',
		  route = 'enemy_center'
		},

		-- Ещё через 20 секунд: дракон
		{
		  time = 230,
		  action = 'recruit',
		  building = 'enemy_altar',
		  slot = 'dragon1',
		  route = 'enemy_center'
		}
	  }
	},

  decors = {}
}