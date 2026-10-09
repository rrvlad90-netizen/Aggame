local ArmySystem = {}
ArmySystem.__index = ArmySystem


function ArmySystem.new(
  state,
  sideRegistry
)
  local self =
    setmetatable(
      {},
      ArmySystem
    )

  self.state = state
  self.sideRegistry = sideRegistry

  return self
end


function ArmySystem:
  getParticipantSide(ownerId)
  return
    self.state:
      getParticipant(ownerId).side
end


function ArmySystem:
  getMaximumSquadCount(
    ownerId,
    slot
  )
  local sideId =
    self:getParticipantSide(
      ownerId
    )

  local definition =
    self.sideRegistry:
      resolveUnit(
        sideId,
        slot
      )

  if not definition then
    return nil
  end

  return
    definition.squadSize or 1
end


function ArmySystem:
  countArmies(ownerId)
  local count = 0

  for _, army in ipairs(
    self.state.armies
  ) do
    if army.owner == ownerId then
      count = count + 1
    end
  end

  return count
end


function ArmySystem:
  canCreateArmy(ownerId)
  return
    self:countArmies(ownerId) <
    (
      self.state.definition
        .maximumArmies or 10
    )
end


function ArmySystem:
  findSquadBySlot(
    army,
    slot
  )
  for _, squad in ipairs(
    army.squads
  ) do
    if squad.slot == slot then
      return squad
    end
  end

  return nil
end


function ArmySystem:
  canAddSquad(
    army,
    slot
  )
  if
    #army.squads >=
    (
      self.state.definition
        .maximumSquadsPerArmy
      or 10
    )
  then
    return false
  end

  if self:findSquadBySlot(
    army,
    slot
  ) then
    return false
  end

  return
    self:getMaximumSquadCount(
      army.owner,
      slot
    ) ~= nil
end


function ArmySystem:
  addSquad(
    army,
    slot,
    count
  )
  if not self:canAddSquad(
    army,
    slot
  ) then
    return nil
  end

  local maximumCount =
    self:getMaximumSquadCount(
      army.owner,
      slot
    )

  local squad = {
    id =
      self.state:
        allocateSquadId(),

    slot = slot,

    count =
      math.max(
        1,

        math.min(
          count or maximumCount,
          maximumCount
        )
      ),

    maximumCount = maximumCount
  }

  army.squads[
    #army.squads + 1
  ] = squad

  return squad
end


function ArmySystem:createArmy(
  ownerId,
  cityId,
  firstSlot,
  name
)
  if not self:canCreateArmy(
    ownerId
  ) then
    return nil
  end

  local city =
    self.state:getCity(cityId)

  if
    not self.state:isAllied(
      ownerId,
      city.owner
    )
  then
    return nil
  end

  local id =
    self.state:
      allocateArmyId()

  local army = {
    id = id,

    name =
      name
      or (
        'Army ' ..
        tostring(
          self.state.nextArmyId - 1
        )
      ),

    owner = ownerId,
    cityId = cityId,

    journey = nil,
    returning = false,

    squads = {}
  }

  self.state:addArmy(army)

  if firstSlot then
    local squad =
      self:addSquad(
        army,
        firstSlot
      )

    if not squad then
      self.state:
        removeArmy(army.id)

      return nil
    end
  end

  return army
end


function ArmySystem:
  replenishSquad(
    army,
    squadId
  )
  for _, squad in ipairs(
    army.squads
  ) do
    if squad.id == squadId then
      squad.count =
        squad.maximumCount

      return true
    end
  end

  return false
end


function ArmySystem:
  removeEmptySquads(army)
  for index =
    #army.squads,
    1,
    -1
  do
    if
      army.squads[index].count <= 0
    then
      table.remove(
        army.squads,
        index
      )
    end
  end

  if #army.squads == 0 then
    self.state:
      removeArmy(army.id)

    return false
  end

  return true
end


function ArmySystem:
  applyBattleSurvivors(
    armyId,
    survivors
  )
  local army =
    self.state.armiesById[
      armyId
    ]

  if not army then
    return false
  end

  local survivorCounts = {}

  for _, survivor in ipairs(
    survivors or {}
  ) do
    survivorCounts[
      survivor.squadId
    ] =
      math.max(
        0,
        survivor.count or 0
      )
  end

  for _, squad in ipairs(
    army.squads
  ) do
    squad.count =
      math.min(
        squad.maximumCount,

        survivorCounts[
          squad.id
        ] or 0
      )
  end

  return
    self:removeEmptySquads(
      army
    )
end


function ArmySystem:
  applyRetreatLosses(armyId)
  local army =
    self.state.armiesById[
      armyId
    ]

  if not army then
    return false
  end

  for _, squad in ipairs(
    army.squads
  ) do
    local losses =
      math.ceil(
        squad.count * .15
      )

    squad.count =
      math.max(
        0,
        squad.count - losses
      )
  end

  return
    self:removeEmptySquads(
      army
    )
end


return ArmySystem