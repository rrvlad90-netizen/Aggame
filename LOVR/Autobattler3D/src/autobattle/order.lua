local Order = {}
Order.__index = Order


Order.Type = {
  MOVE = 'move',
  ATTACK_SQUAD = 'attack_squad',
  ATTACK_BUILDING = 'attack_building'
}


Order.Status = {
  PENDING = 'pending',
  ACTIVE = 'active',
  INTERRUPTED = 'interrupted',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
  FAILED = 'failed'
}


local nextOrderId = 1


local function allocateId()
  local id = nextOrderId

  nextOrderId = nextOrderId + 1

  return id
end


local function isNumber(value)
  return
    type(value) == 'number'
    and value == value
    and value ~= math.huge
    and value ~= -math.huge
end


local function createOrder(
  orderType,
  settings
)
  settings = settings or {}

  local self =
    setmetatable({}, Order)

  self.id = allocateId()
  self.type = orderType
  self.status = Order.Status.PENDING

  self.x = settings.x
  self.z = settings.z
  self.target = settings.target

  self.path = nil
  self.pathIndex = 1

  self.failureReason = nil
  self.interruptionReason = nil

  self.createdAt =
    settings.createdAt or 0

  self.startedAt = nil
  self.finishedAt = nil

  self.source =
    settings.source or 'unknown'

  self.metadata =
    settings.metadata or {}

  return self
end


-- Создаёт приказ движения.
function Order.move(
  x,
  z,
  settings
)
  assert(
    isNumber(x),
    'Move order has invalid X'
  )

  assert(
    isNumber(z),
    'Move order has invalid Z'
  )

  settings = settings or {}
  settings.x = x
  settings.z = z

  return createOrder(
    Order.Type.MOVE,
    settings
  )
end


-- Создаёт приказ атаки отряда.
function Order.attackSquad(
  squad,
  settings
)
  assert(
    squad,
    'Attack order has no squad'
  )

  settings = settings or {}
  settings.target = squad

  return createOrder(
    Order.Type.ATTACK_SQUAD,
    settings
  )
end


-- Создаёт приказ атаки здания.
function Order.attackBuilding(
  building,
  settings
)
  assert(
    building,
    'Attack order has no building'
  )

  settings = settings or {}
  settings.target = building

  return createOrder(
    Order.Type.ATTACK_BUILDING,
    settings
  )
end


-- Проверяет, является ли приказ движением.
function Order:isMove()
  return self.type == Order.Type.MOVE
end


-- Проверяет, является ли приказ атакой.
function Order:isAttack()
  return
    self.type == Order.Type.ATTACK_SQUAD
    or self.type ==
      Order.Type.ATTACK_BUILDING
end


-- Проверяет завершённое состояние.
function Order:isFinished()
  return
    self.status == Order.Status.COMPLETED
    or self.status == Order.Status.CANCELLED
    or self.status == Order.Status.FAILED
end


-- Проверяет доступность цели.
function Order:isTargetValid()
  if not self:isAttack() then
    return true
  end

  local target = self.target

  if not target then
    return false
  end

  if
    self.type ==
      Order.Type.ATTACK_SQUAD
  then
    if target.isDefeated then
      return not target:isDefeated()
    end

    return target.activeCount == nil
      or target.activeCount > 0
  end

  if target.isTargetable then
    return target:isTargetable()
  end

  return not target.removed
end


-- Назначает рассчитанный путь.
function Order:setPath(path)
  self.path = path
  self.pathIndex = 1
end


-- Возвращает текущую точку пути.
function Order:getPathPoint()
  if not self.path then
    return nil
  end

  return self.path[self.pathIndex]
end


-- Переходит к следующей точке пути.
function Order:advancePath()
  if not self.path then
    return false
  end

  self.pathIndex =
    self.pathIndex + 1

  return
    self.pathIndex <= #self.path
end


-- Проверяет окончание пути.
function Order:isPathFinished()
  return
    not self.path
    or self.pathIndex > #self.path
end


-- Запускает выполнение.
function Order:activate(time)
  if self:isFinished() then
    return false
  end

  self.status = Order.Status.ACTIVE

  if not self.startedAt then
    self.startedAt = time or 0
  end

  return true
end


-- Временно прерывает выполнение.
function Order:interrupt(reason)
  if self:isFinished() then
    return false
  end

  self.status =
    Order.Status.INTERRUPTED

  self.interruptionReason = reason

  return true
end


-- Возобновляет выполнение.
function Order:resume()
  if
    self.status ~=
      Order.Status.INTERRUPTED
  then
    return false
  end

  self.status = Order.Status.ACTIVE
  self.interruptionReason = nil

  return true
end


-- Отмечает приказ выполненным.
function Order:complete(time)
  if self:isFinished() then
    return false
  end

  self.status = Order.Status.COMPLETED
  self.finishedAt = time or 0

  return true
end


-- Отменяет приказ.
function Order:cancel(
  reason,
  time
)
  if self:isFinished() then
    return false
  end

  self.status = Order.Status.CANCELLED
  self.failureReason = reason
  self.finishedAt = time or 0

  return true
end


-- Отмечает ошибку выполнения.
function Order:fail(
  reason,
  time
)
  if self:isFinished() then
    return false
  end

  self.status = Order.Status.FAILED

  self.failureReason =
    reason or 'unknown'

  self.finishedAt = time or 0

  return true
end


return Order