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