local EngagementSystem = {}
EngagementSystem.__index =
  EngagementSystem


local function isUnitAlive(unit)
  return
    unit
    and unit.isTargetable
    and unit:isTargetable()
end


local function isSquadAlive(squad)
  return
    squad
    and not squad:isDefeated()
end


local function getLinkKey(
  firstUnit,
  secondUnit
)
  local firstId =
    assert(
      firstUnit.id,
      'Unit has no ID'
    )

  local secondId =
    assert(
      secondUnit.id,
      'Unit has no ID'
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


function EngagementSystem.new(config)
  local self =
    setmetatable(
      {},
      EngagementSystem
    )

  config = config or {}

  self.releaseDelay =
    config.releaseDelay or 2.5

  self.links = {}
  self.time = 0

  return self
end


function EngagementSystem:
  prepareUnit(unit)
  if not unit then
    return
  end

  unit.engagements =
    unit.engagements or {}

  unit.engaged =
    next(unit.engagements)
    ~= nil
end


function EngagementSystem:
  refreshUnitState(unit)
  if not unit then
    return
  end

  self:prepareUnit(unit)

  unit.engaged =
    next(unit.engagements)
    ~= nil
end


function EngagementSystem:
  refreshSquadState(squad)
  if not squad then
    return
  end

  local engaged = false

  for _, unit in ipairs(
    squad.units or {}
  ) do
    self:refreshUnitState(unit)

    if unit.engaged then
      engaged = true
      break
    end
  end

  squad.engaged = engaged
end


function EngagementSystem:
  canEngageUnits(
    firstUnit,
    secondUnit
  )
  if
    not isUnitAlive(firstUnit)
    or not isUnitAlive(secondUnit)
  then
    return false
  end

  if firstUnit == secondUnit then
    return false
  end

  if
    firstUnit.team ==
    secondUnit.team
  then
    return false
  end

  return true
end


function EngagementSystem:
  touchUnits(
    firstUnit,
    secondUnit
  )
  if
    not self:canEngageUnits(
      firstUnit,
      secondUnit
    )
  then
    return false
  end

  self:prepareUnit(firstUnit)
  self:prepareUnit(secondUnit)

  local key =
    getLinkKey(
      firstUnit,
      secondUnit
    )

  local link =
    self.links[key]

  if link then
    link.lastContact = self.time
    return true
  end

  link = {
    key = key,

    first = firstUnit,
    second = secondUnit,

    startedAt = self.time,
    lastContact = self.time
  }

  self.links[key] = link

  firstUnit.engagements[
    secondUnit
  ] = true

  secondUnit.engagements[
    firstUnit
  ] = true

  self:refreshUnitState(firstUnit)
  self:refreshUnitState(secondUnit)

  self:refreshSquadState(
    firstUnit.squad
  )

  self:refreshSquadState(
    secondUnit.squad
  )

  if firstUnit.onEngagementStarted then
    firstUnit:onEngagementStarted(
      secondUnit
    )
  end

  if secondUnit.onEngagementStarted then
    secondUnit:onEngagementStarted(
      firstUnit
    )
  end

  return true
end


-- Совместимость со старым API групп.
function EngagementSystem:
  touchSquads(
    firstSquad,
    secondSquad
  )
  if
    not isSquadAlive(firstSquad)
    or not isSquadAlive(secondSquad)
    or firstSquad.team ==
      secondSquad.team
  then
    return false
  end

  local nearestFirst = nil
  local nearestSecond = nil
  local nearestDistance = nil

  for _, firstUnit in ipairs(
    firstSquad.units or {}
  ) do
    if isUnitAlive(firstUnit) then
      for _, secondUnit in ipairs(
        secondSquad.units or {}
      ) do
        if isUnitAlive(secondUnit) then
          local dx =
            secondUnit.x -
            firstUnit.x

          local dz =
            secondUnit.z -
            firstUnit.z

          local distance =
            dx * dx + dz * dz

          if
            not nearestDistance
            or distance <
              nearestDistance
          then
            nearestFirst = firstUnit
            nearestSecond = secondUnit
            nearestDistance = distance
          end
        end
      end
    end
  end

  if
    not nearestFirst
    or not nearestSecond
  then
    return false
  end

  return self:touchUnits(
    nearestFirst,
    nearestSecond
  )
end


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

  self:refreshUnitState(first)
  self:refreshUnitState(second)

  if first then
    self:refreshSquadState(
      first.squad
    )
  end

  if second then
    self:refreshSquadState(
      second.squad
    )
  end

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


function EngagementSystem:
  clearUnit(
    unit,
    reason
  )
  if not unit then
    return
  end

  local keys = {}

  for key, link in pairs(
    self.links
  ) do
    if
      link.first == unit
      or link.second == unit
    then
      keys[#keys + 1] = key
    end
  end

  for _, key in ipairs(keys) do
    self:removeLink(
      key,
      reason or 'unit_cleared'
    )
  end

  unit.engagements = {}
  unit.engaged = false

  self:refreshSquadState(
    unit.squad
  )
end


function EngagementSystem:
  clearSquad(
    squad,
    reason
  )
  if not squad then
    return
  end

  local keys = {}

  for key, link in pairs(
    self.links
  ) do
    if
      link.first.squad == squad
      or link.second.squad == squad
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

  for _, unit in ipairs(
    squad.units or {}
  ) do
    unit.engagements = {}
    unit.engaged = false
  end

  squad.engaged = false
end


function EngagementSystem:
  isUnitEngaged(unit)
  if not unit then
    return false
  end

  self:refreshUnitState(unit)

  return unit.engaged
end


-- Принимает и Unit, и логическую группу.
function EngagementSystem:
  isEngaged(subject)
  if not subject then
    return false
  end

  if subject.units then
    self:refreshSquadState(subject)
    return subject.engaged
  end

  return self:isUnitEngaged(subject)
end


function EngagementSystem:
  canMove(subject)
  if not subject then
    return false
  end

  if subject.units then
    return
      isSquadAlive(subject)
      and not self:isEngaged(subject)
  end

  return
    isUnitAlive(subject)
    and not self:isEngaged(subject)
end


function EngagementSystem:
  getUnitOpponents(unit)
  local result = {}

  if
    not unit
    or not unit.engagements
  then
    return result
  end

  local stale = {}

  for opponent in pairs(
    unit.engagements
  ) do
    if isUnitAlive(opponent) then
      result[#result + 1] =
        opponent
    else
      stale[#stale + 1] =
        opponent
    end
  end

  for _, opponent in ipairs(stale) do
    unit.engagements[opponent] = nil
  end

  self:refreshUnitState(unit)

  return result
end


function EngagementSystem:
  getUnitBattleGroup(unit)
  local result = {}
  local queue = { unit }
  local visited = {
    [unit] = true
  }

  local index = 1

  while index <= #queue do
    local current = queue[index]
    index = index + 1

    result[#result + 1] =
      current

    for _, opponent in ipairs(
      self:getUnitOpponents(current)
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


function EngagementSystem:
  areUnitsInSameBattle(
    firstUnit,
    secondUnit
  )
  if
    not firstUnit
    or not secondUnit
  then
    return false
  end

  if firstUnit == secondUnit then
    return true
  end

  for _, unit in ipairs(
    self:getUnitBattleGroup(firstUnit)
  ) do
    if unit == secondUnit then
      return true
    end
  end

  return false
end


function EngagementSystem:
  canTargetUnit(
    attacker,
    target
  )
  if
    not self:canEngageUnits(
      attacker,
      target
    )
  then
    return false
  end

  if not self:isUnitEngaged(attacker) then
    return true
  end

  return self:areUnitsInSameBattle(
    attacker,
    target
  )
end


-- Возвращает группы, непосредственно
-- связанные с данной логической группой.
function EngagementSystem:
  getOpponents(squad)
  local result = {}
  local added = {}

  if not squad then
    return result
  end

  for _, link in pairs(
    self.links
  ) do
    local opponent = nil

    if link.first.squad == squad then
      opponent = link.second.squad

    elseif link.second.squad == squad then
      opponent = link.first.squad
    end

    if
      opponent
      and opponent ~= squad
      and not added[opponent]
      and isSquadAlive(opponent)
    then
      added[opponent] = true
      result[#result + 1] =
        opponent
    end
  end

  return result
end


function EngagementSystem:
  getBattleGroup(squad)
  if not squad then
    return {}
  end

  local result = {}
  local queue = { squad }
  local visited = {
    [squad] = true
  }

  local index = 1

  while index <= #queue do
    local current = queue[index]
    index = index + 1

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


function EngagementSystem:
  canEngage(
    firstSquad,
    secondSquad
  )
  return
    isSquadAlive(firstSquad)
    and isSquadAlive(secondSquad)
    and firstSquad ~= secondSquad
    and firstSquad.team ~=
      secondSquad.team
end


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

  return self:areInSameBattle(
    attackerSquad,
    targetSquad
  )
end


function EngagementSystem:update(dt)
  self.time =
    self.time + dt

  local expired = {}

  for key, link in pairs(
    self.links
  ) do
    local reason = nil

    if
      not isUnitAlive(link.first)
      or not isUnitAlive(link.second)
    then
      reason = 'unit_defeated'

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