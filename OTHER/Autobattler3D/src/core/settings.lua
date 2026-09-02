local Settings = {}

local SETTINGS_DIRECTORY = 'config'
local SETTINGS_FILE =
  SETTINGS_DIRECTORY .. '/settings.cfg'

local DEFAULTS = {
  battle = {
    playerSide = 'human',
    enemySide = 'orcs',
    map = 'test_field'
  },

  audio = {
    master = 1,
    music = .7
  }
}

local SAVED_FIELDS = {
  'battle.playerSide',
  'battle.enemySide',
  'battle.map',
  'audio.master',
  'audio.music'
}


-- Создаёт глубокую копию таблицы.
local function deepCopy(source)
  local result = {}

  for key, value in pairs(source) do
    if type(value) == 'table' then
      result[key] = deepCopy(value)
    else
      result[key] = value
    end
  end

  return result
end


-- Возвращает значение по пути с точками.
local function getByPath(source, path)
  local current = source

  for key in path:gmatch('[^.]+') do
    if type(current) ~= 'table' then
      return nil
    end

    current = current[key]
  end

  return current
end


-- Записывает значение по пути с точками.
local function setByPath(target, path, value)
  local keys = {}

  for key in path:gmatch('[^.]+') do
    keys[#keys + 1] = key
  end

  local current = target

  for index = 1, #keys - 1 do
    local key = keys[index]

    if type(current[key]) ~= 'table' then
      current[key] = {}
    end

    current = current[key]
  end

  current[keys[#keys]] = value
end


-- Ограничивает число диапазоном.
local function clamp(value, minimum, maximum)
  return math.max(
    minimum,
    math.min(maximum, value)
  )
end


-- Преобразует строку в тип настройки.
local function parseValue(text, defaultValue)
  if type(defaultValue) == 'number' then
    return tonumber(text) or defaultValue
  end

  if type(defaultValue) == 'boolean' then
    return text == 'true'
  end

  return text
end


-- Очищает строку перед сохранением.
local function sanitizeText(value)
  return tostring(value):gsub(
    '[\r\n=]',
    ''
  )
end


-- Проверяет загруженные настройки.
local function validate(settings)
  if
    type(settings.battle.playerSide)
    ~= 'string'
  then
    settings.battle.playerSide =
      DEFAULTS.battle.playerSide
  end

  if
    type(settings.battle.enemySide)
    ~= 'string'
  then
    settings.battle.enemySide =
      DEFAULTS.battle.enemySide
  end

  if
    type(settings.battle.map)
    ~= 'string'
  then
    settings.battle.map =
      DEFAULTS.battle.map
  end

  settings.audio.master = clamp(
    tonumber(settings.audio.master)
      or DEFAULTS.audio.master,
    0,
    1
  )

  settings.audio.music = clamp(
    tonumber(settings.audio.music)
      or DEFAULTS.audio.music,
    0,
    1
  )

  return settings
end


-- Загружает сохранённые настройки.
function Settings.load()
  local settings = deepCopy(DEFAULTS)

  local contents =
    lovr.filesystem.read(
      SETTINGS_FILE
    )

  if not contents then
    return settings
  end

  for line in contents:gmatch(
    '[^\r\n]+'
  ) do
    local path, text =
      line:match(
        '^([%w%.]+)=(.*)$'
      )

    local defaultValue =
      path
      and getByPath(
        DEFAULTS,
        path
      )

    if defaultValue ~= nil then
      setByPath(
        settings,
        path,
        parseValue(
          text,
          defaultValue
        )
      )
    end
  end

  return validate(settings)
end


-- Сохраняет настройки.
function Settings.save(settings)
  lovr.filesystem.createDirectory(
    SETTINGS_DIRECTORY
  )

  local lines = {
    '# Autobattler3D settings'
  }

  for _, path in ipairs(
    SAVED_FIELDS
  ) do
    local value =
      getByPath(settings, path)

    lines[#lines + 1] =
      path ..
      '=' ..
      sanitizeText(value)
  end

  return lovr.filesystem.write(
    SETTINGS_FILE,
    table.concat(lines, '\n') .. '\n'
  )
end


-- Возвращает стандартные настройки.
function Settings.reset()
  return deepCopy(DEFAULTS)
end


return Settings