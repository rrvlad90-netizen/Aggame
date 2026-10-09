local CampaignSave = {}
CampaignSave.__index = CampaignSave


local function serializeValue(
  value,
  indentation,
  visited
)
  local valueType = type(value)

  if valueType == 'nil' then
    return 'nil'
  end

  if
    valueType == 'number'
    or valueType == 'boolean'
  then
    return tostring(value)
  end

  if valueType == 'string' then
    return string.format(
      '%q',
      value
    )
  end

  assert(
    valueType == 'table',
    'Unsupported save value: ' ..
    valueType
  )

  assert(
    not visited[value],
    'Campaign save contains a cycle'
  )

  visited[value] = true

  local nextIndentation =
    indentation .. '  '

  local parts = {
    '{\n'
  }

  for key, child in pairs(value) do
    parts[#parts + 1] =
      nextIndentation

    if
      type(key) == 'string'
      and key:match(
        '^[%a_][%w_]*$'
      )
    then
      parts[#parts + 1] =
        key .. ' = '
    else
      parts[#parts + 1] =
        '[' ..
        serializeValue(
          key,
          nextIndentation,
          visited
        ) ..
        '] = '
    end

    parts[#parts + 1] =
      serializeValue(
        child,
        nextIndentation,
        visited
      )

    parts[#parts + 1] = ',\n'
  end

  parts[#parts + 1] =
    indentation .. '}'

  visited[value] = nil

  return table.concat(parts)
end


local function serialize(value)
  return
    'return ' ..
    serializeValue(
      value,
      '',
      {}
    ) ..
    '\n'
end


function CampaignSave.new(definition)
  local self =
    setmetatable(
      {},
      CampaignSave
    )

  self.definition = definition

  local settings =
    definition.autoSave or {}

  self.enabled =
    settings.enabled ~= false

  self.file =
    settings.file
    or (
      'campaign_' ..
      definition.id ..
      '.lua'
    )

  return self
end


function CampaignSave:
  createData(state)
  assert(
    state.turnState == nil,
    'Campaign can only autosave between turns'
  )

  assert(
    state.activeBattleScenario
      == nil,
    'Campaign cannot autosave during battle'
  )

  return {
    version = 1,

    campaignId =
      self.definition.id,

    day = state.day,
    gold = state.gold,

    participants =
      state.participants,

    cities = state.cities,
    armies = state.armies,
    journeys = state.journeys,

    announcedSieges =
      state.announcedSieges,

    eventLog = state.eventLog,

    directorState =
      state.directorState,

    nextArmyId =
      state.nextArmyId,

    nextSquadId =
      state.nextSquadId,

    nextBattleId =
      state.nextBattleId,

    nextProductionId =
      state.nextProductionId,

    nextGeneratedArmyId =
      state.nextGeneratedArmyId,

    nextScenarioId =
      state.nextScenarioId
  }
end


function CampaignSave:save(state)
  if not self.enabled then
    return false
  end

  local data =
    self:createData(state)

  local success, result =
    pcall(
      lovr.filesystem.write,
      self.file,
      serialize(data)
    )

  return
    success
    and result ~= false
end


function CampaignSave:exists()
  if
    not self.enabled
    or not lovr.filesystem.isFile
  then
    return false
  end

  local success, result =
    pcall(
      lovr.filesystem.isFile,
      self.file
    )

  return
    success and result == true
end


function CampaignSave:loadData()
  if not self:exists() then
    return nil
  end

  local success, chunk =
    pcall(
      lovr.filesystem.load,
      self.file
    )

  if
    not success
    or not chunk
  then
    return nil
  end

  local executed, data =
    pcall(chunk)

  if
    not executed
    or type(data) ~= 'table'
    or data.version ~= 1
    or data.campaignId ~=
      self.definition.id
  then
    return nil
  end

  return data
end


function CampaignSave:delete()
  if
    not self:exists()
    or not lovr.filesystem.remove
  then
    return false
  end

  local success, result =
    pcall(
      lovr.filesystem.remove,
      self.file
    )

  return
    success
    and result ~= false
end


return CampaignSave