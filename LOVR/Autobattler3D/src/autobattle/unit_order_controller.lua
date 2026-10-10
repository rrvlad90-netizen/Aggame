local Order =
  require('src.autobattle.order')


local UnitOrderController = {}
UnitOrderController.__index =
  UnitOrderController


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


function UnitOrderController.new(unit)
  local self =
    setmetatable(
      {},
      UnitOrderController
    )

  self.unit = unit
  self.battle = unit.battle

  self.currentOrder = nil

  self.pathRevision = nil
  self.repathTimer = 0
  self.stuckTimer = 0

  self.lastProgressX = unit.x
  self.lastProgressZ = unit.z

  self.lastTargetX = nil
  self.lastTargetZ = nil

  return self
end


function UnitOrderController:
  getOrder()
  return self.currentOrder
end


function UnitOrderController:
  hasOrder()
  return
    self.currentOrder ~= nil
    and not self.currentOrder:
      isFinished()
end


function UnitOrderController:
  isStrictMove()
  return
    self:hasOrder()
    and self.currentOrder:isMove()
end


function UnitOrderController:
  findNearestTargetUnit(group)
  local nearest = nil
  local nearestDistance = nil

  if not group then
    return nil
  end

  for _, candidate in ipairs(
    group.units or {}
  ) do
    if candidate:isTargetable() then
      local candidateDistance =
        distanceSquared(
          self.unit.x,
          self.unit.z,
          candidate.x,
          candidate.z
        )

      if
        not nearestDistance
        or candidateDistance <
          nearestDistance
      then
        nearest = candidate
        nearestDistance =
          candidateDistance
      end
    end
  end

  return nearest
end


function UnitOrderController:
  getTargetPosition(order)
  order = order or self.currentOrder

  if not order then
    return nil, nil, nil
  end

  if order:isMove() then
    return order.x, order.z, nil
  end

  if
    order.type ==
      Order.Type.ATTACK_BUILDING
  then
    local building = order.target

    if
      not building
      or not building:isTargetable()
    then
      return nil, nil, nil
    end

    return
      building.x,
      building.z,
      building
  end

  if
    order.type ==
      Order.Type.ATTACK_SQUAD
  then
    local targetUnit =
      self:findNearestTargetUnit(
        order.target
      )

    if targetUnit then
      return
        targetUnit.x,
        targetUnit.z,
        targetUnit
    end

    return nil, nil, nil
  end

  return nil, nil, nil
end


function UnitOrderController:
  getApproachRange(order, target)
  local attackDistance =
    self.unit.attackDistance
    or self.unit.config
      .attackDistance
    or 1.5

  if
    order.type ==
      Order.Type.ATTACK_BUILDING
  then
    return
      attackDistance +
      (
        target
        and target.radius
        or 0
      )
  end

  return
    attackDistance +
    (
      target
      and target.radius
      or 0
    )
end


function UnitOrderController:
  rebuildPath()
  local order = self.currentOrder

  if
    not order
    or order:isFinished()
  then
    return false, 'no_order'
  end

  local targetX, targetZ, target =
    self:getTargetPosition(order)

  if not targetX then
    return false, 'target_unavailable'
  end

  local pathfinder =
    self.battle.pathfinder

  if not pathfinder then
    return false, 'pathfinder_unavailable'
  end

  local path
  local reason

  if order:isAttack() then
    path, reason =
      pathfinder:findPathToRange(
        self.unit.x,
        self.unit.z,
        targetX,
        targetZ,
        self:getApproachRange(
          order,
          target
        )
      )
  else
    path, reason =
      pathfinder:findPath(
        self.unit.x,
        self.unit.z,
        targetX,
        targetZ
      )
  end

  if not path then
    return
      false,
      reason or 'unreachable'
  end

  order:setPath(path)

  self.pathRevision =
    self.battle.navigationGrid:
      getRevision()

  self.repathTimer = 0
  self.stuckTimer = 0

  self.lastProgressX =
    self.unit.x

  self.lastProgressZ =
    self.unit.z

  self.lastTargetX = targetX
  self.lastTargetZ = targetZ

  return true
end


function UnitOrderController:
  setOrder(order)
  if not self.unit:isTargetable() then
    return false, 'unit_unavailable'
  end

  if self.currentOrder then
    self.currentOrder:cancel(
      'replaced',
      self.battle.time
    )
  end

  self.currentOrder = order

  order:activate(
    self.battle.time
  )

  local success, reason =
    self:rebuildPath()

  if not success then
    order:fail(
      reason,
      self.battle.time
    )

    self.currentOrder = nil

    return false, reason
  end

  return true
end


function UnitOrderController:
  issueMove(
    x,
    z,
    source
  )
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


function UnitOrderController:
  issueAttackSquad(
    target,
    source
  )
  if
    not target
    or target:isDefeated()
    or target.team == self.unit.team
  then
    return false, 'invalid_target'
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


function UnitOrderController:
  issueAttackBuilding(
    building,
    source
  )
  if
    not building
    or not building:isTargetable()
    or building.team ==
      self.unit.team
  then
    return false, 'invalid_target'
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


function UnitOrderController:
  cancel(reason)
  if not self.currentOrder then
    return false
  end

  self.currentOrder:cancel(
    reason or 'cancelled',
    self.battle.time
  )

  self.currentOrder = nil
  self.repathTimer = 0
  self.stuckTimer = 0

  return true
end


function UnitOrderController:
  getWaypoint()
  if not self.currentOrder then
    return nil
  end

  return
    self.currentOrder:
      getPathPoint()
end


function UnitOrderController:
  hasMovementOrder()
  return
    self:hasOrder()
    and self:getWaypoint() ~= nil
end


function UnitOrderController:
  completeMove()
  local order = self.currentOrder

  if
    not order
    or not order:isMove()
  then
    return false
  end

  order:complete(
    self.battle.time
  )

  self.currentOrder = nil
  self.repathTimer = 0
  self.stuckTimer = 0

  return true
end


function UnitOrderController:
  updatePathProgress()
  local order = self.currentOrder

  if
    not order
    or order:isFinished()
  then
    return
  end

  local waypoint =
    order:getPathPoint()

  if not waypoint then
    if order:isMove() then
      self:completeMove()
    end

    return
  end

  local radius =
    self.battle.config.navigation
      .waypointRadius
    or 1

  radius =
    math.max(
      radius,
      self.unit.radius * 1.25
    )

  if
    distanceSquared(
      self.unit.x,
      self.unit.z,
      waypoint.x,
      waypoint.z
    ) > radius * radius
  then
    return
  end

  local hasNext =
    order:advancePath()

  if
    not hasNext
    and order:isMove()
  then
    self:completeMove()
  end
end


function UnitOrderController:
  updateRepath(dt)
  local order = self.currentOrder

  if
    not order
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
    self:rebuildPath()
    return
  end

  if not order:isAttack() then
    return
  end

  local settings =
    self.battle.config.navigation

  if
    self.repathTimer <
      settings.repathInterval
  then
    return
  end

  local targetX, targetZ =
    self:getTargetPosition(order)

  if not targetX then
    return
  end

  local threshold =
    settings.repathDistance

  if
    not self.lastTargetX
    or distanceSquared(
      targetX,
      targetZ,
      self.lastTargetX,
      self.lastTargetZ
    ) >= threshold * threshold
  then
    self:rebuildPath()
  else
    self.repathTimer = 0
  end
end


function UnitOrderController:
  updateStuck(dt)
  if not self:hasMovementOrder() then
    self.stuckTimer = 0
    return
  end

  local settings =
    self.battle.config.squad

  local stuckDistance =
    settings.stuckDistance
    or .5

  if
    distanceSquared(
      self.unit.x,
      self.unit.z,
      self.lastProgressX,
      self.lastProgressZ
    ) >=
      stuckDistance *
      stuckDistance
  then
    self.lastProgressX =
      self.unit.x

    self.lastProgressZ =
      self.unit.z

    self.stuckTimer = 0
    return
  end

  self.stuckTimer =
    self.stuckTimer + dt

  if
    self.stuckTimer >=
      (
        settings.stuckTimeout
        or 1.5
      )
  then
    self.stuckTimer = 0
    self:rebuildPath()
  end
end


function UnitOrderController:
  update(dt)
  local order = self.currentOrder

  if not order then
    return
  end

  if order:isFinished() then
    self.currentOrder = nil
    return
  end

  if
    order:isAttack()
    and not order:isTargetValid()
  then
    order:cancel(
      'target_lost',
      self.battle.time
    )

    self.currentOrder = nil
    return
  end

  self:updatePathProgress()
  self:updateRepath(dt)
  self:updateStuck(dt)
end


return UnitOrderController