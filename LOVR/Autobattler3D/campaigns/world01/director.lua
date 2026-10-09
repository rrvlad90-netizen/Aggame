return {
  enabled = true,

  maximumDangerousEventsPerTurn = 1,
  dangerousEventCooldown = 3,
  armyProtectionDays = 3,
  siegeWarningDays = 2,

  difficulty = {
    incomeMultiplier = 1,
    enemyPowerMultiplier = 1,
    eventFrequencyMultiplier = 1
  },

  powerRanges = {
    neutralAmbush = {
      minimum = .65,
      maximum = .95
    },

    interception = {
      minimum = .85,
      maximum = 1.15
    },

    cityDefense = {
      minimum = 1,
      maximum = 1.30
    }
  },

  events = {
    {
      id = 'neutral_ambush',
      type = 'neutral_ambush',

      minimumDay = 3,
      weight = 1
    },

    {
      id = 'orc_interception',
      type = 'interception',

      participant = 'orc_horde',

      minimumDay = 5,
      weight = 1
    },

    {
      id = 'orc_siege',
      type = 'siege',

      participant = 'orc_horde',
      targetCity = 'HumanMainCity',

      minimumDay = 10,
      weight = .65
    }
  },

  armyTemplates = {
    {
      id = 'neutral_ogres_small',
      category = 'neutral_ambush',

      side = 'monsters',
      minimumDay = 3,

      squads = {
        {
          slot = 'giant1',
          count = 2
        }
      }
    },

    {
      id = 'neutral_ogres_large',
      category = 'neutral_ambush',

      side = 'monsters',
      minimumDay = 12,

      squads = {
        {
          slot = 'giant1',
          count = 4
        }
      }
    },

    {
      id = 'orc_patrol_early',
      category = 'interception',

      side = 'orcs',
      minimumDay = 1,

      squads = {
        {
          slot = 'light_infantry',
          count = 30
        },

        {
          slot = 'archer',
          count = 20
        }
      }
    },

    {
      id = 'orc_patrol_middle',
      category = 'interception',

      side = 'orcs',
      minimumDay = 8,

      squads = {
        {
          slot = 'light_infantry',
          count = 30
        },

        {
          slot = 'archer',
          count = 20
        },

        {
          slot = 'cavalry',
          count = 12
        }
      }
    },

    {
      id = 'orc_city_early',
      category = 'cityDefense',

      side = 'orcs',
      minimumDay = 1,

      squads = {
        {
          slot = 'light_infantry',
          count = 30
        },

        {
          slot = 'archer',
          count = 20
        }
      }
    },

    {
      id = 'orc_city_middle',
      category = 'cityDefense',

      side = 'orcs',
      minimumDay = 8,

      squads = {
        {
          slot = 'light_infantry',
          count = 30
        },

        {
          slot = 'archer',
          count = 20
        },

        {
          slot = 'cavalry',
          count = 12
        },

        {
          slot = 'giant1',
          count = 4
        }
      }
    },

    {
      id = 'orc_city_late',
      category = 'cityDefense',

      side = 'orcs',
      minimumDay = 18,

      squads = {
        {
          slot = 'light_infantry',
          count = 30
        },

        {
          slot = 'archer',
          count = 20
        },

        {
          slot = 'cavalry',
          count = 12
        },

        {
          slot = 'giant1',
          count = 4
        },

        {
          slot = 'catapult',
          count = 4
        },

        {
          slot = 'dragon1',
          count = 1
        }
      }
    },

    {
      id = 'orc_siege_middle',
      category = 'siege',

      side = 'orcs',
      minimumDay = 10,

      squads = {
        {
          slot = 'light_infantry',
          count = 30
        },

        {
          slot = 'archer',
          count = 20
        },

        {
          slot = 'cavalry',
          count = 12
        },

        {
          slot = 'catapult',
          count = 4
        }
      }
    }
  },

  scriptedEvents = {}
}