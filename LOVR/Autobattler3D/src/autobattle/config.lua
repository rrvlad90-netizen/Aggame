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
    spawnDepth = 8,

    -- Расстояние, на котором центр
    -- отряда завершает приказ движения.
    destinationRadius = 1.25,

    -- Радиус поиска новой цели после
    -- уничтожения текущей.
    retargetRadius = 22,

    -- Расстояние между центрами нескольких
    -- отрядов, отправленных в одну точку.
    groupOrderSpacing = 8,

    -- Время отсутствия продвижения,
    -- после которого путь перестраивается.
    stuckTimeout = 1.5,

    -- Минимальное продвижение, которое
    -- сбрасывает таймер застревания.
    stuckDistance = .4
  },

  navigation = {
    -- Старые параметры локального обхода
    -- временно остаются для совместимости.
    avoidanceRadius = 10,
    avoidanceAngle = math.rad(55),
    defaultCorridorWidth = 18,

	grid = {
		  cellSize = 2,
		  clearance = .2,
		  maximumSlope = .85
		},

    pathfinder = {
      maximumVisited = 20000,
      nearestCellRadius = 24,
      approachSamples = 16
    },

    -- Точка пути считается достигнутой.
    waypointRadius = .85,

    -- Минимальный интервал перестроения
    -- пути к движущейся цели.
    repathInterval = .65,

    -- Цель должна сместиться хотя бы
    -- настолько для перестроения пути.
    repathDistance = 3
  },

  engagement = {
    -- Задержка освобождения отряда после
    -- исчезновения melee-контакта.
    releaseDelay = 2.5,

    -- Радиус поиска новой цели после
    -- завершения текущей схватки.
    retargetRadius = 22
  },

  selection = {
    -- Движение мыши до этого значения
    -- считается обычным кликом.
    dragThreshold = 6,

    minimumBoxSize = 4,

    -- Дополнительный экранный отступ
    -- вокруг проекции бойца.
    unitPadding = 3
  },

  unit = {
    model = 'elfwarrior',

    -- Радиус автоматического поиска врага.
    sightDistance = 16,

    -- Период обновления цели в тиках.
    retargetTicks = 8,

    -- Время существования трупа.
    corpseLifetime = 60,

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
    enabled = false,

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