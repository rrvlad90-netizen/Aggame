local Utils = require("src.utils")

local Registry = {}

Registry.actorList = {}
Registry.projectileList = {}
Registry.effectList = {}
Registry.levelList = {}
Registry.levelEndList = {}
Registry.sceneList = {}
Registry.playerList = {}
Registry.platformList = {}
Registry.pickupList = {}
Registry.decorList = {}

Registry.cache = {}

-- Безопасно загружает Lua-файл и возвращает результат.
-- Data-файлы должны делать return table.
function Registry.loadLuaFile(path)
    if not path then
        error("Registry.loadLuaFile: path is nil")
    end

    local chunk, loadError = love.filesystem.load(path)

    if not chunk then
        error("Failed to load Lua file: " .. tostring(path) .. "\n" .. tostring(loadError))
    end

    local ok, result = pcall(chunk)

    if not ok then
        error("Failed to execute Lua file: " .. tostring(path) .. "\n" .. tostring(result))
    end

    return result
end

-- Загружает list-файл.
-- Если файла нет, возвращает пустую таблицу.
function Registry.loadList(path)
    if not love.filesystem.getInfo(path) then
        return {}
    end

    return Registry.loadLuaFile(path) or {}
end

-- Загружает все registry-list файлы.
function Registry.loadAll()
    Registry.actorList = Registry.loadList("data/actorlist.lua")
    Registry.projectileList = Registry.loadList("data/projectilelist.lua")
    Registry.effectList = Registry.loadList("data/effectlist.lua")
    Registry.levelList = Registry.loadList("data/levellist.lua")
	Registry.levelEndList = Registry.loadList("data/level_endlist.lua")
    Registry.sceneList = Registry.loadList("data/scenelist.lua")
    Registry.playerList = Registry.loadList("data/players.lua")
    Registry.platformList = Registry.loadList("data/platformlist.lua")
    Registry.pickupList = Registry.loadList("data/pickuplist.lua")
    Registry.decorList = Registry.loadList("data/decorlist.lua")

    Registry.cache = {}
end

-- Возвращает путь к definition по id и конкретному списку.
function Registry.getPathFromList(list, id, kind)
    local path = list[id]

    if not path then
        error("Unknown " .. tostring(kind) .. " id: " .. tostring(id))
    end

    return path
end

-- Загружает definition с кешированием.
function Registry.loadDefinitionFromPath(path)
    if Registry.cache[path] then
        return Utils.deepCopy(Registry.cache[path])
    end

    local definition = Registry.loadLuaFile(path)

    Registry.cache[path] = definition

    return Utils.deepCopy(definition)
end

-- Проверяет, что id внутри definition совпадает с ожидаемым id.
-- Если id не указан, автоматически подставляет expectedId.
function Registry.normalizeDefinition(definition, expectedId)
    definition = definition or {}

    if definition.id and definition.id ~= expectedId then
        error(
            "Definition id mismatch. Expected "
            .. tostring(expectedId)
            .. ", got "
            .. tostring(definition.id)
        )
    end

    definition.id = definition.id or expectedId

    return definition
end

-- Загружает actor definition.
function Registry.loadActor(id)
    local path = Registry.getPathFromList(Registry.actorList, id, "actor")
    local definition = Registry.loadDefinitionFromPath(path)

    return Registry.normalizeDefinition(definition, id)
end

-- Загружает projectile definition.
function Registry.loadProjectile(id)
    local path = Registry.getPathFromList(Registry.projectileList, id, "projectile")
    local definition = Registry.loadDefinitionFromPath(path)

    return Registry.normalizeDefinition(definition, id)
end

-- Загружает effect definition.
function Registry.loadEffect(id)
    local path = Registry.getPathFromList(Registry.effectList, id, "effect")
    local definition = Registry.loadDefinitionFromPath(path)

    return Registry.normalizeDefinition(definition, id)
end

-- Загружает level definition.
function Registry.loadLevel(id)
    local path = Registry.getPathFromList(Registry.levelList, id, "level")
    local definition = Registry.loadDefinitionFromPath(path)

    return Registry.normalizeDefinition(definition, id)
end

-- Загружает level_end definition.
function Registry.loadLevelEnd(id)
    local path = Registry.getPathFromList(Registry.levelEndList, id, "level_end")
    local definition = Registry.loadDefinitionFromPath(path)

    return Registry.normalizeDefinition(definition, id)
end

-- Загружает scene definition.
function Registry.loadScene(id)
    local path = Registry.getPathFromList(Registry.sceneList, id, "scene")
    local definition = Registry.loadDefinitionFromPath(path)

    return Registry.normalizeDefinition(definition, id)
end

-- Загружает player definition.
function Registry.loadPlayer(id)
    local path = Registry.getPathFromList(Registry.playerList, id, "player")
    local definition = Registry.loadDefinitionFromPath(path)

    return Registry.normalizeDefinition(definition, id)
end

-- Загружает platform definition.
function Registry.loadPlatform(id)
    local path = Registry.getPathFromList(Registry.platformList, id, "platform")
    local definition = Registry.loadDefinitionFromPath(path)

    return Registry.normalizeDefinition(definition, id)
end

-- Загружает pickup definition.
function Registry.loadPickup(id)
    local path = Registry.getPathFromList(Registry.pickupList, id, "pickup")
    local definition = Registry.loadDefinitionFromPath(path)

    return Registry.normalizeDefinition(definition, id)
end

-- Загружает decor definition.
function Registry.loadDecor(id)
    local path = Registry.getPathFromList(Registry.decorList, id, "decor")
    local definition = Registry.loadDefinitionFromPath(path)

    return Registry.normalizeDefinition(definition, id)
end

-- Проверяет, есть ли id в указанном списке.
function Registry.hasId(list, id)
    return list[id] ~= nil
end

-- Загружает entity definition по уникальному id.
-- id должен быть уникальным среди actor/projectile/effect/pickup/decor/platform.
function Registry.loadEntity(id)
    if Registry.hasId(Registry.actorList, id) then
        return "actor", Registry.loadActor(id)
    end

    if Registry.hasId(Registry.projectileList, id) then
        return "projectile", Registry.loadProjectile(id)
    end

    if Registry.hasId(Registry.effectList, id) then
        return "effect", Registry.loadEffect(id)
    end

    if Registry.hasId(Registry.pickupList, id) then
        return "pickup", Registry.loadPickup(id)
    end

    if Registry.hasId(Registry.decorList, id) then
        return "decor", Registry.loadDecor(id)
    end

    if Registry.hasId(Registry.platformList, id) then
        return "platform", Registry.loadPlatform(id)
    end
	
	if Registry.hasId(Registry.levelEndList, id) then
        return "levelEnd", Registry.loadLevelEnd(id)
    end

    error("Unknown entity id: " .. tostring(id))
end

return Registry