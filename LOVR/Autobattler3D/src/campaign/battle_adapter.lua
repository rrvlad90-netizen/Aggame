local BattleAdapter = {}
BattleAdapter.__index = BattleAdapter


local function copyTable(source)
  if type(source) ~= 'table' then
    return source
  end

  local result = {}

  for key, value in pairs(source) do
    result[copyTable(key)] =
      copyTable(value)
  end

  return result
end


function BattleAdapter.new(
  state,
  mapRegistry,
  sideRegistry
)
  local self =
    setmetatable(
      {},
      BattleAdapter
    )

  self.state = state
  self.mapRegistry = mapRegistry
  self.sideRegistry = sideRegistry

  return self
end


function BattleAdapter:
  getArmySide(army)
  if army.side then
    return army.side
  end

  return
    self.state:
      getParticipant(
        army.owner
      ).side
end


function BattleAdapter:
  chooseMapId(kind)
  local pools =
    self.state.definition
      .battleMaps

  local pool =
    pools[kind]
    or pools.road

  assert(
    pool and #pool > 0,
    'No campaign battle maps: ' ..
    tostring(kind)
  )

  return
    pool[
      math.random(1, #pool)
    ]
end


function BattleAdapter:
  createGroups(
    army,
    positions
  )
  assert(
    #army.squads <= #positions,
    'Not enough campaign deployment positions'
  )

  local groups = {}

  for index, squad in ipairs(
    army.squads
  ) do
    local position =
      positions[index]

    groups[
      #groups + 1
    ] = {
      campaignSquadId =
        squad.id,

      slot = squad.slot,
      count = squad.count,

      x = position.x,
      z = position.z,

      defaultRoute =
        position.route
    }
  end

  return groups
end


function BattleAdapter:
  createRuntimeMap(
    mapId,
    playerArmy,
    enemyArmy
  )
  local source =
    self.mapRegistry:get(mapId)

  local map = copyTable(source)

  local deployment =
    map.campaignDeployment

  if not deployment then
    local deployments =
      self.state.definition
        .deployments or {}

    deployment =
      deployments[mapId]
  end

  deployment =
    assert(
      deployment,
      'Battle map has no campaign deployment: ' ..
      mapId
    )

  local playerGroups =
    self:createGroups(
      playerArmy,
      deployment.player
    )

  local enemyGroups =
    self:createGroups(
      enemyArmy,
      deployment.enemy
    )

  assert(
    playerGroups[1]
    and enemyGroups[1],
    'Campaign battle has an empty army'
  )

  map.id =
    map.id .. '_campaign'

  map.victoryCondition =
    'elimination'

  map.enemyAI = nil
  map.enemyScript = nil
  map.economy = nil

  map.buildings = nil
  map.capturePoints = nil

  map.squads = {
    player = {
      slot =
        playerGroups[1].slot,

      groups = playerGroups
    },

    enemy = {
      slot =
        enemyGroups[1].slot,

      groups = enemyGroups
    }
  }

  return map
end


function BattleAdapter:createRequest(
  kind,
  playerArmy,
  enemyArmy,
  context
)
  local mapId =
    self:chooseMapId(kind)

  local map =
    self:createRuntimeMap(
      mapId,
      playerArmy,
      enemyArmy
    )

  local playerSide =
    self:getArmySide(playerArmy)

  local enemySide =
    self:getArmySide(enemyArmy)

  local playerFirst =
    playerArmy.squads[1]

  local enemyFirst =
    enemyArmy.squads[1]

  local request = {
    id =
      self.state:
        allocateBattleId(),

    kind = kind,
    context = context or {},

    mapId = mapId,
    map = map,

    playerArmyId =
      playerArmy.id,

    enemyArmyId =
      enemyArmy.id,

    enemyGenerated =
      enemyArmy.generated == true,

    playerSide = playerSide,
    enemySide = enemySide,

    playerUnitDefinition =
      self.sideRegistry:
        resolveUnit(
          playerSide,
          playerFirst.slot
        ),

    enemyUnitDefinition =
      self.sideRegistry:
        resolveUnit(
          enemySide,
          enemyFirst.slot
        ),

    playerArmy = playerArmy,
    enemyArmy = enemyArmy
  }

  return request
end


function BattleAdapter:
  createBattleOptions(request)
  return {
    map = request.map,

    playerSide =
      request.playerSide,

    enemySide =
      request.enemySide,

    playerUnitDefinition =
      request.playerUnitDefinition,

    enemyUnitDefinition =
      request.enemyUnitDefinition,

    sideRegistry =
      self.sideRegistry,

    campaignBattleId =
      request.id
  }
end


function BattleAdapter:
  collectTeamSurvivors(
    battle,
    team
  )
  local survivors = {}

  for _, squad in ipairs(
    battle.squads
  ) do
    if
      squad.team == team
      and squad.campaignSquadId
      and not squad:isDefeated()
    then
      survivors[
        #survivors + 1
      ] = {
        squadId =
          squad.campaignSquadId,

        count =
          squad.activeCount
      }
    end
  end

  return survivors
end


function BattleAdapter:
  collectResult(
    request,
    battle
  )
  local winner

  if battle.winner == 'allies' then
    winner = 'player'
  elseif
    battle.winner == 'enemies'
  then
    winner = 'enemy'
  else
    winner = 'draw'
  end

  return {
    battleId = request.id,
    winner = winner,

    playerArmyId =
      request.playerArmyId,

    enemyArmyId =
      request.enemyArmyId,

    playerSurvivors =
      self:collectTeamSurvivors(
        battle,
        'allies'
      ),

    enemySurvivors =
      self:collectTeamSurvivors(
        battle,
        'enemies'
      ),

    context = request.context
  }
end


return BattleAdapter