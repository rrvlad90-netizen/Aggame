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

  self.economy = settings.economy

  self.playerSide =
    settings.playerSide

  self.enemySide =
    settings.enemySide

  self.buildings = {}
  self.buildingsById = {}

  self.script =
    self.map.enemyScript

  self.scriptTime = 0
  self.scriptEventIndex = 1

  self:createMapBuildings()

  return self
end


-- Возвращает команду по стороне карты.
function BuildingSystem:getTeam(
  mapSide
)
  if mapSide == 'player' then
    return 'allies'
  end

  return 'enemies'
end


-- Возвращает выбранную фракцию стороны.
function BuildingSystem:getSideId(
  mapSide
)
  if mapSide == 'player' then
    return self.playerSide
  end

  return self.enemySide
end


-- Создаёт здания и платформы карты.
function BuildingSystem:createMapBuildings()
  for _, settings in ipairs(
    self.map.buildings or {}
  ) do
    local sideId =
      self:getSideId(settings.side)

    local definition =
      BuildingCatalog.get(
        settings.type
      )

    local building = Building.new({
      id = settings.id,

      team =
        self:getTeam(settings.side),

      sideId = sideId,

      buildingType =
        settings.type,

      definition = definition,

      modelId =
        BuildingCatalog.getModel(
          sideId,
          settings.type
        ),

      modelRegistry =
        self.modelRegistry,

      system = self,

      x = settings.x,
      z = settings.z,
      yaw = settings.yaw or 0,

      floorY =
        self.map.field.floorY or 0,

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
          or distance <
            nearestDistance
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

  return building:startConstruction()
end


-- Возвращает точку появления отряда.
function BuildingSystem:
  getSquadSpawnPoint(building)
  if
    building.spawnX
    and building.spawnZ
  then
    return
      building.spawnX,
      building.spawnZ
  end

  local direction =
    building.team == 'allies'
    and -1
    or 1

  return
    building.x,
    building.z + direction * 7
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
      building
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
    not self:spawnSquad(
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


-- Нанимает сценарный отряд противника.
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
      return self:spawnSquad(
        building,
        option,
        routeId
      )
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


-- Выталкивает бойца из здания.
function BuildingSystem:
  resolveUnitCollision(
    unit,
    building
  )
  if
    not building:
      isSpatiallyActive()
    or unit.flyingBehavior
  then
    return
  end

  local dx = unit.x - building.x
  local dz = unit.z - building.z

  local minimumDistance =
    unit.radius + building.radius

  local distanceSquared =
    dx * dx + dz * dz

  if
    distanceSquared >=
    minimumDistance *
    minimumDistance
  then
    return
  end

  local normalX
  local normalZ
  local distance

  if distanceSquared < .0001 then
    local angle =
      unit.id * 2.399963

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
    minimumDistance - distance

  unit.x =
    unit.x +
    normalX * correction

  unit.z =
    unit.z +
    normalZ * correction
end


-- Разрешает столкновения со зданиями.
--function BuildingSystem:
--  resolveBuildingCollisions(unit)
--  if not unit:isSpatiallyActive() then
--    return
--  end

--  for _, building in ipairs(
--    self.buildings
--  ) do
--    self:resolveUnitCollision(
--      unit,
--      building
--    )
--  end
--end

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

  if self.battle.winner then
    return
  end

  if building.team == 'allies' then
    self.battle.winner = 'enemies'
  else
    self.battle.winner = 'allies'
  end
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

  while
    self.scriptTime >= duration
  do
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

    self:updateTower(
      building,
      dt
    )

    -- Уничтожение алтаря завершает бой.
    -- Сценарий больше не обновляется.
    if self.battle.winner then
      return
    end
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