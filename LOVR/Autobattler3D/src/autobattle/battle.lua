local Squad =
  require('src.autobattle.squad')

local SpatialGrid =
  require('src.autobattle.spatial_grid')

local NavigationGrid =
  require(
    'src.autobattle.navigation_grid'
  )

local Pathfinder =
  require('src.autobattle.pathfinder')

local EngagementSystem =
  require(
    'src.autobattle.engagement_system'
  )

local CaptureSystem =
  require(
    'src.autobattle.capture_system'
  )

local Economy =
  require('src.economy.economy')

local BuildingSystem =
  require(
    'src.buildings.building_system'
  )

local ProjectileRegistry =
  require(
    'src.projectiles.projectile_registry'
  )

local ProjectileSystem =
  require(
    'src.projectiles.projectile_system'
  )

local ModelLighting =
  require(
    'src.graphics.model_lighting'
  )

local EnemyAI =
  require(
    'src.autobattle.enemy_ai'
  )


local Battle = {}
Battle.__index = Battle


-- Создаёт настроенное сражение.
function Battle.new(
  config,
  modelRegistry,
  field,
  options
)
  local self =
    setmetatable({}, Battle)

  options = options or {}

  self.config = config
  self.modelRegistry = modelRegistry
  self.field = field

  self.sideRegistry =
    assert(
      options.sideRegistry,
      'Battle has no side registry'
    )

  self.map =
    assert(
      options.map,
      'Battle has no map'
    )

  self.playerSide =
    assert(
      options.playerSide,
      'Battle has no player side'
    )

  self.enemySide =
    assert(
      options.enemySide,
      'Battle has no enemy side'
    )

  self.monsterSide =
    options.monsterSide
    or 'monsters'

  self.playerUnitDefinition =
    assert(
      options.playerUnitDefinition,
      'Player side has no unit'
    )

  self.enemyUnitDefinition =
    assert(
      options.enemyUnitDefinition,
      'Enemy side has no unit'
    )

  self.time = 0

  self.nextUnitId = 1
  self.nextSquadId = 1

  self.squads = {}
  self.units = {}
  self.winner = nil

  self.endingWinner = nil
  self.endingTime = 0
  self.endingDuration = 0

  self.economies = {}
  self.economy = nil

  self.buildingSystem = nil
  self.captureSystem = nil
  self.enemyAI = nil

  -- Пространственная сетка бойцов.
  self.grid =
    SpatialGrid.new(
      config.collision.cellSize
    )

  -- Навигационная сетка статического мира.
  self.navigationGrid =
    NavigationGrid.new(
      field,
      config.navigation.grid
    )

  self.pathfinder =
    Pathfinder.new(
      self.navigationGrid,
      config.navigation.pathfinder
    )

  self.engagementSystem =
    EngagementSystem.new(
      self,
      config.engagement
    )

  self.navigationObstacleSignature =
    nil

  self.projectileRegistry =
    ProjectileRegistry.new()

  self.projectileSystem =
    ProjectileSystem.new(
      self.projectileRegistry,
      self
    )

  self.modelLightingShader =
    ModelLighting.new()

  self:createConfiguredBattle()

  if self.map.buildings then
    local playerEconomySettings =
      self.map.economy
      or config.economy

	local enemyAIConfig =
		self.map.enemyAI

	  if
		self.buildingSystem
		and (
		  not enemyAIConfig
		  or enemyAIConfig.enabled ~= false
		)
	  then
		if not enemyAIConfig then
		  enemyAIConfig = {
			enabled = true,
			useEconomy = false,

			decisionInterval = 1.5,

			baseDefenseRadius = 75,
			baseDefenseTriggerRadius = 35,

			minimumReserve = 1,

			attackArmy = {
			  light_infantry = 3,
			  archer = 2
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
			}
		  }
		end

		-- Новый AI полностью заменяет
		-- старые волны по маршрутным точкам.
		self.buildingSystem.script = nil

		self.enemyAI =
		  EnemyAI.new({
			battle = self,

			buildingSystem =
			  self.buildingSystem,

			economy =
			  self.economies.enemies,

			config =
			  enemyAIConfig
		  })
	  end

    local enemyEconomySettings =
      enemyAIConfig
      and enemyAIConfig.economy
      or playerEconomySettings

    self.economies.allies =
      Economy.new(
        playerEconomySettings
      )

    self.economies.enemies =
      Economy.new(
        enemyEconomySettings
      )

    -- Совместимость существующего HUD.
    self.economy =
      self.economies.allies

    self.buildingSystem =
      BuildingSystem.new({
        battle = self,
        map = self.map,

        modelRegistry =
          self.modelRegistry,

        sideRegistry =
          self.sideRegistry,

        economies =
          self.economies,

        economy =
          self.economies.allies,

        playerSide =
          self.playerSide,

        enemySide =
          self.enemySide
      })
  end

  -- После появления зданий перестраивает
  -- динамическую часть навигации.
  self:updateNavigationObstacles(true)

  if
    self.buildingSystem
    and self.map.capturePoints
    and #self.map.capturePoints > 0
  then
    self.captureSystem =
      CaptureSystem.new({
        battle = self,
        map = self.map,

        buildingSystem =
          self.buildingSystem
      })
  end

  local enemyAIConfig =
    self.map.enemyAI

  if
    self.buildingSystem
    and enemyAIConfig
    and enemyAIConfig.enabled
      ~= false
  then
    self.enemyAI =
      EnemyAI.new({
        battle = self,

        buildingSystem =
          self.buildingSystem,

        economy =
          self.economies.enemies,

        config =
          enemyAIConfig
      })
  end

  return self
end


-- Выделяет уникальный ID бойца.
function Battle:allocateUnitId()
  local id = self.nextUnitId

  self.nextUnitId =
    self.nextUnitId + 1

  return id
end


-- Выделяет уникальный ID отряда.
function Battle:allocateSquadId()
  local id = self.nextSquadId

  self.nextSquadId =
    self.nextSquadId + 1

  return id
end


-- Добавляет отряд.
function Battle:addSquad(
  team,
  squadSettings,
  unitDefinition
)
  local squad = Squad.new({
    id = self:allocateSquadId(),

    campaignSquadId =
      squadSettings.campaignSquadId,

    team = team,

    direction =
      team == 'allies'
      and -1
      or 1,

    startX = squadSettings.x,
    startZ = squadSettings.z,

    count =
      squadSettings.count
      or unitDefinition.squadSize
      or 1,

    guardPoint =
      squadSettings.guardPoint,

    unitDefinition = unitDefinition,

    battle = self,
    config = self.config,

    modelRegistry =
      self.modelRegistry
  })

  self.squads[#self.squads + 1] =
    squad

  for _, unit in ipairs(
    squad.units
  ) do
    self.units[#self.units + 1] =
      unit
  end

  return squad
end


-- Создаёт начальные отряды карты.
function Battle:createConfiguredBattle()
  local squads = self.map.squads

  for _, group in ipairs(
    squads.player.groups
  ) do
    local definition =
      self.playerUnitDefinition

    if group.slot then
      definition =
        self.sideRegistry:
          resolveUnit(
            self.playerSide,
            group.slot
          )
    end

    assert(
      definition,
      'Player group has no unit'
    )

    self:addSquad(
      'allies',
      group,
      definition
    )
  end

  for _, group in ipairs(
    squads.enemy.groups
  ) do
    local definition =
      self.enemyUnitDefinition

    if group.slot then
      definition =
        self.sideRegistry:
          resolveUnit(
            self.enemySide,
            group.slot
          )
    end

    assert(
      definition,
      'Enemy group has no unit'
    )

    self:addSquad(
      'enemies',
      group,
      definition
    )
  end

  local monsters =
    squads.monsters

  if not monsters then
    return
  end

  self.monsterSide =
    monsters.side
    or self.monsterSide

  for _, group in ipairs(
    monsters.groups or {}
  ) do
    local definition =
      self.sideRegistry:
        resolveUnit(
          self.monsterSide,
          group.slot
        )

    assert(
      definition,

      'Monster group has no unit: ' ..
      tostring(group.slot)
    )

    self:addSquad(
      'monsters',
      group,
      definition
    )
  end
end

local EngagementSystem = {}
EngagementSystem.__index =
  EngagementSystem


local function isSquadAlive(squad)
  return
    squad
    and not squad:isDefeated()
end


local function getLinkKey(
  firstSquad,
  secondSquad
)
  local firstId =
    assert(
      firstSquad.id,
      'Squad has no ID'
    )

  local secondId =
    assert(
      secondSquad.id,
      'Squad has no ID'
    )

  if firstId < secondId then
    return
      tostring(firstId) ..
      ':' ..
      tostring(secondId)
  end

  return
    tostring(secondId) ..
    ':' ..
    tostring(firstId)
end


-- Создаёт систему связывания боем.
function EngagementSystem.new(
  battle,
  config
)
  assert(
    battle,
    'Engagement system has no battle'
  )

  local self =
    setmetatable(
      {},
      EngagementSystem
    )

  self.battle = battle
  self.config = config or {}

  -- Связь снимается не мгновенно:
  -- между ударами проходят анимации.
  self.releaseDelay =
    self.config.releaseDelay
    or 2.5

  self.time = 0
  self.links = {}

  return self
end


-- Подготавливает состояние отряда.
function EngagementSystem:
  prepareSquad(squad)
  squad.engagements =
    squad.engagements or {}

  squad.engaged =
    next(squad.engagements)
    ~= nil
end


-- Обновляет общий флаг отряда.
function EngagementSystem:
  refreshSquadState(squad)
  if not squad then
    return
  end

  self:prepareSquad(squad)

  squad.engaged =
    next(squad.engagements)
    ~= nil
end


-- Проверяет возможность связывания.
function EngagementSystem:
  canEngage(
    firstSquad,
    secondSquad
  )
  if
    not isSquadAlive(firstSquad)
    or not isSquadAlive(secondSquad)
  then
    return false
  end

  if firstSquad == secondSquad then
    return false
  end

  if
    firstSquad.team ==
    secondSquad.team
  then
    return false
  end

  return true
end


-- Создаёт либо обновляет связь.
function EngagementSystem:
  touchSquads(
    firstSquad,
    secondSquad
  )
  if
    not self:canEngage(
      firstSquad,
      secondSquad
    )
  then
    return false
  end

  self:prepareSquad(firstSquad)
  self:prepareSquad(secondSquad)

  local key =
    getLinkKey(
      firstSquad,
      secondSquad
    )

  local link =
    self.links[key]

  if link then
    link.lastContact = self.time
    return true
  end

  link = {
    key = key,
    first = firstSquad,
    second = secondSquad,
    startedAt = self.time,
    lastContact = self.time
  }

  self.links[key] = link

  firstSquad.engagements[
    secondSquad
  ] = true

  secondSquad.engagements[
    firstSquad
  ] = true

  self:refreshSquadState(
    firstSquad
  )

  self:refreshSquadState(
    secondSquad
  )

  if firstSquad.onEngagementStarted then
    firstSquad:
      onEngagementStarted(
        secondSquad
      )
  end

  if secondSquad.onEngagementStarted then
    secondSquad:
      onEngagementStarted(
        firstSquad
      )
  end

  return true
end


-- Регистрирует melee-контакт бойцов.
function EngagementSystem:
  touchUnits(
    firstUnit,
    secondUnit
  )
  if
    not firstUnit
    or not secondUnit
  then
    return false
  end

  return self:touchSquads(
    firstUnit.squad,
    secondUnit.squad
  )
end


-- Удаляет конкретную связь.
function EngagementSystem:
  removeLink(
    key,
    reason
  )
  local link =
    self.links[key]

  if not link then
    return false
  end

  self.links[key] = nil

  local first = link.first
  local second = link.second

  if first and first.engagements then
    first.engagements[second] = nil
  end

  if second and second.engagements then
    second.engagements[first] = nil
  end

  self:refreshSquadState(first)
  self:refreshSquadState(second)

  if
    first
    and first.onEngagementEnded
  then
    first:onEngagementEnded(
      second,
      reason
    )
  end

  if
    second
    and second.onEngagementEnded
  then
    second:onEngagementEnded(
      first,
      reason
    )
  end

  return true
end


-- Удаляет все связи отряда.
function EngagementSystem:
  clearSquad(
    squad,
    reason
  )
  local keys = {}

  for key, link in pairs(
    self.links
  ) do
    if
      link.first == squad
      or link.second == squad
    then
      keys[#keys + 1] = key
    end
  end

  for _, key in ipairs(keys) do
    self:removeLink(
      key,
      reason or 'squad_cleared'
    )
  end

  if squad then
    squad.engagements = {}
    squad.engaged = false
  end
end


-- Проверяет, связан ли отряд.
function EngagementSystem:
  isEngaged(squad)
  if not squad then
    return false
  end

  self:refreshSquadState(squad)

  return squad.engaged
end


-- Проверяет возможность движения.
function EngagementSystem:
  canMove(squad)
  return
    isSquadAlive(squad)
    and not self:isEngaged(squad)
end


-- Возвращает прямых противников.
function EngagementSystem:
  getOpponents(squad)
  local result = {}

  if
    not squad
    or not squad.engagements
  then
    return result
  end

  local stale = {}

  for opponent in pairs(
    squad.engagements
  ) do
    if isSquadAlive(opponent) then
      result[#result + 1] =
        opponent
    else
      stale[#stale + 1] =
        opponent
    end
  end

  for _, opponent in ipairs(stale) do
    squad.engagements[opponent] = nil
  end

  self:refreshSquadState(squad)

  return result
end


-- Возвращает всю связанную группу боя.
function EngagementSystem:
  getBattleGroup(squad)
  local result = {}

  if not squad then
    return result
  end

  local queue = {
    squad
  }

  local visited = {
    [squad] = true
  }

  local queueIndex = 1

  while queueIndex <= #queue do
    local current =
      queue[queueIndex]

    queueIndex =
      queueIndex + 1

    result[#result + 1] =
      current

    for _, opponent in ipairs(
      self:getOpponents(current)
    ) do
      if not visited[opponent] then
        visited[opponent] = true
        queue[#queue + 1] =
          opponent
      end
    end
  end

  return result
end


-- Проверяет участие в одной схватке.
function EngagementSystem:
  areInSameBattle(
    firstSquad,
    secondSquad
  )
  if
    not firstSquad
    or not secondSquad
  then
    return false
  end

  if firstSquad == secondSquad then
    return true
  end

  for _, squad in ipairs(
    self:getBattleGroup(firstSquad)
  ) do
    if squad == secondSquad then
      return true
    end
  end

  return false
end


-- Проверяет допустимость новой цели.
function EngagementSystem:
  canTargetSquad(
    attackerSquad,
    targetSquad
  )
  if
    not self:canEngage(
      attackerSquad,
      targetSquad
    )
  then
    return false
  end

  if
    not self:isEngaged(
      attackerSquad
    )
  then
    return true
  end

  -- Связанный отряд может менять цель
  -- только внутри текущей схватки.
  return self:areInSameBattle(
    attackerSquad,
    targetSquad
  )
end


-- Удаляет устаревшие связи.
function EngagementSystem:update(dt)
  self.time =
    self.time + dt

  local expired = {}

  for key, link in pairs(
    self.links
  ) do
    local reason = nil

    if
      not isSquadAlive(link.first)
      or not isSquadAlive(link.second)
    then
      reason = 'squad_defeated'

    elseif
      self.time -
      link.lastContact >=
      self.releaseDelay
    then
      reason = 'contact_lost'
    end

    if reason then
      expired[#expired + 1] = {
        key = key,
        reason = reason
      }
    end
  end

  for _, entry in ipairs(
    expired
  ) do
    self:removeLink(
      entry.key,
      entry.reason
    )
  end
end


return EngagementSystem
Следующий файл — обновлённый config.lua.

да

Файл 5 — обновлённый src/autobattle/config.lua:

lua
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

      -- Дополнительный отступ от зданий.
      clearance = .75,

      -- Максимальная допустимая крутизна.
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
Следующий файл — полностью переработанный squad.lua.

да

Analysis

Файл 6 — полная замена src/autobattle/squad.lua:

lua
local Unit =
  require('src.autobattle.unit')

local Order =
  require('src.autobattle.order')


local Squad = {}
Squad.__index = Squad


Squad.State = {
  IDLE = 'idle',
  MOVING = 'moving',
  ATTACKING = 'attacking',
  ENGAGED = 'engaged',
  DEFEATED = 'defeated'
}


local function distanceSquared(
  firstX,
  firstZ,
  secondX,
  secondZ
)
  local dx = secondX - firstX
  local dz = secondZ - firstZ

  return dx * dx + dz * dz
end


-- Ищет свободную начальную позицию.
local function findSpawnPosition(squad)
  local settings =
    squad.gameConfig.squad

  local radius =
    squad.unitDefinition.radius

  local minimumDistance =
    squad.unitDefinition.spawnSpacing
    or radius * 2.15

  for attempt = 1, 100 do
    local x =
      squad.startX +
      (math.random() - .5) *
      settings.spawnWidth

    local z =
      squad.startZ -
      squad.direction *
      math.random() *
      settings.spawnDepth

    local free = true

    for _, unit in ipairs(
      squad.units
    ) do
      local dx = unit.x - x
      local dz = unit.z - z

      if
        dx * dx + dz * dz <
        minimumDistance *
        minimumDistance
      then
        free = false
        break
      end
    end

    if free then
      return x, z
    end
  end

  local index = #squad.units
  local column = index % 10
  local row =
    math.floor(index / 10)

  return
    squad.startX +
    (column - 4.5) *
    minimumDistance,

    squad.startZ -
    squad.direction *
    row *
    minimumDistance
end


-- Создаёт отряд.
function Squad.new(settings)
  local self =
    setmetatable({}, Squad)

  self.id = settings.id

  self.campaignSquadId =
    settings.campaignSquadId

  self.team = settings.team
  self.direction = settings.direction

  self.battle = settings.battle
  self.gameConfig = settings.config

  self.unitDefinition =
    settings.unitDefinition

  self.startX = settings.startX or 0
  self.startZ = settings.startZ or 0

  self.guardPoint =
    settings.guardPoint

  self.units = {}
  self.initialCount = settings.count
  self.activeCount = settings.count

  self.state = Squad.State.IDLE

  self.currentOrder = nil
  self.interruptedOrder = nil

  self.pathRevision = nil
  self.repathTimer = 0

  self.lastPathTargetX = nil
  self.lastPathTargetZ = nil

  self.stuckTimer = 0
  self.lastProgressX = self.startX
  self.lastProgressZ = self.startZ

  self.engagements = {}
  self.engaged = false

  self.formationOffsets = {}

  self.chargeDefinition =
    self.unitDefinition.charge

  self.chargeReady =
    self.chargeDefinition ~= nil
    and self.chargeDefinition.enabled
      == true

  self.chargeActive = false
  self.chargeTimer = 0
  self.chargeUsers = {}

  self.chargeDistance = 0
  self.lastChargeX = self.startX
  self.lastChargeZ = self.startZ

  for index = 1, settings.count do
    local x, z =
      findSpawnPosition(self)

    local unit = Unit.new({
      id =
        self.battle:
          allocateUnitId(),

      squad = self,
      battle = self.battle,

      config =
        self.unitDefinition,

      modelRegistry =
        settings.modelRegistry,

      x = x,
      z = z
    })

    self.units[#self.units + 1] =
      unit
  end

  self:rebuildFormation()

  return self
end


-- Возвращает живых бойцов.
function Squad:getLivingUnits()
  local result = {}

  for _, unit in ipairs(
    self.units
  ) do
    if unit:isTargetable() then
      result[#result + 1] =
        unit
    end
  end

  return result
end


-- Возвращает центр отряда.
function Squad:getCenter()
  local x = 0
  local z = 0
  local count = 0

  for _, unit in ipairs(
    self.units
  ) do
    if unit:isTargetable() then
      x = x + unit.x
      z = z + unit.z
      count = count + 1
    end
  end

  if count == 0 then
    return
      self.startX,
      self.startZ
  end

  return
    x / count,
    z / count
end


-- Возвращает примерный радиус отряда.
function Squad:getRadius()
  local centerX, centerZ =
    self:getCenter()

  local maximum = 0

  for _, unit in ipairs(
    self.units
  ) do
    if unit:isTargetable() then
      local dx =
        unit.x - centerX

      local dz =
        unit.z - centerZ

      local distance =
        math.sqrt(
          dx * dx + dz * dz
        ) + (unit.radius or 0)

      maximum =
        math.max(maximum, distance)
    end
  end

  return maximum
end


-- Перестраивает позиции формации.
function Squad:rebuildFormation()
  self.formationOffsets = {}

  local living =
    self:getLivingUnits()

  table.sort(
    living,

    function(first, second)
      return first.id < second.id
    end
  )

  local spacing =
    self.unitDefinition
      .formationSpacing
    or self.unitDefinition
      .spawnSpacing
    or self.unitDefinition.radius *
      2.5

  local rowSpacing =
    self.unitDefinition
      .formationRowSpacing
    or spacing * 1.15

  local maximumRowSize = 10
  local count = #living

  for index, unit in ipairs(
    living
  ) do
    local row =
      math.floor(
        (index - 1) /
        maximumRowSize
      )

    local firstIndex =
      row * maximumRowSize + 1

    local rowSize =
      math.min(
        maximumRowSize,
        count - firstIndex + 1
      )

    local column =
      index - firstIndex

    self.formationOffsets[unit] = {
      side =
        (
          column -
          (rowSize - 1) * .5
        ) * spacing,

      depth = row * rowSpacing
    }
  end
end


-- Возвращает цель приказа.
function Squad:getOrderTargetPosition(
  order
)
  order = order or self.currentOrder

  if not order then
    return nil, nil
  end

  if order:isMove() then
    return order.x, order.z
  end

  local target = order.target

  if not target then
    return nil, nil
  end

  if
    order.type ==
      Order.Type.ATTACK_SQUAD
  then
    return target:getCenter()
  end

  return target.x, target.z
end


-- Возвращает дистанцию подхода к цели.
function Squad:getAttackApproachRange(
  order
)
  local attackDistance =
    self.unitDefinition.attackDistance
    or 1.5

  if
    order.type ==
      Order.Type.ATTACK_BUILDING
  then
    return
      (order.target.radius or 0) +
      attackDistance
  end

  return math.max(
    attackDistance,
    self.unitDefinition.radius * 3
  )
end


-- Строит путь текущего приказа.
function Squad:rebuildOrderPath()
  local order = self.currentOrder

  if not order then
    return false
  end

  local pathfinder =
    self.battle.pathfinder

  if not pathfinder then
    order:fail(
      'pathfinder_unavailable',
      self.battle.time
    )

    return false
  end

  local centerX, centerZ =
    self:getCenter()

  local targetX, targetZ =
    self:getOrderTargetPosition(order)

  if not targetX then
    order:fail(
      'target_unavailable',
      self.battle.time
    )

    return false
  end

  local path
  local reason

  if order:isAttack() then
    path, reason =
      pathfinder:findPathToRange(
        centerX,
        centerZ,
        targetX,
        targetZ,
        self:getAttackApproachRange(
          order
        )
      )
  else
    path, reason =
      pathfinder:findPath(
        centerX,
        centerZ,
        targetX,
        targetZ
      )
  end

  if not path then
    order:fail(
      reason or 'unreachable',
      self.battle.time
    )

    return false
  end

  order:setPath(path)

  self.pathRevision =
    self.battle.navigationGrid:
      getRevision()

  self.lastPathTargetX = targetX
  self.lastPathTargetZ = targetZ
  self.repathTimer = 0
  self.stuckTimer = 0

  self.lastProgressX = centerX
  self.lastProgressZ = centerZ

  return true
end


-- Назначает приказ.
function Squad:setOrder(order)
  if self:isDefeated() then
    return false, 'defeated'
  end

  if self.currentOrder then
    self.currentOrder:cancel(
      'replaced',
      self.battle.time
    )
  end

  self.currentOrder = order
  self.interruptedOrder = nil

  order:activate(
    self.battle.time
  )

  if order:isMove() then
    self.state = Squad.State.MOVING
  else
    self.state = Squad.State.ATTACKING
  end

  if not self:rebuildOrderPath() then
    self.currentOrder = nil
    self.state = Squad.State.IDLE

    return false, 'unreachable'
  end

  return true
end


-- Отдаёт приказ движения.
function Squad:issueMove(
  x,
  z,
  source
)
  if
    self.battle.engagementSystem:
      isEngaged(self)
  then
    return false, 'engaged'
  end

  return self:setOrder(
    Order.move(
      x,
      z,
      {
        source = source or 'player',
        createdAt = self.battle.time
      }
    )
  )
end


-- Отдаёт приказ атаки отряда.
function Squad:issueAttackSquad(
  target,
  source
)
  if
    not target
    or target:isDefeated()
    or target.team == self.team
  then
    return false, 'invalid_target'
  end

  if
    self.engaged
    and not self.battle
      .engagementSystem:
        canTargetSquad(
          self,
          target
        )
  then
    return false, 'outside_engagement'
  end

  return self:setOrder(
    Order.attackSquad(
      target,
      {
        source = source or 'player',
        createdAt = self.battle.time
      }
    )
  )
end


-- Отдаёт приказ атаки здания.
function Squad:issueAttackBuilding(
  building,
  source
)
  if
    not building
    or not building:isTargetable()
    or building.team == self.team
  then
    return false, 'invalid_target'
  end

  if self.engaged then
    return false, 'engaged'
  end

  return self:setOrder(
    Order.attackBuilding(
      building,
      {
        source = source or 'player',
        createdAt = self.battle.time
      }
    )
  )
end


-- Вступает в автоматический бой.
function Squad:beginAutomaticAttack(
  target
)
  if
    not target
    or target:isDefeated()
  then
    return false
  end

  if
    self.currentOrder
    and self.currentOrder:isMove()
  then
    self.currentOrder:interrupt(
      'enemy_detected'
    )

    self.interruptedOrder =
      self.currentOrder
  end

  local order =
    Order.attackSquad(
      target,
      {
        source = 'automatic',
        createdAt = self.battle.time
      }
    )

  self.currentOrder = order

  order:activate(
    self.battle.time
  )

  self.state =
    self.engaged
    and Squad.State.ENGAGED
    or Squad.State.ATTACKING

  return self:rebuildOrderPath()
end


-- Возобновляет прерванное движение.
function Squad:resumeInterruptedOrder()
  local order =
    self.interruptedOrder

  self.interruptedOrder = nil

  if
    not order
    or order:isFinished()
  then
    return false
  end

  order:resume()

  self.currentOrder = order
  self.state = Squad.State.MOVING

  return self:rebuildOrderPath()
end


-- Ищет новую цель рядом.
function Squad:findRetarget()
  local radius =
    self.gameConfig.engagement
      .retargetRadius

  return self.battle:
    findNearestEnemyTargetForSquad(
      self,
      radius
    )
end


-- Обрабатывает уничтожение цели.
function Squad:finishAttackOrder()
  if self.currentOrder then
    self.currentOrder:complete(
      self.battle.time
    )
  end

  self.currentOrder = nil

  local target =
    self:findRetarget()

  if target then
    if target.isBuilding then
      return self:
        issueAttackBuilding(
          target,
          'retarget'
        )
    end

    return self:
      beginAutomaticAttack(target)
  end

  if self:resumeInterruptedOrder() then
    return true
  end

  self.state = Squad.State.IDLE

  return false
end


-- Вызывается при начале melee-связи.
function Squad:onEngagementStarted(
  opponent
)
  self.engaged = true
  self.state = Squad.State.ENGAGED

  if
    self.currentOrder
    and self.currentOrder:isMove()
  then
    self.currentOrder:interrupt(
      'melee_engagement'
    )

    self.interruptedOrder =
      self.currentOrder

    self.currentOrder = nil
  end

  if
    not self.currentOrder
    or not self.currentOrder:isAttack()
  then
    local order =
      Order.attackSquad(
        opponent,
        {
          source = 'engagement',
          createdAt = self.battle.time
        }
      )

    order:activate(
      self.battle.time
    )

    self.currentOrder = order
  end
end


-- Вызывается при окончании melee-связи.
function Squad:onEngagementEnded()
  self.engaged =
    self.battle.engagementSystem:
      isEngaged(self)

  if self.engaged then
    self.state = Squad.State.ENGAGED
    return
  end

  if
    self.currentOrder
    and self.currentOrder:isAttack()
    and self.currentOrder:
      isTargetValid()
  then
    self.state = Squad.State.ATTACKING
    self:rebuildOrderPath()
    return
  end

  self:finishAttackOrder()
end


-- Возвращает текущую точку пути.
function Squad:getCurrentWaypoint()
  if not self.currentOrder then
    return nil
  end

  return
    self.currentOrder:
      getPathPoint()
end


-- Возвращает позицию бойца в строю.
function Squad:getUnitMovementTarget(
  unit
)
  local waypoint =
    self:getCurrentWaypoint()

  if not waypoint then
    return nil, nil
  end

  local centerX, centerZ =
    self:getCenter()

  local dx = waypoint.x - centerX
  local dz = waypoint.z - centerZ

  local length =
    math.sqrt(
      dx * dx + dz * dz
    )

  if length <= .001 then
    return waypoint.x, waypoint.z
  end

  dx = dx / length
  dz = dz / length

  local rightX = -dz
  local rightZ = dx

  local offset =
    self.formationOffsets[unit]
    or {
      side = 0,
      depth = 0
    }

  return
    waypoint.x +
    rightX * offset.side -
    dx * offset.depth,

    waypoint.z +
    rightZ * offset.side -
    dz * offset.depth
end


-- Проверяет наличие движения.
function Squad:hasMovementOrder()
  return
    self.currentOrder ~= nil
    and not self.engaged
    and self.currentOrder:
      getPathPoint() ~= nil
end


-- Обновляет прохождение пути.
function Squad:updatePathProgress()
  local order = self.currentOrder

  if
    not order
    or self.engaged
  then
    return
  end

  local waypoint =
    order:getPathPoint()

  if not waypoint then
    if order:isMove() then
      order:complete(
        self.battle.time
      )

      self.currentOrder = nil
      self.state = Squad.State.IDLE
    end

    return
  end

  local centerX, centerZ =
    self:getCenter()

  local radius =
    self.gameConfig.navigation
      .waypointRadius

  if
    distanceSquared(
      centerX,
      centerZ,
      waypoint.x,
      waypoint.z
    ) <= radius * radius
  then
    local hasNext =
      order:advancePath()

    if not hasNext then
      if order:isMove() then
        order:complete(
          self.battle.time
        )

        self.currentOrder = nil
        self.state = Squad.State.IDLE
      end
    end
  end
end


-- Проверяет перестроение пути.
function Squad:updateRepath(dt)
  local order = self.currentOrder

  if
    not order
    or self.engaged
    or order:isFinished()
  then
    return
  end

  self.repathTimer =
    self.repathTimer + dt

  local revision =
    self.battle.navigationGrid:
      getRevision()

  if revision ~= self.pathRevision then
    self:rebuildOrderPath()
    return
  end

  local targetX, targetZ =
    self:getOrderTargetPosition(order)

  if not targetX then
    return
  end

  local settings =
    self.gameConfig.navigation

  if
    order:isAttack()
    and self.repathTimer >=
      settings.repathInterval
  then
    local threshold =
      settings.repathDistance

    if
      not self.lastPathTargetX
      or distanceSquared(
        targetX,
        targetZ,
        self.lastPathTargetX,
        self.lastPathTargetZ
      ) >= threshold * threshold
    then
      self:rebuildOrderPath()
    else
      self.repathTimer = 0
    end
  end
end


-- Проверяет застревание отряда.
function Squad:updateStuck(dt)
  if
    not self:hasMovementOrder()
  then
    self.stuckTimer = 0
    return
  end

  local centerX, centerZ =
    self:getCenter()

  local settings =
    self.gameConfig.squad

  local movedSquared =
    distanceSquared(
      centerX,
      centerZ,
      self.lastProgressX,
      self.lastProgressZ
    )

  if
    movedSquared >=
    settings.stuckDistance *
    settings.stuckDistance
  then
    self.lastProgressX = centerX
    self.lastProgressZ = centerZ
    self.stuckTimer = 0
    return
  end

  self.stuckTimer =
    self.stuckTimer + dt

  if
    self.stuckTimer >=
    settings.stuckTimeout
  then
    self:rebuildOrderPath()
  end
end


-- Открывает окно суперудара.
function Squad:startChargeWindow()
  if
    not self.chargeDefinition
    or not self.chargeReady
  then
    return false
  end

  self.chargeReady = false
  self.chargeActive = true

  self.chargeTimer =
    self.chargeDefinition
      .windowDuration or 1

  self.chargeUsers = {}
  self.chargeDistance = 0

  return true
end


-- Разрешает бойцу суперудар.
function Squad:claimChargeHit(unit)
  if
    not self.chargeDefinition
    or not self.chargeDefinition.enabled
  then
    return nil
  end

  if self.chargeReady then
    self:startChargeWindow()
  end

  if not self.chargeActive then
    return nil
  end

  if self.chargeUsers[unit.id] then
    return nil
  end

  self.chargeUsers[unit.id] = true

  return self.chargeDefinition
end


-- Обновляет перезарядку натиска.
function Squad:updateCharge(dt)
  local centerX, centerZ =
    self:getCenter()

  if self.chargeActive then
    self.chargeTimer =
      self.chargeTimer - dt

    if self.chargeTimer <= 0 then
      self.chargeTimer = 0
      self.chargeActive = false
    end
  end

  if
    not self.chargeReady
    and not self.chargeActive
    and self.state ==
      Squad.State.MOVING
  then
    local dx =
      centerX - self.lastChargeX

    local dz =
      centerZ - self.lastChargeZ

    self.chargeDistance =
      self.chargeDistance +
      math.sqrt(
        dx * dx + dz * dz
      )

    local required =
      self.chargeDefinition
      and self.chargeDefinition
        .rechargeDistance
      or 20

    if self.chargeDistance >= required then
      self.chargeReady = true
      self.chargeUsers = {}
      self.chargeDistance = 0
    end
  end

  self.lastChargeX = centerX
  self.lastChargeZ = centerZ
end


-- Учитывает погибшего бойца.
function Squad:onUnitRemoved(
  unit,
  reason
)
  if unit.countedAsRemoved then
    return
  end

  unit.countedAsRemoved = true
  unit.removalReason = reason

  self.activeCount =
    math.max(
      0,
      self.activeCount - 1
    )

  self:rebuildFormation()

  if self.activeCount <= 0 then
    self.state = Squad.State.DEFEATED

    if self.currentOrder then
      self.currentOrder:cancel(
        'squad_defeated',
        self.battle.time
      )
    end

    self.currentOrder = nil
    self.interruptedOrder = nil

    self.battle.engagementSystem:
      clearSquad(
        self,
        'squad_defeated'
      )
  end
end


-- Проверяет уничтожение отряда.
function Squad:isDefeated()
  return self.activeCount <= 0
end


-- Обновляет отряд.
function Squad:update(dt)
  if self:isDefeated() then
    return
  end

  if
    self.currentOrder
    and self.currentOrder:isAttack()
    and not self.currentOrder:
      isTargetValid()
  then
    self:finishAttackOrder()
  end

  self:updatePathProgress()
  self:updateRepath(dt)
  self:updateStuck(dt)
  self:updateCharge(dt)
end


return Squad
Следующим должен идти unit.lua. Он большой, поэтому его придётся отправлять несколькими последовательными частями.

да

Analysis

src/autobattle/unit.lua, часть 1 из 4. Эта часть заканчивается после isInsideRangedDistance.

lua
local Entity =
  require('src.world.entity')

local SoundPlayer =
  require('src.audio.sound_player')


local Unit = {}
Unit.__index = Unit


-- Возвращает случайное число диапазона.
local function randomRange(
  minimum,
  maximum
)
  minimum = minimum or 0
  maximum = maximum or minimum

  return
    minimum +
    math.random() *
    (maximum - minimum)
end


-- Создаёт независимого бойца.
function Unit.new(settings)
  local self =
    setmetatable({}, Unit)

  self.id = settings.id
  self.squad = settings.squad
  self.team = self.squad.team
  self.config = settings.config
  self.battle = settings.battle

  self.x = settings.x
  self.z = settings.z

  self.y =
    self.battle.field:getHeight(
      self.x,
      self.z
    )

  self.previousX = self.x
  self.previousZ = self.z

  self.radius = self.config.radius
  self.health = self.config.health
  self.maximumHealth = self.health

  self.damageMinimum =
    self.config.damageMinimum

  self.damageMaximum =
    self.config.damageMaximum

  self.damageType =
    self.config.damageType
    or 'normal'

  self.attackDistance =
    self.config.attackDistance
    or 0

  self.rangedAttack =
    self.config.rangedAttack

  self.sightDistance =
    self.config.sightDistance
    or self.attackDistance

  if self.rangedAttack then
    self.sightDistance =
      math.max(
        self.sightDistance,

        self.rangedAttack
          .maximumDistance
        or 0
      )
  end

  self.lastAttackIndex = nil
  self.rangedCooldown = 0

  self.state = 'idle'

  self.attackKind = nil
  self.attackPhase = nil
  self.attackDefinition = nil

  self.target = nil

  -- Отдельных маршрутов у бойцов больше нет.
  -- Направление движения задаёт отряд.
  self.blockedTime = 0

  self.avoidanceSide =
    math.random() < .5
    and -1
    or 1

  self.removed = false
  self.combatAlive = true
  self.countedAsRemoved = false

  self.corpseDefinition =
    self.config.corpse
    or {
      mode = 'never',
      stayChance = 0
    }

  local defaultCorpseLifetime =
    self.battle.config.unit
    and self.battle.config.unit
      .corpseLifetime
    or 60

  self.corpseLifetime =
    self.corpseDefinition.lifetime
    or defaultCorpseLifetime

  self.corpseTime = 0
  self.corpseResolved = false

  self.fallDefinition =
    self.config.fallDeath
    or {
      enabled = true,

      distanceMinimum = 2.5,
      distanceMaximum = 3.4,

      heightMinimum = 1.3,
      heightMaximum = 1.9,

      durationMinimum = .7,
      durationMaximum = .95
    }

  self.fallPhase = nil
  self.fallTime = 0
  self.fallDuration = 0

  self.flyingBehavior =
    require(
      'src.autobattle.flying_behavior'
    ).new(self)

  self.entity = Entity.new({
    id =
      'battle_unit_' ..
      self.id,

    model = self.config.model,
    tint = self.config.tint,

    position = {
      self.x,
      self.y,
      self.z
    },

    animation = 'idle',
    solid = false
  }, settings.modelRegistry)

  self.visualYaw =
    self.entity.yaw or 0

  self.targetYaw =
    self.visualYaw

  -- Скорость только визуального поворота.
  self.turnSpeed =
    self.config.turnSpeed
    or math.rad(270)

  SoundPlayer.preload(
    self.entity.definition.sounds
  )

  return self
end


-- Проигрывает звук бойца.
function Unit:playSound(name)
  local sounds =
    self.entity.definition.sounds

  if not sounds then
    return
  end

  SoundPlayer.play(
    sounds[name],

    self.x,
    self.y +
    (sounds.height or .8),

    self.z,

    {
      kind = name,
      group = name
    }
  )
end


-- Запоминает позицию перед шагом.
function Unit:beginSimulationStep()
  self.previousX = self.x
  self.previousZ = self.z
end


-- Проверяет участие в столкновениях.
function Unit:isSpatiallyActive()
  return
    self.combatAlive
    and not self.removed
end


-- Проверяет доступность для атаки.
function Unit:isTargetable()
  return
    self.combatAlive
    and not self.removed
end


-- Возвращает охраняемую точку монстра.
function Unit:getGuardPoint()
  if
    self.team ~= 'monsters'
    or not self.squad.guardPoint
    or not self.battle.captureSystem
  then
    return nil
  end

  return
    self.battle.captureSystem:
      getPoint(
        self.squad.guardPoint
      )
end


-- Возвращает личное место монстра.
function Unit:getGuardHomePosition(
  point
)
  local radius =
    point.guardFormationRadius
    or 7

  -- Золотой угол равномерно
  -- распределяет бойцов по окружности.
  local angle =
    (
      self.id *
      2.3999632297
    ) % (
      math.pi * 2
    )

  return
    point.x +
    math.cos(angle) * radius,

    point.z +
    math.sin(angle) * radius
end


-- Возвращает монстра к охраняемой точке.
function Unit:updateGuardMovement(
  dt,
  point
)
  local targetX, targetZ =
    self:getGuardHomePosition(
      point
    )

  local dx = targetX - self.x
  local dz = targetZ - self.z

  local distance =
    math.sqrt(
      dx * dx + dz * dz
    )

  if distance <= .001 then
    self:waitForPath(dt)
    return
  end

  self.target = nil

  self:moveInDirection(
    dt,
    dx / distance,
    dz / distance
  )
end


-- Синхронизирует визуальную сущность.
function Unit:syncEntity()
  self.entity.x = self.x

  local visualHeight = 0

  if self.flyingBehavior then
    visualHeight =
      self.flyingBehavior:
        getHeight()
  end

  self.entity.y =
    self.y + visualHeight

  self.entity.z = self.z
end


-- Устанавливает анимацию.
function Unit:setAnimation(name)
  if not name then
    return
  end

  if name == 'idle' then
    local battleAnimations =
      self.entity.definition
        .battleAnimations

    name =
      battleAnimations
      and battleAnimations.idle
      or 'idle'
  end

  if
    self.entity.animationName ==
    name
  then
    return
  end

  self.entity:setAnimation(
    name,
    true
  )
end


-- Запоминает желаемое направление.
function Unit:faceDirection(dx, dz)
  if
    dx * dx + dz * dz <
    .0001
  then
    return
  end

  self.targetYaw =
    math.atan2(-dx, -dz)
end


-- Плавно поворачивает модель.
function Unit:updateVisualRotation(dt)
  local fullTurn =
    math.pi * 2

  local difference =
    (
      self.targetYaw -
      self.visualYaw +
      math.pi
    ) % fullTurn - math.pi

  local maximumStep =
    self.turnSpeed * dt

  if
    math.abs(difference) <=
    maximumStep
  then
    self.visualYaw =
      self.targetYaw
  else
    self.visualYaw =
      self.visualYaw +
      (
        difference > 0
        and maximumStep
        or -maximumStep
      )
  end

  self.visualYaw =
    (
      self.visualYaw +
      math.pi
    ) % fullTurn - math.pi

  self.entity.yaw =
    self.visualYaw
end


-- Возвращает расстояние до цели.
function Unit:getDistanceTo(target)
  local dx = target.x - self.x
  local dz = target.z - self.z

  local distance =
    math.sqrt(
      dx * dx + dz * dz
    )

  if target.isBuilding then
    distance =
      distance -
      (target.radius or 0)
  end

  return math.max(
    0,
    distance
  )
end


-- Возвращает случайную анимацию смерти.
function Unit:getDeathAnimation()
  local deaths =
    self.entity.definition
      .battleAnimations.deaths

  return deaths[
    math.random(1, #deaths)
  ]
end


-- Возвращает анимации падения.
function Unit:getFallAnimations()
  local battleAnimations =
    self.entity.definition
      .battleAnimations

  local fall =
    battleAnimations
    and battleAnimations.fall

  if not fall then
    return nil
  end

  local animations =
    self.entity.definition.animations

  if
    not animations
    or not animations[fall.start]
    or not animations[fall.airborne]
    or not animations[fall.land]
  then
    return nil
  end

  return fall
end


-- Проверяет наличие ближней атаки.
function Unit:hasMeleeAttack()
  local battleAnimations =
    self.entity.definition
      .battleAnimations

  local attacks =
    battleAnimations
    and battleAnimations.attacks

  return
    attacks ~= nil
    and #attacks > 0
end


-- Проверяет наличие дальней атаки.
function Unit:hasRangedAttack()
  if not self.rangedAttack then
    return false
  end

  local battleAnimations =
    self.entity.definition
      .battleAnimations

  return
    battleAnimations ~= nil
    and battleAnimations.ranged
      ~= nil
    and self.rangedAttack.projectile
      ~= nil
end


-- Возвращает перезарядку выстрела.
function Unit:getRangedCooldown()
  local settings =
    self.rangedAttack

  local minimum =
    settings.cooldownMinimum
    or settings.cooldown
    or 1

  local maximum =
    settings.cooldownMaximum
    or settings.cooldown
    or minimum

  if maximum < minimum then
    maximum = minimum
  end

  return randomRange(
    minimum,
    maximum
  )
end


-- Проверяет дистанцию выстрела.
function Unit:isInsideRangedDistance(
  distance
)
  if not self:hasRangedAttack() then
    return false
  end

  local minimum =
    self.rangedAttack
      .minimumDistance
    or 0

  local maximum =
    self.rangedAttack
      .maximumDistance
    or self.sightDistance

  return
    distance >= minimum
    and distance <= maximum
end
Следующая часть начинается с движения по приказу отряда и заканчивается перед обработкой melee-атаки.

да

Analysis

src/autobattle/unit.lua, часть 2 из 4. Вставляется сразу после первой части.

lua
-- Проверяет разрешение атаковать цель.
function Unit:isCombatTargetAllowed(
  target
)
  if
    not target
    or target.team == self.team
    or not target:isTargetable()
  then
    return false
  end

  local engagementSystem =
    self.battle.engagementSystem

  if
    self.squad.engaged
    and not target.isBuilding
  then
    return engagementSystem:
      areInSameBattle(
        self.squad,
        target.squad
      )
  end

  if
    self.squad.engaged
    and target.isBuilding
  then
    return false
  end

  return true
end


-- Ищет ближайшего допустимого бойца.
function Unit:findNearestEnemyUnit(
  radius
)
  return self.battle.grid:
    findNearest(
      self.x,
      self.z,
      radius,

      function(candidate)
        return
          candidate ~= self
          and self:
            isCombatTargetAllowed(
              candidate
            )
      end
    )
end


-- Ищет предпочтительную боевую цель.
function Unit:findPreferredEnemy(
  radius
)
  local enemy =
    self:findNearestEnemyUnit(
      radius
    )

  if enemy then
    local order =
      self.squad.currentOrder

    -- При обычном движении встреченный
    -- противник прерывает приказ всему отряду.
    if
      order
      and order:isMove()
      and enemy.squad
    then
      self.squad:
        beginAutomaticAttack(
          enemy.squad
        )
    end

    return enemy
  end

  local order =
    self.squad.currentOrder

  if
    order
    and order:isAttack()
    and order:isTargetValid()
  then
    if
      order.type ==
        'attack_building'
    then
      local building =
        order.target

      if
        self:getDistanceTo(building)
        <= radius
      then
        return building
      end
    elseif
      order.type ==
        'attack_squad'
    then
      local nearest = nil
      local nearestDistance = radius

      for _, candidate in ipairs(
        order.target.units
      ) do
        if
          candidate:isTargetable()
        then
          local distance =
            self:getDistanceTo(
              candidate
            )

          if distance < nearestDistance then
            nearest = candidate
            nearestDistance = distance
          end
        end
      end

      if nearest then
        return nearest
      end
    end
  end

  if
    not self.squad.engaged
    and self.battle.buildingSystem
  then
    return
      self.battle.buildingSystem:
        findNearestEnemyBuilding(
          self,
          radius
        )
  end

  return nil
end


-- Удаляет бойца за границей карты.
function Unit:checkMapExit()
  local map =
    self.battle.map.field

  local outside =
    math.abs(self.x) >
      map.width * .5
    or math.abs(self.z) >
      map.length * .5

  if not outside then
    return false
  end

  self.combatAlive = false
  self.removed = true
  self.target = nil

  self.squad:onUnitRemoved(
    self,
    'exited'
  )

  return true
end


-- Выполняет суперудар на ходу.
function Unit:tryChargeHit(
  target,
  dt
)
  if
    self.squad.engaged
    or not self.squad:
      hasMovementOrder()
  then
    return false
  end

  local charge =
    self.squad:claimChargeHit(
      self
    )

  if not charge then
    return false
  end

  local minimum =
    charge.damageMinimum

  local maximum =
    charge.damageMaximum

  if not minimum then
    minimum =
      self.damageMinimum *
      (charge.damageMultiplier or 1)
  end

  if not maximum then
    maximum =
      self.damageMaximum *
      (charge.damageMultiplier or 1)
  end

  local damage =
    randomRange(
      minimum,
      maximum
    )

  self:faceDirection(
    target.x - self.x,
    target.z - self.z
  )

  self.state = 'moving'

  self:setAnimation(
    self.entity.definition
      .battleAnimations.forward
  )

  self:playSound('attack')

  target:takeDamage(
    damage,
    self.damageType,
    {
      source = self,
      x = self.x,
      z = self.z,

      radiusAttack = false,

      launchOnKill =
        charge.launchOnKill
          == true,

      chargeAttack = true
    }
  )

  self.entity:update(dt)

  return true
end


-- Начинает ближнюю атаку.
function Unit:startMeleeAttack(target)
  local attacks =
    self.entity.definition
      .battleAnimations.attacks

  local attackIndex =
    math.random(1, #attacks)

  if
    #attacks > 1
    and attackIndex ==
      self.lastAttackIndex
  then
    attackIndex =
      attackIndex %
      #attacks + 1
  end

  self.lastAttackIndex =
    attackIndex

  self.attackDefinition =
    attacks[attackIndex]

  self.target = target
  self.attackKind = 'melee'
  self.attackPhase = 'start'
  self.state = 'attacking'

  -- Melee-контакт связывает оба отряда.
  if
    target.squad
    and self.battle
      .engagementSystem
  then
    self.battle.engagementSystem:
      touchUnits(
        self,
        target
      )
  end

  self.entity:setAnimation(
    self.attackDefinition.start,
    true
  )
end


-- Начинает дальнюю атаку.
function Unit:startRangedAttack(target)
  self.target = target
  self.attackKind = 'ranged'
  self.attackPhase = 'start'
  self.state = 'attacking'

  self.attackDefinition =
    self.entity.definition
      .battleAnimations.ranged

  self.entity:setAnimation(
    self.attackDefinition.start,
    true
  )
end


-- Завершает атаку.
function Unit:finishAttack()
  self.target = nil
  self.attackKind = nil
  self.attackPhase = nil
  self.attackDefinition = nil
  self.state = 'idle'
end


-- Выпускает снаряд.
function Unit:fireProjectile()
  local settings =
    self.rangedAttack

  local target = self.target

  if
    not target
    or not self:
      isCombatTargetAllowed(target)
    or not self:
      isInsideRangedDistance(
        self:getDistanceTo(target)
      )
  then
    target =
      self:findPreferredEnemy(
        settings.maximumDistance
        or self.sightDistance
      )
  end

  if not target then
    return false
  end

  local distance =
    self:getDistanceTo(target)

  if
    not self:isInsideRangedDistance(
      distance
    )
  then
    return false
  end

  self.target = target

  self:faceDirection(
    target.x - self.x,
    target.z - self.z
  )

  local dx = target.x - self.x
  local dz = target.z - self.z

  local horizontalLength =
    math.sqrt(
      dx * dx + dz * dz
    )

  local directionX = 0
  local directionZ = 0

  if horizontalLength > .0001 then
    directionX =
      dx / horizontalLength

    directionZ =
      dz / horizontalLength
  end

  local spawnForward =
    settings.spawnForward or 0

  local spawnHeight =
    settings.spawnHeight or 1.2

  local targetHeight =
    settings.targetHeight or .8

  self.battle:spawnProjectile(
    settings.projectile,
    {
      team = self.team,
      source = self,

      x =
        self.x +
        directionX *
        spawnForward,

      y =
        self.y +
        spawnHeight,

      z =
        self.z +
        directionZ *
        spawnForward,

      target = target,
      targetX = target.x,

      targetY =
        target.y +
        targetHeight,

      targetZ = target.z
    }
  )

  self:playSound('attack')

  self.rangedCooldown =
    self:getRangedCooldown()

  return true
end
Следующая часть содержит полный melee/ranged цикл, получение урона, смерть и падение.

да

Analysis

src/autobattle/unit.lua, часть 3 из 5. Из-за размера смерть вынесена в следующую часть.

lua
-- Обновляет ближнюю атаку.
function Unit:updateMeleeAttack(dt)
  local victim =
    self:findPreferredEnemy(
      self.attackDistance
    )

  self.target = victim

  if victim then
    self:faceDirection(
      victim.x - self.x,
      victim.z - self.z
    )

    -- Поддерживает связь между ударами,
    -- пока противники остаются рядом.
    if
      victim.squad
      and self.battle
        .engagementSystem
    then
      self.battle.engagementSystem:
        touchUnits(
          self,
          victim
        )
    end
  end

  self.entity:update(dt)

  if
    not self.entity:
      isAnimationFinished()
  then
    return
  end

  if self.attackPhase == 'start' then
    self.attackPhase = 'hit'

    self.entity:setAnimation(
      self.attackDefinition.hit,
      true
    )

    victim =
      self:findPreferredEnemy(
        self.attackDistance
      )

    self.target = victim

    if victim then
      if
        victim.squad
        and self.battle
          .engagementSystem
      then
        self.battle.engagementSystem:
          touchUnits(
            self,
            victim
          )
      end

      self:playSound('attack')

      local area =
        self.config.meleeArea

      if area and area.enabled then
        self.battle:damageRadius(
          self.x,
          self.z,
          area.radius,

          {
            damageMinimum =
              area.damageMinimum
              or self.damageMinimum,

            damageMaximum =
              area.damageMaximum
              or self.damageMaximum,

            damageType =
              area.damageType
              or self.damageType,

            friendlyFire =
              area.friendlyFire == true,

            damageFalloff =
              area.damageFalloff
              or 'uniform',

            launchOnKill =
              area.launchOnKill
              ~= false
          },

          self.team,
          self
        )
      else
        local damage =
          math.random(
            self.damageMinimum,
            self.damageMaximum
          )

        victim:takeDamage(
          damage,
          self.damageType,
          {
            source = self,
            x = self.x,
            z = self.z,
            radiusAttack = false
          }
        )
      end
    end

    return
  end

  if self.attackPhase == 'hit' then
    self.attackPhase = 'finish'

    self.entity:setAnimation(
      self.attackDefinition.finish,
      true
    )

    return
  end

  self:finishAttack()
end


-- Обновляет дальнюю атаку.
function Unit:updateRangedAttack(dt)
  if
    self.target
    and self.target:isTargetable()
  then
    self:faceDirection(
      self.target.x - self.x,
      self.target.z - self.z
    )
  end

  self.entity:update(dt)

  if
    not self.entity:
      isAnimationFinished()
  then
    return
  end

  if self.attackPhase == 'start' then
    self.attackPhase = 'fire'

    self.entity:setAnimation(
      self.attackDefinition.fire,
      true
    )

    self:fireProjectile()

    return
  end

  if self.attackPhase == 'fire' then
    self.attackPhase = 'finish'

    self.entity:setAnimation(
      self.attackDefinition.finish,
      true
    )

    return
  end

  self:finishAttack()
end


-- Обновляет текущую атаку.
function Unit:updateAttack(dt)
  if self.attackKind == 'ranged' then
    self:updateRangedAttack(dt)
  else
    self:updateMeleeAttack(dt)
  end
end


-- Ожидает освобождения пути.
function Unit:waitForPath(dt)
  self.blockedTime =
    self.blockedTime + dt

  if self.blockedTime >= .5 then
    self.blockedTime = 0

    self.avoidanceSide =
      -self.avoidanceSide
  end

  self.state = 'idle'
  self:setAnimation('idle')
  self.entity:update(dt)
end


-- Ожидает перезарядки.
function Unit:waitForRangedAttack(
  dt,
  target
)
  self.state = 'idle'
  self.blockedTime = 0

  if target then
    self:faceDirection(
      target.x - self.x,
      target.z - self.z
    )
  end

  self:setAnimation('idle')
  self.entity:update(dt)
end


-- Проверяет будущую мировую позицию.
function Unit:isMovementPositionValid(
  worldX,
  worldZ
)
  local grid =
    self.battle.navigationGrid

  if not grid then
    return true
  end

  return grid:isWorldWalkable(
    worldX,
    worldZ
  )
end


-- Двигает бойца.
function Unit:moveInDirection(
  dt,
  desiredX,
  desiredZ
)
  local movementX, movementZ =
    self.battle:
      chooseMovementDirection(
        self,
        desiredX,
        desiredZ
      )

  if not movementX then
    self:waitForPath(dt)
    return false
  end

  local movement =
    self.config.moveSpeed * dt

  local nextX =
    self.x +
    movementX * movement

  local nextZ =
    self.z +
    movementZ * movement

  if
    not self:isMovementPositionValid(
      nextX,
      nextZ
    )
  then
    self:waitForPath(dt)
    return false
  end

  self.blockedTime = 0

  self.x = nextX
  self.z = nextZ

  self.y =
    self.battle.field:getHeight(
      self.x,
      self.z
    )

  self:faceDirection(
    movementX,
    movementZ
  )

  self.state = 'moving'

  self:setAnimation(
    self.entity.definition
      .battleAnimations.forward
  )

  self.entity:update(dt)
  self:checkMapExit()

  return true
end


-- Двигается к противнику.
function Unit:updateCombatMovement(
  dt,
  target
)
  local dx = target.x - self.x
  local dz = target.z - self.z

  local distance =
    math.sqrt(
      dx * dx + dz * dz
    )

  if distance <= .0001 then
    self:waitForPath(dt)
    return
  end

  self:moveInDirection(
    dt,
    dx / distance,
    dz / distance
  )
end


-- Двигается по приказу отряда.
function Unit:updateOrderMovement(dt)
  if
    self.squad.engaged
    or not self.squad:
      hasMovementOrder()
  then
    self:waitForPath(dt)
    return
  end

  local targetX, targetZ =
    self.squad:
      getUnitMovementTarget(self)

  if not targetX then
    self:waitForPath(dt)
    return
  end

  local dx = targetX - self.x
  local dz = targetZ - self.z

  local distance =
    math.sqrt(
      dx * dx + dz * dz
    )

  local radius =
    self.battle.config
      .navigation
      .waypointRadius

  if distance <= radius then
    self:waitForPath(dt)
    return
  end

  self.target = nil

  self:moveInDirection(
    dt,
    dx / distance,
    dz / distance
  )
end
Следующая часть — смерть, трупы, падение и получение урона.

да

src/autobattle/unit.lua, часть 4 из 5:

lua
-- Завершает отображение тела.
function Unit:resolveCorpse()
  if self.corpseResolved then
    return
  end

  self.corpseResolved = true

  local corpse =
    self.corpseDefinition

  local shouldStay =
    corpse.mode == 'always'

  if corpse.mode == 'random' then
    shouldStay =
      math.random() <
      (corpse.stayChance or 0)
  end

  if shouldStay then
    self.state = 'corpse'
    self.corpseTime = 0
  else
    self.removed = true
  end
end


-- Обновляет оставшийся труп.
function Unit:updateCorpse(dt)
  self.corpseTime =
    self.corpseTime + dt

  if
    self.corpseTime >=
    self.corpseLifetime
  then
    self.removed = true
    return
  end

  self:syncEntity()
end


-- Запускает обычную смерть.
function Unit:startNormalDeath()
  self.state = 'dying'

  self.entity:setAnimation(
    self:getDeathAnimation(),
    true
  )
end


-- Запускает отлёт от удара.
function Unit:startFallDeath(context)
  local settings =
    self.fallDefinition

  local sourceX =
    context.x
    or (
      context.source
      and context.source.x
    )
    or self.x

  local sourceZ =
    context.z
    or (
      context.source
      and context.source.z
    )
    or self.z

  local directionX =
    self.x - sourceX

  local directionZ =
    self.z - sourceZ

  local length =
    math.sqrt(
      directionX * directionX +
      directionZ * directionZ
    )

  if length <= .0001 then
    local angle =
      math.random() *
      math.pi * 2

    directionX = math.cos(angle)
    directionZ = math.sin(angle)
  else
    directionX =
      directionX / length

    directionZ =
      directionZ / length
  end

  self.state = 'falling'
  self.fallPhase = 'flight'
  self.fallTime = 0

  self.fallDuration =
    randomRange(
      settings.durationMinimum
        or settings.duration
        or .8,

      settings.durationMaximum
        or settings.duration
        or .8
    )

  self.fallHeight =
    randomRange(
      settings.heightMinimum
        or settings.height
        or 1.5,

      settings.heightMaximum
        or settings.height
        or 1.5
    )

  self.fallDistance =
    randomRange(
      settings.distanceMinimum
        or settings.distance
        or 2.5,

      settings.distanceMaximum
        or settings.distance
        or 2.5
    )

  self.fallStartX = self.x
  self.fallStartY = self.y
  self.fallStartZ = self.z

  self.fallEndX =
    self.x +
    directionX *
    self.fallDistance

  self.fallEndZ =
    self.z +
    directionZ *
    self.fallDistance

  self.fallAnimations =
    self:getFallAnimations()

  if self.fallAnimations then
    self.entity:setAnimation(
      self.fallAnimations.start,
      true
    )
  else
    self.entity:setAnimation(
      self:getDeathAnimation(),
      true
    )
  end
end


-- Запускает смерть бойца.
function Unit:startDeath(context)
  self.combatAlive = false

  -- Погибший больше не участвует
  -- в столкновениях.
  self.radius = 0

  self.target = nil
  self.attackKind = nil
  self.attackPhase = nil
  self.attackDefinition = nil

  self:playSound('death')

  self.squad:onUnitRemoved(
    self,
    'killed'
  )

  local shouldFall =
    context
    and context.launchOnKill
    and self.fallDefinition
    and self.fallDefinition.enabled
      ~= false

  if shouldFall then
    self:startFallDeath(context)
  else
    self:startNormalDeath()
  end
end


-- Наносит бойцу урон.
function Unit:takeDamage(
  amount,
  damageType,
  context
)
  if not self.combatAlive then
    return
  end

  local multiplier = 1

  if damageType == 'spear' then
    multiplier =
      self.config
        .spearDamageMultiplier
      or 1

  elseif damageType == 'magic' then
    multiplier =
      self.config
        .magicDamageMultiplier
      or 1
  end

  self.health =
    self.health -
    amount * multiplier

  -- Получение melee-урона также
  -- связывает весь отряд.
  if
    context
    and context.source
    and context.source.squad
    and context.radiusAttack ~= true
    and self.battle.engagementSystem
  then
    local source =
      context.source

    if source.hasMeleeAttack
      and source:hasMeleeAttack()
    then
      self.battle.engagementSystem:
        touchUnits(
          source,
          self
        )
    end
  end

  if self.health <= 0 then
    self.health = 0
    self:startDeath(context)
  else
    self:playSound('hit')
  end
end


-- Обновляет обычную смерть.
function Unit:updateDeath(dt)
  self.entity:update(dt)

  if
    self.entity:
      isAnimationFinished()
  then
    self:resolveCorpse()
  end
end


-- Обновляет отлёт погибшего бойца.
function Unit:updateFallDeath(dt)
  if self.fallPhase == 'flight' then
    self.fallTime =
      self.fallTime + dt

    local progress =
      math.min(
        1,
        self.fallTime /
        self.fallDuration
      )

    self.x =
      self.fallStartX +
      (
        self.fallEndX -
        self.fallStartX
      ) * progress

    self.z =
      self.fallStartZ +
      (
        self.fallEndZ -
        self.fallStartZ
      ) * progress

    self.y =
      self.fallStartY +
      4 *
      self.fallHeight *
      progress *
      (1 - progress)

    self.entity:update(dt)

    if
      self.fallAnimations
      and self.entity:
        isAnimationFinished()
      and self.entity.animationName ==
        self.fallAnimations.start
    then
      self.entity:setAnimation(
        self.fallAnimations.airborne,
        true
      )
    end

    if progress < 1 then
      return
    end

    self.x = self.fallEndX
    self.y = self.fallStartY
    self.z = self.fallEndZ

    self.fallPhase = 'landing'

    if self.fallAnimations then
      self.entity:setAnimation(
        self.fallAnimations.land,
        true
      )
    end

    return
  end

  self.entity:update(dt)

  if
    self.entity:
      isAnimationFinished()
  then
    self:resolveCorpse()
  end
end


-- Обновляет перезарядку.
function Unit:updateCooldowns(dt)
  self.rangedCooldown =
    math.max(
      0,
      self.rangedCooldown - dt
    )
end
Последняя часть — выбор боевого действия, главный update, отрисовка и return Unit.

да

src/autobattle/unit.lua, часть 5 из 5:

lua
-- Выбирает боевое действие.
function Unit:updateCombat(
  dt,
  enemy
)
  local distance =
    self:getDistanceTo(enemy)

  if
    distance <= self.attackDistance
    and self:hasMeleeAttack()
  then
    if
      self:tryChargeHit(
        enemy,
        dt
      )
    then
      return
    end

    self:startMeleeAttack(enemy)
    return
  end

  if self:hasRangedAttack() then
    local minimumDistance =
      self.rangedAttack
        .minimumDistance
      or 0

    if
      distance < minimumDistance
      and not self:hasMeleeAttack()
    then
      self:waitForRangedAttack(
        dt,
        enemy
      )

      return
    end
  end

  if
    self:isInsideRangedDistance(
      distance
    )
  then
    if self.rangedCooldown <= 0 then
      self:startRangedAttack(enemy)
    else
      self:waitForRangedAttack(
        dt,
        enemy
      )
    end

    return
  end

  self:updateCombatMovement(
    dt,
    enemy
  )
end


-- Обновляет бойца.
function Unit:update(dt)
  if self.flyingBehavior then
    self.flyingBehavior:update(dt)
  end

  if self.removed then
    return
  end

  if self.state == 'dying' then
    self:updateDeath(dt)
    self:syncEntity()
    return
  end

  if self.state == 'falling' then
    self:updateFallDeath(dt)
    self:syncEntity()
    return
  end

  if self.state == 'corpse' then
    self:updateCorpse(dt)
    return
  end

  self:updateCooldowns(dt)

  if self.state == 'attacking' then
    self:updateAttack(dt)
    self:updateVisualRotation(dt)
    self:syncEntity()
    return
  end

  local guardPoint =
    self:getGuardPoint()

  local guardDistance = nil
  local guardHomeDistance = nil

  if guardPoint then
    local centerDx =
      self.x - guardPoint.x

    local centerDz =
      self.z - guardPoint.z

    guardDistance =
      math.sqrt(
        centerDx * centerDx +
        centerDz * centerDz
      )

    local homeX, homeZ =
      self:getGuardHomePosition(
        guardPoint
      )

    local homeDx =
      self.x - homeX

    local homeDz =
      self.z - homeZ

    guardHomeDistance =
      math.sqrt(
        homeDx * homeDx +
        homeDz * homeDz
      )

    local guardLeash =
      guardPoint.guardLeash
      or math.huge

    if guardDistance > guardLeash then
      self:updateGuardMovement(
        dt,
        guardPoint
      )

      self:updateVisualRotation(dt)
      self:syncEntity()
      return
    end
  end

  local enemy =
    self:findPreferredEnemy(
      self.sightDistance
    )

  if enemy then
    self:updateCombat(
      dt,
      enemy
    )

  elseif
    guardPoint
    and guardHomeDistance >
      (
        guardPoint.guardSlotRadius
        or 1.5
      )
  then
    self:updateGuardMovement(
      dt,
      guardPoint
    )

  else
    self:updateOrderMovement(dt)
  end

  self:updateVisualRotation(dt)
  self:syncEntity()
end


-- Рисует бойца.
function Unit:draw(pass, camera)
  if self.removed then
    return
  end

  self:syncEntity()

  local allowLod =
    self.combatAlive
    and self.state ~= 'falling'

  self.entity:draw(
    pass,
    camera,
    allowLod
  )
end


return Unit
unit.lua завершён. Следующий файл — обновлённый battle.lua; он также потребует несколько частей.

да

Analysis

src/autobattle/battle.lua, часть 1. Она заменяет начало файла до конца createConfiguredBattle.

lua
local Squad =
  require('src.autobattle.squad')

local SpatialGrid =
  require('src.autobattle.spatial_grid')

local NavigationGrid =
  require(
    'src.autobattle.navigation_grid'
  )

local Pathfinder =
  require('src.autobattle.pathfinder')

local EngagementSystem =
  require(
    'src.autobattle.engagement_system'
  )

local CaptureSystem =
  require(
    'src.autobattle.capture_system'
  )

local Economy =
  require('src.economy.economy')

local BuildingSystem =
  require(
    'src.buildings.building_system'
  )

local ProjectileRegistry =
  require(
    'src.projectiles.projectile_registry'
  )

local ProjectileSystem =
  require(
    'src.projectiles.projectile_system'
  )

local ModelLighting =
  require(
    'src.graphics.model_lighting'
  )

local EnemyAI =
  require(
    'src.autobattle.enemy_ai'
  )


local Battle = {}
Battle.__index = Battle


-- Создаёт настроенное сражение.
function Battle.new(
  config,
  modelRegistry,
  field,
  options
)
  local self =
    setmetatable({}, Battle)

  options = options or {}

  self.config = config
  self.modelRegistry = modelRegistry
  self.field = field

  self.sideRegistry =
    assert(
      options.sideRegistry,
      'Battle has no side registry'
    )

  self.map =
    assert(
      options.map,
      'Battle has no map'
    )

  self.playerSide =
    assert(
      options.playerSide,
      'Battle has no player side'
    )

  self.enemySide =
    assert(
      options.enemySide,
      'Battle has no enemy side'
    )

  self.monsterSide =
    options.monsterSide
    or 'monsters'

  self.playerUnitDefinition =
    assert(
      options.playerUnitDefinition,
      'Player side has no unit'
    )

  self.enemyUnitDefinition =
    assert(
      options.enemyUnitDefinition,
      'Enemy side has no unit'
    )

  self.time = 0

  self.nextUnitId = 1
  self.nextSquadId = 1

  self.squads = {}
  self.units = {}
  self.winner = nil

  self.endingWinner = nil
  self.endingTime = 0
  self.endingDuration = 0

  self.economies = {}
  self.economy = nil

  self.buildingSystem = nil
  self.captureSystem = nil
  self.enemyAI = nil

  -- Пространственная сетка бойцов.
  self.grid =
    SpatialGrid.new(
      config.collision.cellSize
    )

  -- Навигационная сетка статического мира.
  self.navigationGrid =
    NavigationGrid.new(
      field,
      config.navigation.grid
    )

  self.pathfinder =
    Pathfinder.new(
      self.navigationGrid,
      config.navigation.pathfinder
    )

  self.engagementSystem =
    EngagementSystem.new(
      self,
      config.engagement
    )

  self.navigationObstacleSignature =
    nil

  self.projectileRegistry =
    ProjectileRegistry.new()

  self.projectileSystem =
    ProjectileSystem.new(
      self.projectileRegistry,
      self
    )

  self.modelLightingShader =
    ModelLighting.new()

  self:createConfiguredBattle()

  if self.map.buildings then
    local playerEconomySettings =
      self.map.economy
      or config.economy

    local enemyAIConfig =
      self.map.enemyAI

    local enemyEconomySettings =
      enemyAIConfig
      and enemyAIConfig.economy
      or playerEconomySettings

    self.economies.allies =
      Economy.new(
        playerEconomySettings
      )

    self.economies.enemies =
      Economy.new(
        enemyEconomySettings
      )

    -- Совместимость существующего HUD.
    self.economy =
      self.economies.allies

    self.buildingSystem =
      BuildingSystem.new({
        battle = self,
        map = self.map,

        modelRegistry =
          self.modelRegistry,

        sideRegistry =
          self.sideRegistry,

        economies =
          self.economies,

        economy =
          self.economies.allies,

        playerSide =
          self.playerSide,

        enemySide =
          self.enemySide
      })
  end

  -- После появления зданий перестраивает
  -- динамическую часть навигации.
  self:updateNavigationObstacles(true)

  if
    self.buildingSystem
    and self.map.capturePoints
    and #self.map.capturePoints > 0
  then
    self.captureSystem =
      CaptureSystem.new({
        battle = self,
        map = self.map,

        buildingSystem =
          self.buildingSystem
      })
  end

  local enemyAIConfig =
    self.map.enemyAI

  if
    self.buildingSystem
    and enemyAIConfig
    and enemyAIConfig.enabled
      ~= false
  then
    self.enemyAI =
      EnemyAI.new({
        battle = self,

        buildingSystem =
          self.buildingSystem,

        economy =
          self.economies.enemies,

        config =
          enemyAIConfig
      })
  end

  return self
end


-- Выделяет уникальный ID бойца.
function Battle:allocateUnitId()
  local id = self.nextUnitId

  self.nextUnitId =
    self.nextUnitId + 1

  return id
end


-- Выделяет уникальный ID отряда.
function Battle:allocateSquadId()
  local id = self.nextSquadId

  self.nextSquadId =
    self.nextSquadId + 1

  return id
end


-- Добавляет отряд.
function Battle:addSquad(
  team,
  squadSettings,
  unitDefinition
)
  local squad = Squad.new({
    id = self:allocateSquadId(),

    campaignSquadId =
      squadSettings.campaignSquadId,

    team = team,

    direction =
      team == 'allies'
      and -1
      or 1,

    startX = squadSettings.x,
    startZ = squadSettings.z,

    count =
      squadSettings.count
      or unitDefinition.squadSize
      or 1,

    guardPoint =
      squadSettings.guardPoint,

    unitDefinition = unitDefinition,

    battle = self,
    config = self.config,

    modelRegistry =
      self.modelRegistry
  })

  self.squads[#self.squads + 1] =
    squad

  for _, unit in ipairs(
    squad.units
  ) do
    self.units[#self.units + 1] =
      unit
  end

  return squad
end


-- Создаёт начальные отряды карты.
function Battle:createConfiguredBattle()
  local squads = self.map.squads

  for _, group in ipairs(
    squads.player.groups
  ) do
    local definition =
      self.playerUnitDefinition

    if group.slot then
      definition =
        self.sideRegistry:
          resolveUnit(
            self.playerSide,
            group.slot
          )
    end

    assert(
      definition,
      'Player group has no unit'
    )

    self:addSquad(
      'allies',
      group,
      definition
    )
  end

  for _, group in ipairs(
    squads.enemy.groups
  ) do
    local definition =
      self.enemyUnitDefinition

    if group.slot then
      definition =
        self.sideRegistry:
          resolveUnit(
            self.enemySide,
            group.slot
          )
    end

    assert(
      definition,
      'Enemy group has no unit'
    )

    self:addSquad(
      'enemies',
      group,
      definition
    )
  end

  local monsters =
    squads.monsters

  if not monsters then
    return
  end

  self.monsterSide =
    monsters.side
    or self.monsterSide

  for _, group in ipairs(
    monsters.groups or {}
  ) do
    local definition =
      self.sideRegistry:
        resolveUnit(
          self.monsterSide,
          group.slot
        )

    assert(
      definition,

      'Monster group has no unit: ' ..
      tostring(group.slot)
    )

    self:addSquad(
      'monsters',
      group,
      definition
    )
  end
end
Следующая часть начнётся с обновления навигационных препятствий и поиска целей, затем сохранит существующую систему урона и снарядов.

да

Analysis

src/autobattle/battle.lua, часть 2. Вставляется после первой части.

lua
-- Формирует подпись препятствий.
function Battle:
  getNavigationObstacleSignature()
  if not self.buildingSystem then
    return ''
  end

  local parts = {}

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    parts[#parts + 1] =
      table.concat({
        tostring(building.id),
        tostring(building.x),
        tostring(building.z),
        tostring(building.radius),
        tostring(building.removed),
        tostring(building.state)
      }, ':')
  end

  table.sort(parts)

  return table.concat(parts, '|')
end


-- Обновляет препятствия при изменении зданий.
function Battle:
  updateNavigationObstacles(force)
  local signature =
    self:
      getNavigationObstacleSignature()

  if
    not force
    and signature ==
      self.navigationObstacleSignature
  then
    return false
  end

  self.navigationObstacleSignature =
    signature

  self.navigationGrid:
    rebuildFromBattle(self)

  return true
end


-- Ищет ближайшую цель для отряда.
function Battle:
  findNearestEnemyTargetForSquad(
    squad,
    radius
  )
  if
    not squad
    or squad:isDefeated()
  then
    return nil
  end

  local centerX, centerZ =
    squad:getCenter()

  local nearest = nil
  local nearestDistance = radius

  for _, candidate in ipairs(
    self.squads
  ) do
    if
      candidate ~= squad
      and candidate.team ~= squad.team
      and not candidate:isDefeated()
    then
      local candidateX,
        candidateZ =
        candidate:getCenter()

      local dx =
        candidateX - centerX

      local dz =
        candidateZ - centerZ

      local distance =
        math.max(
          0,

          math.sqrt(
            dx * dx + dz * dz
          ) - candidate:getRadius()
        )

      if distance < nearestDistance then
        nearest = candidate
        nearestDistance = distance
      end
    end
  end

  if self.buildingSystem then
    for _, building in ipairs(
      self.buildingSystem.buildings
    ) do
      if
        building.team ~= squad.team
        and building:isTargetable()
      then
        local dx =
          building.x - centerX

        local dz =
          building.z - centerZ

        local distance =
          math.max(
            0,

            math.sqrt(
              dx * dx + dz * dz
            ) - (building.radius or 0)
          )

        if distance < nearestDistance then
          nearest = building
          nearestDistance = distance
        end
      end
    end
  end

  return nearest
end


-- Начинает завершение боя.
function Battle:startEnding(
  winner,
  duration
)
  if
    self.winner
    or self.endingWinner
  then
    return
  end

  self.endingWinner = winner
  self.endingTime = 0

  self.endingDuration =
    duration or .4
end


-- Обновляет финальный эффект.
function Battle:updateEnding(dt)
  self.projectileSystem:update(dt)

  self.endingTime =
    self.endingTime + dt

  if
    self.endingTime >=
    self.endingDuration
  then
    self.winner =
      self.endingWinner

    self.endingWinner = nil
    self.endingTime = 0
  end
end


-- Ищет ближайшего врага.
function Battle:findNearestEnemy(
  unit,
  radius
)
  local enemy =
    self.grid:findNearest(
      unit.x,
      unit.z,
      radius,

      function(candidate)
        return
          candidate.team ~= unit.team
          and candidate:isTargetable()
      end
    )

  if enemy then
    return enemy
  end

  if self.buildingSystem then
    return
      self.buildingSystem:
        findNearestEnemyBuilding(
          unit,
          radius
        )
  end

  return nil
end


-- Проверяет разрешение пройти
-- сквозь союзного бойца.
function Battle:canUnitPassThrough(
  movingUnit,
  otherUnit
)
  if
    movingUnit.team ~=
    otherUnit.team
  then
    return false
  end

  local rules =
    movingUnit.config
      .alliedPassThroughSlots

  if not rules then
    return false
  end

  local movingSlot =
    movingUnit.config.slot

  local otherSlot =
    otherUnit.config.slot

  if
    rules.exceptSameSlot
    and movingSlot == otherSlot
  then
    return false
  end

  local blockedSlots =
    rules.blockedSlots

  if
    blockedSlots
    and blockedSlots[otherSlot]
  then
    return false
  end

  if rules.all == true then
    return true
  end

  return rules[otherSlot] == true
end


-- Проверяет ближайший участок движения.
function Battle:isDirectionClear(
  unit,
  directionX,
  directionZ
)
  local navigation =
    self.config.navigation

  local clear = true

  self.grid:forEachNearby(
    unit.x,
    unit.z,
    navigation.avoidanceRadius,

    function(candidate)
      if
        not clear
        or candidate == unit
        or candidate.team ~= unit.team
        or not candidate:
          isSpatiallyActive()
      then
        return
      end

      local unitFlying =
        unit.flyingBehavior ~= nil

      local candidateFlying =
        candidate.flyingBehavior ~= nil

      if
        unitFlying ~=
        candidateFlying
      then
        return
      end

      if
        self:canUnitPassThrough(
          unit,
          candidate
        )
      then
        return
      end

      local relativeX =
        candidate.x - unit.x

      local relativeZ =
        candidate.z - unit.z

      local forward =
        relativeX * directionX +
        relativeZ * directionZ

      local requiredSpace =
        unit.radius +
        candidate.radius +
        .15

      if
        forward <= 0
        or forward > requiredSpace
      then
        return
      end

      local sideways =
        math.abs(
          relativeX * directionZ -
          relativeZ * directionX
        )

      if sideways < requiredSpace then
        clear = false
      end
    end
  )

  return clear
end


-- Ищет свободное локальное направление.
function Battle:chooseMovementDirection(
  unit,
  desiredX,
  desiredZ
)
  if
    self:isDirectionClear(
      unit,
      desiredX,
      desiredZ
    )
  then
    return desiredX, desiredZ
  end

  local angles = {
    math.rad(35),
    math.rad(60),
    math.rad(85)
  }

  for _, angle in ipairs(angles) do
    local cosine = math.cos(angle)
    local sine = math.sin(angle)

    for attempt = 1, 2 do
      local side =
        attempt == 1
        and unit.avoidanceSide
        or -unit.avoidanceSide

      local signedSine =
        sine * side

      local candidateX =
        desiredX * cosine -
        desiredZ * signedSine

      local candidateZ =
        desiredX * signedSine +
        desiredZ * cosine

      if
        self:isDirectionClear(
          unit,
          candidateX,
          candidateZ
        )
      then
        unit.avoidanceSide = side

        return
          candidateX,
          candidateZ
      end
    end
  end

  return nil
end


-- Наносит радиусный урон бойцам.
function Battle:damageUnitsInRadius(
  x,
  z,
  radius,
  attack,
  sourceTeam,
  source
)
  self.grid:forEachNearby(
    x,
    z,
    radius,

    function(unit)
      if
        unit == source
        or not unit:isTargetable()
      then
        return
      end

      if
        not attack.friendlyFire
        and unit.team == sourceTeam
      then
        return
      end

      local dx = unit.x - x
      local dz = unit.z - z

      local distanceSquared =
        dx * dx + dz * dz

      if
        distanceSquared >
        radius * radius
      then
        return
      end

      local damage =
        math.random(
          attack.damageMinimum,
          attack.damageMaximum
        )

      if
        attack.damageFalloff ==
          'linear'
        and radius > 0
      then
        local distance =
          math.sqrt(
            distanceSquared
          )

        damage =
          damage *
          math.max(
            0,
            1 - distance / radius
          )
      end

      unit:takeDamage(
        damage,
        attack.damageType,
        {
          source = source,
          x = x,
          z = z,

          radiusAttack = true,

          launchOnKill =
            attack.launchOnKill
              == true
        }
      )
    end
  )
end


-- Наносит радиусный урон зданиям.
function Battle:
  damageBuildingsInRadius(
    x,
    z,
    radius,
    attack,
    sourceTeam,
    source
  )
  if not self.buildingSystem then
    return
  end

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    if
      building ~= source
      and building:isTargetable()
      and (
        attack.friendlyFire
        or building.team ~= sourceTeam
      )
    then
      local dx = building.x - x
      local dz = building.z - z

      local centerDistance =
        math.sqrt(
          dx * dx + dz * dz
        )

      local distance =
        math.max(
          0,
          centerDistance -
          building.radius
        )

      if distance <= radius then
        local damage =
          math.random(
            attack.damageMinimum,
            attack.damageMaximum
          )

        if
          attack.damageFalloff ==
            'linear'
          and radius > 0
        then
          damage =
            damage *
            math.max(
              0,
              1 - distance / radius
            )
        end

        building:takeDamage(
          damage,
          attack.damageType,
          {
            source = source,
            x = x,
            z = z,
            radiusAttack = true
          }
        )
      end
    end
  end
end


-- Наносит радиусный урон.
function Battle:damageRadius(
  x,
  z,
  radius,
  attack,
  sourceTeam,
  source
)
  self:damageUnitsInRadius(
    x,
    z,
    radius,
    attack,
    sourceTeam,
    source
  )

  self:damageBuildingsInRadius(
    x,
    z,
    radius,
    attack,
    sourceTeam,
    source
  )
end


-- Создаёт снаряд.
function Battle:spawnProjectile(
  projectileId,
  settings
)
  local source =
    settings.source

  if
    source
    and source.flyingBehavior
  then
    settings.y =
      settings.y +
      source.flyingBehavior:
        getHeight()
  end

  local target =
    settings.target

  if
    target
    and target.flyingBehavior
  then
    settings.targetY =
      settings.targetY +
      target.flyingBehavior:
        getHeight()
  end

  return
    self.projectileSystem:spawn(
      projectileId,
      settings
    )
end


-- Ищет первого живого бойца стороны.
function Battle:findFirstLivingUnit(team)
  for _, unit in ipairs(
    self.units
  ) do
    if
      unit.team == team
      and unit:isTargetable()
    then
      return unit
    end
  end

  return nil
end


-- Выпускает тестовый снаряд.
function Battle:fireDebugProjectile(
  projectileId
)
  local source =
    self:findFirstLivingUnit(
      'allies'
    )

  local target =
    self:findFirstLivingUnit(
      'enemies'
    )

  if not source or not target then
    return
  end

  local definition =
    self.projectileRegistry:get(
      projectileId
    )

  local settings = {
    team = source.team,
    source = source,

    x = source.x,
    y = source.y + 1.2,
    z = source.z,

    target = target,
    targetX = target.x,
    targetY = target.y + .7,
    targetZ = target.z
  }

  if definition.hitMode == 'point' then
    settings.target = nil
  end

  self:spawnProjectile(
    projectileId,
    settings
  )
end

function Unit:isMovementPositionValid(
  worldX,
  worldZ
)
  if self.flyingBehavior then
    return true
  end

  local grid =
    self.battle.navigationGrid

  if not grid then
    return true
  end

  return grid:isWorldWalkable(
    worldX,
    worldZ
  )
end
src/autobattle/battle.lua, часть 3 из 3:

lua
-- Раздвигает пересекающихся бойцов.
function Battle:separateUnits(
  first,
  second
)
  if
    not first:isSpatiallyActive()
    or not second:
      isSpatiallyActive()
  then
    return
  end

  local firstFlying =
    first.flyingBehavior ~= nil

  local secondFlying =
    second.flyingBehavior ~= nil

  if firstFlying ~= secondFlying then
    return
  end

  local dx = second.x - first.x
  local dz = second.z - first.z

  local minimumDistance =
    first.radius + second.radius

  local distanceSquared =
    dx * dx + dz * dz

  if
    distanceSquared >=
    minimumDistance *
    minimumDistance
  then
    return
  end

  local firstMoved =
    math.abs(
      first.x - first.previousX
    ) > .0001
    or math.abs(
      first.z - first.previousZ
    ) > .0001

  local secondMoved =
    math.abs(
      second.x - second.previousX
    ) > .0001
    or math.abs(
      second.z - second.previousZ
    ) > .0001

  if first.team == second.team then
    local firstCanPass =
      firstMoved
      and self:canUnitPassThrough(
        first,
        second
      )

    local secondCanPass =
      secondMoved
      and self:canUnitPassThrough(
        second,
        first
      )

    if firstCanPass or secondCanPass then
      return
    end
  end

  local bothMoving =
    firstMoved
    and secondMoved
    and first.state == 'moving'
    and second.state == 'moving'

  if
    bothMoving
    and first.team == second.team
  then
    local distance
    local normalX
    local normalZ

    if distanceSquared < .0001 then
      local angle =
        (
          first.id * 37 +
          second.id * 17
        ) % 360

      angle = math.rad(angle)

      normalX = math.cos(angle)
      normalZ = math.sin(angle)
      distance = 0
    else
      distance =
        math.sqrt(distanceSquared)

      normalX = dx / distance
      normalZ = dz / distance
    end

    local correction =
      (
        minimumDistance -
        distance
      ) * .5

    first.x =
      first.x -
      normalX * correction

    first.z =
      first.z -
      normalZ * correction

    second.x =
      second.x +
      normalX * correction

    second.z =
      second.z +
      normalZ * correction

    return
  end

  if firstMoved then
    first.x = first.previousX
    first.z = first.previousZ
  end

  if secondMoved then
    second.x = second.previousX
    second.z = second.previousZ
  end
end


-- Выполняет проход столкновений.
function Battle:resolveCollisionPass()
  for _, first in ipairs(
    self.units
  ) do
    if first:isSpatiallyActive() then
      self.grid:forEachNearby(
        first.x,
        first.z,
        first.radius * 2.2,

        function(second)
          if second.id > first.id then
            self:separateUnits(
              first,
              second
            )
          end
        end
      )
    end
  end
end


-- Удаляет законченные сущности.
function Battle:removeFinishedUnits()
  for index = #self.units,
    1,
    -1
  do
    local unit = self.units[index]

    if unit.removed then
      table.remove(
        self.units,
        index
      )

      for squadIndex =
        #unit.squad.units,
        1,
        -1
      do
        if
          unit.squad.units[
            squadIndex
          ] == unit
        then
          table.remove(
            unit.squad.units,
            squadIndex
          )

          break
        end
      end
    end
  end
end


-- Проверяет поражение стороны.
function Battle:isTeamDefeated(team)
  local found = false

  for _, squad in ipairs(
    self.squads
  ) do
    if squad.team == team then
      found = true

      if not squad:isDefeated() then
        return false
      end
    end
  end

  return found
end


-- Проверяет победителя.
function Battle:checkWinner()
  if self.winner then
    return
  end

  if
    self.map.victoryCondition ==
      'altar'
  then
    return
  end

  if self:isTeamDefeated(
    'enemies'
  ) then
    self.winner = 'allies'

  elseif self:isTeamDefeated(
    'allies'
  ) then
    self.winner = 'enemies'
  end
end


-- Выполняет фиксированный шаг.
function Battle:update(dt)
  if self.winner then
    return
  end

  self.time = self.time + dt

  if self.endingWinner then
    self:updateEnding(dt)
    return
  end

  for _, economy in pairs(
    self.economies
  ) do
    economy:update(dt)
  end

  if self.buildingSystem then
    self.buildingSystem:update(dt)

    self:
      updateNavigationObstacles(
        false
      )
  end

  if self.enemyAI then
    self.enemyAI:update(dt)
  end

  -- Сначала отряды обновляют приказы
  -- и рассчитанные пути.
  for _, squad in ipairs(
    self.squads
  ) do
    squad:update(dt)
  end

  for _, unit in ipairs(
    self.units
  ) do
    unit:beginSimulationStep()
  end

  self.grid:rebuild(
    self.units
  )

  for _, unit in ipairs(
    self.units
  ) do
    unit:update(dt)

    if self.endingWinner then
      return
    end
  end

  for _, unit in ipairs(
    self.units
  ) do
    if unit:isSpatiallyActive() then
      self.field:
        resolveUnitCollisions(unit)

      unit:syncEntity()
    end
  end

  for iteration = 1,
    self.config.collision.iterations
  do
    self.grid:rebuild(
      self.units
    )

    self:resolveCollisionPass()
  end

  self.grid:rebuild(
    self.units
  )

  -- Контакты обновлены бойцами выше.
  -- Теперь можно снять устаревшие связи.
  self.engagementSystem:update(dt)

  self.projectileSystem:update(dt)

  if self.endingWinner then
    return
  end

  if self.captureSystem then
    self.captureSystem:update(dt)
  end

  for _, unit in ipairs(
    self.units
  ) do
    unit:syncEntity()
  end

  self:removeFinishedUnits()
  self:checkWinner()
end


-- Рисует бойцов, здания и снаряды.
function Battle:draw(pass, camera)
  local lighting =
    self.config.lighting or {}

  local lightingEnabled =
    lighting.enabled ~= false

  local function applyLighting()
    if not lightingEnabled then
      pass:setShader()
      return
    end

    pass:setShader(
      self.modelLightingShader
    )

    pass:send(
      'sunDirection',

      lighting.sunDirection
      or {
        -.45,
        .8,
        .3
      }
    )

    pass:send(
      'ambientLight',
      lighting.ambientLight
      or .42
    )

    pass:send(
      'sunStrength',
      lighting.sunStrength
      or .75
    )
  end

  if self.buildingSystem then
    self.buildingSystem:draw(
      pass,
      camera,
      applyLighting
    )
  end

  for _, unit in ipairs(
    self.units
  ) do
    applyLighting()

    unit:draw(
      pass,
      camera
    )
  end

  pass:setShader()

  self.projectileSystem:draw(
    pass,
    camera
  )
end


return Battle