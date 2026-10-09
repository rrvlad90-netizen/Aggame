local function createLevels()
  return {
    {
      level = 1,
      income = 100,

      upgradeCost = 400,
      upgradeTurns = 2
    },

    {
      level = 2,
      income = 160,

      upgradeCost = 800,
      upgradeTurns = 3
    },

    {
      level = 3,
      income = 240,

      upgradeCost = 1400,
      upgradeTurns = 4
    },

    {
      level = 4,
      income = 340,

      upgradeCost = 2200,
      upgradeTurns = 5
    },

    {
      level = 5,
      income = 480
    }
  }
end


return {
  {
    id = 'HumanMainCity',
    name = 'Human Main City',

    x = 240,
    y = 360,

    markerRadius = 28,

    nativeParticipant = 'humans',
    startingOwner = 'humans',
    startingLevel = 1,

    capital = true,

    recruitmentProfile =
      'standard',

    battleMapPool = 'city',

    defenseMultiplier = 1.15,

    levels = createLevels()
  },

  {
    id = 'HumanBorderTown',
    name = 'Human Border Town',

    x = 420,
    y = 220,

    markerRadius = 20,

    nativeParticipant = 'humans',
    startingOwner = 'humans',
    startingLevel = 1,

    capital = false,

    recruitmentProfile =
      'standard',

    battleMapPool = 'city',

    defenseMultiplier = 1.10,

    levels = createLevels()
  },

  {
    id = 'OrcMainCamp',
    name = 'Orc Main Camp',

    x = 1040,
    y = 360,

    markerRadius = 28,

    nativeParticipant = 'orc_horde',
    startingOwner = 'orc_horde',
    startingLevel = 1,

    capital = true,

    recruitmentProfile =
      'standard',

    battleMapPool = 'city',

    defenseMultiplier = 1.15,

    levels = createLevels()
  },

  {
    id = 'OrcForwardCamp',
    name = 'Orc Forward Camp',

    x = 860,
    y = 500,

    markerRadius = 20,

    nativeParticipant = 'orc_horde',
    startingOwner = 'orc_horde',
    startingLevel = 1,

    capital = false,

    recruitmentProfile =
      'standard',

    battleMapPool = 'city',

    defenseMultiplier = 1.10,

    levels = createLevels()
  }
}