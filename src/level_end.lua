local Assets = require("src.assets")
local Collision = require("src.collision")
local AnimationSet = require("src.animation_set")
local Shadow = require("src.shadow")

local LevelEnd = {}
LevelEnd.__index = LevelEnd

-- Нормализует описание следующего перехода.
-- Поддерживает next, nextLevel и nextScene.
local function normalizeNextTarget(config)
    if config.next then
        return config.next
    end

    if config.nextLevel or config.next_level then
        return {
            type = "level",
            id = config.nextLevel or config.next_level
        }
    end

    if config.nextScene or config.next_scene then
        return {
            type = "scene",
            id = config.nextScene or config.next_scene
        }
    end

    return nil
end

-- Создаёт объект конца уровня.
-- LevelEnd может быть прямым config или registry-сущностью из data/level_ends.
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
	
----ТЕНЬ опционально	
	levelEnd.shadowType = config.shadowType
        or config.shadow_type
        or 0

    levelEnd.shadowAlpha = config.shadowAlpha
        or config.shadow_alpha
        or 0.3

    levelEnd.shadowWidth = config.shadowWidth
        or config.shadow_width

    levelEnd.shadowHeight = config.shadowHeight
        or config.shadow_height

    levelEnd.shadowOffsetX = config.shadowOffsetX
        or config.shadow_offset_x
        or 0

    levelEnd.shadowOffsetY = config.shadowOffsetY
        or config.shadow_offset_y
        or 0

    levelEnd.shadowScaleX = config.shadowScaleX
        or config.shadow_scale_x

    levelEnd.shadowScaleY = config.shadowScaleY
        or config.shadow_scale_y

    levelEnd.shadowVisible = false
    levelEnd.shadowX = 0
    levelEnd.shadowY = 0	
----ТЕНЬ опционально


    levelEnd.vx = config.vx or config.speedX or config.speed_x or 0
    levelEnd.vy = config.vy or config.speedY or config.speed_y or 0

    levelEnd.active = config.active ~= false
    levelEnd.triggered = false

    -- Если nextTarget nil, World оставит старую victory/flow-логику.
    levelEnd.nextTarget = normalizeNextTarget(config)

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

-- Возвращает цель перехода после активации LevelEnd.
function LevelEnd:getNextTarget()
    return self.nextTarget
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
	
	Shadow.draw(self, camera)	

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