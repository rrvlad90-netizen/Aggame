local EnemyAI = {}
EnemyAI.__index = EnemyAI


-- Создаёт экономический AI.
function EnemyAI.new(settings)
  local self =
    setmetatable({}, EnemyAI)

  self.battle =
    assert(
      settings.battle,
      'EnemyAI has no battle'
    )

  self.buildingSystem =
    assert(
      settings.buildingSystem,
      'EnemyAI has no building system'
    )

  self.economy =
    assert(
      settings.economy,
      'EnemyAI has no economy'
    )

  self.config =
    settings.config or {}

  self.decisionInterval =
    self.config.decisionInterval
    or 1.5

  self.decisionTimer = 0

  return self
end


-- Возвращает количество активных
-- отрядов каждого типа.
function EnemyAI:getSquadCounts()
  local counts = {}
  local total = 0

  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'enemies'
      and not squad:isDefeated()
    then
      local slot =
        squad.unitDefinition.slot

      counts[slot] =
        (counts[slot] or 0) + 1

      total = total + 1
    end
  end

  return counts, total
end


-- Проверяет наличие варианта найма.
function EnemyAI:getRecruitOption(
  building,
  slot
)
  local options =
    building.definition
      .recruitOptions
    or {}

  for _, option in ipairs(options) do
    if option.slot == slot then
      return option
    end
  end

  return nil
end


-- Возвращает доступные казармы.
function EnemyAI:getReadyBarracks()
  local result = {}

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    if
      building.team == 'enemies'
      and building.buildingType ==
        'barracks'
      and building:isReady()
      and #building.recruitQueue < 2
    then
      result[#result + 1] =
        building
    end
  end

  return result
end


-- Считает отряды, уже направленные
-- по определённому маршруту.
function EnemyAI:getRouteUsage(
  routeId
)
  local count = 0

  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'enemies'
      and not squad:isDefeated()
      and squad.currentRoute
      and squad.currentRoute.id ==
        routeId
    then
      count = count + 1
    end
  end

  return count
end


-- Считает союзные войска игрока
-- возле стратегической области.
function EnemyAI:getThreatNearPoint(
  point
)
  if not point then
    return 0
  end

  local radius =
    point.radius * 1.6

  local radiusSquared =
    radius * radius

  local threat = 0

  for _, unit in ipairs(
    self.battle.units
  ) do
    if
      unit.team == 'allies'
      and unit:isTargetable()
    then
      local dx =
        unit.x - point.x

      local dz =
        unit.z - point.z

      if
        dx * dx + dz * dz <=
        radiusSquared
      then
        threat = threat + 1
      end
    end
  end

  return threat
end


-- Оценивает стратегический маршрут.
function EnemyAI:getRouteScore(
  settings
)
  local score =
    settings.baseScore or 10

  local captureSystem =
    self.battle.captureSystem

  local point =
    captureSystem
    and settings.capturePoint
    and captureSystem:getPoint(
      settings.capturePoint
    )

  if point then
    if not point.ownerTeam then
      score = score + 45

    elseif
      point.ownerTeam == 'allies'
    then
      score = score + 65

    elseif
      point.ownerTeam == 'enemies'
    then
      local threat =
        self:getThreatNearPoint(
          point
        )

      score =
        score + threat * 5
    end
  end

  score =
    score -
    self:getRouteUsage(
      settings.id
    ) * 12

  return score
end


-- Выбирает наиболее полезный маршрут.
function EnemyAI:chooseRoute()
  local routes =
    self.config.routes or {}

  local selected = nil
  local selectedScore = nil

  for _, settings in ipairs(routes) do
    local route =
      self.battle:findRoute(
        'enemy',
        settings.id
      )

    if route then
      local score =
        self:getRouteScore(
          settings
        )

      -- Небольшая случайность не позволяет
      -- AI всегда действовать одинаково.
      score =
        score +
        math.random() * 4

      if
        not selectedScore
        or score > selectedScore
      then
        selected = route
        selectedScore = score
      end
    end
  end

  return selected
end

-- Возвращает приоритет строительства.
function EnemyAI:getBuildingPriority(
  building
)
  if
    building.buildingType ==
    'barracks'
  then
    return 100
  end

  if
    building.buildingType ==
    'tower'
  then
    return 50
  end

  return 0
end


-- Выбирает следующую платформу.
function EnemyAI:
  chooseConstructionTarget()
  local selected = nil
  local selectedPriority = nil

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    if
      building.team == 'enemies'
      and building.state ==
        'platform'
    then
      local priority =
        self:getBuildingPriority(
          building
        )

      if
        priority > 0
        and (
          not selectedPriority
          or priority >
            selectedPriority
        )
      then
        selected = building
        selectedPriority = priority
      end
    end
  end

  return selected
end


-- Пытается построить здание.
-- Второй результат означает накопление.
function EnemyAI:tryBuild(totalSquads)
  local building =
    self:chooseConstructionTarget()

  if not building then
    return false, false
  end

  local cost =
    building.definition.buildCost
    or 0

  if self.economy:canAfford(cost) then
    local built =
      self.buildingSystem:
        startEnemyConstruction(
          building
        )

    return built, false
  end

  local minimumArmy =
    self.config
      .minimumArmyBeforeSaving
    or 3

  local shouldSave =
    self.config.saveForBuildings
      ~= false
    and (
      building.buildingType ==
        'barracks'
      or totalSquads >= minimumArmy
    )

  return false, shouldSave
end


-- Выбирает юнита и казарму.
function EnemyAI:chooseRecruitment(
  counts
)
  local composition =
    self.config.composition
    or {}

  local barracks =
    self:getReadyBarracks()

  local selectedBuilding = nil
  local selectedOption = nil
  local selectedScore = nil

  for _, building in ipairs(
    barracks
  ) do
    for _, desired in ipairs(
      composition
    ) do
      local option =
        self:getRecruitOption(
          building,
          desired.slot
        )

      if
        option
        and self.economy:
          canAfford(
            option.cost or 0
          )
      then
        local existing =
          counts[desired.slot]
          or 0

        local score =
          (desired.weight or 1) /
          (existing + 1)

        score =
          score +
          math.random() * .03

        if
          not selectedScore
          or score > selectedScore
        then
          selectedBuilding =
            building

          selectedOption = option
          selectedScore = score
        end
      end
    end
  end

  return
    selectedBuilding,
    selectedOption
end


-- Пытается нанять новый отряд.
function EnemyAI:tryRecruit(counts)
  local building, option =
    self:chooseRecruitment(
      counts
    )

  if not building or not option then
    return false
  end

  local route =
    self:chooseRoute()

  if not route then
    return false
  end

  return
    self.buildingSystem:
      recruitEnemySquad(
        building,
        option.slot,
        route.id
      )
end


-- Выполняет одно стратегическое решение.
function EnemyAI:makeDecision()
  local counts, totalSquads =
    self:getSquadCounts()

  local built, saving =
    self:tryBuild(totalSquads)

  if built or saving then
    return
  end

  self:tryRecruit(counts)
end


-- Обновляет экономический AI.
function EnemyAI:update(dt)
  self.decisionTimer =
    self.decisionTimer + dt

  while
    self.decisionTimer >=
    self.decisionInterval
  do
    self.decisionTimer =
      self.decisionTimer -
      self.decisionInterval

    self:makeDecision()
  end
end


return EnemyAI