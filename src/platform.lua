local Platform = {}
Platform.__index = Platform

-- Проверяем, существует ли файл внутри Love2D-проекта.
local function fileExists(path)
    return path and love.filesystem.getInfo(path) ~= nil
end

-- Безопасно загружаем картинку платформы.
local function loadImage(path)
    if fileExists(path) then
        return love.graphics.newImage(path)
    end

    return nil
end

function Platform:new(config)
    local platform = setmetatable({}, Platform)

    config = config or {}

    platform.x = config.x or 0
    platform.y = config.y or 0
    platform.w = config.w or config.width or 160
    platform.h = config.h or config.height or 24

    -- walkY — линия, на которой стоят ноги игрока/актора.
    -- Если не указана, используем y платформы.
    platform.walkY = config.walkY or config.walk_y or platform.y

    -- Визуальные параметры могут отличаться от физики.
    platform.visualY = config.visualY or config.visual_y or platform.y
    platform.visualHeight = config.visualHeight or config.visual_height or platform.h

    platform.imagePath = config.image
    platform.image = loadImage(platform.imagePath)

    platform.color = config.color or {0.45, 0.35, 0.25}

    -- Скорость движения платформы.
    -- Положительное значение двигает платформу влево.
	platform.PlatformScrollSpeed = config.PlatformScrollSpeed
		or config.platformScrollSpeed
		or 0

    -- solid = true означает возвышенность/стену:
    -- через неё нельзя проходить сбоку.
    platform.solid = config.solid == true

    -- oneWay = true означает обычную платформу:
    -- на неё можно приземлиться сверху, но снизу/сбоку она не мешает.
    platform.oneWay = config.oneWay

    if platform.oneWay == nil then
        platform.oneWay = not platform.solid
    end

    -- Если 0 — не удалять за экраном.
    platform.DissaperWheOutOfScreen = config.DissaperWheOutOfScreen
        or config.disappearWhenOutOfScreen
        or 100

    return platform
end

-- Обновляет движение платформы.
function Platform:update(dt)
    self.x = self.x - self.PlatformScrollSpeed * dt
end

-- Проверяет, вышла ли платформа за экран.
function Platform:isOffscreen()
    if self.DissaperWheOutOfScreen == 0 then
        return false
    end

    local screenWidth = love.graphics.getWidth()
    local margin = self.DissaperWheOutOfScreen

    return self.x + self.w < -margin
        or self.x > screenWidth + margin
end

-- Можно ли удалить платформу.
function Platform:isRemovable()
    return self:isOffscreen()
end

-- Физический hitbox платформы.
function Platform:getHitbox()
    return {
        x = self.x,
        y = self.y,
        w = self.w,
        h = self.h
    }
end

-- Проверяет, пересекаются ли два прямоугольника.
local function rectsOverlap(a, b)
    return a.x < b.x + b.w
        and b.x < a.x + a.w
        and a.y < b.y + b.h
        and b.y < a.y + a.h
end

-- Ставит игрока/актора на верх платформы и сбрасывает прыжок.
local function landEntityOnPlatform(entity, platformTop)
    if entity.landOn then
        entity:landOn(platformTop)
        return
    end

    entity.y = platformTop - entity.h
    entity.vy = 0
    entity.onGround = true

    entity.jumpCount = 0
    entity.jumpsUsed = 0

    if entity.setState and entity.state == "jump" then
        entity:setState("idle")
    end
end

-- Разруливает столкновение игрока с платформой.
-- previousPlayerX/previousPlayerY нужны, чтобы понять,
-- откуда игрок пришёл: сверху, снизу или сбоку.
function Platform:resolvePlayerCollision(player, previousPlayerX, previousPlayerY)
    if not player or player.dead then
        return false
    end

    local playerHitbox = player:getHitbox()
    local platformHitbox = self:getHitbox()

    if not rectsOverlap(playerHitbox, platformHitbox) then
        return false
    end

    local previousHitbox = {
        x = previousPlayerX or player.x,
        y = previousPlayerY or player.y,
        w = player.w,
        h = player.h
    }

    local platformTop = self.walkY or self.y

    -- Приземление сверху.
    -- Работает и для обычной платформы, и для solid-возвышенности.
    local wasAbovePlatform = previousHitbox.y + previousHitbox.h <= platformTop
    local isFalling = (player.vy or 0) >= 0

    if wasAbovePlatform and isFalling then
        landEntityOnPlatform(player, platformTop)
        return true
    end

    -- Обычная oneWay-платформа не мешает сбоку и снизу.
    if self.oneWay and not self.solid then
        return false
    end

    -- Дальше логика только для solid-возвышенности.
    if not self.solid then
        return false
    end

    -- Удар снизу.
    if previousHitbox.y >= platformHitbox.y + platformHitbox.h then
        player.y = platformHitbox.y + platformHitbox.h
        player.vy = math.max(0, player.vy or 0)
        return true
    end

    -- Упёрся в левую сторону возвышенности.
    if previousHitbox.x >= platformHitbox.x + platformHitbox.w then
        player.x = platformHitbox.x + platformHitbox.w
        return true
    end

    -- Упёрся в правую сторону возвышенности.
    if previousHitbox.x + previousHitbox.w <= platformHitbox.x then
        player.x = platformHitbox.x - player.w
        return true
    end

    return false
end

-- Отрисовка платформы.
function Platform:draw(camera)
    camera = camera or {x = 0, y = 0}

    local drawX = self.x - camera.x
    local drawY = self.visualY - camera.y

    if self.image then
        love.graphics.setColor(1, 1, 1)

        local scaleX = self.w / self.image:getWidth()
        local scaleY = self.visualHeight / self.image:getHeight()

        love.graphics.draw(
            self.image,
            drawX,
            drawY,
            0,
            scaleX,
            scaleY
        )

        return
    end

    love.graphics.setColor(self.color)
    love.graphics.rectangle(
        "fill",
        drawX,
        drawY,
        self.w,
        self.visualHeight
    )

    love.graphics.setColor(0.1, 0.08, 0.05)
    love.graphics.rectangle(
        "line",
        self.x - camera.x,
        self.y - camera.y,
        self.w,
        self.h
    )

    love.graphics.setColor(1, 1, 1)
end

return Platform