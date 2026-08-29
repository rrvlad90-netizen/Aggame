local EntityFactory = require("src.entity_factory")
local Config = require("src.config")
local Render = require("src.render")
local SpatialGrid = require("src.spatial_grid")

local Level = {}
Level.__index = Level

-- Создаёт runtime-уровень из level definition.
function Level:new(config)
    config = config or {}

    local level = setmetatable({}, Level)

    level.id = config.id or "level"

    level.playerId = config.playerId
        or config.player_id

    level.music = config.music

    level.defeatScene = config.defeatScene
        or config.defeat_scene
        or "game_over"

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

    -- Земля создаётся через platforms.
    level.ground = config.ground

    -- Запрещает игроку возвращаться назад по уровню.
    level.oneSide = config.oneSide == true
        or config.one_side == true

    level.oneSideBackMargin = config.oneSideBackMargin
        or config.one_side_back_margin
        or 0

    level.pendingActors = {}
    level.platforms = {}
    level.pickups = {}
    level.decors = {}
    level.effects = {}
    level.checkpoints = {}

    -- Индекс платформ перестраивается после движения платформ.
    level.platformSpatialGrid = SpatialGrid:new(
        config.spatialCellSize
            or config.spatial_cell_size
            or 256
    )

    -- Старое поле оставлено для совместимости.
    level.levelEnd = nil
    level.levelEnds = {}

    level.completed = false
    level.failed = false

    level:createStaticObjects(config)
    level:rebuildPlatformSpatialGrid()

    return level
end

-- Обновляет совместимый alias level.levelEnd.
function Level:refreshLevelEndAlias()
    if self.levelEnds and #self.levelEnds > 0 then
        self.levelEnd = self.levelEnds[1]
    else
        self.levelEnd = nil
    end
end

-- Добавляет runtime LevelEnd в список уровня.
function Level:addLevelEnd(levelEnd)
    if not levelEnd then
        return
    end

    table.insert(self.levelEnds, levelEnd)
    self:refreshLevelEndAlias()
end

-- Создаёт один LevelEnd из config.
function Level:createLevelEnd(levelEndConfig)
    if not levelEndConfig then
        return nil
    end

    if levelEndConfig.id then
        return EntityFactory.createLevelEnd(
            levelEndConfig.id,
            levelEndConfig.x,
            levelEndConfig.y,
            levelEndConfig
        )
    end

    return EntityFactory.createLevelEnd(levelEndConfig)
end

-- Создаёт статичные объекты уровня.
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

    for _, checkpointConfig in ipairs(config.checkpoints or {}) do
        table.insert(
            self.checkpoints,
            EntityFactory.createCheckpoint(
                checkpointConfig.id,
                checkpointConfig.x,
                checkpointConfig.y,
                checkpointConfig
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

    -- Старый формат одного LevelEnd.
    if config.levelEnd then
        self:addLevelEnd(
            self:createLevelEnd(config.levelEnd)
        )
    end

    -- Новый формат нескольких LevelEnd.
    for _, levelEndConfig in ipairs(
        config.levelEnds or config.level_ends or {}
    ) do
        self:addLevelEnd(
            self:createLevelEnd(levelEndConfig)
        )
    end
end

-- Проверяет попадание pending actor в активную область камеры.
function Level:shouldSpawnActorInCamera(actorConfig, camera)
    if not camera then
        return true
    end

    local spawnMargin = actorConfig.spawnMargin
        or actorConfig.spawn_margin
        or 64

    local screenWidth = Config.screen
        and Config.screen.width
        or 800

    local left = camera.x - spawnMargin
    local right = camera.x + screenWidth + spawnMargin

    return actorConfig.x >= left
        and actorConfig.x <= right
end

-- Проверяет, должен ли pending actor появиться рядом с игроком.
function Level:shouldSpawnActor(actorConfig, player, camera)
    if not player then
        return false
    end

    local appearDistance = actorConfig.appearDistance
        or actorConfig.appear_distance
        or 0

    if math.abs(actorConfig.x - player.x) > appearDistance then
        return false
    end

    return self:shouldSpawnActorInCamera(
        actorConfig,
        camera
    )
end

-- Создаёт actor-ов, до которых приблизился игрок.
function Level:spawnPendingActors(player, camera)
    local spawnedActors = {}

    for index = #self.pendingActors, 1, -1 do
        local actorConfig = self.pendingActors[index]

        if self:shouldSpawnActor(
            actorConfig,
            player,
            camera
        ) then
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

-- Обновляет прокрутку фоновых слоёв.
function Level:updateBackgrounds(dt)
    for _, background in ipairs(
        self.backgrounds or {}
    ) do
        Render.updateScroll(background, dt)
    end
end

-- Перестраивает индекс платформ.
-- Это необходимо для движущихся и исчезающих платформ.
function Level:rebuildPlatformSpatialGrid()
    if not self.platformSpatialGrid then
        return
    end

    self.platformSpatialGrid:rebuild(
        self.platforms,
        function(platform)
            return platform:getHitbox()
        end
    )
end

-- Возвращает платформы из ближайших секций.
function Level:getPlatformsNearRect(rect, padding)
    if not self.platformSpatialGrid then
        return self.platforms or {}
    end

    return self.platformSpatialGrid:query(
        rect,
        padding or 8
    )
end

-- Обновляет runtime-объекты уровня.
function Level:update(dt, world)
    self:updateBackgrounds(dt)

    for index = #self.platforms, 1, -1 do
        local platform = self.platforms[index]

        platform:update(dt, world)

        if platform.isRemovable
            and platform:isRemovable()
        then
            table.remove(self.platforms, index)
        end
    end

    -- Учитываем новые позиции движущихся платформ.
    self:rebuildPlatformSpatialGrid()

    for _, pickup in ipairs(self.pickups) do
        pickup:update(dt)
    end

    for _, decor in ipairs(self.decors) do
        decor:update(dt, world)
    end

    for _, effect in ipairs(self.effects) do
        effect:update(dt, world)
    end

    for _, levelEnd in ipairs(
        self.levelEnds or {}
    ) do
        levelEnd:update(dt)
    end
end

-- Возвращает активированный LevelEnd.
function Level:checkLevelEnd(player, activatePressed)
    if not player then
        return nil
    end

    for _, levelEnd in ipairs(
        self.levelEnds or {}
    ) do
        if levelEnd:canTrigger() then
            local touchesLevelEnd =
                require("src.collision").intersects(
                    player:getHitbox(),
                    levelEnd:getHitbox()
                )

            if touchesLevelEnd then
                if levelEnd.requiresActivation
                    and levelEnd:requiresActivation()
                    and not activatePressed
                then
                    -- Ожидаем нажатия Up.
                else
                    return levelEnd
                end
            end
        end
    end

    return nil
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