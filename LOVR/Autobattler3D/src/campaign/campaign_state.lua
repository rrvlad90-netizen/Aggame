local CampaignState = {}
CampaignState.__index = CampaignState


function CampaignState.new(definition)
  local self =
    setmetatable(
      {},
      CampaignState
    )

  self.definition = definition

  self.day = 1
  self.gold =
    definition.startingGold or 0

  self.participants = {}
  self.participantsById = {}

  self.cities = {}
  self.citiesById = {}

  self.armies = {}
  self.armiesById = {}

  self.journeys = {}
  self.pendingBattles = {}
  self.announcedSieges = {}

  self.eventLog = {}

  self.nextArmyId = 1
  self.nextSquadId = 1
  self.nextBattleId = 1

  self.directorState = {
    dangerousEventCooldown = 0,
    protectedArmies = {}
  }

  self.turnState = nil

  self:createParticipants()
  self:createCities()

  self:addLog(
    'Campaign started.'
  )

  return self
end


function CampaignState:
  createParticipants()
  for _, definition in ipairs(
    self.definition.participants
  ) do
    local participant = {
      id = definition.id,
      side = definition.side,

      controller =
        definition.controller,

      team = definition.team,
      capital = definition.capital
    }

    self.participants[
      #self.participants + 1
    ] = participant

    self.participantsById[
      participant.id
    ] = participant
  end
end


function CampaignState:createCities()
  for _, definition in ipairs(
    self.definition.cities
  ) do
    local city = {
      id = definition.id,

      owner =
        definition.startingOwner,

      level =
        definition.startingLevel
        or 1,

      productionQueue = {}
    }

    self.cities[
      #self.cities + 1
    ] = city

    self.citiesById[
      city.id
    ] = city
  end
end


function CampaignState:
  getParticipant(id)
  return assert(
    self.participantsById[id],
    'Unknown participant: ' ..
    tostring(id)
  )
end


function CampaignState:
  getPlayerParticipant()
  for _, participant in ipairs(
    self.participants
  ) do
    if
      participant.controller ==
        'player'
    then
      return participant
    end
  end

  error(
    'Campaign has no player'
  )
end


function CampaignState:
  getCity(id)
  return assert(
    self.citiesById[id],
    'Unknown city: ' ..
    tostring(id)
  )
end


function CampaignState:
  getCityDefinition(id)
  for _, city in ipairs(
    self.definition.cities
  ) do
    if city.id == id then
      return city
    end
  end

  error(
    'Unknown city definition: ' ..
    tostring(id)
  )
end


function CampaignState:
  getArmy(id)
  return assert(
    self.armiesById[id],
    'Unknown army: ' ..
    tostring(id)
  )
end


function CampaignState:
  isAllied(
    firstParticipantId,
    secondParticipantId
  )
  if
    not firstParticipantId
    or not secondParticipantId
  then
    return false
  end

  local first =
    self:getParticipant(
      firstParticipantId
    )

  local second =
    self:getParticipant(
      secondParticipantId
    )

  return first.team == second.team
end


function CampaignState:
  isPlayerParticipant(
    participantId
  )
  return
    participantId ==
    self:getPlayerParticipant().id
end


function CampaignState:
  allocateArmyId()
  local id =
    'army_' .. self.nextArmyId

  self.nextArmyId =
    self.nextArmyId + 1

  return id
end


function CampaignState:
  allocateSquadId()
  local id =
    'campaign_squad_' ..
    self.nextSquadId

  self.nextSquadId =
    self.nextSquadId + 1

  return id
end


function CampaignState:
  allocateBattleId()
  local id =
    'campaign_battle_' ..
    self.nextBattleId

  self.nextBattleId =
    self.nextBattleId + 1

  return id
end


function CampaignState:addArmy(army)
  assert(
    not self.armiesById[army.id],
    'Duplicate army: ' .. army.id
  )

  self.armies[
    #self.armies + 1
  ] = army

  self.armiesById[
    army.id
  ] = army
end


function CampaignState:
  removeArmy(armyId)
  local army =
    self.armiesById[armyId]

  if not army then
    return false
  end

  self.armiesById[armyId] = nil

  for index =
    #self.armies,
    1,
    -1
  do
    if
      self.armies[index].id ==
      armyId
    then
      table.remove(
        self.armies,
        index
      )

      break
    end
  end

  for index =
    #self.journeys,
    1,
    -1
  do
    if
      self.journeys[index]
        .armyId == armyId
    then
      table.remove(
        self.journeys,
        index
      )
    end
  end

  return true
end


function CampaignState:
  changeCityOwner(
    cityId,
    participantId
  )
  local city =
    self:getCity(cityId)

  self:getParticipant(
    participantId
  )

  city.owner = participantId
  city.productionQueue = {}

  self:addLog(
    cityId ..
    ' is now controlled by ' ..
    participantId .. '.'
  )
end


function CampaignState:
  addLog(message)
  self.eventLog[
    #self.eventLog + 1
  ] = {
    day = self.day,
    message = message
  }
end


function CampaignState:
  isVictory()
  local player =
    self:getPlayerParticipant()

  for _, cityId in ipairs(
    self.definition.objectives
      .cities or {}
  ) do
    local city =
      self:getCity(cityId)

    if
      not self:isAllied(
        player.id,
        city.owner
      )
    then
      return false
    end
  end

  return true
end


function CampaignState:
  isDefeat()
  local capitalId =
    self.definition.defeat
    and self.definition.defeat
      .capital

  if not capitalId then
    return false
  end

  local capital =
    self:getCity(capitalId)

  return
    capital.owner ~=
    self:getPlayerParticipant().id
end


function CampaignState.fromData(
  definition,
  data
)
  local self =
    setmetatable(
      {},
      CampaignState
    )

  self.definition = definition

  self.day = data.day or 1
  self.gold = data.gold or 0

  self.participants =
    data.participants or {}

  self.participantsById = {}

  for _, participant in ipairs(
    self.participants
  ) do
    self.participantsById[
      participant.id
    ] = participant
  end

  self.cities = data.cities or {}
  self.citiesById = {}

  for _, city in ipairs(
    self.cities
  ) do
    city.productionQueue =
      city.productionQueue or {}

    self.citiesById[
      city.id
    ] = city
  end

  self.armies = data.armies or {}
  self.armiesById = {}

  for _, army in ipairs(
    self.armies
  ) do
    self.armiesById[
      army.id
    ] = army
  end

  self.journeys =
    data.journeys or {}

  self.announcedSieges =
    data.announcedSieges or {}

  self.eventLog =
    data.eventLog or {}

  self.directorState =
    data.directorState
    or {
      dangerousEventCooldown = 0,
      protectedArmies = {}
    }

  self.directorState
    .protectedArmies =
    self.directorState
      .protectedArmies or {}

  self.nextArmyId =
    data.nextArmyId or 1

  self.nextSquadId =
    data.nextSquadId or 1

  self.nextBattleId =
    data.nextBattleId or 1

  self.nextProductionId =
    data.nextProductionId or 1

  self.nextGeneratedArmyId =
    data.nextGeneratedArmyId or 1

  self.nextScenarioId =
    data.nextScenarioId or 1

  self.pendingBattles = {}
  self.activeBattleScenario = nil

  self.notifications = {}
  self.activeNotification = nil

  self.turnState = nil

  return self
end

return CampaignState