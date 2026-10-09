local EnemyAI = {}
EnemyAI.__index = EnemyAI


-- Создаёт стратегический AI.
function EnemyAI.new(settings)
  local self =
    setmetatable({}, EnemyAI)

  self.battle =
    assert(
      settings.battle,
      'EnemyAI has no battle'
    )

  -- В tactical-режиме зданий
  -- и экономики может не быть.
  self.buildingSystem =
    settings.buildingSystem

  self.economy =
    settings.economy

  self.config =
    settings.config or {}

  self.decisionInterval =
    self.config.decisionInterval
    or 1.5

	self.decisionTimer =
	  self.config.tactical
	  and self.decisionInterval
	  or 0

  self.attackArmy =
    self.config.attackArmy
    or {
      light_infantry = 4,
      archer = 1
    }

  self.minimumReserve =
    self.config.minimumReserve
    or 1

  self:prepareInitialArmy()

  return self
end


-- Подготавливает начальные войска.
function EnemyAI:prepareInitialArmy()
  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'enemies'
      and not squad:isDefeated()
    then
      squad.aiState = 'reserve'
      squad.aiObjective = nil
    end
  end
end


-- Возвращает живые отряды AI.
function EnemyAI:getSquads()
  local result = {}

  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'enemies'
      and not squad:isDefeated()
    then
      result[#result + 1] =
        squad
    end
  end

  return result
end


-- Возвращает свободные отряды.
function EnemyAI:getAvailableSquads(
  state
)
  local result = {}

  for _, squad in ipairs(
    self:getSquads()
  ) do
    if
      not squad.engaged
      and (
        not state
        or squad.aiState == state
      )
    then
      result[#result + 1] =
        squad
    end
  end

  return result
end


-- Считает отряды по типам.
function EnemyAI:getSquadCounts(
  state
)
  local counts = {}
  local total = 0

  for _, squad in ipairs(
    self:getSquads()
  ) do
    if
      not state
      or squad.aiState == state
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


-- Добавляет отряды из очередей.
function EnemyAI:getPlannedCounts()
  local counts =
    self:getSquadCounts('reserve')

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    if building.team == 'enemies' then
      for _, request in ipairs(
        building.recruitQueue or {}
      ) do
        local option = request.option

        if option and option.slot then
          counts[option.slot] =
            (
              counts[option.slot]
              or 0
            ) + 1
        end
      end
    end
  end

  return counts
end


-- Проверяет готовность ударной армии.
function EnemyAI:isAttackArmyReady()
  local counts =
    self:getSquadCounts('reserve')

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


-- Возвращает приоритет здания.
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


-- Выбирает площадку строительства.
function EnemyAI:
  chooseConstructionTarget()
  local selected = nil
  local selectedPriority = nil

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    if
      building.team == 'enemies'
      and building:isPlatform()
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
function EnemyAI:tryBuild()
  local building =
    self:chooseConstructionTarget()

  if not building then
    return false, false
  end

  local cost =
    building.definition.buildCost
    or 0

  if self.economy:canAfford(cost) then
    return
      self.buildingSystem:
        startEnemyConstruction(
          building
        ),
      false
  end

  local _, total =
    self:getSquadCounts()

  local shouldSave =
    self.config.saveForBuildings
      ~= false
    and (
      building.buildingType ==
        'barracks'
      or total >=
        (
          self.config
            .minimumArmyBeforeSaving
          or 3
        )
    )

  return false, shouldSave
end


-- Возвращает готовые казармы.
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
    then
      result[#result + 1] =
        building
    end
  end

  return result
end


-- Ищет вариант найма.
function EnemyAI:getRecruitOption(
  building,
  slot
)
  for _, option in ipairs(
    building.definition
      .recruitOptions or {}
  ) do
    if option.slot == slot then
      return option
    end
  end

  return nil
end


-- Выбирает следующий тип войск.
function EnemyAI:chooseRecruitment()
  local counts =
    self:getPlannedCounts()

  local composition =
    self.config.composition or {}

  local bestBuilding = nil
  local bestOption = nil
  local bestScore = nil

  for _, building in ipairs(
    self:getReadyBarracks()
  ) do
    for _, desired in ipairs(
      composition
    ) do
      local option =
        self:getRecruitOption(
          building,
          desired.slot
        )

      if option then
        local existing =
          counts[desired.slot] or 0

        local required =
          self.attackArmy[
            desired.slot
          ] or 0

        local missing =
          math.max(
            0,
            required - existing
          )

        local score

        if missing > 0 then
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
          score + math.random() * .02

        if
          not bestScore
          or score > bestScore
        then
          bestBuilding = building
          bestOption = option
          bestScore = score
        end
      end
    end
  end

  -- Если карта не задала composition,
  -- использует обязательный состав.
  if
    not bestOption
    and #composition == 0
  then
    for _, building in ipairs(
      self:getReadyBarracks()
    ) do
      for slot in pairs(
        self.attackArmy
      ) do
        local option =
          self:getRecruitOption(
            building,
            slot
          )

        if option then
          return building, option
        end
      end
    end
  end

  return bestBuilding, bestOption
end


-- Пытается нанять новый отряд.
function EnemyAI:tryRecruit()
  local building, option =
    self:chooseRecruitment()

  if not building or not option then
    return false
  end

  return
    self.buildingSystem:
      recruitEnemySquad(
        building,
        option.slot,

        -- Отряд появляется без маршрута.
        false
      )
end

-- Возвращает здания главной базы.
function EnemyAI:getBaseBuildings()
  local result = {}
  local altar = nil

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    if
      building.team == 'enemies'
      and building.buildingType ==
        'altar'
      and building:isTargetable()
    then
      altar = building
      break
    end
  end

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
      and building:isTargetable()
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


-- Ищет угрозу главной базе.
function EnemyAI:findBaseThreat()
  local triggerRadius =
    self.config
      .baseDefenseTriggerRadius
    or 35

  local selected = nil
  local selectedDistance = nil

  for _, building in ipairs(
    self:getBaseBuildings()
  ) do
    for _, squad in ipairs(
      self.battle.squads
    ) do
      if
        squad.team == 'allies'
        and not squad:isDefeated()
      then
        local x, z =
          squad:getCenter()

        local dx = x - building.x
        local dz = z - building.z

        local distance =
          math.sqrt(
            dx * dx + dz * dz
          ) - squad:getRadius()

        if
          distance <= triggerRadius
          and (
            not selectedDistance
            or distance <
              selectedDistance
          )
        then
          selected = squad
          selectedDistance = distance
        end
      end
    end
  end

  return selected
end


-- Возвращает расстояние между отрядами.
function EnemyAI:getSquadDistance(
  first,
  second
)
  local firstX, firstZ =
    first:getCenter()

  local secondX, secondZ =
    second:getCenter()

  local dx = secondX - firstX
  local dz = secondZ - firstZ

  return math.sqrt(
    dx * dx + dz * dz
  )
end


-- Сортирует отряды по расстоянию.
function EnemyAI:sortByDistance(
  squads,
  target
)
  table.sort(
    squads,

    function(first, second)
      return
        self:getSquadDistance(
          first,
          target
        ) <
        self:getSquadDistance(
          second,
          target
        )
    end
  )
end


-- Отправляет войска защищать базу.
function EnemyAI:respondToBaseThreat()
  local threat =
    self:findBaseThreat()

  if not threat then
    return false
  end

  local candidates = {}

  for _, squad in ipairs(
    self:getAvailableSquads()
  ) do
    if
      squad.aiState == 'reserve'
      or squad.aiState == 'assault'
    then
      candidates[#candidates + 1] =
        squad
    end
  end

  self:sortByDistance(
    candidates,
    threat
  )

  local typicalSize =
    threat.unitDefinition.squadSize
    or threat.initialCount
    or 1

  local required =
    math.max(
      1,

      math.ceil(
        threat.activeCount /
        math.max(typicalSize, 1)
      ) + 1
    )

  required =
    math.min(
      required,
      #candidates
    )

  for index = 1, required do
    local squad = candidates[index]

    if
      squad.aiState ~= 'defense'
      or squad.aiObjective ~= threat
      or not squad.currentOrder
    then
      squad:issueAttackSquad(
        threat,
        'ai_defense'
      )
    end

    squad.aiState = 'defense'
    squad.aiObjective = threat
  end

  return required > 0
end


-- Возвращает завершившихся защитников
-- обратно в резерв.
function EnemyAI:updateDefenders()
  for _, squad in ipairs(
    self:getSquads()
  ) do
    if squad.aiState == 'defense' then
      local target =
        squad.aiObjective

      if
        not target
        or target:isDefeated()
        or not self:findBaseThreat()
      then
        squad.aiState = 'reserve'
        squad.aiObjective = nil

        if
          squad.currentOrder
          and squad.currentOrder.source ==
            'ai_defense'
        then
          squad.currentOrder:cancel(
            'defense_complete',
            self.battle.time
          )

          squad.currentOrder = nil
          squad.state = 'idle'
        end
      end
    end
  end
end


-- Выбирает незахваченную область.
function EnemyAI:chooseCapturePoint()
  local captureSystem =
    self.battle.captureSystem

  if not captureSystem then
    return nil
  end

  local best = nil
  local bestScore = nil

  for _, point in ipairs(
    captureSystem.points
  ) do
    if point.ownerTeam ~= 'enemies' then
      local score = 100

      if point.ownerTeam == 'allies' then
        score = score + 40
      end

      if
        not bestScore
        or score > bestScore
      then
        best = point
        bestScore = score
      end
    end
  end

  return best
end


-- Возвращает ценность здания.
function EnemyAI:getTargetPriority(
  building
)
  if building.buildingType == 'altar' then
    return 1000
  end

  if
    building.buildingType ==
      'barracks'
  then
    return 650
  end

  if building.buildingType == 'tower' then
    return 450
  end

  return 300
end


-- Выбирает стратегическую цель.
function EnemyAI:chooseAttackTarget(
  sourceSquad
)
  local capturePoint =
    self:chooseCapturePoint()

  if capturePoint then
    return {
      kind = 'capture',
      target = capturePoint
    }
  end

  local sourceX, sourceZ =
    sourceSquad:getCenter()

  local selected = nil
  local selectedScore = nil

  -- На tactical-карте зданий нет.
  if self.buildingSystem then
    for _, building in ipairs(
      self.buildingSystem.buildings
    ) do
      if
        building.team == 'allies'
        and building:isTargetable()
      then
        local dx =
          building.x - sourceX

        local dz =
          building.z - sourceZ

        local distance =
          math.sqrt(
            dx * dx + dz * dz
          )

        local score =
          self:getTargetPriority(
            building
          ) - distance * 1.5

        if
          not selectedScore
          or score > selectedScore
        then
          selected = building
          selectedScore = score
        end
      end
    end
  end

  if selected then
    return {
      kind = 'building',
      target = selected
    }
  end

  local nearest = nil
  local nearestDistance = nil

  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'allies'
      and not squad:isDefeated()
    then
      local distance =
        self:getSquadDistance(
          sourceSquad,
          squad
        )

      if
        not nearestDistance
        or distance <
          nearestDistance
      then
        nearest = squad
        nearestDistance = distance
      end
    end
  end

  if nearest then
    return {
      kind = 'squad',
      target = nearest
    }
  end

  return nil
end


-- Отдаёт приказ по выбранной цели.
function EnemyAI:issueObjective(
  squad,
  objective
)
  if not objective then
    return false
  end

  if objective.kind == 'capture' then
    return squad:issueMove(
      objective.target.x,
      objective.target.z,
      'ai_capture'
    )
  end

  if objective.kind == 'building' then
    return squad:issueAttackBuilding(
      objective.target,
      'ai_assault'
    )
  end

  if objective.kind == 'squad' then
    return squad:issueAttackSquad(
      objective.target,
      'ai_assault'
    )
  end

  return false
end


-- Запускает собранную армию.
function EnemyAI:launchAttack()
  local reserves =
    self:getAvailableSquads(
      'reserve'
    )

  if
    #reserves <= self.minimumReserve
  then
    return false
  end

  local assaultCount =
    #reserves -
    self.minimumReserve

  local leader = reserves[1]

  local objective =
    self:chooseAttackTarget(
      leader
    )

  if not objective then
    return false
  end

  local issued = false

  for index = 1, assaultCount do
    local squad = reserves[index]

    if
      self:issueObjective(
        squad,
        objective
      )
    then
      squad.aiState = 'assault'
      squad.aiObjective =
        objective.target

      issued = true
    end
  end

  return issued
end


-- Поддерживает наступающие отряды.
function EnemyAI:maintainAssaults()
  for _, squad in ipairs(
    self:getSquads()
  ) do
    if
      squad.aiState == 'assault'
      and not squad.engaged
      and not squad.currentOrder
    then
      local objective =
        self:chooseAttackTarget(
          squad
        )

      if objective then
        self:issueObjective(
          squad,
          objective
        )

        squad.aiObjective =
          objective.target
      else
        squad.aiState = 'reserve'
        squad.aiObjective = nil
      end
    end
  end
end


-- Нормализует новые отряды.
function EnemyAI:prepareNewSquads()
  for _, squad in ipairs(
    self:getSquads()
  ) do
    if not squad.aiState then
      squad.aiState = 'reserve'
      squad.aiObjective = nil
    end
  end
end

-- Отправляет тактические войска в бой.
function EnemyAI:launchTacticalAttack()
  local reserves =
    self:getAvailableSquads(
      'reserve'
    )

  for _, squad in ipairs(reserves) do
    local objective =
      self:chooseAttackTarget(
        squad
      )

    if objective then
      self:issueObjective(
        squad,
        objective
      )

      squad.aiState = 'assault'
      squad.aiObjective =
        objective.target
    end
  end
end

-- Выполняет стратегическое решение.
function EnemyAI:makeDecision()
  self:prepareNewSquads()
  self:maintainAssaults()

  if self.config.tactical then
    self:launchTacticalAttack()
    return
  end

  self:updateDefenders()
  self:respondToBaseThreat()

  if self:isAttackArmyReady() then
    self:launchAttack()
  end

  local built, saving =
    self:tryBuild()

  if built or saving then
    return
  end

  self:tryRecruit()
end


-- Обновляет AI.
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