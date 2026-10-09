local TurnProcessor = {}
TurnProcessor.__index = TurnProcessor


function TurnProcessor.new(settings)
  local self =
    setmetatable(
      {},
      TurnProcessor
    )

  self.state = settings.state

  self.productionSystem =
    settings.productionSystem

  self.journeySystem =
    settings.journeySystem

  self.director =
    settings.director

  self.battleManager =
    settings.battleManager

  self.state.notifications =
    self.state.notifications or {}

  self.state.activeNotification =
    self.state.activeNotification
    or nil

  return self
end


function TurnProcessor:
  queueNotification(
    kind,
    message,
    data
  )
  self.state.notifications[
    #self.state.notifications + 1
  ] = {
    kind = kind,
    message = message,
    data = data or {}
  }
end


function TurnProcessor:
  activateNextNotification()
  if self.state.activeNotification then
    return
  end

  if #self.state.notifications == 0 then
    return
  end

  self.state.activeNotification =
    table.remove(
      self.state.notifications,
      1
    )
end


function TurnProcessor:
  acknowledgeNotification()
  if
    not self.state.activeNotification
  then
    return false
  end

  self.state.activeNotification = nil

  self:activateNextNotification()

  return true
end


function TurnProcessor:
  beginEndTurn()
  if self.state.turnState then
    return false
  end

  self.state.day =
    self.state.day + 1

  self.state.turnState = {
    phase = 'production',

    journeyEvents = nil,
    journeyEventIndex = 1,

    directorEvents = nil,
    directorEventIndex = 1
  }

  self.state:addLog(
    'Day ' ..
    self.state.day ..
    ' started.'
  )

  return true
end


function TurnProcessor:
  processProduction(turn)
  local completed =
    self.productionSystem:
      advanceDay()

  for _, order in ipairs(
    completed
  ) do
    self:queueNotification(
      'production_completed',

      'Production completed: ' ..
      (
        order.slot
        or 'city upgrade'
      ),

      {
        orderId = order.id,
        orderType = order.type
      }
    )
  end

  turn.phase = 'journeys'
end


function TurnProcessor:
  prepareJourneyEvents(turn)
  turn.journeyEvents =
    self.journeySystem:
      advanceDay()

  turn.journeyEventIndex = 1
  turn.phase = 'journey_events'
end


function TurnProcessor:
  processJourneyEvent(event)
  if event.type == 'returned' then
    self:queueNotification(
      'army_returned',

      'Army returned to ' ..
      event.cityId .. '.',

      event
    )

    return
  end

  if event.type ~= 'arrival' then
    return
  end

  if event.hostile then
    self.battleManager:
      queueCityAttack(
        event.armyId,
        event.cityId
      )

    return
  end

  self.journeySystem:
    completeArrival(
      event.armyId,
      event.cityId
    )

  self:queueNotification(
    'army_arrived',

    'Army arrived at ' ..
    event.cityId .. '.',

    event
  )
end


function TurnProcessor:
  processJourneyEvents(turn)
  local events =
    turn.journeyEvents or {}

  local event =
    events[
      turn.journeyEventIndex
    ]

  if not event then
    turn.phase = 'director'
    return
  end

  turn.journeyEventIndex =
    turn.journeyEventIndex + 1

  self:processJourneyEvent(event)
end


function TurnProcessor:
  prepareDirectorEvents(turn)
  turn.directorEvents =
    self.director:advanceDay()

  turn.directorEventIndex = 1
  turn.phase = 'director_events'
end


function TurnProcessor:
  processDirectorEvent(event)
  if event.type == 'battle' then
    self.battleManager:
      queueTravelEncounter(event)

    return
  end

  if
    event.type ==
    'siege_announced'
  then
    self:queueNotification(
      'siege_announced',

      'Enemy siege announced against ' ..
      event.cityId ..
      '. Arrival in ' ..
      event.remainingDays ..
      ' days.',

      event
    )

    return
  end

  if event.type == 'siege' then
    self.battleManager:
      queueSiege(
        event.cityId,
        event.participant
      )
  end
end


function TurnProcessor:
  processDirectorEvents(turn)
  local events =
    turn.directorEvents or {}

  local event =
    events[
      turn.directorEventIndex
    ]

  if not event then
    turn.phase = 'income'
    return
  end

  turn.directorEventIndex =
    turn.directorEventIndex + 1

  self:processDirectorEvent(event)
end


function TurnProcessor:
  processIncome(turn)
  local player =
    self.state:
      getPlayerParticipant()

  local income = 0

  for _, city in ipairs(
    self.state.cities
  ) do
    if city.owner == player.id then
      local definition =
        self.state:
          getCityDefinition(
            city.id
          )

      local level =
        definition.levels[
          city.level
        ]

      income =
        income +
        (level.income or 0)
    end
  end

  local difficulty =
    self.state.definition
      .director.difficulty
    or {}

  income =
    math.floor(
      income *
      (
        difficulty
          .incomeMultiplier
        or 1
      )
    )

  self.state.gold =
    self.state.gold + income

  self.state:addLog(
    'Daily income: ' ..
    income .. ' gold.'
  )

  self:queueNotification(
    'income',

    'Received ' ..
    income .. ' gold.',

    {
      amount = income
    }
  )

  turn.phase = 'outcome'
end


function TurnProcessor:
  processOutcome(turn)
  if self.state:isDefeat() then
    turn.phase = 'defeat'
    return
  end

  if self.state:isVictory() then
    turn.phase = 'victory'
    return
  end

  turn.phase = 'complete'
end


function TurnProcessor:continue()
  self:activateNextNotification()

  if self.state.activeNotification then
    return {
      status = 'notification',

      notification =
        self.state
          .activeNotification
    }
  end

  local activeBattle =
    self.battleManager:getActive()

  if activeBattle then
    return {
      status = 'battle',
      battle = activeBattle
    }
  end

  local turn =
    self.state.turnState

  if not turn then
    return {
      status = 'idle'
    }
  end

  while true do
    if turn.phase == 'production' then
      self:processProduction(turn)

    elseif turn.phase == 'journeys' then
      self:prepareJourneyEvents(
        turn
      )

    elseif
      turn.phase ==
      'journey_events'
    then
      self:processJourneyEvents(
        turn
      )

    elseif turn.phase == 'director' then
      self:prepareDirectorEvents(
        turn
      )

    elseif
      turn.phase ==
      'director_events'
    then
      self:processDirectorEvents(
        turn
      )

    elseif turn.phase == 'income' then
      self:processIncome(turn)

    elseif turn.phase == 'outcome' then
      self:processOutcome(turn)

    elseif turn.phase == 'victory' then
      return {
        status = 'victory'
      }

    elseif turn.phase == 'defeat' then
      return {
        status = 'defeat'
      }

    elseif turn.phase == 'complete' then
      self.state.turnState = nil

      return {
        status = 'turn_complete'
      }
    end

    self:activateNextNotification()

    if self.state.activeNotification then
      return {
        status = 'notification',

        notification =
          self.state
            .activeNotification
      }
    end

    activeBattle =
      self.battleManager:getActive()

    if activeBattle then
      return {
        status = 'battle',
        battle = activeBattle
      }
    end
  end
end


return TurnProcessor