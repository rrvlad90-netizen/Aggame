local Building =
  require('src.buildings.building')

local BuildingCatalog =
  require(
    'src.buildings.building_catalog'
  )

local BuildingSystem = {}
BuildingSystem.__index = BuildingSystem


-- Создаёт систему зданий.
function BuildingSystem.new(settings)
  local self =
    setmetatable({}, BuildingSystem)

  self.battle = settings.battle
  self.map = settings.map

  self.modelRegistry =
    settings.modelRegistry

  self.sideRegistry =
    settings.sideRegistry

  self.economies =
    settings.economies or {}

  self.economy =
    settings.economy
    or self.economies.allies

  self.playerSide =
    settings.playerSide

  self.enemySide =
    settings.enemySide

  self.enemyUsesEconomy =
    self.map.enemyAI ~= nil
    and self.map.enemyAI.enabled
      ~= false
    and self.map.enemyAI.useEconomy
      ~= false

  self.buildings = {}
  self.buildingsById = {}

  self.script =
    self.map.enemyScript

  self.scriptTime = 0
  self.scriptEventIndex = 1

  self:createMapBuildings()

  return self
end

-- Возвращает экономику команды.
function BuildingSystem:getEconomy(team)
  return self.economies[team]
end

-- Возвращает команду по стороне карты.
function BuildingSystem:getTeam(mapSide)
  if
    mapSide == 'player'
    or mapSide == 'allies'
  then
    return 'allies'
  end

  if
    mapSide == 'enemy'
    or mapSide == 'enemies'
  then
    return 'enemies'
  end

  if mapSide == 'monsters' then
    return 'monsters'
  end

  return nil
end


-- Возвращает выбранную фракцию стороны.
function BuildingSystem:getSideId(mapSide)
  if
    mapSide == 'player'
    or mapSide == 'allies'
  then
    return self.playerSide
  end

  if
    mapSide == 'enemy'
    or mapSide == 'enemies'
  then
    return self.enemySide
  end

  return nil
end


-- Создаёт здания и платформы карты.
function BuildingSystem:createMapBuildings()
  for _, settings in ipairs(
    self.map.buildings or {}
  ) do
    local team =
      self:getTeam(settings.side)

    local sideId =
      self:getSideId(settings.side)

    local definition =
      BuildingCatalog.get(
        settings.type
      )

    local modelId = nil

    -- Нейтральная платформа получает
    -- модель только после захвата.
    if sideId then
      modelId =
        BuildingCatalog.getModel(
          sideId,
          settings.type
        )
    end

    local building = Building.new({
      id = settings.id,
      team = team,
      sideId = sideId,

      buildingType =
        settings.type,

      definition = definition,
      modelId = modelId,

      modelRegistry =
        self.modelRegistry,

      system = self,

      x = settings.x,
      z = settings.z,
      yaw = settings.yaw or 0,

      floorY =
        self.battle.field:
          getHeight(
            settings.x,
            settings.z
          ),

      routeId = settings.routeId,
      spawnX = settings.spawnX,
      spawnZ = settings.spawnZ,

      built = settings.built == true
    })

    self.buildings[
      #self.buildings + 1
    ] = building

    self.buildingsById[
      building.id
    ] = building
  end
end


-- Передаёт платформу новой стороне.
function BuildingSystem:setBuildingOwner(
  building,
  team,
  ownerSettings
)
  if
    not building
    or (
      team ~= 'allies'
      and team ~= 'enemies'
    )
  then
    return false
  end

  local mapSide =
    team == 'allies'
    and 'player'
    or 'enemy'

  local sideId =
    self:getSideId(mapSide)

  local settings =
    ownerSettings
    and ownerSettings[team]
    or {}

  building.team = team
  building.sideId = sideId

  building.modelId =
    BuildingCatalog.getModel(
      sideId,
      building.buildingType
    )

  building.routeId =
    settings.routeId

  building.spawnX =
    settings.spawnX

  building.spawnZ =
    settings.spawnZ

  return true
end


-- Возвращает здание по идентификатору.
function BuildingSystem:getBuilding(id)
  return self.buildingsById[id]
end


-- Ищет здание под точкой земли.
function BuildingSystem:findAt(x, z)
  local nearest = nil
  local nearestDistance = nil

  for _, building in ipairs(
    self.buildings
  ) do
    if not building.removed then
      local dx = building.x - x
      local dz = building.z - z

      local distance =
        dx * dx + dz * dz

      if
        building:containsPoint(x, z)
        and (
          not nearestDistance
          or distance < nearestDistance
        )
      then
        nearest = building
        nearestDistance = distance
      end
    end
  end

  return nearest
end


-- Пытается начать строительство игрока.
function BuildingSystem:
  startPlayerConstruction(building)
  if
    not building
    or building.team ~= 'allies'
    or not building:isPlatform()
  then
    return false
  end

  local cost =
    building.definition.buildCost
    or 0

  if
    not self.economy:
      canAfford(cost)
  then
    return false
  end

  if
    not building:
      startConstruction()
  then
    return false
  end

  self.economy:spend(cost)

  return true
end


-- Начинает строительство противника.
function BuildingSystem:
  startEnemyConstruction(building)
  if
    not building
    or building.team ~= 'enemies'
    or not building:isPlatform()
  then
    return false
  end

  local cost =
    building.definition.buildCost
    or 0

  local economy =
    self:getEconomy('enemies')

  if
    self.enemyUsesEconomy
    and (
      not economy
      or not economy:canAfford(cost)
    )
  then
    return false
  end

  if
    not building:
      startConstruction()
  then
    return false
  end

  if self.enemyUsesEconomy then
    economy:spend(cost)
  end

  return true
end


-- Возвращает точку появления отряда.
function BuildingSystem:
  getSquadSpawnPoint(
    building,
    slot
  )
  local directionZ =
    building.team == 'allies'
    and -1
    or 1

  local baseX
  local baseZ

  if
    building.spawnX ~= nil
    and building.spawnZ ~= nil
  then
    baseX = building.spawnX
    baseZ = building.spawnZ
  else
    baseX = building.x

    baseZ =
      building.z +
      directionZ * 10
  end

  local offsets =
    building.definition
      .spawnOffsets
    or {}

  local offset =
    offsets[slot]
    or {}

  local rightX =
    -directionZ

  return
    baseX +
      rightX *
      (offset.side or 0),

    baseZ +
      directionZ *
      (offset.forward or 0)
end


-- Добавляет отряд в очередь здания.
function BuildingSystem:queueSquad(
  building,
  option,
  routeId
)
  if
    not building
    or not option
  then
    return false
  end

  building.recruitQueue =
    building.recruitQueue or {}

  building.recruitQueue[
    #building.recruitQueue + 1
  ] = {
    option = option,
    routeId = routeId
  }

  return true
end


-- Проверяет, свободна ли зона появления.
function BuildingSystem:
  isSquadSpawnAreaClear(
    building,
    option
  )
  local definition =
    self.sideRegistry:resolveUnit(
      building.sideId,
      option.slot
    )

  if not definition then
    return false
  end

  local spawnX, spawnZ =
    self:getSquadSpawnPoint(
      building,
      option.slot
    )

  local clearRadius =
    building.definition
      .spawnClearRadius
    or 10

  local spawningFlying =
    definition.flying ~= nil
    and definition.flying.enabled
      ~= false

  for _, unit in ipairs(
    self.battle.units
  ) do
    if unit:isSpatiallyActive() then
      local unitFlying =
        unit.flyingBehavior ~= nil

      if
        unitFlying ==
        spawningFlying
      then
        local dx =
          unit.x - spawnX

        local dz =
          unit.z - spawnZ

        local requiredDistance =
          clearRadius +
          (unit.radius or 0)

        if
          dx * dx + dz * dz <
          requiredDistance *
          requiredDistance
        then
          return false
        end
      end
    end
  end

  return true
end


-- Обрабатывает очередь найма здания.
function BuildingSystem:
  updateRecruitment(
    building,
    dt
  )
  building.recruitCooldown =
    math.max(
      0,
      (building.recruitCooldown or 0)
        - dt
    )

  building.recruitCheckTimer =
    math.max(
      0,
      (building.recruitCheckTimer or 0)
        - dt
    )

  if
    not building:isReady()
    or not building.recruitQueue
    or #building.recruitQueue == 0
    or building.recruitCooldown > 0
    or building.recruitCheckTimer > 0
  then
    return
  end

  building.recruitCheckTimer =
    building.definition
      .spawnCheckInterval
    or .25

  local request =
    building.recruitQueue[1]

  if
    not self:isSquadSpawnAreaClear(
      building,
      request.option
    )
  then
    return
  end

  if
    not self:spawnSquad(
      building,
      request.option,
      request.routeId
    )
  then
    return
  end

  table.remove(
    building.recruitQueue,
    1
  )

  building.recruitCooldown =
    building.definition
      .spawnCooldown
    or 0
end


-- Создаёт нанятый отряд.
function BuildingSystem:spawnSquad(
  building,
  option,
  routeId
)
  local definition =
    self.sideRegistry:resolveUnit(
      building.sideId,
      option.slot
    )

  if not definition then
    return false
  end

  local x, z =
    self:getSquadSpawnPoint(
      building,
      option.slot
    )

  local routeTeam =
    building.team == 'allies'
    and 'player'
    or 'enemy'

  self.battle:addSquad(
    building.team,

    {
      count =
        option.count
        or definition.squadSize
        or 1,

      x = x,
      z = z,

      defaultRoute =
        routeId
        or building.routeId
    },

    definition,
    routeTeam
  )

  return true
end

-- Пытается нанять отряд игрока.
function BuildingSystem:
  recruitPlayerSquad(
    building,
    optionIndex
  )
  if
    not building
    or building.team ~= 'allies'
    or not building:isReady()
  then
    return false
  end

  local options =
    building.definition
      .recruitOptions

  local option =
    options
    and options[optionIndex]

  if not option then
    return false
  end

  if
    not self.economy:
      canAfford(option.cost)
  then
    return false
  end

  if
    not self:queueSquad(
      building,
      option
    )
  then
    return false
  end

  self.economy:spend(
    option.cost
  )

  return true
end

-- Нанимает отряд противника.
function BuildingSystem:
  recruitEnemySquad(
    building,
    slot,
    routeId
  )
  if
    not building
    or building.team ~= 'enemies'
    or not building:isReady()
  then
    return false
  end

  local options =
    building.definition
      .recruitOptions
    or {}

  for _, option in ipairs(options) do
    if option.slot == slot then
      local cost =
        option.cost or 0

      local economy =
        self:getEconomy(
          'enemies'
        )

      if
        self.enemyUsesEconomy
        and (
          not economy
          or not economy:
            canAfford(cost)
        )
      then
        return false
      end

      if
        not self:queueSquad(
          building,
          option,
          routeId
        )
      then
        return false
      end

      if self.enemyUsesEconomy then
        economy:spend(cost)
      end

      return true
    end
  end

  return false
end


-- Ищет ближайшего вражеского бойца.
function BuildingSystem:
  findNearestEnemyUnit(
    building,
    radius
  )
  local nearest = nil

  local nearestDistanceSquared =
    radius * radius

  for _, unit in ipairs(
    self.battle.units
  ) do
    if
      unit.team ~= building.team
      and unit:isTargetable()
    then
      local dx =
        unit.x - building.x

      local dz =
        unit.z - building.z

      local distanceSquared =
        dx * dx + dz * dz

      if
        distanceSquared <=
        nearestDistanceSquared
      then
        nearest = unit

        nearestDistanceSquared =
          distanceSquared
      end
    end
  end

  return nearest
end


-- Выпускает снаряд башни.
function BuildingSystem:
  fireTower(building, attack)
  local target =
    self:findNearestEnemyUnit(
      building,
      attack.maximumDistance
    )

  if not target then
    return false
  end

  building.attackCooldown =
    attack.cooldown or 1

  self.battle:spawnProjectile(
    attack.projectile,
    {
      team = building.team,
      source = building,

      x = building.x,

      y =
        building.y +
        (
          attack.spawnHeight
          or 3
        ),

      z = building.z,

      target = target,
      targetX = target.x,
      targetY = target.y + .8,
      targetZ = target.z
    }
  )

  return true
end


-- Обновляет атаку башни.
function BuildingSystem:
  updateTower(building, dt)
  if
    not building:isReady()
    or building.buildingType ~=
      'tower'
  then
    return
  end

  local attack =
    building.definition.attack

  building.attackCooldown =
    math.max(
      0,
      (
        building.attackCooldown
        or 0
      ) - dt
    )

  if building.attackCooldown > 0 then
    return
  end

  self:fireTower(
    building,
    attack
  )
end


-- Ищет ближайшее вражеское здание.
function BuildingSystem:
  findNearestEnemyBuilding(
    unit,
    radius
  )
  local nearest = nil
  local nearestDistance = radius

  for _, building in ipairs(
    self.buildings
  ) do
    if
      building.team ~= unit.team
      and building:isTargetable()
    then
      local dx =
        building.x - unit.x

      local dz =
        building.z - unit.z

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

      if distance <= nearestDistance then
        nearest = building
        nearestDistance = distance
      end
    end
  end

  return nearest
end


-- Разрешает проход юнитов через здания.
function BuildingSystem:
  resolveBuildingCollisions(unit)
  -- Здания участвуют в выборе целей,
  -- но не блокируют движение.
end


-- Обрабатывает разрушение здания.
function BuildingSystem:
  onBuildingDestroyed(
    building,
    context
  )
  if building.buildingType ~= 'altar' then
    return
  end

  local winner =
    building.team == 'allies'
    and 'enemies'
    or 'allies'

  self.battle:startEnding(
    winner,
    .4
  )
end


-- Выполняет событие сценария противника.
function BuildingSystem:
  executeScriptEvent(event)
  local building =
    self:getBuilding(
      event.building
    )

  if event.action == 'build' then
    self:startEnemyConstruction(
      building
    )

    return
  end

  if event.action == 'recruit' then
    self:recruitEnemySquad(
      building,
      event.slot,
      event.route
    )
  end
end


-- Выполняет достигнутые события сценария.
function BuildingSystem:
  processScriptEvents()
  local events =
    self.script.events or {}

  while
    self.scriptEventIndex <=
    #events
  do
    local event =
      events[
        self.scriptEventIndex
      ]

    if event.time > self.scriptTime then
      break
    end

    self:executeScriptEvent(
      event
    )

    self.scriptEventIndex =
      self.scriptEventIndex + 1
  end
end


-- Обновляет циклический сценарий противника.
function BuildingSystem:
  updateEnemyScript(dt)
  if not self.script then
    return
  end

  self.scriptTime =
    self.scriptTime + dt

  self:processScriptEvents()

  local duration =
    math.max(
      self.script.duration or 60,
      .001
    )

  while self.scriptTime >= duration do
    self.scriptTime =
      self.scriptTime - duration

    self.scriptEventIndex = 1

    self:processScriptEvents()
  end
end


-- Обновляет здания и сценарий.
function BuildingSystem:update(dt)
  for _, building in ipairs(
    self.buildings
  ) do
    building:update(dt)

    self:updateRecruitment(
      building,
      dt
    )

    self:updateTower(
      building,
      dt
    )
  end

  self:updateEnemyScript(dt)
end


-- Рисует здания и платформы.
function BuildingSystem:draw(
  pass,
  camera,
  applyLighting
)
  for _, building in ipairs(
    self.buildings
  ) do
    building:draw(
      pass,
      camera,
      applyLighting
    )
  end

  pass:setShader()
  pass:setMaterial()
  pass:setColor(1, 1, 1, 1)
end

return BuildingSystem