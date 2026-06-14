local EntityFactory = require("src.entity_factory")
local LevelEnd = require("src.level_end")

local Level = {}
Level.__index = Level

-- Создаёт runtime-уровень из level definition.
function Level:new(config)
    config = config or {}

    local level = setmetatable({}, Level)

    level.id = config.id or "level"

    level.music = config.music

    level.bounds = config.bounds or {
        left = 0,
        right = 3000,
        top = 0,
        bottom = 600
    }

    level.playerStart = config.playerStart
        or config.player_start
        or {
            x = 120,
            y = 420
        }

    level.backgrounds = config.backgrounds or {}

    level.ground = config.ground or {
        y = 455,
        visualY = 425,
        visualHeight = 130
    }

    level.pendingActors = {}
    level.platforms = {}
    level.pickups = {}
    level.decors = {}
    level.effects = {}

    level.levelEnd = nil

    level.completed = false
    level.failed = false

    level:createStaticObjects(config)

    return level
end

-- Создаёт статичные объекты уровня:
-- platforms, pickups, decors, effects и levelEnd.
function Level:createStaticObjects(config)
    for _, actorConfig in ipairs(config.actors or {}) do
        table.insert(self.pendingActors, actorConfig)
    end

    for _, platformConfig in ipairs(config.platforms or {}) do
        table.insert(
            self.platforms,
            EntityFactory.createPlatform(
                platformConfig.id,
                platformConfig.x,
                platformConfig.y,
                platformConfig
            )
        )
    end

    for _, pickupConfig in ipairs(config.pickups or {}) do
        table.insert(
            self.pickups,
            EntityFactory.createPickup(
                pickupConfig.id,
                pickupConfig.x,
                pickupConfig.y,
                pickupConfig
            )
        )
    end

    for _, decorConfig in ipairs(config.decors or {}) do
        table.insert(
            self.decors,
            EntityFactory.createDecor(
                decorConfig.id,
                decorConfig.x,
                decorConfig.y,
                decorConfig
            )
        )
    end

    for _, effectConfig in ipairs(config.effects or {}) do
        table.insert(
            self.effects,
            EntityFactory.createEffect(
                effectConfig.id,
                effectConfig.x,
                effectConfig.y,
                effectConfig
            )
        )
    end

    if config.levelEnd then
        self.levelEnd = LevelEnd:new(config.levelEnd)
    end
end

-- Возвращает true, если pending actor должен появиться.
function Level:shouldSpawnActor(actorConfig, player)
    if not player then
        return false
    end

    local appearDistance = actorConfig.appearDistance
        or actorConfig.appear_distance
        or 0

    return math.abs(actorConfig.x - player.x) <= appearDistance
end

-- Создаёт actor-ов, до которых игрок приблизился.
-- Возвращает список созданных actor-ов.
function Level:spawnPendingActors(player)
    local spawnedActors = {}

    for index = #self.pendingActors, 1, -1 do
        local actorConfig = self.pendingActors[index]

        if self:shouldSpawnActor(actorConfig, player) then
            local actor = EntityFactory.createActor(
                actorConfig.id,
                actorConfig.x,
                actorConfig.y,
                actorConfig
            )

            table.insert(spawnedActors, actor)
            table.remove(self.pendingActors, index)
        end
    end

    return spawnedActors
end

-- Обновляет объекты уровня.
function Level:update(dt, world)
    for _, platform in ipairs(self.platforms) do
        platform:update(dt)
    end

    for _, pickup in ipairs(self.pickups) do
        pickup:update(dt)
    end

    for _, decor in ipairs(self.decors) do
        decor:update(dt)
    end

    for _, effect in ipairs(self.effects) do
        effect:update(dt, world)
    end

    if self.levelEnd then
        self.levelEnd:update(dt)
    end
end

-- Возвращает true, если игрок дошёл до LevelEnd.
function Level:checkLevelEnd(player)
    if not self.levelEnd then
        return false
    end

    if not self.levelEnd:canTrigger() then
        return false
    end

    if self.levelEnd and player then
        return require("src.collision").intersects(
            player:getHitbox(),
            self.levelEnd:getHitbox()
        )
    end

    return false
end

-- Помечает уровень завершённым.
function Level:complete()
    self.completed = true
end

-- Помечает уровень проваленным.
function Level:fail()
    self.failed = true
end

return Level