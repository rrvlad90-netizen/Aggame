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
    incomeInterval = 1
  },

  field = {
    width = 120,
    length = 140,

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
          z = -40,

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
      spawnZ = 50
    },

    {
      id = 'player_barracks',
      side = 'player',
      type = 'barracks',

      x = -22,
      z = 49,
      yaw = math.pi,

      built = false,

      routeId = 'player_center',
      spawnX = -16,
      spawnZ = 42
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
      z = -59,
      yaw = 0,

      built = true,

      routeId = 'enemy_center',
      spawnX = 0,
      spawnZ = -50
    },

    {
      id = 'enemy_barracks',
      side = 'enemy',
      type = 'barracks',

      x = 22,
      z = -49,
      yaw = 0,

      built = false,

      routeId = 'enemy_center',
      spawnX = 16,
      spawnZ = -42
    },

    {
      id = 'enemy_tower',
      side = 'enemy',
      type = 'tower',

      x = -22,
      z = -46,
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
          z = -51
        },

        points = {
          { x = -20, z = 34 },
          { x = -30, z = 10 },
          { x = -22, z = -24 },
          { x = -8, z = -51 }
        }
      },

      {
        id = 'player_center',
        name = 'Center Route',
        width = 18,

        endpoint = {
          x = 0,
          z = -52
        },

        points = {
          { x = 0, z = 30 },
          { x = 0, z = 5 },
          { x = 0, z = -25 },
          { x = 0, z = -52 }
        }
      },

      {
        id = 'player_right',
        name = 'Right Route',
        width = 18,

        endpoint = {
          x = 8,
          z = -51
        },

        points = {
          { x = 20, z = 34 },
          { x = 30, z = 10 },
          { x = 22, z = -24 },
          { x = 8, z = -51 }
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
    duration = 240,

    events = {
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

      {
        time = 12,
        action = 'recruit',
        building = 'enemy_barracks',
        slot = 'light_infantry',
        route = 'enemy_center'
      },

      {
        time = 30,
        action = 'recruit',
        building = 'enemy_barracks',
        slot = 'archer',
        route = 'enemy_center'
      },

      {
        time = 50,
        action = 'recruit',
        building = 'enemy_barracks',
        slot = 'cavalry',
        route = 'enemy_center'
      },

      {
        time = 72,
        action = 'recruit',
        building = 'enemy_barracks',
        slot = 'catapult',
        route = 'enemy_center'
      },

      {
        time = 96,
        action = 'recruit',
        building = 'enemy_barracks',
        slot = 'giant1',
        route = 'enemy_center'
      },

      {
        time = 220,
        action = 'recruit',
        building = 'enemy_altar',
        slot = 'dragon1',
        route = 'enemy_center'
      }
    }
  },

  decors = {}
}