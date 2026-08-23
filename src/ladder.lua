local Assets = require("src.assets")
local Render = require("src.render")

local Ladder = {}
Ladder.__index = Ladder

-- Создаёт лестницу из конфигурации уровня.
function Ladder:new(config)
    config = config or {}

    local ladder = setmetatable({}, Ladder)

    ladder.id = config.id or "ladder"
    ladder.entityType = "ladder"

    -- x/y — левый верхний угол лестницы.
    ladder.x = config.x or 0
    ladder.y = config.y or 0

    ladder.w = config.w or config.width or 48
    ladder.h = config.h or config.height or 160

    ladder.climbSpeed = config.climbSpeed
        or config.climb_speed
        or 120

    -- Допуск для входа на лестницу сверху и снизу.
    ladder.entryMargin = config.entryMargin
        or config.entry_margin
        or 12

    ladder.layer = config.layer or "middle"
    ladder.imagePath = config.image
    ladder.image = nil

    ladder.color = config.color or {
        0.65,
        0.48,
        0.25,
        1
    }

    ladder.railWidth = config.railWidth
        or config.rail_width
        or 5

    ladder.stepHeight = config.stepHeight
        or config.step_height
        or 20

    ladder.hidden = config.hidden == true

    ladder.canvas = {
        width = ladder.w,
        height = ladder.h
    }

    ladder.offset = {
        x = 0,
        y = 0
    }

    ladder.bbox = {
        x = 0,
        y = 0,
        w = ladder.w,
        h = ladder.h
    }

    ladder.shadowType = 0

    if ladder.imagePath
        and love.filesystem.getInfo(ladder.imagePath)
    then
        ladder.image = Assets.getImage(ladder.imagePath)
    end

    return ladder
end

-- Возвращает область лестницы в мировых координатах.
function Ladder:getHitbox()
    return {
        x = self.x,
        y = self.y,
        w = self.w,
        h = self.h
    }
end

-- Проверяет, может ли игрок использовать лестницу.
-- Игрок не притягивается к центру: его точка ног должна находиться по ширине лестницы.
function Ladder:canUse(player)
    if not player or player.dead then
        return false
    end

    local margin = self.entryMargin or 0
    local footX = player.x
    local footY = player.y

    local insideX = footX >= self.x
        and footX <= self.x + self.w

    local insideY = footY >= self.y - margin
        and footY <= self.y + self.h + margin

    return insideX and insideY
end

-- Обновляет лестницу.
function Ladder:update(dt, world)
    -- Пока лестница не имеет собственного runtime-состояния.
end

-- Рисует лестницу картинкой или простыми перекладинами.
function Ladder:draw(camera)
    if self.hidden then
        return
    end

    local screenX = Render.worldToScreenX(self.x, camera)
    local screenY = Render.worldToScreenY(self.y, camera)

    if self.image then
        local imageWidth = self.image:getWidth()
        local imageHeight = self.image:getHeight()

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            self.image,
            screenX,
            screenY,
            0,
            self.w / imageWidth,
            self.h / imageHeight
        )
        love.graphics.setColor(1, 1, 1, 1)

        return
    end

    local railWidth = self.railWidth
    local leftRailX = screenX
    local rightRailX = screenX + self.w - railWidth

    love.graphics.setColor(self.color)

    love.graphics.rectangle(
        "fill",
        leftRailX,
        screenY,
        railWidth,
        self.h
    )

    love.graphics.rectangle(
        "fill",
        rightRailX,
        screenY,
        railWidth,
        self.h
    )

    local stepY = screenY + self.stepHeight

    while stepY < screenY + self.h do
        love.graphics.rectangle(
            "fill",
            screenX,
            stepY,
            self.w,
            math.max(2, railWidth * 0.6)
        )

        stepY = stepY + self.stepHeight
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return Ladder