local Assets = require("src.assets")
local Collision = require("src.collision")
local AnimationSet = require("src.animation_set")

local LevelEnd = {}
LevelEnd.__index = LevelEnd

-- Создаёт объект конца уровня.
-- Это простой объект, не Actor.
function LevelEnd:new(config)
    config = config or {}

    local levelEnd = setmetatable({}, LevelEnd)

    levelEnd.id = config.id or "level_end"

    levelEnd.x = config.x or 0
    levelEnd.y = config.y or 0

    levelEnd.canvas = config.canvas or {
        width = config.w or config.width or 48,
        height = config.h or config.height or 80
    }

    levelEnd.offset = config.offset or {
        x = 0,
        y = 0
    }

    levelEnd.bbox = config.bbox or {
        x = 0,
        y = 0,
        w = levelEnd.canvas.width,
        h = levelEnd.canvas.height
    }

    levelEnd.image = config.image

    levelEnd.alpha = config.alpha or 1
    levelEnd.color = config.color or {1.0, 0.85, 0.2}

    levelEnd.vx = config.vx or config.speedX or config.speed_x or 0
    levelEnd.vy = config.vy or config.speedY or config.speed_y or 0

    levelEnd.active = config.active ~= false
    levelEnd.triggered = false

    levelEnd.animationSet = nil

    if config.animations then
        levelEnd.animationSet = AnimationSet:new({
            default = config.defaultAnimation or config.default_animation or "idle",
            animations = config.animations
        })
    end

    return levelEnd
end

-- Обновляет объект конца уровня.
function LevelEnd:update(dt)
    if not self.active or self.triggered then
        return
    end

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if self.animationSet then
        self.animationSet:update(dt)
    end
end

-- Возвращает hitbox объекта конца уровня.
function LevelEnd:getHitbox()
    return Collision.localBoxToWorld(self, self.bbox)
end

-- Проверяет, может ли игрок завершить уровень.
function LevelEnd:canTrigger()
    return self.active and not self.triggered
end

-- Помечает объект как использованный.
function LevelEnd:trigger()
    if self.triggered then
        return
    end

    self.triggered = true
end

-- Рисует объект конца уровня.
function LevelEnd:draw(camera)
    if not self.active or self.triggered then
        return
    end

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
        self.canvas.height,
        6,
        6
    )

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        "END",
        screenX - self.offset.x,
        screenY - self.offset.y + self.canvas.height / 2 - 8,
        self.canvas.width,
        "center"
    )

    love.graphics.setColor(1, 1, 1)
end

return LevelEnd