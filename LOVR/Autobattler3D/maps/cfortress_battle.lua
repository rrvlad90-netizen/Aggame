return {
  id = 'cfortress_battle',
  name = 'Fortress Battle',

  description = 'Destroy the enemy altar to win.',

  preview = true,
  image = 'textures/scenes/cfortress_intro.png',

  victoryCondition = 'altar',
  
  music = {
    path =
      'music/fortress_battle.mp3',

    volume = .35,
    loop = true
  },

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

	  terrain = {
		enabled = true,

		-- Меньше значение — плавнее поверхность,
		-- но выше нагрузка при загрузке.
		cellSize = 4,

		hills = {
		  {
			x = -38,
			z = 15,
			radius = 22,
			height = 4
		  },

		  {
			x = 40,
			z = -18,
			radius = 20,
			height = 3.5
		  },

		  {
			x = -38,
			z = -42,
			radius = 16,
			height = 2.5
		  },

		  {
			x = 38,
			z = 40,
			radius = 18,
			height = 3
		  },

		  -- Небольшая центральная впадина.
		  {
			x = 0,
			z = 0,
			radius = 16,
			height = -1.5
		  }
		}
	  },

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
		spawnZ = -51
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
	  duration = 580, --общее время (должно быть > последнего указанного времени в списке)

	  events = {
		-- Строительство
		{
		  time = 1,
		  action = 'build',
		  building = 'enemy_barracks'
		},
		{
		  time = 2,
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
		  time = 45,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},

		-- Через 5 секунд: два отряда стрелков
		{
		  time = 65,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'archer',
		  route = 'enemy_center'
		},
		{
		  time = 85,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'archer',
		  route = 'enemy_center'
		},

		-- Конница
		{
		  time = 95,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'cavalry',
		  route = 'enemy_center'
		},

		-- Две последовательные пехоты
		{
		  time = 115,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},
		{
		  time = 125,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},

		-- Великаны
		{
		  time = 135,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'giant1',
		  route = 'enemy_center'
		},

		-- Пехота и катапульты
		{
		  time = 145,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},
		{
		  time = 175,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'catapult',
		  route = 'enemy_center'
		},

		-- Два отряда стрелков
		{
		  time = 190,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'archer',
		  route = 'enemy_center'
		},
		{
		  time = 210,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'archer',
		  route = 'enemy_center'
		},

		-- Два отряда великанов и конница
		{
		  time = 220,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'giant1',
		  route = 'enemy_center'
		},
		{
		  time = 235,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'giant1',
		  route = 'enemy_center'
		},
		{
		  time = 270,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'cavalry',
		  route = 'enemy_center'
		},

		{
		  time = 295,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},
		{
		  time = 310,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},

		{
		  time = 340,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'light_infantry',
		  route = 'enemy_center'
		},
		{
		  time = 430,
		  action = 'recruit',
		  building = 'enemy_barracks',
		  slot = 'archer',
		  route = 'enemy_center'
		},

		{
		  time = 560,
		  action = 'recruit',
		  building = 'enemy_altar',
		  slot = 'dragon1',
		  route = 'enemy_center'
		}
	  }
	},

  decors = {}
}