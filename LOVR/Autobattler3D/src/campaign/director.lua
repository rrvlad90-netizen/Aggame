local Director = {}
Director.__index = Director


function Director.new(
  state,
  autoBattle
)
  local self =
    setmetatable(
      {},
      Director
    )

  self.state = state
  self.autoBattle = autoBattle
  self.config =
    state.definition.director or {}

  self.state.nextGeneratedArmyId =
    self.state.nextGeneratedArmyId
    or 1

  return self
end


function Director:
  allocateGeneratedArmyId()
  local id =
    'generated_army_' ..
    self.state.nextGeneratedArmyId

  self.state.nextGeneratedArmyId =
    self.state.nextGeneratedArmyId + 1

  return id
end


function Director:
  getArmyPower(army)
  local total = 0

  for _, squad in ipairs(
    army.squads or {}
  ) do
    local settings =
      self.autoBattle:
        getSlotSettings(
          squad.slot
        )

    total =
      total +
      squad.count *
      settings.campaignPower
  end

  return total
end


function Director:
  getTemplatePower(template)
  return
    self:getArmyPower({
      squads = template.squads
    })
end


function Director:
  findParticipantBySide(sideId)
  for _, participant in ipairs(
    self.state.participants
  ) do
    if participant.side == sideId then
      return participant
    end
  end

  return nil
end


function Director:
  chooseTemplate(
    category,
    desiredPower
  )
  local selected = nil
  local selectedDifference = nil

  for _, template in ipairs(
    self.config.armyTemplates
    or {}
  ) do
    if
      template.category == category
      and self.state.day >=
        (
          template.minimumDay
          or 1
        )
    then
      local power =
        self:getTemplatePower(
          template
        )

      local difference =
        math.abs(
          power - desiredPower
        )

      if
        not selectedDifference
        or difference <
          selectedDifference
      then
        selected = template
        selectedDifference =
          difference
      end
    end
  end

  return selected
end


function Director:
  createGeneratedArmy(
    template
  )
  if not template then
    return nil
  end

  local participant =
    self:findParticipantBySide(
      template.side
    )

  local army = {
    id =
      self:
        allocateGeneratedArmyId(),

    name = template.id,

    generated = true,

    owner =
      participant
      and participant.id
      or nil,

    side = template.side,
    squads = {}
  }

  for _, settings in ipairs(
    template.squads
  ) do
    army.squads[
      #army.squads + 1
    ] = {
      id =
        self.state:
          allocateSquadId(),

      slot = settings.slot,
      count = settings.count,

      maximumCount =
        settings.count
    }
  end

  return army
end


function Director:
  getPowerRange(kind)
  local ranges =
    self.config.powerRanges
    or {}

  return
    ranges[kind]
    or {
      minimum = 1,
      maximum = 1
    }
end


function Director:
  getDesiredPower(
    kind,
    targetArmy
  )
  local range =
    self:getPowerRange(kind)

  local multiplier =
    range.minimum +
    math.random() *
    (
      range.maximum -
      range.minimum
    )

  local difficulty =
    self.config.difficulty
    or {}

  multiplier =
    multiplier *
    (
      difficulty
        .enemyPowerMultiplier
      or 1
    )

  return
    self:getArmyPower(
      targetArmy
    ) * multiplier
end


function Director:
  createArmyForTarget(
    templateCategory,
    powerKind,
    targetArmy
  )
  local desiredPower =
    self:getDesiredPower(
      powerKind,
      targetArmy
    )

  local template =
    self:chooseTemplate(
      templateCategory,
      desiredPower
    )

  return
    self:createGeneratedArmy(
      template
    )
end


function Director:
  createCityDefense(
    cityId,
    attackingArmy
  )
  local city =
    self.state:getCity(cityId)

  local owner = nil

  if city.owner then
    owner =
      self.state:
        getParticipant(
          city.owner
        )
  end

  local desiredPower =
    self:getDesiredPower(
      'cityDefense',
      attackingArmy
    )

  local category =
    owner
    and 'cityDefense'
    or 'neutral_ambush'

  local requiredSide =
    owner
    and owner.side
    or self.state.definition
      .neutralSide

  local selected = nil
  local selectedDifference = nil

  for _, template in ipairs(
    self.config.armyTemplates
    or {}
  ) do
    if
      template.category == category
      and template.side ==
        requiredSide
      and self.state.day >=
        (
          template.minimumDay
          or 1
        )
    then
      local difference =
        math.abs(
          self:getTemplatePower(
            template
          ) - desiredPower
        )

      if
        not selectedDifference
        or difference <
          selectedDifference
      then
        selected = template
        selectedDifference =
          difference
      end
    end
  end

  return
    self:createGeneratedArmy(
      selected
    )
end


function Director:
  updateCooldowns()
  local directorState =
    self.state.directorState

  directorState
    .dangerousEventCooldown =
    math.max(
      0,

      (
        directorState
          .dangerousEventCooldown
        or 0
      ) - 1
    )

  for armyId, days in pairs(
    directorState.protectedArmies
  ) do
    days = days - 1

    if days <= 0 then
      directorState
        .protectedArmies[
          armyId
        ] = nil
    else
      directorState
        .protectedArmies[
          armyId
        ] = days
    end
  end
end


function Director:
  getAvailableTravelingArmies()
  local result = {}

  local protected =
    self.state.directorState
      .protectedArmies

  for _, journey in ipairs(
    self.state.journeys
  ) do
    local army =
      self.state.armiesById[
        journey.armyId
      ]

    if
      army
      and not journey.returning
      and not journey.arrived
      and not protected[army.id]
    then
      result[
        #result + 1
      ] = army
    end
  end

  return result
end


function Director:
  isSiegeAnnounced(cityId)
  for _, siege in ipairs(
    self.state.announcedSieges
  ) do
    if siege.cityId == cityId then
      return true
    end
  end

  return false
end


function Director:
  chooseRandomEvent()
  local candidates = {}
  local totalWeight = 0

  local traveling =
    self:getAvailableTravelingArmies()

  for _, event in ipairs(
    self.config.events or {}
  ) do
    if
      self.state.day >=
      (event.minimumDay or 1)
    then
      local available = true

      if
        (
          event.type ==
            'neutral_ambush'
          or event.type ==
            'interception'
        )
        and #traveling == 0
      then
        available = false
      end

      if event.type == 'siege' then
        local city =
          self.state:getCity(
            event.targetCity
          )

        local player =
          self.state:
            getPlayerParticipant()

        available =
          self.state:isAllied(
            player.id,
            city.owner
          )
          and not self:
            isSiegeAnnounced(
              city.id
            )
      end

      if available then
        local weight =
          event.weight or 1

        totalWeight =
          totalWeight + weight

        candidates[
          #candidates + 1
        ] = {
          event = event,
          maximum = totalWeight
        }
      end
    end
  end

  if totalWeight <= 0 then
    return nil
  end

  local roll =
    math.random() * totalWeight

  for _, candidate in ipairs(
    candidates
  ) do
    if roll <= candidate.maximum then
      return candidate.event
    end
  end

  return
    candidates[#candidates].event
end


function Director:
  protectArmy(armyId)
  self.state.directorState
    .protectedArmies[armyId] =
    self.config.armyProtectionDays
    or 3
end


function Director:
  startDangerousCooldown()
  self.state.directorState
    .dangerousEventCooldown =
    self.config
      .dangerousEventCooldown
    or 3
end


function Director:
  triggerTravelEvent(event)
  local armies =
    self:getAvailableTravelingArmies()

  if #armies == 0 then
    return nil
  end

  local army =
    armies[
      math.random(1, #armies)
    ]

  local category
  local powerKind

  if
    event.type ==
    'neutral_ambush'
  then
    category = 'neutral_ambush'
    powerKind = 'neutralAmbush'
  else
    category = 'interception'
    powerKind = 'interception'
  end

  local enemyArmy =
    self:createArmyForTarget(
      category,
      powerKind,
      army
    )

  if not enemyArmy then
    return nil
  end

  self:protectArmy(army.id)
  self:startDangerousCooldown()

  self.state:addLog(
    'An enemy force intercepted ' ..
    army.name .. '.'
  )

  return {
    type = 'battle',
    kind = event.type,

    playerArmyId = army.id,
    enemyArmy = enemyArmy,

    playerIsAttacker = false
  }
end


function Director:
  announceSiege(event)
  local siege = {
    cityId = event.targetCity,

    participant =
      event.participant,

    remainingDays =
      self.config.siegeWarningDays
      or 2
  }

  self.state.announcedSieges[
    #self.state.announcedSieges + 1
  ] = siege

  self:startDangerousCooldown()

  self.state:addLog(
    'Enemy siege announced against ' ..
    siege.cityId .. '.'
  )

  return {
    type = 'siege_announced',
    cityId = siege.cityId,

    remainingDays =
      siege.remainingDays
  }
end


function Director:
  advanceSieges()
  local events = {}

  for index =
    #self.state.announcedSieges,
    1,
    -1
  do
    local siege =
      self.state.announcedSieges[
        index
      ]

    siege.remainingDays =
      siege.remainingDays - 1

    if siege.remainingDays <= 0 then
      table.remove(
        self.state.announcedSieges,
        index
      )

      events[
        #events + 1
      ] = {
        type = 'siege',
        cityId = siege.cityId,

        participant =
          siege.participant
      }
    end
  end

  return events
end


function Director:advanceDay()
  self:updateCooldowns()

  local events =
    self:advanceSieges()

  if #events > 0 then
    return events
  end

  if
    self.state.directorState
      .dangerousEventCooldown > 0
  then
    return events
  end

  local difficulty =
    self.config.difficulty
    or {}

  local chance =
    (
      self.config.eventChance
      or .35
    )
    *
    (
      difficulty
        .eventFrequencyMultiplier
      or 1
    )

  if math.random() > chance then
    return events
  end

  local event =
    self:chooseRandomEvent()

  if not event then
    return events
  end

  local result

  if
    event.type ==
      'neutral_ambush'
    or event.type ==
      'interception'
  then
    result =
      self:triggerTravelEvent(
        event
      )

  elseif event.type == 'siege' then
    result =
      self:announceSiege(
        event
      )
  end

  if result then
    events[
      #events + 1
    ] = result
  end

  return events
end


return Director