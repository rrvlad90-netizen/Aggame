local Assets = require("src.assets")
local AnimationSet = require("src.animation_set")

local Decor = {}
Decor.__index = Decor

-- —оздаЄт decor из definition.
-- Decor Ч это визуальный объект без боевой логики:
-- камни, деревь€, кусты, фоновые объекты.
function Decor:new(config)
    config = config or {}

    local decor = setmetatable({}, Decor)

    decor.id = config.id or "decor"

    decor.x = config.x or 0
    decor.y = config.y or 0

    decor.canvas = config.canvas or {
        width = config.w or config.width or 32,
        height = config.h or config.height or 32
    }

    decor.offset = config.offset or {
        x = 0,
        y = 0
    }

    decor.image = config.image

    decor.alpha = config.alpha or 1
    decor.color = config.color or {0.5, 0.5, 0.5}

    -- layer = "back" рисуетс€ за gameplay.
    -- layer = "front" рисуетс€ поверх gameplay.
    decor.layer = config.layer or "back"

    decor.vx = config.vx or config.speedX or config.speed_x or 0
    decor.vy = config.vy or config.speedY or config.speed_y or 0

    decor.dead = false

	decor.entitySpawnRequests = {} --для звуков
    decor.animationSet = nil
	
	if decor.animationSet and decor.animationSet:has(decor.spawnAnimation) then
		decor.animationSet:set(decor.spawnAnimation, true)
		decor.spawnFinished = false
		decor.trackingEnabled = false
	end

    if config.animations then
        decor.animationSet = AnimationSet:new({
            default = config.defaultAnimation or config.default_animation or "idle",
            animations = config.animations
        })
    end

--поведение если игрок слева от декора то анимация - ildleft
--по центру - проcто idle
--справа - idleright. 
--можно сделать что бы следил за игроком на заднем плане
	decor.trackPlayer = config.trackPlayer == true
		or config.track_player == true
		
	decor.trackingEnabled = decor.trackPlayer	
		
	decor.spawnAnimation = config.spawnAnimation
		or config.spawn_animation
		or "spawn"

	decor.spawnFinished = true

	decor.removeDecorAnimation = config.removeDecorAnimation
		or config.remove_decor_animation
		or "removeDecor"

	decor.leftAnimation = config.leftAnimation
		or config.left_animation
		or "idleleft"

	decor.centerAnimation = config.centerAnimation
		or config.center_animation
		or "idle"

	decor.rightAnimation = config.rightAnimation
		or config.right_animation
		or "idleright"

	decor.centerRange = config.centerRange
		or config.center_range
		or 80

    return decor
end

-- Обновляет decor: движение, spawn, tracking игрока и animation events.
function Decor:update(dt, world)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    self:updateSpawnAnimation()
    self:updatePlayerTracking(world)

    if self.animationSet then
        local events = self.animationSet:update(dt)

        for _, event in ipairs(events) do
            table.insert(self.entitySpawnRequests, event)
        end
    end

    self:updateRemoveDecorAnimation()
end

-- Возвращает и очищает события анимации decor-а.
-- World потом выполнит их через EventRunner.
function Decor:consumeEntitySpawnRequests()
    local requests = self.entitySpawnRequests

    self.entitySpawnRequests = {}

    return requests
end

-- Рисует decor.
function Decor:draw(camera)
    local screenX = self.x - (camera and camera.x or 0)
    local screenY = self.y - (camera and camera.y or 0)

    if self.animationSet then
        self.animationSet:draw(
            screenX,
            screenY,
            0,
            1,
            1,
            self.offset.x,
            self.offset.y,
            self.alpha
        )

        return
    end

    if self.image then
        local image = Assets.getImage(self.image)

        love.graphics.setColor(1, 1, 1, self.alpha)
        love.graphics.draw(
            image,
            screenX,
            screenY,
            0,
            1,
            1,
            self.offset.x,
            self.offset.y
        )
        love.graphics.setColor(1, 1, 1)

        return
    end

    love.graphics.setColor(
        self.color[1],
        self.color[2],
        self.color[3],
        self.alpha
    )

    love.graphics.rectangle(
        "fill",
        screenX - self.offset.x,
        screenY - self.offset.y,
        self.canvas.width,
        self.canvas.height
    )

    love.graphics.setColor(1, 1, 1)
end

-- Возвращает true, если decor можно удалить.
function Decor:isRemovable()
    return self.dead
end




-- Включает или выключает tracking игрока.
-- Используется animation event-ом setTracking.
function Decor:setTracking(enabled)
    self.trackPlayer = enabled == true
    self.trackingEnabled = enabled == true
end

-- Запускает animation decor-а по имени.
-- Нужен для animation event type = "setState".
function Decor:playAnimation(name, force)
    if not self.animationSet then
        return
    end

    self.animationSet:set(name, force)
end

-- Обновляет состояние стартовой spawn-анимации.
-- Пока spawn не закончилась, tracking игрока не работает.
function Decor:updateSpawnAnimation()
    if self.spawnFinished then
        return
    end

    if not self.animationSet then
        self.spawnFinished = true
        self.trackingEnabled = self.trackPlayer
        return
    end

    if self.animationSet:getCurrentName() ~= self.spawnAnimation then
        self.spawnFinished = true
        self.trackingEnabled = self.trackPlayer
        return
    end

    if self.animationSet:isCurrentFinished() then
        self.spawnFinished = true
        self.trackingEnabled = self.trackPlayer
    end
end

-- Проверяет, закончилась ли removeDecor-анимация.
-- Если закончилась — decor помечается на удаление.
function Decor:updateRemoveDecorAnimation()
    if not self.animationSet then
        return
    end

    if self.animationSet:getCurrentName() ~= self.removeDecorAnimation then
        return
    end

    if self.animationSet:isCurrentFinished() then
        self.dead = true
    end
end




-- Запускает animation decor-а по имени.
-- Нужен для animation event type = "setState".
function Decor:playAnimation(name, force)
    if not self.animationSet then
        return
    end

    self.animationSet:set(name, force)
end

-- Выбирает анимацию decor-а в зависимости от позиции игрока.
-- Используется для фоновых объектов, которые "следят" за игроком.
function Decor:updatePlayerTracking(world)
	if not self.trackPlayer or not self.trackingEnabled then
		return
	end

    if not self.animationSet then
        return
    end

    if not world or not world.player then
        return
    end

    local player = world.player
    local distanceX = player.x - self.x
    local halfCenterRange = self.centerRange / 2

    local animationName = self.centerAnimation

    if distanceX < -halfCenterRange then
        animationName = self.leftAnimation
    elseif distanceX > halfCenterRange then
        animationName = self.rightAnimation
    end

    if self.animationSet:has(animationName) then
        self.animationSet:set(animationName)
    end
end

return Decor