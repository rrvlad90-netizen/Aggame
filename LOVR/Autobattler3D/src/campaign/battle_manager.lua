local BattleManager = {}
BattleManager.__index = BattleManager


function BattleManager.new(settings)
  local self =
    setmetatable(
      {},
      BattleManager
    )

  self.state = settings.state

  self.armySystem =
    settings.armySystem

  self.journeySystem =
    settings.journeySystem

  self.director =
    settings.director

  self.autoBattle =
    settings.autoBattle

  self.battleAdapter =
    settings.battleAdapter

  self.state.nextScenarioId =
    self.state.nextScenarioId or 1

  self.state.activeBattleScenario =
    self.state.activeBattleScenario
    or nil

  return self
end


function BattleManager:
  allocateScenarioId()
  local id =
    'battle_scenario_' ..
    self.state.nextScenarioId

  self.state.nextScenarioId =
    self.state.nextScenarioId + 1

  return id
end


function BattleManager:
  enqueue(scenario)
  self.state.pendingBattles[
    #self.state.pendingBattles + 1
  ] = scenario

  self:activateNext()
end


function BattleManager:activateNext()
  if
    self.state.activeBattleScenario
  then
    return
  end

  if
    #self.state.pendingBattles == 0
  then
    return
  end

  self.state.activeBattleScenario =
    table.remove(
      self.state.pendingBattles,
      1
    )
end


function BattleManager:getActive()
  return
    self.state.activeBattleScenario
end


function BattleManager:
  finishActive()
  self.state.activeBattleScenario =
    nil

  self:activateNext()
end


function BattleManager:
  getCityArmies(cityId)
  local result = {}

  for _, army in ipairs(
    self.state.armies
  ) do
    if army.cityId == cityId then
      result[#result + 1] =
        army
    end
  end

  return result
end


function BattleManager:
  queueTravelEncounter(event)
  local army =
    self.state.armiesById[
      event.playerArmyId
    ]

  if not army then
    return false
  end

  self:enqueue({
    id = self:allocateScenarioId(),

    kind = event.kind,

    playerArmyId = army.id,
    enemyArmy = event.enemyArmy,

    playerIsAttacker =
      event.playerIsAttacker
      == true,

    canRetreat = true,

    context = {
      type = 'travel'
    },

    status = 'choice'
  })

  return true
end


function BattleManager:
  queueCityAttack(
    armyId,
    cityId
  )
  local army =
    self.state.armiesById[
      armyId
    ]

  if not army then
    return false
  end

  local city =
    self.state:getCity(cityId)

  if
    self.state:isAllied(
      army.owner,
      city.owner
    )
  then
    self.journeySystem:
      completeArrival(
        army.id,
        city.id
      )

    return true
  end

  local defense =
    self.director:
      createCityDefense(
        city.id,
        army
      )

  if not defense then
    self.state:
      changeCityOwner(
        city.id,
        army.owner
      )

    self.journeySystem:
      completeArrival(
        army.id,
        city.id
      )

    return true
  end

  self:enqueue({
    id = self:allocateScenarioId(),

    kind = 'city',

    playerArmyId = army.id,
    enemyArmy = defense,

    playerIsAttacker = true,
    canRetreat = true,

    context = {
      type = 'city_attack',
      cityId = city.id
    },

    status = 'choice'
  })

  return true
end


function BattleManager:
  queueSiege(
    cityId,
    participantId
  )
  local defenders =
    self:getCityArmies(cityId)

  if #defenders == 0 then
    self.state:
      changeCityOwner(
        cityId,
        participantId
      )

    return true
  end

  local strongest =
    defenders[1]

  local strongestPower =
    self.director:
      getArmyPower(strongest)

  for index = 2, #defenders do
    local power =
      self.director:
        getArmyPower(
          defenders[index]
        )

    if power > strongestPower then
      strongest =
        defenders[index]

      strongestPower = power
    end
  end

  local enemyArmy =
    self.director:
      createArmyForTarget(
        'siege',
        'cityDefense',
        strongest
      )

  if not enemyArmy then
    return false
  end

  local defenderIds = {}

  for _, army in ipairs(defenders) do
    defenderIds[
      #defenderIds + 1
    ] = army.id
  end

  self:enqueue({
    id = self:allocateScenarioId(),

    kind = 'siege',

    playerArmyId = nil,
    enemyArmy = enemyArmy,

    remainingDefenders =
      defenderIds,

    playerIsAttacker = false,
    canRetreat = false,

    context = {
      type = 'siege',
      cityId = cityId,

      attackingParticipant =
        participantId
    },

    status =
      'select_defender'
  })

  return true
end


function BattleManager:
  selectSiegeDefender(armyId)
  local scenario =
    self:getActive()

  if
    not scenario
    or scenario.kind ~= 'siege'
    or scenario.status ~=
      'select_defender'
  then
    return false
  end

  for index, candidateId in ipairs(
    scenario.remainingDefenders
  ) do
    if candidateId == armyId then
      scenario.playerArmyId =
        armyId

      table.remove(
        scenario.remainingDefenders,
        index
      )

      scenario.status = 'choice'

      return true
    end
  end

  return false
end


function BattleManager:
  getPlayerArmy(scenario)
  return
    self.state.armiesById[
      scenario.playerArmyId
    ]
end


function BattleManager:
  applyGeneratedSurvivors(
    army,
    survivors
  )
  local counts = {}

  for _, survivor in ipairs(
    survivors or {}
  ) do
    counts[survivor.squadId] =
      survivor.count
  end

  for index =
    #army.squads,
    1,
    -1
  do
    local squad =
      army.squads[index]

    squad.count =
      counts[squad.id] or 0

    if squad.count <= 0 then
      table.remove(
        army.squads,
        index
      )
    end
  end
end


function BattleManager:
  completePlayerVictory(
    scenario
  )
  local army =
    self:getPlayerArmy(scenario)

  if not army then
    self:finishActive()
    return
  end

  if
    scenario.context.type ==
      'city_attack'
  then
    local cityId =
      scenario.context.cityId

    self.state:
      changeCityOwner(
        cityId,
        army.owner
      )

    self.journeySystem:
      completeArrival(
        army.id,
        cityId
      )
  end

  self.state:addLog(
    army.name ..
    ' won a battle.'
  )

  self:finishActive()
end


function BattleManager:
  completePlayerDefeat(
    scenario
  )
  local armyId =
    scenario.playerArmyId

  if armyId then
    self.state:
      removeArmy(armyId)
  end

  if scenario.kind == 'siege' then
    scenario.playerArmyId = nil

    local remaining = {}

    for _, defenderId in ipairs(
      scenario.remainingDefenders
    ) do
      if
        self.state.armiesById[
          defenderId
        ]
      then
        remaining[
          #remaining + 1
        ] = defenderId
      end
    end

    scenario.remainingDefenders =
      remaining

    if #remaining > 0 then
      scenario.status =
        'select_defender'

      return
    end

    self.state:
      changeCityOwner(
        scenario.context.cityId,

        scenario.context
          .attackingParticipant
      )
  end

  self:finishActive()
end


function BattleManager:
  applyResult(
    scenario,
    result
  )
  local army =
    self:getPlayerArmy(scenario)

  if army then
    self.armySystem:
      applyBattleSurvivors(
        army.id,
        result.playerSurvivors
        or {}
      )
  end

  self:applyGeneratedSurvivors(
    scenario.enemyArmy,

    result.enemySurvivors
    or {}
  )

  if result.winner == 'player' then
    self:completePlayerVictory(
      scenario
    )
  else
    self:completePlayerDefeat(
      scenario
    )
  end
end


function BattleManager:
  resolveAutomatically()
  local scenario =
    self:getActive()

  if
    not scenario
    or scenario.status ~= 'choice'
  then
    return nil
  end

  local playerArmy =
    self:getPlayerArmy(scenario)

  if not playerArmy then
    return nil
  end

  local options = {}

  if
    scenario.context.type ==
      'city_attack'
  then
    local definition =
      self.state:
        getCityDefinition(
          scenario.context.cityId
        )

    options.defenderMultiplier =
      definition.defenseMultiplier
      or 1.15

  elseif scenario.kind == 'siege' then
    local definition =
      self.state:
        getCityDefinition(
          scenario.context.cityId
        )

    options.attackerMultiplier =
      definition.defenseMultiplier
      or 1.15
  end

  local autoResult =
    self.autoBattle:resolve(
      playerArmy,
      scenario.enemyArmy,
      options
    )

  local result = {
    winner =
      autoResult.winner ==
        'attacker'
      and 'player'
      or (
        autoResult.winner ==
          'defender'
        and 'enemy'
        or 'draw'
      ),

    playerSurvivors =
      autoResult
        .attackerSurvivors,

    enemySurvivors =
      autoResult
        .defenderSurvivors
  }

  self:applyResult(
    scenario,
    result
  )

  return result
end


function BattleManager:
  beginManualBattle()
  local scenario =
    self:getActive()

  if
    not scenario
    or scenario.status ~= 'choice'
  then
    return nil
  end

  local playerArmy =
    self:getPlayerArmy(scenario)

  if not playerArmy then
    return nil
  end

  local request =
    self.battleAdapter:
      createRequest(
        scenario.kind,
        playerArmy,
        scenario.enemyArmy,
        scenario.context
      )

  scenario.manualRequest =
    request

  scenario.status =
    'manual_battle'

  return request
end


function BattleManager:
  finishManualBattle(battle)
  local scenario =
    self:getActive()

  if
    not scenario
    or scenario.status ~=
      'manual_battle'
    or not scenario.manualRequest
  then
    return nil
  end

  local adapterResult =
    self.battleAdapter:
      collectResult(
        scenario.manualRequest,
        battle
      )

  local result = {
    winner =
      adapterResult.winner,

    playerSurvivors =
      adapterResult
        .playerSurvivors,

    enemySurvivors =
      adapterResult
        .enemySurvivors
  }

  scenario.manualRequest = nil

  self:applyResult(
    scenario,
    result
  )

  return result
end


function BattleManager:
  retreat()
  local scenario =
    self:getActive()

  if
    not scenario
    or scenario.status ~= 'choice'
    or not scenario.canRetreat
  then
    return false
  end

  local armyId =
    scenario.playerArmyId

  local survived =
    self.armySystem:
      applyRetreatLosses(
        armyId
      )

  if survived then
    self.journeySystem:
      beginReturn(armyId)
  end

  self.state:addLog(
    'Army retreated from battle.'
  )

  self:finishActive()

  return true
end


return BattleManager