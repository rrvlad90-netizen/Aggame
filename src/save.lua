local Save = {}

Save.fileName = "save.lua"

Save.data = {
    currentFlowIndex = 1,
    selectedPlayerId = nil,
	continueSceneId = nil,

    audio = {
        musicVolume = 0.75,
        soundVolume = 0.85
    },

    touch = {
        buttonScale = 1.0,
        buttonAlpha = 0.65
    }
}

-- Возвращает Lua-код для сохранения простых таблиц.
-- Поддерживает строки, числа, boolean и вложенные таблицы.
local function serializeValue(value, indent)
    indent = indent or 0

    local valueType = type(value)

    if valueType == "string" then
        return string.format("%q", value)
    end

    if valueType == "number" or valueType == "boolean" then
        return tostring(value)
    end

    if valueType == "table" then
        local spaces = string.rep(" ", indent)
        local childSpaces = string.rep(" ", indent + 4)
        local result = "{\n"

        for key, childValue in pairs(value) do
            local serializedKey = nil

            if type(key) == "string" and string.match(key, "^[%a_][%w_]*$") then
                serializedKey = key
            else
                serializedKey = "[" .. serializeValue(key, 0) .. "]"
            end

            result = result
                .. childSpaces
                .. serializedKey
                .. " = "
                .. serializeValue(childValue, indent + 4)
                .. ",\n"
        end

        result = result .. spaces .. "}"

        return result
    end

    return "nil"
end

-- Возвращает data по умолчанию.
function Save.getDefaultData()
    return {
        currentFlowIndex = 1,
        selectedPlayerId = nil,
		continueSceneId = nil,

        audio = {
            musicVolume = 0.75,
            soundVolume = 0.85
        },

		keyboard = {
            bindings = nil
        },

        touch = {
            buttonScale = 1.0,
            buttonAlpha = 0.65
        }

    }
end

-- Загружает save-файл.
-- Если файла нет или он повреждён, используется default data.
function Save.load()
    if not love.filesystem.getInfo(Save.fileName) then
        Save.data = Save.getDefaultData()
        return Save.data
    end

    local chunk, loadError = love.filesystem.load(Save.fileName)

    if not chunk then
        Save.data = Save.getDefaultData()
        return Save.data
    end

    local ok, result = pcall(chunk)

    if not ok or type(result) ~= "table" then
        Save.data = Save.getDefaultData()
        return Save.data
    end

    Save.data = result

    return Save.data
end

-- Сохраняет текущие данные.
function Save.save()
    local content = "return " .. serializeValue(Save.data, 0)

    love.filesystem.write(Save.fileName, content)
end

-- Начинает новую игру.
function Save.startNewGame()
    Save.data.currentFlowIndex = 1
    Save.data.selectedPlayerId = nil
    Save.data.continueSceneId = nil

    Save.save()
end

function Save.setContinueSceneId(sceneId)
    Save.data.continueSceneId = sceneId

    Save.save()
end

function Save.getContinueSceneId()
    return Save.data.continueSceneId
end

-- Сохраняет индекс текущего элемента flow.
function Save.setFlowIndex(index)
    Save.data.currentFlowIndex = index or 1

    Save.save()
end

-- Возвращает индекс текущего элемента flow.
function Save.getFlowIndex()
    return Save.data.currentFlowIndex or 1
end

-- Сохраняет выбранного игрока.
function Save.setSelectedPlayerId(playerId)
    Save.data.selectedPlayerId = playerId

    Save.save()
end

-- Возвращает выбранного игрока.
function Save.getSelectedPlayerId()
    return Save.data.selectedPlayerId
end

-- Сохраняет настройки звука.
function Save.setAudioSettings(musicVolume, soundVolume)
    Save.data.audio = Save.data.audio or {}

    Save.data.audio.musicVolume = musicVolume
    Save.data.audio.soundVolume = soundVolume

    Save.save()
end

-- Сохраняет настройки touch-кнопок.
function Save.setTouchSettings(buttonScale, buttonAlpha)
    Save.data.touch = Save.data.touch or {}

    Save.data.touch.buttonScale = buttonScale
    Save.data.touch.buttonAlpha = buttonAlpha

    Save.save()
end

-- Сохраняет настройки клавиатуры.
function Save.setKeyboardBindings(bindings)
    Save.data.keyboard = Save.data.keyboard or {}
    Save.data.keyboard.bindings = bindings

    Save.save()
end

-- Возвращает настройки клавиатуры.
function Save.getKeyboardBindings()
    if not Save.data.keyboard then
        return nil
    end

    return Save.data.keyboard.bindings
end

return Save