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

    if config.animations then
        decor.animationSet = AnimationSet:new({
            default = config.defaultAnimation or config.default_animation or "idle",
            animations = config.animations
        })
    end

    return decor
end

-- Обновляет decor: движение и animation events.
function Decor:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if self.animationSet then
        local events = self.animationSet:update(dt)

        for _, event in ipairs(events) do
            table.insert(self.entitySpawnRequests, event)
        end
    end
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

-- ¬озвращает true, если decor можно удалить.
function Decor:isRemovable()
    return self.dead
end

return Decor