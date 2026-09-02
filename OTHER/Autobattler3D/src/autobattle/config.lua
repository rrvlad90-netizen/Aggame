return {
  simulationStep = 1 / 30,
  maximumFrameDelta = .1,

  map = {
    width = 60,
    length = 80,
    floorY = 0,
    floorThickness = .2,

    alliedStartZ = 25,
    enemyStartZ = -25
  },

  squad = {
    spawnWidth = 18,
    spawnDepth = 8
  },

  navigation = {
    -- Расстояние, на котором промежуточная
    -- точка считается достигнутой.
    waypointRadius = 1,

    -- Радиус поиска возможности обхода.
    avoidanceRadius = 10,

    -- Угол попытки обхода препятствия.
    avoidanceAngle = math.rad(55),

    -- Стандартная ширина маршрута.
    defaultCorridorWidth = 18
  },

  unit = {
    model = 'elfwarrior',

    -- Радиус поиска ближайшего врага.
    sightDistance = 16,

    -- Период обновления цели в тиках.
    retargetTicks = 8,

    health = 200,
    damageMinimum = 20,
    damageMaximum = 30,

    moveSpeed = 3.2,
    radius = .4,
    attackDistance = 1.45,

    spearDamageMultiplier = 1,
    magicDamageMultiplier = 1
  },

  economy = {
    startingGold = 1000,
    incomeAmount = 25,
    incomeInterval = 1
  },

  buildings = {
    platformHeight = .08,
    selectionPadding = 1
  },

  collision = {
    cellSize = 2,
    iterations = 2
  },

  lighting = {
    enabled = false,--!!!!

    sunDirection = {
      -.45,
      .8,
      .3
    },

    ambientLight = .42,
    sunStrength = .75
  },

  camera = {
    x = 0,
    y = 36,
    z = 34,

    yaw = 0,
    pitch = -.72,

    moveSpeed = 18,
    fastMultiplier = 2.5,
    sensitivity = .0025,

    minimumY = 4,
    maximumY = 70
  }
}