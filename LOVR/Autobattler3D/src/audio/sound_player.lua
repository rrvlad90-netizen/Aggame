local SoundPlayer = {}

local templates = {}
local activeSources = {}
local lastPlayed = {}
local lastPaths = {}

local maximumActiveSources = 16

local listenerX = 0
local listenerY = 0
local listenerZ = 0
local listenerReady = false


function SoundPlayer.setListenerPosition(
  x,
  y,
  z
)
  listenerX = x or 0
  listenerY = y or 0
  listenerZ = z or 0
  listenerReady = true
end

local soundRules = {
  attack = {
    chance = .30,--30% шанс проигрыания (их там много каша из звуков будет иначе)
    cooldown = .18,--разрешает не чаще одного такого звука за 0,18 секунды
    maximumConcurrent = 3,

    maximumDistance = 40,
    falloffStart = 16,
    minimumVolume = .03,
    volume = .7
  },

  hit = {
    chance = .15,
    cooldown = .12,
    maximumConcurrent = 2,

    maximumDistance = 40,
    falloffStart = 16,
    minimumVolume = .03,
    volume = .7
  },

  death = {
    chance = .65,
    cooldown = .10,
    maximumConcurrent = 3,

    maximumDistance = 40,
    falloffStart = 16,
    minimumVolume = .03,
    volume = .7
  }
}

local function getTime()
  if
    lovr.timer
    and lovr.timer.getTime
  then
    return lovr.timer.getTime()
  end

  return os.clock()
end


local function warn(path, message)
  print(
    '[audio] ' ..
    message ..
    ': ' ..
    tostring(path)
  )
end


local function removeFinishedSources()
  for index =
    #activeSources,
    1,
    -1
  do
    local item =
      activeSources[index]

    local success, playing =
      pcall(
        item.source.isPlaying,
        item.source
      )

    if
      not success
      or not playing
    then
      table.remove(
        activeSources,
        index
      )
    end
  end
end


local function countGroup(group)
  local count = 0

  for _, item in ipairs(
    activeSources
  ) do
    if item.group == group then
      count = count + 1
    end
  end

  return count
end


-- Безопасно загружает звуковой файл.
local function getTemplate(path)
  if
    type(path) ~= 'string'
    or path == ''
  then
    return nil
  end

  if templates[path] ~= nil then
    return templates[path] or nil
  end

  if
    lovr.filesystem
    and lovr.filesystem.isFile
  then
    local success, exists =
      pcall(
        lovr.filesystem.isFile,
        path
      )

    if success and not exists then
      templates[path] = false

      warn(
        path,
        'file not found'
      )

      return nil
    end
  end

  local success, source =
    pcall(
      function()
        return lovr.audio.newSource(
          path,
          {
            decode = true,
            spatial = true,
            pitchable = false
          }
        )
      end
    )

  if
    not success
    or not source
  then
    templates[path] = false

    warn(
      path,
      'failed to load'
    )

    return nil
  end

  templates[path] = source

  return source
end


-- Собирает только реально загруженные варианты.
local function getAvailableVariants(
  variants
)
  local available = {}

  for _, path in ipairs(
    variants or {}
  ) do
    if getTemplate(path) then
      available[
        #available + 1
      ] = path
    end
  end

  return available
end


-- Выбирает случайный вариант без
-- немедленного повторения.
local function chooseVariant(
  variants,
  group
)
  local available =
    getAvailableVariants(
      variants
    )

  if #available == 0 then
    return nil
  end

  local previous =
    lastPaths[group]

  local candidates = {}

  for _, path in ipairs(
    available
  ) do
    if
      #available == 1
      or path ~= previous
    then
      candidates[
        #candidates + 1
      ] = path
    end
  end

  return candidates[
    math.random(
      1,
      #candidates
    )
  ]
end


local function isCloseEnough(
  x,
  y,
  z,
  maximumDistance
)
  if
    not maximumDistance
    or not listenerReady
  then
    return true
  end

  local dx =
    (x or 0) - listenerX

  local dy =
    (y or 0) - listenerY

  local dz =
    (z or 0) - listenerZ

  return
    dx * dx +
    dy * dy +
    dz * dz <=
    maximumDistance *
    maximumDistance
end


-- Загружает существующие звуки заранее.
function SoundPlayer.preload(definition)
  for _, variants in pairs(
    definition or {}
  ) do
    if type(variants) == 'table' then
      for _, path in ipairs(
        variants
      ) do
        getTemplate(path)
      end
    end
  end
end


-- Проигрывает ограниченный случайный звук.
function SoundPlayer.play(
  variants,
  x,
  y,
  z,
  options
)
  options = options or {}
  
  local rule =
    soundRules[options.kind]
    or soundRules.attack

  if
    type(variants) ~= 'table'
    or #variants == 0
  then
    return false
  end

  local chance =
    rule.chance

  if chance == nil then
    chance = 1
  end

  if
    chance <= 0
    or math.random() > chance
  then
    return false
  end

  if not isCloseEnough(
    x,
    y,
    z,
    rule.maximumDistance
  ) then
    return false
  end

  removeFinishedSources()

  if
    #activeSources >=
    maximumActiveSources
  then
    return false
  end

  local group =
    options.group
    or 'unit'

  local currentTime =
    getTime()

  local cooldown =
    rule.cooldown
    or 0

  local previousTime =
    lastPlayed[group]

  if
    previousTime
    and currentTime -
      previousTime < cooldown
  then
    return false
  end

  local maximumConcurrent =
    rule.maximumConcurrent
    or 3

  if
    countGroup(group) >=
    maximumConcurrent
  then
    return false
  end

  local path =
    chooseVariant(
      variants,
      group
    )

  if not path then
    return false
  end

  local template =
    getTemplate(path)

  if not template then
    return false
  end

  local success, source =
    pcall(
      template.clone,
      template
    )

  if not success or not source then
    return false
  end

  success =
    pcall(
      function()
        source:setPosition(
          x or 0,
          y or 0,
          z or 0
        )

		source:setVolume(
		  rule.volume or 1
		)

		-- Включает пространственный звук.
		source:setSpatialization(true)

		-- После falloffStart громкость
		-- постепенно уменьшается до нуля.
		source:setFalloff(
		  rule.falloffStart or 3,
		  rule.minimumVolume or 0
		)

		return source:play()
      end
    )

  if not success then
    return false
  end

  activeSources[
    #activeSources + 1
  ] = {
    source = source,
    group = group
  }

  lastPlayed[group] =
    currentTime

  lastPaths[group] = path

  return true
end


return SoundPlayer