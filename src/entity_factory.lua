local Registry = require("src.registry")
local Utils = require("src.utils")

local Actor = require("src.actor")
local Projectile = require("src.projectile")
local Effect = require("src.effect")
local Platform = require("src.platform")
local Pickup = require("src.pickup")
local Decor = require("src.decor")
local LevelEnd = require("src.level_end")

local EntityFactory = {}

-- Подготавливает definition к созданию runtime entity.
-- Берёт data definition и накладывает overrides.
function EntityFactory.prepareConfig(definition, x, y, overrides)
    local config = Utils.mergeConfig(definition, overrides or {})

    if x ~= nil then
        config.x = x
    end

    if y ~= nil then
        config.y = y
    end

    return config
end

-- Создаёт Actor по id.
function EntityFactory.createActor(id, x, y, overrides)
    local definition = Registry.loadActor(id)
    local config = EntityFactory.prepareConfig(definition, x, y, overrides)

    return Actor:new(config)
end

-- Создаёт Projectile по id.
function EntityFactory.createProjectile(id, x, y, overrides)
    local definition = Registry.loadProjectile(id)
    local config = EntityFactory.prepareConfig(definition, x, y, overrides)

    return Projectile:new(config)
end

-- Создаёт Effect по id.
function EntityFactory.createEffect(id, x, y, overrides)
    local definition = Registry.loadEffect(id)
    local config = EntityFactory.prepareConfig(definition, x, y, overrides)

    return Effect:new(config)
end

-- Создаёт Platform по id.
function EntityFactory.createPlatform(id, x, y, overrides)
    local definition = Registry.loadPlatform(id)
    local config = EntityFactory.prepareConfig(definition, x, y, overrides)

    return Platform:new(config)
end

-- Создаёт Pickup по id.
function EntityFactory.createPickup(id, x, y, overrides)
    local definition = Registry.loadPickup(id)
    local config = EntityFactory.prepareConfig(definition, x, y, overrides)

    return Pickup:new(config)
end

-- Создаёт Decor по id.
function EntityFactory.createDecor(id, x, y, overrides)
    local definition = Registry.loadDecor(id)
    local config = EntityFactory.prepareConfig(definition, x, y, overrides)

    return Decor:new(config)
end

-- Создаёт LevelEnd.
-- Новый формат: createLevelEnd(id, x, y, overrides) через data/level_endlist.lua.
-- Старый формат: createLevelEnd(config) оставлен для совместимости.
function EntityFactory.createLevelEnd(idOrConfig, x, y, overrides)
    if type(idOrConfig) == "table" then
        return LevelEnd:new(idOrConfig)
    end

    local definition = Registry.loadLevelEnd(idOrConfig)
    local config = EntityFactory.prepareConfig(definition, x, y, overrides)

    return LevelEnd:new(config)
end

-- Создаёт entity по уникальному id.
-- Registry сам определяет тип entity.
function EntityFactory.createEntity(id, x, y, overrides)
    local kind, definition = Registry.loadEntity(id)
    local config = EntityFactory.prepareConfig(definition, x, y, overrides)

    if kind == "actor" then
        return "actor", Actor:new(config)
    end

    if kind == "projectile" then
        return "projectile", Projectile:new(config)
    end

    if kind == "effect" then
        return "effect", Effect:new(config)
    end

    if kind == "platform" then
        return "platform", Platform:new(config)
    end

    if kind == "pickup" then
        return "pickup", Pickup:new(config)
    end

    if kind == "decor" then
        return "decor", Decor:new(config)
    end

    error("EntityFactory.createEntity: unsupported kind " .. tostring(kind))
end

return EntityFactory