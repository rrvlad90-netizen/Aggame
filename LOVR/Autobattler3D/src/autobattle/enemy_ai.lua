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

	self.attackArmy =
		self.config.attackArmy
		or {
		  light_infantry = 4,
		  archer = 1
		}

	  self:prepareInitialArmy()

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

-- Оставляет отряд ждать общего наступления.
function EnemyAI:holdSquad(squad)
  squad.aiWaitingForAttack = true
  squad.currentRoute = nil
  squad.strategicRoute = nil
  squad.resumeRoute = nil

  for _, unit in ipairs(
    squad.units
  ) do
    unit.route = nil
    unit.routePointIndex = nil
    unit.routeFinished = true
  end
end


-- Останавливает начальные войска противника.
function EnemyAI:prepareInitialArmy()
  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'enemies'
      and not squad:isDefeated()
    then
      self:holdSquad(squad)
    end
  end
end


-- Считает только ожидающие наступления отряды.
function EnemyAI:getWaitingSquadCounts()
  local counts = {}

  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'enemies'
      and squad.aiWaitingForAttack
      and not squad:isDefeated()
    then
      local slot =
        squad.unitDefinition.slot

      counts[slot] =
        (counts[slot] or 0) + 1
    end
  end

  return counts
end


-- Учитывает отряды в очередях казарм.
function EnemyAI:getPlannedSquadCounts()
  local counts =
    self:getWaitingSquadCounts()

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    if building.team == 'enemies' then
      for _, request in ipairs(
        building.recruitQueue or {}
      ) do
        if request.routeId == false then
          local slot =
            request.option.slot

          counts[slot] =
            (counts[slot] or 0) + 1
        end
      end
    end
  end

  return counts
end


-- Проверяет готовность ударной армии.
function EnemyAI:isAttackArmyReady(counts)
  for slot, required in pairs(
    self.attackArmy
  ) do
    if
      (counts[slot] or 0) <
      required
    then
      return false
    end
  end

  return true
end


-- Выбирает маршрут для отдельного
-- отряда наступающей волны.
function EnemyAI:chooseWaveRoute(
  waveUsage
)
  local selected = nil
  local selectedScore = nil

  for _, settings in ipairs(
    self.config.routes or {}
  ) do
    local route =
      self.battle:findRoute(
        'enemy',
        settings.id
      )

    if route then
      local usage =
        waveUsage[route.id]
        or 0

      local score =
        self:getRouteScore(
          settings
        )

      -- Сильный штраф заставляет волну
      -- равномерно занимать маршруты.
      score =
        score -
        usage * 35

      -- Небольшое отклонение сохраняет
      -- непредсказуемость AI.
      score =
        score +
        math.random() * 8

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

-- Распределяет накопленную армию
-- по нескольким направлениям.
function EnemyAI:launchAttack()
  local waiting = {}

  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'enemies'
      and squad.aiWaitingForAttack
      and not squad:isDefeated()
    then
      waiting[#waiting + 1] =
        squad
    end
  end

  if #waiting == 0 then
    return false
  end

  -- Передние войска получают маршруты
  -- раньше стрелков и осадных орудий.
  local priorities = {
    light_infantry = 1,
    medium_infantry = 1,
    heavy_infantry = 1,

    cavalry = 2,
    heavy_cavalry = 2,

    giant1 = 3,
    giant2 = 3,
    giant3 = 3,

    archer = 4,
    crossbowman = 4,
    heavy_archer = 4,

    catapult = 5,
    ballista = 5
  }

  table.sort(
    waiting,

    function(first, second)
      local firstPriority =
        priorities[
          first.unitDefinition.slot
        ] or 3

      local secondPriority =
        priorities[
          second.unitDefinition.slot
        ] or 3

      if
        firstPriority ==
        secondPriority
      then
        return first.id < second.id
      end

      return
        firstPriority <
        secondPriority
    end
  )

  local waveUsage = {}
  local launched = false

  for _, squad in ipairs(waiting) do
    local route =
      self:chooseWaveRoute(
        waveUsage
      )

    if route then
      squad.aiWaitingForAttack =
        false

	local laneIndex =
			waveUsage[route.id]
			or 0

		  local lane = 0

		  -- Получается последовательность:
		  -- 0, -1, 1, -2, 2...
		  if laneIndex > 0 then
			local magnitude =
			  math.ceil(
				laneIndex / 2
			  )

			local side =
			  laneIndex % 2 == 1
			  and -1
			  or 1

			lane =
			  magnitude * side
		  end

		  squad.combatLaneOffset =
			lane *
			(
			  self.config
				.attackLaneSpacing
			  or 5
			)

		  squad.combatLaneMergeDistance =
			self.config
			  .attackLaneMergeDistance
			or 12


      squad:setStrategicRoute(
        route
      )

      waveUsage[route.id] =
        (
          waveUsage[route.id]
          or 0
        ) + 1

      launched = true
    end
  end

  return launched
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

        local required =
          self.attackArmy[
            desired.slot
          ] or 0

        local missing =
          required - existing

        local score

        if missing > 0 then
          -- Сначала закрывает обязательный
          -- состав ударной армии.
          score =
            1000 +
            missing * 100 +
            (desired.weight or 1)
        else
          score =
            (desired.weight or 1) /
            (existing + 1)
        end

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

        -- Отряд ждёт сбора всей армии.
        false
      )
end

-- Возвращает здания главной базы.
function EnemyAI:getMainBaseBuildings()
  local altar = nil

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    if
      building.team == 'enemies'
      and building.buildingType ==
        'altar'
      and not building.removed
    then
      altar = building
      break
    end
  end

  local result = {}

  if not altar then
    return result
  end

  local radius =
    self.config.baseDefenseRadius
    or 75

  local radiusSquared =
    radius * radius

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    if
      building.team == 'enemies'
      and not building.removed
    then
      local dx =
        building.x - altar.x

      local dz =
        building.z - altar.z

      if
        dx * dx + dz * dz <=
        radiusSquared
      then
        result[#result + 1] =
          building
      end
    end
  end

  return result
end


-- Ищет игрока, атакующего здания базы.
function EnemyAI:findBaseThreat()
  local triggerRadius =
    self.config
      .baseDefenseTriggerRadius
    or 35

  local triggerSquared =
    triggerRadius *
    triggerRadius

  local selected = nil
  local selectedDistance = nil

  for _, building in ipairs(
    self:getMainBaseBuildings()
  ) do
    for _, unit in ipairs(
      self.battle.units
    ) do
      if
        unit.team == 'allies'
        and unit:isTargetable()
      then
        local dx =
          unit.x - building.x

        local dz =
          unit.z - building.z

        local distance =
          dx * dx + dz * dz

        if
          distance <= triggerSquared
          and (
            not selectedDistance
            or distance <
              selectedDistance
          )
        then
          selected = unit
          selectedDistance = distance
        end
      end
    end
  end

  return selected
end


-- Отправляет ожидающие отряды
-- защищать атакованную базу.
function EnemyAI:respondToBaseThreat()
  local threat =
    self:findBaseThreat()

  if not threat then
    return false
  end

  local sent = false

  local spread =
    self.config.baseDefenseSpread
    or 8

  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'enemies'
      and squad.aiWaitingForAttack
      and not squad:isDefeated()
    then
      local targetMoved = true

      if
        squad.aiDefenseTargetX
        and squad.aiDefenseTargetZ
      then
        local dx =
          threat.x -
          squad.aiDefenseTargetX

        local dz =
          threat.z -
          squad.aiDefenseTargetZ

        targetMoved =
          dx * dx + dz * dz >
          8 * 8
      end

      if
        not squad.aiDefendingBase
        or targetMoved
      then
        local angle =
          (
            squad.id * 2.399
          ) % (
            math.pi * 2
          )

        squad:moveToPoint(
          threat.x +
          math.cos(angle) * spread,

          threat.z +
          math.sin(angle) * spread
        )

        squad.aiDefendingBase = true

        squad.aiDefenseTargetX =
          threat.x

        squad.aiDefenseTargetZ =
          threat.z
      end

      sent = true
    end
  end

  return sent
end

-- Выполняет одно стратегическое решение.
function EnemyAI:makeDecision()
  local waitingCounts =
    self:getWaitingSquadCounts()

-- Защита базы важнее накопления
  -- и планового наступления.
  if self:respondToBaseThreat() then
    return
  end

  if self:isAttackArmyReady(
    waitingCounts
  ) then
    if self:launchAttack() then
      return
    end
  end

  local _, totalSquads =
    self:getSquadCounts()

  local built, saving =
    self:tryBuild(totalSquads)

  if built or saving then
    return
  end

  local plannedCounts =
    self:getPlannedSquadCounts()

  self:tryRecruit(
    plannedCounts
  )
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