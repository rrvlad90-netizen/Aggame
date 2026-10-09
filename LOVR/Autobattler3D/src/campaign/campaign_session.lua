local CampaignState =
  require(
    'src.campaign.campaign_state'
  )

local CampaignSave =
  require(
    'src.campaign.campaign_save'
  )

local ArmySystem =
  require(
    'src.campaign.army_system'
  )

local Pathfinder =
  require(
    'src.campaign.pathfinder'
  )

local JourneySystem =
  require(
    'src.campaign.journey_system'
  )

local ProductionSystem =
  require(
    'src.campaign.production_system'
  )

local AutoBattle =
  require(
    'src.campaign.auto_battle'
  )

local Director =
  require(
    'src.campaign.director'
  )

local BattleAdapter =
  require(
    'src.campaign.battle_adapter'
  )

local BattleManager =
  require(
    'src.campaign.battle_manager'
  )

local TurnProcessor =
  require(
    'src.campaign.turn_processor'
  )


local CampaignSession = {}
CampaignSession.__index =
  CampaignSession


function CampaignSession.new(settings)
  local self =
    setmetatable(
      {},
      CampaignSession
    )

  self.definition =
    assert(
      settings.definition,
      'CampaignSession has no definition'
    )

  self.sideRegistry =
    assert(
      settings.sideRegistry,
      'CampaignSession has no side registry'
    )

  self.mapRegistry =
    assert(
      settings.mapRegistry,
      'CampaignSession has no map registry'
    )

  self.save =
    CampaignSave.new(
      self.definition
    )

  local savedData = nil

  if settings.loadSave then
    savedData =
      self.save:loadData()
  end

  if savedData then
    self.state =
      CampaignState.fromData(
        self.definition,
        savedData
      )
  else
    self.state =
      CampaignState.new(
        self.definition
      )
  end

  self.armySystem =
    ArmySystem.new(
      self.state,
      self.sideRegistry
    )

  self.pathfinder =
    Pathfinder.new(
      self.state
    )

  self.journeySystem =
    JourneySystem.new(
      self.state,
      self.pathfinder
    )

  self.productionSystem =
    ProductionSystem.new(
      self.state,
      self.armySystem
    )

  self.autoBattle =
    AutoBattle.new(
      self.state
    )

  self.director =
    Director.new(
      self.state,
      self.autoBattle
    )

  self.battleAdapter =
    BattleAdapter.new(
      self.state,
      self.mapRegistry,
      self.sideRegistry
    )

  self.battleManager =
    BattleManager.new({
      state = self.state,

      armySystem =
        self.armySystem,

      journeySystem =
        self.journeySystem,

      director =
        self.director,

      autoBattle =
        self.autoBattle,

      battleAdapter =
        self.battleAdapter
    })

  self.turnProcessor =
    TurnProcessor.new({
      state = self.state,

      productionSystem =
        self.productionSystem,

      journeySystem =
        self.journeySystem,

      director =
        self.director,

      battleManager =
        self.battleManager
    })

  if not savedData then
    self.save:save(
      self.state
    )
  end

  return self
end


function CampaignSession:
  canPerformActions()
  return
    self.state.turnState == nil
    and self.state
      .activeBattleScenario == nil
    and self.state
      .activeNotification == nil
end


function CampaignSession:
  getPlayer()
  return
    self.state:
      getPlayerParticipant()
end


function CampaignSession:
  getPlayerArmies()
  local result = {}

  local player =
    self:getPlayer()

  for _, army in ipairs(
    self.state.armies
  ) do
    if army.owner == player.id then
      result[#result + 1] =
        army
    end
  end

  return result
end


function CampaignSession:
  queueUpgrade(cityId)
  if not self:canPerformActions() then
    return false
  end

  return
    self.productionSystem:
      queueUpgrade(cityId)
end


function CampaignSession:
  queueRecruit(
    cityId,
    slot,
    armyId
  )
  if not self:canPerformActions() then
    return false
  end

  return
    self.productionSystem:
      queueRecruit(
        cityId,
        self:getPlayer().id,
        slot,
        armyId
      )
end


function CampaignSession:
  sendArmy(
    armyId,
    cityId
  )
  if not self:canPerformActions() then
    return nil
  end

  return
    self.journeySystem:
      startJourney(
        armyId,
        cityId
      )
end


function CampaignSession:
  cancelJourney(armyId)
  if not self:canPerformActions() then
    return false
  end

  return
    self.journeySystem:
      cancelJourney(armyId)
end


function CampaignSession:
  handleTurnResult(result)
  if
    result
    and result.status ==
      'turn_complete'
  then
    result.saved =
      self.save:save(
        self.state
      )
  end

  return result
end


function CampaignSession:endTurn()
  if not self:canPerformActions() then
    return nil
  end

  if
    not self.turnProcessor:
      beginEndTurn()
  then
    return nil
  end

  return
    self:handleTurnResult(
      self.turnProcessor:
        continue()
    )
end


function CampaignSession:continueTurn()
  return
    self:handleTurnResult(
      self.turnProcessor:
        continue()
    )
end


function CampaignSession:
  acknowledgeNotification()
  if
    not self.turnProcessor:
      acknowledgeNotification()
  then
    return nil
  end

  return self:continueTurn()
end


function CampaignSession:
  selectSiegeDefender(armyId)
  if
    not self.battleManager:
      selectSiegeDefender(armyId)
  then
    return nil
  end

  return self:continueTurn()
end


function CampaignSession:
  getBattleForecast()
  local scenario =
    self.battleManager:getActive()

  if
    not scenario
    or scenario.status ~= 'choice'
  then
    return nil
  end

  local playerArmy =
    self.state.armiesById[
      scenario.playerArmyId
    ]

  if not playerArmy then
    return nil
  end

  local options = {}

  if
    scenario.context.type ==
      'city_attack'
  then
    local city =
      self.state:
        getCityDefinition(
          scenario.context.cityId
        )

    options.defenderMultiplier =
      city.defenseMultiplier
      or 1.15

  elseif scenario.kind == 'siege' then
    local city =
      self.state:
        getCityDefinition(
          scenario.context.cityId
        )

    options.attackerMultiplier =
      city.defenseMultiplier
      or 1.15
  end

  return
    self.autoBattle:getForecast(
      playerArmy,
      scenario.enemyArmy,
      options
    )
end


function CampaignSession:
  resolveBattleAutomatically()
  local result =
    self.battleManager:
      resolveAutomatically()

  if not result then
    return nil
  end

  return {
    battleResult = result,
    turn = self:continueTurn()
  }
end


function CampaignSession:
  retreatFromBattle()
  if
    not self.battleManager:
      retreat()
  then
    return nil
  end

  return self:continueTurn()
end


function CampaignSession:
  beginManualBattle()
  local request =
    self.battleManager:
      beginManualBattle()

  if not request then
    return nil
  end

  return {
    request = request,

    options =
      self.battleAdapter:
        createBattleOptions(
          request
        )
  }
end


function CampaignSession:
  finishManualBattle(battle)
  local result =
    self.battleManager:
      finishManualBattle(battle)

  if not result then
    return nil
  end

  return {
    battleResult = result,
    turn = self:continueTurn()
  }
end


function CampaignSession:hasSave()
  return self.save:exists()
end


function CampaignSession:deleteSave()
  return self.save:delete()
end


return CampaignSession