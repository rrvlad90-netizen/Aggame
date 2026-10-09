local ProductionSystem = {}
ProductionSystem.__index =
  ProductionSystem


function ProductionSystem.new(
  state,
  armySystem
)
  local self =
    setmetatable(
      {},
      ProductionSystem
    )

  self.state = state
  self.armySystem = armySystem

  self.state.nextProductionId =
    self.state.nextProductionId or 1

  return self
end


function ProductionSystem:
  allocateOrderId()
  local id =
    'production_' ..
    self.state.nextProductionId

  self.state.nextProductionId =
    self.state.nextProductionId + 1

  return id
end


function ProductionSystem:
  getRecruitmentProfile(cityId)
  local definition =
    self.state:
      getCityDefinition(cityId)

  local profileId =
    definition.recruitmentProfile
    or 'standard'

  local profiles =
    self.state.definition
      .recruitment.profiles

  return assert(
    profiles[profileId],
    'Unknown recruitment profile: ' ..
    tostring(profileId)
  )
end


function ProductionSystem:
  getRecruitmentOption(
    cityId,
    slot
  )
  for _, option in ipairs(
    self:getRecruitmentProfile(
      cityId
    )
  ) do
    if option.slot == slot then
      return option
    end
  end

  return nil
end


function ProductionSystem:
  spendGold(amount)
  amount = amount or 0

  if self.state.gold < amount then
    return false
  end

  self.state.gold =
    self.state.gold - amount

  return true
end


function ProductionSystem:
  countReservedArmies(ownerId)
  local count = 0

  for _, city in ipairs(
    self.state.cities
  ) do
    for _, order in ipairs(
      city.productionQueue
    ) do
      if
        order.type == 'recruit'
        and order.mode ==
          'new_army'
        and order.owner ==
          ownerId
      then
        count = count + 1
      end
    end
  end

  return count
end


function ProductionSystem:
  hasQueuedSquadOrder(
    armyId,
    slot
  )
  for _, city in ipairs(
    self.state.cities
  ) do
    for _, order in ipairs(
      city.productionQueue
    ) do
      if
        order.type == 'recruit'
        and order.armyId ==
          armyId
        and order.slot == slot
      then
        return true
      end
    end
  end

  return false
end


function ProductionSystem:
  queueUpgrade(cityId)
  local city =
    self.state:getCity(cityId)

  local definition =
    self.state:
      getCityDefinition(cityId)

  local player =
    self.state:
      getPlayerParticipant()

  if city.owner ~= player.id then
    return false
  end

  if
    definition.nativeParticipant ~=
    city.owner
  then
    return false
  end

  local levelDefinition =
    definition.levels[city.level]

  if
    not levelDefinition
    or not levelDefinition
      .upgradeCost
    or city.level >=
      #definition.levels
  then
    return false
  end

  for _, order in ipairs(
    city.productionQueue
  ) do
    if order.type == 'upgrade' then
      return false
    end
  end

  local cost =
    levelDefinition.upgradeCost

  if not self:spendGold(cost) then
    return false
  end

  city.productionQueue[
    #city.productionQueue + 1
  ] = {
    id = self:allocateOrderId(),
    type = 'upgrade',

    targetLevel =
      city.level + 1,

    remainingTurns =
      levelDefinition
        .upgradeTurns or 1,

    cost = cost
  }

  self.state:addLog(
    'Upgrade queued in ' ..
    cityId .. '.'
  )

  return true
end


function ProductionSystem:
  canQueueNewArmy(ownerId)
  local maximum =
    self.state.definition
      .maximumArmies or 10

  return
    self.armySystem:
      countArmies(ownerId)
    +
    self:countReservedArmies(
      ownerId
    )
    < maximum
end


function ProductionSystem:
  queueRecruit(
    cityId,
    ownerId,
    slot,
    armyId
  )
  local city =
    self.state:getCity(cityId)

  if
    not self.state:isAllied(
      ownerId,
      city.owner
    )
  then
    return false
  end

  local option =
    self:getRecruitmentOption(
      cityId,
      slot
    )

  if
    not option
    or city.level <
      (
        option.minimumCityLevel
        or 1
      )
  then
    return false
  end

  local maximumCount =
    self.armySystem:
      getMaximumSquadCount(
        ownerId,
        slot
      )

  if not maximumCount then
    return false
  end

  local mode
  local targetSquadId = nil

  if armyId then
    local army =
      self.state:getArmy(armyId)

    if
      army.owner ~= ownerId
      or army.cityId ~= cityId
      or army.journeyId
      or self:
        hasQueuedSquadOrder(
          armyId,
          slot
        )
    then
      return false
    end

    local existing =
      self.armySystem:
        findSquadBySlot(
          army,
          slot
        )

    if existing then
      if
        existing.count >=
        existing.maximumCount
      then
        return false
      end

      mode = 'replenish'
      targetSquadId =
        existing.id
    else
      if
        not self.armySystem:
          canAddSquad(
            army,
            slot
          )
      then
        return false
      end

      mode = 'add_squad'
    end
  else
    if
      not self:
        canQueueNewArmy(
          ownerId
        )
    then
      return false
    end

    mode = 'new_army'
  end

  local cost = option.cost or 0

  if not self:spendGold(cost) then
    return false
  end

  city.productionQueue[
    #city.productionQueue + 1
  ] = {
    id = self:allocateOrderId(),
    type = 'recruit',

    mode = mode,
    owner = ownerId,

    armyId = armyId,
    squadId = targetSquadId,

    slot = slot,

    remainingTurns =
      option.turns or 1,

    cost = cost
  }

  self.state:addLog(
    'Recruitment queued in ' ..
    cityId .. ': ' .. slot .. '.'
  )

  return true
end


function ProductionSystem:
  completeRecruitment(
    city,
    order
  )
  if order.mode == 'new_army' then
    local army =
      self.armySystem:createArmy(
        order.owner,
        city.id,
        order.slot
      )

    return army ~= nil
  end

  local army =
    self.state.armiesById[
      order.armyId
    ]

  if
    not army
    or army.cityId ~= city.id
  then
    return false
  end

  if order.mode == 'add_squad' then
    return
      self.armySystem:addSquad(
        army,
        order.slot
      ) ~= nil
  end

  if order.mode == 'replenish' then
    return
      self.armySystem:
        replenishSquad(
          army,
          order.squadId
        )
  end

  return false
end


function ProductionSystem:
  completeOrder(
    city,
    order
  )
  if order.type == 'upgrade' then
    local definition =
      self.state:
        getCityDefinition(
          city.id
        )

    city.level =
      math.min(
        order.targetLevel,
        #definition.levels
      )

    self.state:addLog(
      city.id ..
      ' reached level ' ..
      city.level .. '.'
    )

    return true
  end

  if order.type == 'recruit' then
    local completed =
      self:completeRecruitment(
        city,
        order
      )

    if completed then
      self.state:addLog(
        'Recruitment completed in ' ..
        city.id .. ': ' ..
        order.slot .. '.'
      )
    else
      self.state:addLog(
        'Recruitment failed in ' ..
        city.id .. ': ' ..
        order.slot .. '.'
      )
    end

    return completed
  end

  return false
end


function ProductionSystem:advanceDay()
  local completed = {}

  for _, city in ipairs(
    self.state.cities
  ) do
    local order =
      city.productionQueue[1]

    if order then
      order.remainingTurns =
        order.remainingTurns - 1

      if order.remainingTurns <= 0 then
        table.remove(
          city.productionQueue,
          1
        )

        self:completeOrder(
          city,
          order
        )

        completed[
          #completed + 1
        ] = order
      end
    end
  end

  return completed
end


return ProductionSystem