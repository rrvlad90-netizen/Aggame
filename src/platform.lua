local Render = require("src.render")

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
    config = config or {}

    local platform = setmetatable({}, Platform)
	
	platform.id = config.id or "platform" --чтобы debug мог писать имя платформы
    platform.x = config.x or 0
    platform.y = config.y or 0

    platform.w = config.w or config.width or 128
    platform.h = config.h or config.height or 24

    platform.solid = config.solid == true

    -- Линия, на которой стоят ноги игрока/актора.
    platform.walkOffsetY = config.walkOffsetY
        or config.walk_offset_y
        or 0

    platform.walkY = config.walkY
        or config.platformWalkY
        or platform.y + platform.walkOffsetY
		
		
-- Slope-платформа.(треугольная наклонная)
    -- Физика остаётся простой: bbox прямоугольный,
    -- но линия ног вычисляется по X между slopeLeftY и slopeRightY.
    platform.slope = config.slope == true
        or config.isSlope == true
        or config.is_slope == true

    platform.slopeLeftY = config.slopeLeftY
        or config.slope_left_y
        or platform.walkY

    platform.slopeRightY = config.slopeRightY
        or config.slope_right_y
        or platform.walkY

    platform.slopeBottomY = config.slopeBottomY
        or config.slope_bottom_y		

-- Если true, entity может зайти на slope сбоку,
    -- если его ноги рядом с линией slope.
    -- Если false, slope работает только как top-only поверхность.
    platform.slopeWalkOn = config.slopeWalkOn == true
        or config.slope_walk_on == true
        or config.walkOntoSlope == true
        or config.walk_onto_slope == true

    -- Насколько далеко по Y можно "подхватить" entity на slope.
    -- Чем больше число, тем легче зайти на крутой склон.
    platform.slopeStepHeight = config.slopeStepHeight
        or config.slope_step_height
        or 24

-- Визуальные параметры могут отличаться от физики.
    platform.visualY = config.visualY or config.visual_y or platform.y
    platform.visualHeight = config.visualHeight or config.visual_height or platform.h

    -- Смещение только картинки, не физики.
    -- Полезно для 3D-дороги: физика остаётся на y, а визуал можно поднять выше.
    platform.imageOffsetY = config.imageOffsetY
        or config.image_offset_y
        or 0

    platform.imagePath = config.image
    platform.image = loadImage(platform.imagePath)

    -- Скорость движения самой платформы по уровню.
    -- Если параметр не указан, платформа стоит на месте.
    platform.PlatformScrollSpeed = config.PlatformScrollSpeed
        or config.platformScrollSpeed
        or config.platform_scroll_speed
        or 0
				
-- Универсальная скорость платформы.
    -- vx/vy двигают физику платформы.
    -- platformScrollSpeed оставлен для совместимости и двигает платформу влево.
    platform.vx = config.vx
        or config.speedX
        or config.speed_x
        or 0

    platform.vy = config.vy
        or config.speedY
        or config.speed_y
        or 0

    -- Смещение платформы за последний кадр.
    -- Physics.resolvePlatforms использует deltaX, чтобы тянуть entity вместе с платформой.
    platform.deltaX = 0
    platform.deltaY = 0

    -- Запоминаем относительные смещения, чтобы при движении по Y
    -- walkY и visualY ехали вместе с физической платформой.
    platform.walkOffsetFromY = platform.walkY - platform.y
    platform.visualOffsetFromY = platform.visualY - platform.y		

    -- Скорость прокрутки картинки внутри платформы.
    -- Это только визуальный эффект, физику платформы не двигает.
    platform.imageScrollSpeed = config.imageScrollSpeed
        or config.image_scroll_speed
        or config.scrollSpeed
        or config.scroll_speed
        or 0

    platform.imageScrollDirection = config.imageScrollDirection
        or config.image_scroll_direction
        or config.scrollDirection
        or config.scroll_direction
        or "left"

    platform.scrollOffsetX = config.scrollOffsetX
        or config.scroll_offset_x
        or 0

    platform.scrollOffsetY = config.scrollOffsetY
        or config.scroll_offset_y
        or 0

    -- stretch = старое поведение, tile = картинка повторяется и может скроллиться.
    platform.imageDrawMode = config.imageDrawMode
        or config.image_draw_mode

    if not platform.imageDrawMode then
        if platform.imageScrollSpeed ~= 0 then
            platform.imageDrawMode = "tile"
        else
            platform.imageDrawMode = "stretch"
        end
    end

    platform.color = config.color or {0.45, 0.35, 0.25}

    return platform
end

-- Обновляет платформу.
-- Двигает физический bbox платформы через vx/vy.
-- Старый platformScrollSpeed сохранён: он двигает платформу влево.
-- imageScrollSpeed остаётся только визуальным скроллом картинки.
function Platform:update(dt)
    local previousX = self.x
    local previousY = self.y

    local platformScrollSpeed = self.PlatformScrollSpeed or 0

    -- Новый универсальный movement.
    self.x = self.x + (self.vx or 0) * dt
    self.y = self.y + (self.vy or 0) * dt

    -- Старое поведение сохраняем:
    -- platformScrollSpeed > 0 двигает платформу влево.
    if platformScrollSpeed ~= 0 then
        self.x = self.x - platformScrollSpeed * dt
    end

    self.deltaX = self.x - previousX
    self.deltaY = self.y - previousY

    -- Если платформа двигается по Y, линия ног должна ехать вместе с ней.
    self.walkY = self.y + (self.walkOffsetFromY or self.walkOffsetY or 0)

    -- visualY тоже держим относительно физического y.
    self.visualY = self.y + (self.visualOffsetFromY or 0)

    if Render and Render.updateScroll then
        Render.updateScroll(self, dt)
    end
end


-- Возвращает Y линии ног в указанной world-X позиции.
-- Для обычной платформы это просто walkY.
-- Для slope — интерполяция между slopeLeftY и slopeRightY.
function Platform:getWalkYAtX(worldX)
    if not self.slope then
        return self.walkY or self.y
    end

    if not self.w or self.w == 0 then
        return self.slopeLeftY or self.walkY or self.y
    end

    local t = ((worldX or self.x) - self.x) / self.w

    if t < 0 then
        t = 0
    elseif t > 1 then
        t = 1
    end

    local leftY = self.slopeLeftY or self.walkY or self.y
    local rightY = self.slopeRightY or self.walkY or self.y

    return leftY + (rightY - leftY) * t
end

-- Возвращает нижнюю Y-границу визуального slope-мокапа.
function Platform:getSlopeBottomY()
    if self.slopeBottomY then
        return self.slopeBottomY
    end

    local visualBottom = (self.visualY or self.y) + (self.visualHeight or self.h or 0)
    local slopeBottom = math.max(
        self.slopeLeftY or self.y,
        self.slopeRightY or self.y
    )

    return math.max(visualBottom, slopeBottom)
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

-- Проверяет пересечение по X.
function Platform:overlapsX(rect)
    return rect.x < self.x + self.w
        and rect.x + rect.w > self.x
end

-- Проверяет, может ли entity приземлиться на платформу сверху.
-- В новой системе entity.y — это точка ног.
function Platform:canLandEntity(entity, previousEntityY)
    local entityHitbox = entity:getHitbox()

    local previousFeetY = previousEntityY or entity.y
    local currentFeetY = entity.y
    local walkY = self:getWalkYAtX(entity.x)

    return (entity.vy or 0) >= 0
        and self:overlapsX(entityHitbox)
        and previousFeetY <= walkY
        and currentFeetY >= walkY
end

-- Ставит entity на платформу.
function Platform:landEntity(entity)
    local walkY = self:getWalkYAtX(entity.x)

    if entity.landOn then
        entity:landOn(walkY)
    else
        entity.y = walkY
        entity.vy = 0
        entity.onGround = true

        if entity.jumpCount ~= nil then
            entity.jumpCount = 0
        end
    end

    entity.onPlatform = true
    -- Если платформа движется, она немного тащит entity вместе с собой.
    entity.x = entity.x + (self.deltaX or 0)
end

-- Разруливает столкновение entity с платформой.
function Platform:resolveEntityCollision(entity, previousEntityX, previousEntityY)
    if not entity or entity.dead then
        return false
    end

    -- Сначала проверяем приземление сверху.
    -- Для этого не требуем полного пересечения hitbox:
    -- важно поймать момент, когда ноги пересекли walkY.
    if self:canLandEntity(entity, previousEntityY) then
        self:landEntity(entity)
        return true
    end

    -- Обычная платформа не блокирует сбоку и снизу.
    if not self.solid then
        return false
    end

    local entityHitbox = entity:getHitbox()
    local platformHitbox = self:getHitbox()

    local isOverlapping =
        entityHitbox.x < platformHitbox.x + platformHitbox.w
        and platformHitbox.x < entityHitbox.x + entityHitbox.w
        and entityHitbox.y < platformHitbox.y + platformHitbox.h
        and platformHitbox.y < entityHitbox.y + entityHitbox.h

    if not isOverlapping then
        return false
    end

    local previousHitbox = {
        x = previousEntityX or entity.x,
        y = previousEntityY or entity.y,
        w = entityHitbox.w,
        h = entityHitbox.h
    }

    -- Удар снизу.
    if (entity.vy or 0) < 0
        and previousHitbox.y >= platformHitbox.y + platformHitbox.h
    then
        entity.vy = 0
        return true
    end

    -- Боковые столкновения для solid-платформ.
    local hitboxOffsetX = entityHitbox.x - entity.x

    if previousHitbox.x + previousHitbox.w <= platformHitbox.x then
        entity.x = platformHitbox.x - hitboxOffsetX - entityHitbox.w
        entity.vx = 0
        return true
    end

    if previousHitbox.x >= platformHitbox.x + platformHitbox.w then
        entity.x = platformHitbox.x + platformHitbox.w - hitboxOffsetX
        entity.vx = 0
        return true
    end

    return true
end

-- Совместимость со старым именем.
function Platform:resolvePlayerCollision(player, previousPlayerX, previousPlayerY)
    return self:resolveEntityCollision(player, previousPlayerX, previousPlayerY)
end

-- Отрисовывает платформу: физический bbox остается на месте, картинку можно сместить отдельно.
function Platform:draw(camera)
    camera = camera or {x = 0, y = 0}

    local drawX = self.x - camera.x
    local drawY = self.visualY - camera.y
    local imageDrawY = self.visualY + (self.imageOffsetY or 0) - camera.y

    if self.image then
        love.graphics.setColor(1, 1, 1)

        if self.imageDrawMode == "tile" then
            Render.drawTiledImage(
                self.image,
                drawX,
                imageDrawY,
                self.w,
                self.visualHeight,
                self.scrollOffsetX or 0,
                self.scrollOffsetY or 0
            )

            return
        end

        local scaleX = self.w / self.image:getWidth()
        local scaleY = self.visualHeight / self.image:getHeight()

        love.graphics.draw(
            self.image,
            drawX,
            imageDrawY,
            0,
            scaleX,
            scaleY
        )

        love.graphics.setColor(1, 1, 1)
        return
    end

---наклонная (треугольная платформа)
if self.slope then
        local leftY = self.slopeLeftY or self.walkY or self.y
        local rightY = self.slopeRightY or self.walkY or self.y
        local bottomY = self:getSlopeBottomY()

        local x1 = self.x - camera.x
        local x2 = self.x + self.w - camera.x

        local yLeft = leftY - camera.y
        local yRight = rightY - camera.y
        local yBottom = bottomY - camera.y

        love.graphics.setColor(self.color)

        love.graphics.polygon(
            "fill",
            x1, yLeft,
            x2, yRight,
            x2, yBottom,
            x1, yBottom
        )

        love.graphics.setColor(0.1, 0.08, 0.05)
        love.graphics.polygon(
            "line",
            x1, yLeft,
            x2, yRight,
            x2, yBottom,
            x1, yBottom
        )

        love.graphics.setColor(1, 1, 1)
        return
    end
------------------------

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

return Platform