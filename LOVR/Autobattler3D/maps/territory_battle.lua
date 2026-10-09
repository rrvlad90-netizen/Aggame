return {
  id = 'territory_battle',
  name = 'Territory Battle',

  description =
    'Capture guarded regions and destroy the enemy altar.',

  preview = nil,
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
    incomeInterval = 1.2
  },

  field = {
    width = 360,
    length = 480,

    floorY = 0,
    floorThickness = .2,

    terrain = {
      enabled = true,
      cellSize = 4,
      hills = {}
    },

    ground = {
      texture =
        'textures/GRASS1.png',

      tileSize = 24,
      visualWidth = 900,
      visualLength = 1200
    },

    sky = {
      texture =
        'textures/SKY1.png',

      radius = 500,
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
          z = 170,

          defaultRoute =
            'player_left_assault'
        }
      }
    },

    enemy = {
      slot = 'light_infantry',

      groups = {
        {
          count = 30,
          x = 0,
          z = -170,

          defaultRoute =
            'enemy_right_assault'
        }
      }
    },

    monsters = {
      side = 'monsters',

      groups = {
        {
          id = 'left_guards',
          slot = 'giant1',
          count = 4,

          x = -100,
          z = 0,

          guardPoint =
            'left_region'
        },

        {
          id = 'right_guards',
          slot = 'giant1',
          count = 4,

          x = 100,
          z = 0,

          guardPoint =
            'right_region'
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
      z = 210,
      yaw = math.pi,

      built = true,

      routeId =
        'player_left_assault',

      spawnX = 0,
      spawnZ = 170
    },

    {
      id = 'player_barracks',
      side = 'player',
      type = 'barracks',

      x = -48,
      z = 192,
      yaw = math.pi,

      built = false,

      routeId =
        'player_left_assault',

      spawnX = -48,
      spawnZ = 160
    },

    {
      id = 'player_tower',
      side = 'player',
      type = 'tower',

      x = 48,
      z = 188,
      yaw = math.pi,

      built = false,

      routeId =
        'player_right_assault'
    },

    {
      id = 'enemy_altar',
      side = 'enemy',
      type = 'altar',

      x = 0,
      z = -210,
      yaw = 0,

      built = true,

      routeId =
        'enemy_right_assault',

      spawnX = 0,
      spawnZ = -170
    },

    {
      id = 'enemy_barracks',
      side = 'enemy',
      type = 'barracks',

      x = 48,
      z = -192,
      yaw = 0,

      built = false,

      routeId =
        'enemy_right_assault',

      spawnX = 48,
      spawnZ = -160
    },

    {
      id = 'enemy_tower',
      side = 'enemy',
      type = 'tower',

      x = -48,
      z = -188,
      yaw = 0,

      built = false,

      routeId =
        'enemy_left_assault'
    },

    -- Левая область: казарма и две башни.
    {
      id = 'left_barracks',
      side = 'neutral',
      type = 'barracks',

      x = -100,
      z = 0,
      yaw = 0,

      built = false
    },

    {
      id = 'left_tower_north',
      side = 'neutral',
      type = 'tower',

      x = -124,
      z = 22,
      yaw = 0,

      built = false
    },

    {
      id = 'left_tower_south',
      side = 'neutral',
      type = 'tower',

      x = -124,
      z = -22,
      yaw = math.pi,

      built = false
    },

    -- Правая область: казарма и две башни.
    {
      id = 'right_barracks',
      side = 'neutral',
      type = 'barracks',

      x = 100,
      z = 0,
      yaw = math.pi,

      built = false
    },

    {
      id = 'right_tower_north',
      side = 'neutral',
      type = 'tower',

      x = 124,
      z = 22,
      yaw = math.pi,

      built = false
    },

    {
      id = 'right_tower_south',
      side = 'neutral',
      type = 'tower',

      x = 124,
      z = -22,
      yaw = 0,

      built = false
    }
  },

  capturePoints = {
    {
      id = 'left_region',

      x = -100,
      z = 0,
      radius = 38,

      captureTime = 5,
      cooldown = 8,

      guardRespawnDelay = 15,
      guardLeash = 34,
      guardHomeRadius = 8,

      buildings = {
        {
          id = 'left_barracks',

          owners = {
            allies = {
              routeId =
                'player_left_assault',

              spawnX = -100,
              spawnZ = -30
            },

            enemies = {
              routeId =
                'enemy_left_assault',

              spawnX = -100,
              spawnZ = 30
            }
          }
        },

        {
          id = 'left_tower_north'
        },

        {
          id = 'left_tower_south'
        }
      },

      onCaptured = {
        enemies = {
          action = 'build_all',
          delay = 1
        }
      }
    },

    {
      id = 'right_region',

      x = 100,
      z = 0,
      radius = 38,

      captureTime = 5,
      cooldown = 8,

      guardRespawnDelay = 15,
      guardLeash = 34,
      guardHomeRadius = 8,

      buildings = {
        {
          id = 'right_barracks',

          owners = {
            allies = {
              routeId =
                'player_right_assault',

              spawnX = 100,
              spawnZ = -30
            },

            enemies = {
              routeId =
                'enemy_right_assault',

              spawnX = 100,
              spawnZ = 30
            }
          }
        },

        {
          id = 'right_tower_north'
        },

        {
          id = 'right_tower_south'
        }
      },

      onCaptured = {
        enemies = {
          action = 'build_all',
          delay = 1
        }
      }
    }
  },
 routes = {
    player = {

      {
        id = 'player_left_assault',
        name = 'Left Assault',
        width = 18,

        endpoint = {
          x = -16,
          z = -210
        },

        points = {
          { x = -32, z = 144 },
          { x = -70, z = 84 },

          {
            x = -100,
            z = 0,

            capturePoint =
              'left_region'
          },

          { x = -76, z = -92 },
          { x = -32, z = -156 },
          { x = -16, z = -210 }
        }
      },

      {
        id = 'player_right_assault',
        name = 'Right Assault',
        width = 18,

        endpoint = {
          x = 16,
          z = -210
        },

        points = {
          { x = 32, z = 144 },
          { x = 70, z = 84 },

          {
            x = 100,
            z = 0,

            capturePoint =
              'right_region'
          },

          { x = 76, z = -92 },
          { x = 32, z = -156 },
          { x = 16, z = -210 }
        }
      }
    },

    enemy = {
  
      {
        id = 'enemy_left_assault',
        name = 'Enemy Left Assault',
        width = 18,

        endpoint = {
          x = -16,
          z = 210
        },

        points = {
          { x = -32, z = -144 },
          { x = -70, z = -84 },

          {
            x = -100,
            z = 0,

            capturePoint =
              'left_region'
          },

          { x = -76, z = 92 },
          { x = -32, z = 156 },
          { x = -16, z = 210 }
        }
      },

      {
        id = 'enemy_right_assault',
        name = 'Enemy Right Assault',
        width = 18,

        endpoint = {
          x = 16,
          z = 210
        },

        points = {
          { x = 32, z = -144 },
          { x = 70, z = -84 },

          {
            x = 100,
            z = 0,

            capturePoint =
              'right_region'
          },

          { x = 76, z = 92 },
          { x = 32, z = 156 },
          { x = 16, z = 210 }
        }
      }
    }
  },

enemyAI = {
  enabled = true,
  useEconomy = true,

  decisionInterval = 1.5,

  -- Защита главной базы.
  baseDefenseRadius = 75,
  baseDefenseTriggerRadius = 35,
  baseDefenseSpread = 8,

  -- Распределение наступающих отрядов.
  attackLaneSpacing = 5,
  attackLaneMergeDistance = 12,

  saveForBuildings = true,
  minimumArmyBeforeSaving = 3,

  attackArmy = {
    light_infantry = 4,
    archer = 3,
  },

  economy = {
    startingGold = 1800,
    incomeAmount = 30, --25,
    incomeInterval = 1, --1.2
  },

  routes = {
    {
      id = 'enemy_left_assault',

      capturePoint =
        'left_region',

      baseScore = 10
    },

    {
      id = 'enemy_right_assault',

      capturePoint =
        'right_region',

      baseScore = 10
    }
  },

  composition = {
    {
      slot = 'light_infantry',
      weight = 3
    },

    {
      slot = 'archer',
      weight = 2
    },

    {
      slot = 'cavalry',
      weight = 1.2
    },

    {
      slot = 'giant1',
      weight = .8
    },

    {
      slot = 'catapult',
      weight = .6
    }
  },
},

  decors = {}
} 