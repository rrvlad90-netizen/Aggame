local Unit =
  require('src.autobattle.unit')

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
  self.team = settings.team
  self.direction = settings.direction

  self.battle = settings.battle
  self.gameConfig = settings.config

  self.unitDefinition =
    settings.unitDefinition

  self.startX = settings.startX or 0
  self.startZ = settings.startZ

  self.units = {}
  self.initialCount = settings.count
  self.activeCount = settings.count
  self.currentRoute = nil

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
    self:assignRoute(
      settings.route
    )
  end

  return self
end


-- Равномерно распределяет бойцов
-- по ширине маршрута.
function Squad:assignRoute(
  route,
  preserveProgress
)
  self.currentRoute = route

  local routeWidth =
    route.width
    or self.gameConfig.navigation
      .defaultCorridorWidth

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
      if first.x == second.x then
        return first.id < second.id
      end

      return first.x < second.x
    end
  )
  
  local routeSpacing =
  self.unitDefinition
    .routeSpacing

	if
	  routeSpacing
	  and #activeUnits > 1
	then
	  routeWidth =
		math.max(
		  routeWidth,
		  routeSpacing *
		  (#activeUnits - 1)
		)
	end

  if #activeUnits == 1 then
    local pointIndex = 1

    if preserveProgress then
      pointIndex =
        activeUnits[1]
          .routePointIndex
        or 1
    end

    activeUnits[1]:setRoute(
      route,
      0,
      pointIndex
    )

    return
  end

  local spacing =
    routeWidth /
    math.max(
      #activeUnits - 1,
      1
    )

  for index, unit in ipairs(
    activeUnits
  ) do
    local routeOffset =
      -routeWidth / 2 +
      (index - 1) * spacing

    local pointIndex = 1

    if preserveProgress then
      pointIndex =
        unit.routePointIndex
        or 1
    end

    unit:setRoute(
      route,
      routeOffset,
      pointIndex
    )
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
end


return Squad