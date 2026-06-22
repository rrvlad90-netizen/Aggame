local EntityFactory = require("src.entity_factory")
local Config = require("src.config")
local Render = require("src.render")

local Level = {}
Level.__index = Level

-- Создаёт runtime-уровень из level definition.
-- Уровень хранит bounds, старт игрока и статичные объекты сцены.
function Level:new(config)
    config = config or {}

    local level = setmetatable({}, Level)

    level.id = config.id or "level"
	
	-- Если указано, уровень сам выбирает player-а и не зависит от player_select.
    level.playerId = config.playerId
        or config.player_id

    level.music = config.music
	
	level.defeatScene = config.defeatScene --в лчае смерти игрока куда отправляем его.
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

    -- ground больше не создаётся по умолчанию.
    -- Если уровню нужна земля, её надо делать через platforms.
    level.ground = config.ground
	
-----Делает так что на уровне игрок не может вернуться назад	
	level.oneSide = config.oneSide == true
        or config.one_side == true

    level.oneSideBackMargin = config.oneSideBackMargin
        or config.one_side_back_margin
        or 0	
------
    level.pendingActors = {}
    level.platforms = {}
    level.pickups = {}
    level.decors = {}
    level.effects = {}
	level.checkpoints = {}

-- Старое поле оставляем для совместимости.
    -- Новая логика работает через список levelEnds.
    level.levelEnd = nil
    level.levelEnds = {}

    level.completed = false
    level.failed = false

    level:createStaticObjects(config)

    return level
end

-- Обновляет совместимый alias level.levelEnd.
-- Нужен, чтобы старый код/старые уровни не ломались.
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
-- Поддерживает registry-формат с id и старый прямой config без id.
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

    -- Старый формат без registry id оставляем для совместимости.
    return EntityFactory.createLevelEnd(levelEndConfig)
end


-- Создаёт статичные объекты уровня:
-- actors, platforms, pickups, decors, effects и levelEnd.
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

	-- Старый формат: один LevelEnd.
		if config.levelEnd then
			self:addLevelEnd(self:createLevelEnd(config.levelEnd))
		end

		-- Новый формат: несколько LevelEnd на уровне.
		-- Можно писать levelEnds или level_ends.
		for _, levelEndConfig in ipairs(config.levelEnds or config.level_ends or {}) do
			self:addLevelEnd(self:createLevelEnd(levelEndConfig))
		end
end

-- Возвращает true, если pending actor уже попадает в активную область камеры.
function Level:shouldSpawnActorInCamera(actorConfig, camera)
    if not camera then
        return true
    end

    local spawnMargin = actorConfig.spawnMargin
        or actorConfig.spawn_margin
        or 64

    local screenWidth = Config.screen and Config.screen.width or 800
    local left = camera.x - spawnMargin
    local right = camera.x + screenWidth + spawnMargin

    return actorConfig.x >= left and actorConfig.x <= right
end

-- Возвращает true, если pending actor должен появиться рядом с игроком.
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

    return self:shouldSpawnActorInCamera(actorConfig, camera)
end

-- Создаёт actor-ов, до которых игрок приблизился.
-- Возвращает список созданных actor-ов.
function Level:spawnPendingActors(player, camera)
    local spawnedActors = {}

    for index = #self.pendingActors, 1, -1 do
        local actorConfig = self.pendingActors[index]

        if self:shouldSpawnActor(actorConfig, player, camera) then
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

-- Обновляет scroll offsets у background/front-background слоёв.
function Level:updateBackgrounds(dt)
    for _, background in ipairs(self.backgrounds or {}) do
        Render.updateScroll(background, dt)
    end
end

-- Обновляет runtime-объекты уровня.
function Level:update(dt, world)
	self:updateBackgrounds(dt)

    for _, platform in ipairs(self.platforms) do
        platform:update(dt)
    end

    for _, pickup in ipairs(self.pickups) do
        pickup:update(dt)
    end

	for _, decor in ipairs(self.decors) do
		decor:update(dt, world)
	end

    for _, effect in ipairs(self.effects) do
        effect:update(dt, world)
    end

	for _, levelEnd in ipairs(self.levelEnds or {}) do
        levelEnd:update(dt)
    end
end

-- Возвращает активированный LevelEnd или nil.
-- Обычный LevelEnd срабатывает от касания.
-- Если у LevelEnd activateIfTouch=true, нужно стоять в hitbox и нажать action "up".
function Level:checkLevelEnd(player, activatePressed)
    if not player then
        return nil
    end

    for _, levelEnd in ipairs(self.levelEnds or {}) do
        if levelEnd:canTrigger() then
            local touchesLevelEnd = require("src.collision").intersects(
                player:getHitbox(),
                levelEnd:getHitbox()
            )

            if touchesLevelEnd then
                if levelEnd.requiresActivation
                    and levelEnd:requiresActivation()
                    and not activatePressed
                then
                    -- Игрок касается двери, но ещё не нажал up.
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