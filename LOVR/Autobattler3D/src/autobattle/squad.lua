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
  self.disengageUntil = 0

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
  if self:isDefeated() then
    return false, 'defeated'
  end

  if self.engaged then
    self.disengageUntil =
      self.battle.time +
      (
        self.gameConfig.engagement
          .disengageDuration
        or 1
      )

    self.battle.engagementSystem:
      clearSquad(
        self,
        'movement_order'
      )
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
  if self.engaged then
    local opponents =
      self.battle.engagementSystem:
        getOpponents(self)

    local centerX, centerZ =
      self:getCenter()

    local nearest = nil
    local nearestDistance = nil

    for _, opponent in ipairs(
      opponents
    ) do
      if not opponent:isDefeated() then
        local x, z =
          opponent:getCenter()

        local dx = x - centerX
        local dz = z - centerZ

        local distance =
          dx * dx + dz * dz

        if
          not nearestDistance
          or distance < nearestDistance
        then
          nearest = opponent
          nearestDistance = distance
        end
      end
    end

    return nearest
  end

  return self.battle:
    findNearestEnemyTargetForSquad(
      self,
      self.gameConfig.engagement
        .retargetRadius
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

-- Проверяет принудительный выход из боя.
function Squad:isDisengaging()
  return
    self.battle.time <
    self.disengageUntil
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

-- Совместимость с появлением войск из зданий.
function Squad:moveToPoint(x, z)
  return self:issueMove(
    x,
    z,
    'spawn'
  )
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