local AutoBattle = {}
AutoBattle.__index = AutoBattle


function AutoBattle.new(state)
  local self =
    setmetatable(
      {},
      AutoBattle
    )

  self.state = state

  self.recruitment =
    state.definition.recruitment

  return self
end


function AutoBattle:
  getSlotSettings(slot)
  for _, profile in pairs(
    self.recruitment.profiles
  ) do
    for _, settings in ipairs(
      profile
    ) do
      if settings.slot == slot then
        return settings
      end
    end
  end

  error(
    'No campaign settings for slot: ' ..
    tostring(slot)
  )
end


function AutoBattle:
  getClassStrengths(army)
  local strengths = {}
  local total = 0

  for _, squad in ipairs(
    army.squads or {}
  ) do
    if squad.count > 0 then
      local settings =
        self:getSlotSettings(
          squad.slot
        )

      local class =
        settings.campaignClass

      local strength =
        squad.count *
        settings.campaignPower

      strengths[class] =
        (strengths[class] or 0)
        + strength

      total = total + strength
    end
  end

  return strengths, total
end


function AutoBattle:
  getEffectiveStrength(
    ownStrengths,
    enemyStrengths,
    multiplier
  )
  local enemyTotal = 0

  for _, strength in pairs(
    enemyStrengths
  ) do
    enemyTotal =
      enemyTotal + strength
  end

  local total = 0

  for class, strength in pairs(
    ownStrengths
  ) do
    local bonus = 0

    local classBonuses =
      self.recruitment
        .classBonuses[class]
      or {}

    if enemyTotal > 0 then
      for enemyClass,
        enemyStrength
      in pairs(enemyStrengths) do
        local advantage =
          classBonuses[enemyClass]
          or 0

        bonus =
          bonus +
          advantage *
          (
            enemyStrength /
            enemyTotal
          )
      end
    end

    total =
      total +
      strength * (1 + bonus)
  end

  return
    total * (multiplier or 1)
end


function AutoBattle:
  calculateStrengths(
    attacker,
    defender,
    options
  )
  options = options or {}

  local attackerClasses =
    self:getClassStrengths(
      attacker
    )

  local defenderClasses =
    self:getClassStrengths(
      defender
    )

  local attackerStrength =
    self:getEffectiveStrength(
      attackerClasses,
      defenderClasses,
      options.attackerMultiplier
        or 1
    )

  local defenderStrength =
    self:getEffectiveStrength(
      defenderClasses,
      attackerClasses,
      options.defenderMultiplier
        or 1
    )

  return
    attackerStrength,
    defenderStrength
end


function AutoBattle:
  getForecast(
    attacker,
    defender,
    options
  )
  local attackerStrength,
    defenderStrength =
    self:calculateStrengths(
      attacker,
      defender,
      options
    )

  if defenderStrength <= 0 then
    return 'overwhelming_advantage'
  end

  if attackerStrength <= 0 then
    return 'overwhelming_disadvantage'
  end

  local difference =
    (
      attackerStrength -
      defenderStrength
    ) /
    math.max(
      attackerStrength,
      defenderStrength
    )

  if difference >= .35 then
    return 'clear_advantage'
  end

  if difference >= .10 then
    return 'small_advantage'
  end

  if difference > -.10 then
    return 'equal_forces'
  end

  if difference > -.35 then
    return 'small_disadvantage'
  end

  return 'clear_disadvantage'
end


function AutoBattle:
  createSurvivors(
    army,
    lossRate
  )
  local survivors = {}

  for _, squad in ipairs(
    army.squads or {}
  ) do
    local losses =
      math.ceil(
        squad.count * lossRate
      )

    local count =
      math.max(
        0,
        squad.count - losses
      )

    if count > 0 then
      survivors[
        #survivors + 1
      ] = {
        squadId = squad.id,
        slot = squad.slot,
        count = count
      }
    end
  end

  return survivors
end


function AutoBattle:
  hasSurvivors(survivors)
  for _, squad in ipairs(
    survivors
  ) do
    if squad.count > 0 then
      return true
    end
  end

  return false
end


function AutoBattle:
  randomMultiplier()
  return
    .85 + math.random() * .30
end


function AutoBattle:resolve(
  attacker,
  defender,
  options
)
  options = options or {}

  local attackerStrength,
    defenderStrength =
    self:calculateStrengths(
      attacker,
      defender,
      options
    )

  attackerStrength =
    attackerStrength *
    self:randomMultiplier()

  defenderStrength =
    defenderStrength *
    self:randomMultiplier()

  if
    attackerStrength <= 0
    and defenderStrength <= 0
  then
    return {
      winner = 'draw',
      attackerSurvivors = {},
      defenderSurvivors = {}
    }
  end

  local winner
  local winnerArmy
  local winnerStrength
  local loserStrength

  if
    attackerStrength >
    defenderStrength
  then
    winner = 'attacker'
    winnerArmy = attacker
    winnerStrength = attackerStrength
    loserStrength = defenderStrength
  elseif
    defenderStrength >
    attackerStrength
  then
    winner = 'defender'
    winnerArmy = defender
    winnerStrength = defenderStrength
    loserStrength = attackerStrength
  else
    return {
      winner = 'draw',
      attackerSurvivors = {},
      defenderSurvivors = {}
    }
  end

  local ratio = 0

  if winnerStrength > 0 then
    ratio =
      loserStrength /
      winnerStrength
  end

  local lossRate =
    math.max(
      .10,

      math.min(
        .55,
        .10 + .45 * ratio
      )
    )

  local winnerSurvivors =
    self:createSurvivors(
      winnerArmy,
      lossRate
    )

  if not self:hasSurvivors(
    winnerSurvivors
  ) then
    return {
      winner = 'draw',
      attackerSurvivors = {},
      defenderSurvivors = {},
      winnerLossRate = lossRate
    }
  end

  if winner == 'attacker' then
    return {
      winner = 'attacker',

      attackerSurvivors =
        winnerSurvivors,

      defenderSurvivors = {},

      winnerLossRate = lossRate,

      attackerStrength =
        attackerStrength,

      defenderStrength =
        defenderStrength
    }
  end

  return {
    winner = 'defender',

    attackerSurvivors = {},

    defenderSurvivors =
      winnerSurvivors,

    winnerLossRate = lossRate,

    attackerStrength =
      attackerStrength,

    defenderStrength =
      defenderStrength
  }
end


return AutoBattle