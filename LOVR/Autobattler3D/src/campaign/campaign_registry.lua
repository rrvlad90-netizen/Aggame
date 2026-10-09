local CampaignList =
  require(
    'campaigns.world_campaign_list'
  )

local CampaignRegistry = {}
CampaignRegistry.__index =
  CampaignRegistry


function CampaignRegistry.new()
  local self =
    setmetatable(
      {},
      CampaignRegistry
    )

  self.campaigns = {}
  self.list = {}

  for _, definition in ipairs(
    CampaignList
  ) do
    self:register(definition)
  end

  return self
end


function CampaignRegistry:register(
  definition
)
  assert(
    type(definition.id) == 'string',
    'Campaign has no id'
  )

  assert(
    type(definition.name) == 'string',
    'Campaign has no name: ' ..
    definition.id
  )

  assert(
    not self.campaigns[
      definition.id
    ],
    'Duplicate campaign id: ' ..
    definition.id
  )

  local playerCount = 0
  local participantIds = {}

  for _, participant in ipairs(
    definition.participants or {}
  ) do
    assert(
      type(participant.id) ==
        'string',
      'Campaign participant has no id'
    )

    assert(
      not participantIds[
        participant.id
      ],
      'Duplicate participant id: ' ..
      participant.id
    )

    participantIds[
      participant.id
    ] = true

    if
      participant.controller ==
        'player'
    then
      playerCount =
        playerCount + 1
    end
  end

  assert(
    playerCount == 1,
    'Campaign must have one player'
  )

  local cityIds = {}

  for _, city in ipairs(
    definition.cities or {}
  ) do
    assert(
      type(city.id) == 'string',
      'Campaign city has no id'
    )

    assert(
      not cityIds[city.id],
      'Duplicate city id: ' ..
      city.id
    )

    cityIds[city.id] = true
  end

  self.campaigns[
    definition.id
  ] = definition

  self.list[
    #self.list + 1
  ] = definition
end


function CampaignRegistry:get(id)
  return assert(
    self.campaigns[id],
    'Unknown campaign: ' ..
    tostring(id)
  )
end


function CampaignRegistry:getAll()
  return self.list
end


function CampaignRegistry:getDefault()
  return assert(
    self.list[1],
    'No campaigns registered'
  )
end


return CampaignRegistry