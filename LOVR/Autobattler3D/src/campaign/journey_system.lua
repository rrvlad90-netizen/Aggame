local JourneySystem = {}
JourneySystem.__index = JourneySystem


function JourneySystem.new(
  state,
  pathfinder
)
  local self =
    setmetatable(
      {},
      JourneySystem
    )

  self.state = state
  self.pathfinder = pathfinder

  return self
end


function JourneySystem:
  getJourneyByArmy(armyId)
  for _, journey in ipairs(
    self.state.journeys
  ) do
    if journey.armyId == armyId then
      return journey
    end
  end

  return nil
end


function JourneySystem:
  hasPendingProduction(armyId)
  for _, city in ipairs(
    self.state.cities
  ) do
    for _, order in ipairs(
      city.productionQueue
    ) do
      if
        order.armyId == armyId
      then
        return true
      end
    end
  end

  return false
end


function JourneySystem:
  startJourney(
    armyId,
    targetCityId
  )
  local army =
    self.state:getArmy(armyId)

  if
    army.journeyId
    or not army.cityId
    or self:hasPendingProduction(
      armyId
    )
  then
    return nil
  end

  local path =
    self.pathfinder:findPath(
      army.owner,
      army.cityId,
      targetCityId
    )

  if
    not path
    or #path.segments == 0
  then
    return nil
  end

  local journey = {
    id = 'journey_' .. army.id,
    armyId = army.id,

    originCityId = army.cityId,
    targetCityId = targetCityId,

    path = path,

    segmentIndex = 1,
    segmentProgress = 0,

    elapsedDays = 0,
    remainingDays =
      path.totalDays,

    returning = false,
    returnCityId = nil,

    arrived = false,
    arrivalReported = false
  }

  army.cityId = nil
  army.journeyId = journey.id

  self.state.journeys[
    #self.state.journeys + 1
  ] = journey

  self.state:addLog(
    army.name ..
    ' departed for ' ..
    targetCityId ..
    '.'
  )

  return journey
end


function JourneySystem:
  removeJourney(journey)
  for index =
    #self.state.journeys,
    1,
    -1
  do
    if
      self.state.journeys[index]
      == journey
    then
      table.remove(
        self.state.journeys,
        index
      )

      return
    end
  end
end


function JourneySystem:
  finishAtCity(
    journey,
    cityId
  )
  local army =
    self.state.armiesById[
      journey.armyId
    ]

  if not army then
    self:removeJourney(journey)
    return
  end

  army.cityId = cityId
  army.journeyId = nil

  self:removeJourney(journey)

  self.state:addLog(
    army.name ..
    ' arrived at ' ..
    cityId ..
    '.'
  )
end


function JourneySystem:
  completeArrival(
    armyId,
    cityId
  )
  local journey =
    self:getJourneyByArmy(
      armyId
    )

  if not journey then
    return false
  end

  self:finishAtCity(
    journey,
    cityId
  )

  return true
end


function JourneySystem:
  beginReturn(armyId)
  local journey =
    self:getJourneyByArmy(
      armyId
    )

  if not journey then
    return false
  end

  local returnDays =
    journey.arrived
    and journey.path.totalDays
    or journey.elapsedDays

  journey.returning = true
  journey.arrived = false
  journey.arrivalReported = false

  journey.returnCityId =
    journey.originCityId

  journey.remainingDays =
    math.max(
      0,
      math.ceil(returnDays)
    )

  local army =
    self.state.armiesById[
      armyId
    ]

  if army then
    army.returning = true
  end

  if journey.remainingDays == 0 then
    if army then
      army.returning = false
    end

    self:finishAtCity(
      journey,
      journey.returnCityId
    )
  end

  return true
end


function JourneySystem:
  cancelJourney(armyId)
  local journey =
    self:getJourneyByArmy(
      armyId
    )

  if
    not journey
    or journey.arrived
  then
    return false
  end

  self.state:addLog(
    armyId ..
    ' is returning after cancellation.'
  )

  return
    self:beginReturn(armyId)
end


function JourneySystem:
  advanceReturningJourney(
    journey
  )
  journey.remainingDays =
    math.max(
      0,
      journey.remainingDays - 1
    )

  if journey.remainingDays > 0 then
    return nil
  end

  local army =
    self.state.armiesById[
      journey.armyId
    ]

  if army then
    army.returning = false
  end

  local cityId =
    journey.returnCityId

  self:finishAtCity(
    journey,
    cityId
  )

  return {
    type = 'returned',
    armyId = journey.armyId,
    cityId = cityId
  }
end


function JourneySystem:
  advanceOutgoingJourney(
    journey
  )
  if journey.arrived then
    return nil
  end

  local segment =
    journey.path.segments[
      journey.segmentIndex
    ]

  if not segment then
    journey.arrived = true
    return nil
  end

  journey.segmentProgress =
    journey.segmentProgress + 1

  journey.elapsedDays =
    journey.elapsedDays + 1

  journey.remainingDays =
    math.max(
      0,
      journey.remainingDays - 1
    )

  if
    journey.segmentProgress <
    segment.days
  then
    return nil
  end

  journey.segmentProgress = 0

  local reachedCityId =
    segment.to

  local isFinal =
    journey.segmentIndex ==
    #journey.path.segments

  if not isFinal then
    local army =
      self.state.armiesById[
        journey.armyId
      ]

    local city =
      self.state:getCity(
        reachedCityId
      )

    if
      not army
      or not self.state:isAllied(
        army.owner,
        city.owner
      )
    then
      journey.targetCityId =
        reachedCityId

      journey.arrived = true
      journey.remainingDays = 0
    else
      journey.segmentIndex =
        journey.segmentIndex + 1
    end
  else
    journey.arrived = true
  end

  if
    journey.arrived
    and not journey.arrivalReported
  then
    journey.arrivalReported = true

    local army =
      self.state.armiesById[
        journey.armyId
      ]

    local city =
      self.state:getCity(
        reachedCityId
      )

    return {
      type = 'arrival',
      armyId = journey.armyId,
      cityId = reachedCityId,

      hostile =
        army ~= nil
        and not self.state:
          isAllied(
            army.owner,
            city.owner
          )
    }
  end

  return nil
end


function JourneySystem:advanceDay()
  local events = {}

  for index =
    #self.state.journeys,
    1,
    -1
  do
    local journey =
      self.state.journeys[index]

    local event

    if journey.returning then
      event =
        self:
          advanceReturningJourney(
            journey
          )
    else
      event =
        self:
          advanceOutgoingJourney(
            journey
          )
    end

    if event then
      events[
        #events + 1
      ] = event
    end
  end

  return events
end


function JourneySystem:
  getRemainingDays(armyId)
  local journey =
    self:getJourneyByArmy(
      armyId
    )

  if not journey then
    return nil
  end

  return journey.remainingDays
end


return JourneySystem