local Assets = require("src.assets")
local AnimationSet = require("src.animation_set")
local EventRunner = require("src.event_runner")
local Collision = require("src.collision")
local Shadow = require("src.shadow")

local Decor = {}
Decor.__index = Decor

-- Создаёт decor из definition.
-- Decor это визуальный объект без боевой логики:
-- камни, деревья, кусты, фоновые объекты.
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

    ----Зона удаления акторов - поставить за границу экрана в начале уровня
    ----Но можно и так использовать если нужно что бы монстры, платформы и и.д. удалялись
    decor.bbox = config.bbox or {
        x = 0,
        y = 0,
        w = decor.canvas.width,
        h = decor.canvas.height
    }

    decor.cleanupZone = config.cleanupZone == true
        or config.cleanup_zone == true

    decor.printCleanup = config.printCleanup == true
        or config.print_cleanup == true

    decor.removeActors = config.removeActors ~= false
        and config.remove_actors ~= false

    decor.removeProjectiles = config.removeProjectiles ~= false
        and config.remove_projectiles ~= false

    decor.removeEffects = config.removeEffects ~= false
        and config.remove_effects ~= false

    decor.removePickups = config.removePickups ~= false
        and config.remove_pickups ~= false

    decor.removePlatforms = config.removePlatforms ~= false
        and config.remove_platforms ~= false

    decor.removeDecors = config.removeDecors ~= false
        and config.remove_decors ~= false

    decor.removeLevelEnd = config.removeLevelEnd == true
        or config.remove_level_end == true

    decor.removePlayer = config.removePlayer == true
        or config.remove_player == true

    ----Движение вместе с экраном/камерой
    -- Если followCamera = true, то x/y в конфиге становятся offset-ом относительно камеры.
    -- Например x = -180 значит decor будет всегда на 180 px левее видимой области.
    decor.followCamera = config.followCamera == true
        or config.follow_camera == true
        or config.moveWithScreen == true
        or config.move_with_screen == true

    -- По X включено по умолчанию, если followCamera = true.
    decor.followCameraX = config.followCameraX ~= false
        and config.follow_camera_x ~= false

    -- По Y выключено по умолчанию, чтобы decor мог оставаться на world-высоте.
    decor.followCameraY = config.followCameraY == true
        or config.follow_camera_y == true

    decor.cameraOffsetX = config.cameraOffsetX
        or config.camera_offset_x
        or config.screenX
        or config.screen_x
        or decor.x

    decor.cameraOffsetY = config.cameraOffsetY
        or config.camera_offset_y
        or config.screenY
        or config.screen_y
        or decor.y

    ------ТЕНЬ опционально
    decor.shadowType = config.shadowType
        or config.shadow_type
        or 0

    decor.shadowAlpha = config.shadowAlpha
        or config.shadow_alpha
        or 0.3

    decor.shadowWidth = config.shadowWidth
        or config.shadow_width

    decor.shadowHeight = config.shadowHeight
        or config.shadow_height

    decor.shadowOffsetX = config.shadowOffsetX
        or config.shadow_offset_x
        or 0

    decor.shadowOffsetY = config.shadowOffsetY
        or config.shadow_offset_y
        or 0

    decor.shadowScaleX = config.shadowScaleX
        or config.shadow_scale_x

    decor.shadowScaleY = config.shadowScaleY
        or config.shadow_scale_y

    decor.shadowVisible = false
    decor.shadowX = 0
    decor.shadowY = 0

    decor.image = config.image

    decor.alpha = config.alpha or 1
    decor.color = config.color or {0.5, 0.5, 0.5}

    -------Scale --Чисто визуальный эффект, на bbox и hitbox не влияет
    decor.scale = config.scale or 1

    decor.scaleX = config.scaleX
        or config.scale_x
        or decor.scale

    decor.scaleY = config.scaleY
        or config.scale_y
        or decor.scale

    -----Смещение для Scale если спрайт сьехал в сторону
    decor.drawOffsetX = config.drawOffsetX
        or config.draw_offset_x
        or config.visualOffsetX
        or config.visual_offset_x
        or 0

    decor.drawOffsetY = config.drawOffsetY
        or config.draw_offset_y
        or config.visualOffsetY
        or config.visual_offset_y
        or 0

    decor.layer = config.layer or "back"

    decor.vx = config.vx or config.speedX or config.speed_x or 0
    decor.vy = config.vy or config.speedY or config.speed_y or 0

    decor.dead = false

    decor.trackPlayer = config.trackPlayer == true
        or config.track_player == true

    decor.trackAfterSpawn = config.trackAfterSpawn == true
        or config.track_after_spawn == true

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

    decor.animationSet = nil

    if config.animations then
        decor.animationSet = AnimationSet:new({
            default = config.defaultAnimation or config.default_animation or "idle",
            animations = config.animations
        })
    end

    -- Если у decor-а есть spawn-анимация, всегда стартуем с неё один раз.
    -- Tracking включается отдельно: глобально через trackPlayer или event-ом setTracking.
    if decor.animationSet and decor.animationSet:has(decor.spawnAnimation) then
        decor.animationSet:set(decor.spawnAnimation, true)
        decor.spawnFinished = false
    end

    return decor
end

-- Двигает decor вместе с камерой.
-- Используется для cleanup-zone за экраном.
function Decor:updateCameraFollow(world)
    if not self.followCamera then
        return
    end

    if not world or not world.camera then
        return
    end

    if self.followCameraX then
        self.x = world.camera.x + self.cameraOffsetX
    end

    if self.followCameraY then
        self.y = world.camera.y + self.cameraOffsetY
    end
end

-- Обновляет decor: движение, spawn, tracking игрока и animation events.
function Decor:update(dt, world)
    if self.followCamera then
        self:updateCameraFollow(world)
    else
        self.x = self.x + self.vx * dt
        self.y = self.y + self.vy * dt
    end

    self:updateSpawnAnimation()
    self:updatePlayerTracking(world)

    if self.animationSet then
        local events = self.animationSet:update(dt)

        -- Decor выполняет свои animation events сразу.
        -- Так createEntity, setTracking, randomState и playSound не зависят от World:processDecorEvents.
        EventRunner.runAll(world, self, events)
    end

    self:updateRemoveDecorAnimation()
end

-- Рисует decor.
function Decor:draw(camera)
    -----Смещение для Scale если спрайт сьехал в сторону
    local screenX = self.x
        - (camera and camera.x or 0)
        + (self.drawOffsetX or self.draw_offset_x or 0)

    local screenY = self.y
        - (camera and camera.y or 0)
        + (self.drawOffsetY or self.draw_offset_y or 0)

    local scaleX = self.scaleX or self.scale or 1
    local scaleY = self.scaleY or self.scale or 1

    Shadow.draw(self, camera)

    if self.animationSet then
        self.animationSet:draw(
            screenX,
            screenY,
            0,
            scaleX,
            scaleY,
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
            scaleX,
            scaleY,
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
        screenX - self.offset.x * scaleX,
        screenY - self.offset.y * scaleY,
        self.canvas.width * scaleX,
        self.canvas.height * scaleY
    )

    love.graphics.setColor(1, 1, 1)
end

-- Возвращает bbox decor-а в мировых координатах.
function Decor:getHitbox()
    return Collision.localBoxToWorld(self, self.bbox)
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
-- Когда spawn закончилась, может автоматически включить tracking.
function Decor:updateSpawnAnimation()
    if self.spawnFinished then
        return
    end

    if not self.animationSet then
        self.spawnFinished = true
        return
    end

    if self.animationSet:getCurrentName() ~= self.spawnAnimation then
        self.spawnFinished = true
        return
    end

    if self.animationSet:isCurrentFinished() then
        self.spawnFinished = true

        if self.trackAfterSpawn then
            self:setTracking(true)
        end
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

-- Выбирает анимацию decor-а в зависимости от позиции игрока.
-- Tracking не перебивает spawn/removeDecor и работает только когда включён.
function Decor:updatePlayerTracking(world)
    if not self.trackPlayer or not self.trackingEnabled then
        return
    end

    if not self.animationSet then
        return
    end

    local currentAnimation = self.animationSet:getCurrentName()

    -- Пока spawn не закончился, tracking не имеет права сбивать его.
    if currentAnimation == self.spawnAnimation
        and not self.animationSet:isCurrentFinished()
    then
        return
    end

    -- removeDecor тоже нельзя перебивать tracking-ом.
    if currentAnimation == self.removeDecorAnimation then
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