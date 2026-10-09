local Unit =
  require('src.autobattle.unit')

local RouteGeometry =
  require(
    'src.autobattle.route_geometry'
  )

local Squad = {}
Squad.__index = Squad


-- Ищет свободную начальную позицию.
local function findSpawnPosition(squad)
  local settings =
    squad.gameConfig.squad

  local radius =
    squad.unitDefinition.radius

  local minimumDistance =
    squad.unitDefinition
      .spawnSpacing
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
  local row = math.floor(index / 10)

  return
    squad.startX +
    (column - 4.5) *
    minimumDistance,

    squad.startZ -
    squad.direction *
    row *
    minimumDistance
end


-- Создаёт маркированную группу бойцов.
function Squad.new(settings)
  local self =
    setmetatable({}, Squad)

  self.id = settings.id
  -- Связывает боевой отряд
  -- с отрядом на карте кампании.
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

  -- Текущий физический маршрут.
  self.currentRoute = nil

  -- Постоянное направление наступления.
  self.strategicRoute = nil

  -- Маршрут, который возобновится после
  -- достижения временной точки.
  self.resumeRoute = nil

  self.manualOrderId = 0

  self.chargeDefinition =
    self.unitDefinition.charge

  self.chargeReady =
    self.chargeDefinition ~= nil
    and self.chargeDefinition.enabled
      == true

  self.chargeActive = false
  self.chargeTimer = 0
  self.chargeUsers = {}
  self.chargeRechargePoint = nil

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

    self.units[
      #self.units + 1
    ] = unit
  end

  if settings.route then
    self:setStrategicRoute(
      settings.route
    )
  end

  return self
end


-- Распределяет бойцов по шеренгам.
-- В одной шеренге находится не более
-- десяти бойцов.
function Squad:assignRoute(
  route,
  preserveProgress,
  startPointIndex
)
  self.currentRoute = route

  local activeUnits = {}

  for _, unit in ipairs(
    self.units
  ) do
    if unit:isTargetable() then
      activeUnits[
        #activeUnits + 1
      ] = unit
    end
  end

  table.sort(
    activeUnits,

    function(first, second)
      return first.id < second.id
    end
  )

  local spacing =
    self.unitDefinition
      .formationSpacing
    or self.unitDefinition
      .routeSpacing
    or self.unitDefinition
      .spawnSpacing
    or self.unitDefinition.radius * 2.5

  local rowSpacing =
    self.unitDefinition
      .formationRowSpacing
    or spacing * 1.15

  local maximumRowSize = 10
  local unitCount = #activeUnits

  for index, unit in ipairs(
    activeUnits
  ) do
    local rowIndex =
      math.floor(
        (index - 1) /
        maximumRowSize
      )

    local firstRowUnit =
      rowIndex *
      maximumRowSize +
      1

    local rowSize =
      math.min(
        maximumRowSize,
        unitCount -
        firstRowUnit +
        1
      )

    local columnIndex =
      index - firstRowUnit

    -- Каждая неполная шеренга
    -- располагается относительно центра.
    local sideOffset =
      (
        columnIndex -
        (rowSize - 1) / 2
      ) * spacing

    -- Первая шеренга идёт впереди,
    -- остальные следуют позади неё.
    local depthOffset =
      rowIndex * rowSpacing

    local pointIndex =
      startPointIndex or 1

    if preserveProgress then
      pointIndex =
        unit.routePointIndex
        or pointIndex
    end

    unit:setRoute(
      route,
      sideOffset,
      pointIndex,
      depthOffset
    )
  end
end


-- Назначает постоянный маршрут.
function Squad:setStrategicRoute(route)
  if not route then
    return false
  end

  self.strategicRoute = route
  self.resumeRoute = nil

  local pointIndex =
    RouteGeometry.getEntryPointIndex(
      self,
      route
    )

  self:assignRoute(
    route,
    false,
    pointIndex
  )

  return true
end


-- Создаёт временный маршрут.
function Squad:createTemporaryRoute(
  points,
  width
)
  self.manualOrderId =
    self.manualOrderId + 1

  local endpoint =
    points[#points]

  return {
    id =
      'manual_' ..
      self.id ..
      '_' ..
      self.manualOrderId,

    name = 'Manual order',

    width =
      width
      or self.gameConfig.navigation
        .defaultCorridorWidth,

    temporary = true,

    endpoint = {
      x = endpoint.x,
      z = endpoint.z
    },

    points = points
  }
end


-- Идёт к свободно выбранной позиции,
-- затем продолжает прежний маршрут.
function Squad:moveToPoint(x, z)
  if self:isDefeated() then
    return false
  end

  self.resumeRoute =
    self.strategicRoute

  local route =
    self:createTemporaryRoute({
      {
        x = x,
        z = z
      }
    })

  self:assignRoute(
    route,
    false,
    1
  )

  return true
end


-- Идёт к выбранной точке маршрута,
-- затем продолжает этот маршрут.
function Squad:moveToRoutePoint(
  route,
  targetPointIndex
)
  local target =
    route.points[
      targetPointIndex
    ]

  if not target then
    return false
  end

  self.strategicRoute = route
  self.resumeRoute = route

  local entryPointIndex =
    RouteGeometry.getEntryPointIndex(
      self,
      route,
      targetPointIndex
    )

  local points = {}

  for index =
    entryPointIndex,
    targetPointIndex
  do
    points[#points + 1] =
      route.points[index]
  end

  if #points == 0 then
    points[1] = target
  end

  local temporary =
    self:createTemporaryRoute(
      points,
      route.width
    )

  self:assignRoute(
    temporary,
    false,
    1
  )

  return true
end


-- Проверяет окончание временного приказа.
function Squad:isTemporaryRouteFinished()
  if
    not self.currentRoute
    or not self.currentRoute.temporary
  then
    return false
  end

  local living = 0
  local finished = 0

  for _, unit in ipairs(
    self.units
  ) do
    if unit:isTargetable() then
      living = living + 1

      if unit.routeFinished then
        finished = finished + 1
      end
    end
  end

  if living == 0 then
    return false
  end

  local required =
    math.max(
      1,
      math.ceil(living * .6)
    )

  return finished >= required
end


-- Возобновляет постоянный маршрут.
function Squad:updateTemporaryRoute()
  if
    not self:
      isTemporaryRouteFinished()
  then
    return
  end

  local route =
    self.resumeRoute

  self.resumeRoute = nil

  if route then
    self:setStrategicRoute(route)
  else
    self.currentRoute = nil
  end
end

-- Открывает окно суперудара.
function Squad:startChargeWindow(unit)
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
      .windowDuration
    or 1

  self.chargeUsers = {}

  self.chargeRechargePoint =
    (unit.routePointIndex or 1) + 1

  return true
end


-- Разрешает бойцу один суперудар.
function Squad:claimChargeHit(unit)
  if
    not self.chargeDefinition
    or not self.chargeDefinition
      .enabled
  then
    return nil
  end

  if self.chargeReady then
    self:startChargeWindow(unit)
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


-- Уведомляет о прохождении точки.
function Squad:onUnitReachedRoutePoint(
  unit,
  pointIndex
)
  if
    self.chargeReady
    or self.chargeActive
    or not self.chargeRechargePoint
  then
    return
  end

  if
    pointIndex <
    self.chargeRechargePoint
  then
    return
  end

  self.chargeReady = true
  self.chargeUsers = {}
  self.chargeRechargePoint = nil
end


-- Проверяет прогресс перезарядки.
function Squad:checkChargeRecharge()
  if
    self.chargeReady
    or self.chargeActive
    or not self.chargeRechargePoint
  then
    return
  end

  for _, unit in ipairs(
    self.units
  ) do
    if
      unit:isTargetable()
      and (
        unit.routePointIndex
        or 1
      ) > self.chargeRechargePoint
    then
      self.chargeReady = true
      self.chargeUsers = {}
      self.chargeRechargePoint = nil

      return
    end
  end
end


-- Обновляет окно суперудара.
function Squad:updateCharge(dt)
  if not self.chargeActive then
    self:checkChargeRecharge()
    return
  end

  self.chargeTimer =
    self.chargeTimer - dt

  if self.chargeTimer > 0 then
    return
  end

  self.chargeTimer = 0
  self.chargeActive = false

  self:checkChargeRecharge()
end


-- Учитывает погибшего или ушедшего.
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
end


-- Проверяет исчезновение группы.
function Squad:isDefeated()
  return self.activeCount <= 0
end


-- Обновляет состояние отряда.
function Squad:update(dt)
  self:updateCharge(dt)
  self:updateTemporaryRoute()
end


return Squad