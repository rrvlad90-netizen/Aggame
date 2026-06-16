local Assets = require("src.assets")
local Config = require("src.config")
local Collision = require("src.collision")

local Render = {}

-- Преобразует мировую X-координату в экранную.
function Render.worldToScreenX(x, camera)
    return x - (camera and camera.x or 0)
end

-- Преобразует мировую Y-координату в экранную.
function Render.worldToScreenY(y, camera)
    return y - (camera and camera.y or 0)
end

-- Проверяет, находится ли прямоугольник около экрана.
-- Используется для простого off-camera culling.
function Render.isRectVisible(rect, camera, margin)
    margin = margin or 100

    local screenRect = {
        x = camera and camera.x or 0,
        y = camera and camera.y or 0,
        w = Config.screen.width,
        h = Config.screen.height
    }

    screenRect.x = screenRect.x - margin
    screenRect.y = screenRect.y - margin
    screenRect.w = screenRect.w + margin * 2
    screenRect.h = screenRect.h + margin * 2

    return Collision.intersects(rect, screenRect)
end

-- Рисует entity по системе canvas + offset.
-- entity.x/entity.y — позиция anchor-точки в мире.
-- entity.offset — точка anchor внутри canvas.
function Render.drawEntity(entity, camera)
    if not entity then
        return
    end

    if entity.hidden then
        return
    end

    local image = nil

    if entity.animationSet then
        Render.drawAnimatedEntity(entity, camera)
        return
    end

	if entity.image then
        image = Assets.getImage(entity.image)
    else
        image = Assets.getFallbackImage(
            entity.canvas and entity.canvas.width or 32,
            entity.canvas and entity.canvas.height or 32
        )
    end

    local offset = entity.offset or {x = 0, y = 0}
    local screenX = Render.worldToScreenX(entity.x, camera)
    local screenY = Render.worldToScreenY(entity.y, camera)

    local scaleX = entity.scaleX or entity.scale or 1
    local scaleY = entity.scaleY or entity.scale or 1

    local facing = entity.facing or 1
    local flipSprite = entity.flipSprite == true

    if facing < 0 then
        scaleX = -scaleX
    end

    if flipSprite then
        scaleX = -scaleX
    end

    love.graphics.setColor(1, 1, 1, entity.alpha or 1)
    love.graphics.draw(
        image,
        screenX,
        screenY,
        entity.rotation or 0,
        scaleX,
        scaleY,
        offset.x,
        offset.y
    )
    love.graphics.setColor(1, 1, 1)
end

-- Рисует entity, у которой есть animationSet.
function Render.drawAnimatedEntity(entity, camera)
    local offset = entity.offset or {x = 0, y = 0}
    local screenX = Render.worldToScreenX(entity.x, camera)
    local screenY = Render.worldToScreenY(entity.y, camera)

    local scaleX = entity.scaleX or entity.scale or 1
    local scaleY = entity.scaleY or entity.scale or 1

    local facing = entity.facing or 1
    local flipSprite = entity.flipSprite == true

    if facing < 0 then
        scaleX = -scaleX
    end

    if flipSprite then
        scaleX = -scaleX
    end

    entity.animationSet:draw(
        screenX,
        screenY,
        entity.rotation or 0,
        scaleX,
        scaleY,
        offset.x,
        offset.y,
        entity.alpha or 1
    )
end

-- Рисует список entity.
function Render.drawEntityList(entities, camera)
    for _, entity in ipairs(entities or {}) do
        Render.drawEntity(entity, camera)
    end
end

-- Рисует tiled background по X.
-- scrollFactor задаёт parallax:
-- 0.2 — дальний фон;
-- 1.0 — обычный слой;
-- 1.2 — передний слой.
function Render.drawTiledX(imagePath, camera, y, scrollFactor)
    local image = Assets.getImage(imagePath)
    local imageWidth = image:getWidth()
    local imageHeight = image:getHeight()

    local cameraX = camera and camera.x or 0
    local offsetX = -cameraX * (scrollFactor or 1)

    local startX = offsetX % imageWidth

    if startX > 0 then
        startX = startX - imageWidth
    end

    local x = startX

    love.graphics.setColor(1, 1, 1)

    while x < Config.screen.width do
        love.graphics.draw(image, x, y or 0)
        x = x + imageWidth
    end

    love.graphics.setColor(1, 1, 1)
end

-- Рисует debug-прямоугольник в мировых координатах.
function Render.drawWorldRect(rect, camera, color)
    if not rect then
        return
    end

    color = color or {1, 0, 0, 1}

    love.graphics.setColor(color)

    love.graphics.rectangle(
        "line",
        Render.worldToScreenX(rect.x, camera),
        Render.worldToScreenY(rect.y, camera),
        rect.w,
        rect.h
    )

    love.graphics.setColor(1, 1, 1)
end

-- Рисует debug bbox entity.
function Render.drawEntityBBox(entity, camera)
    local bbox = Collision.getEntityBBox(entity)

    Render.drawWorldRect(bbox, camera, {1, 0, 0, 1})
end

-- Рисует debug hitbox.
function Render.drawHitbox(hitbox, camera)
    Render.drawWorldRect(hitbox, camera, {1, 1, 0, 1})
end


-- Восстанавливает предыдущий scissor после временного clipping.
function Render.restoreScissor(x, y, w, h)
    if x then
        love.graphics.setScissor(x, y, w, h)
    else
        love.graphics.setScissor()
    end
end

-- Рисует image плиткой внутри screen-space прямоугольника.
-- offsetX/offsetY используются для визуального скролла текстуры.
function Render.drawTiledImage(image, x, y, w, h, offsetX, offsetY)
    if not image then
        return
    end

    local imageWidth = image:getWidth()
    local imageHeight = image:getHeight()

    if imageWidth <= 0 or imageHeight <= 0 then
        return
    end

    offsetX = offsetX or 0
    offsetY = offsetY or 0

    local oldX, oldY, oldW, oldH = love.graphics.getScissor()

    love.graphics.setScissor(x, y, w, h)

    local startX = -offsetX % imageWidth
    local startY = -offsetY % imageHeight

    if startX > 0 then
        startX = startX - imageWidth
    end

    if startY > 0 then
        startY = startY - imageHeight
    end

    local drawY = y + startY

    love.graphics.setColor(1, 1, 1)

    while drawY < y + h do
        local drawX = x + startX

        while drawX < x + w do
            love.graphics.draw(image, drawX, drawY)
            drawX = drawX + imageWidth
        end

        drawY = drawY + imageHeight
    end

    Render.restoreScissor(oldX, oldY, oldW, oldH)
    love.graphics.setColor(1, 1, 1)
end

-- Возвращает dx/dy для scroll direction.
function Render.getScrollDelta(direction, speed, dt)
    direction = direction or "left"
    speed = speed or 0

    if direction == "left" then
        return speed * dt, 0
    end

    if direction == "right" then
        return -speed * dt, 0
    end

    if direction == "up" then
        return 0, speed * dt
    end

    if direction == "down" then
        return 0, -speed * dt
    end

    return 0, 0
end

-- Обновляет scroll offsets у table-объекта.
-- Подходит для backgrounds и platforms.
function Render.updateScroll(target, dt)
    if not target then
        return
    end

    local speed = target.imageScrollSpeed
        or target.image_scroll_speed
        or target.scrollSpeed
        or target.scroll_speed
        or 0

    if speed == 0 then
        return
    end

    local direction = target.imageScrollDirection
        or target.image_scroll_direction
        or target.scrollDirection
        or target.scroll_direction
        or "left"

    local dx, dy = Render.getScrollDelta(direction, speed, dt)

    target.scrollOffsetX = (target.scrollOffsetX or target.scroll_offset_x or 0) + dx
    target.scrollOffsetY = (target.scrollOffsetY or target.scroll_offset_y or 0) + dy
end

-- Рисует слой background с поддержкой offsetY, scaleX и визуального скролла.
function Render.drawBackgroundLayer(background, camera)
    if not background then
        return
    end

    local image = Assets.getImage(background.image)

    local scrollFactor = background.scrollFactor
        or background.scroll_factor
        or 1

    local x = background.x or 0
    local y = background.y or 0

    local offsetY = background.offsetY
        or background.offset_y
        or 0

    local scaleX = background.scaleX
        or background.scale_x
        or 1

    local scaleY = background.scaleY
        or background.scale_y
        or 1

    local cameraX = camera and camera.x or 0
    local cameraY = camera and camera.y or 0

    local drawX = x - cameraX * scrollFactor
    local drawY = y + offsetY - cameraY * scrollFactor

    local textureOffsetX = cameraX * scrollFactor
        + (background.scrollOffsetX or background.scroll_offset_x or 0)

    local textureOffsetY = background.scrollOffsetY
        or background.scroll_offset_y
        or 0

    if background.imageDrawMode == "tile" or background.image_draw_mode == "tile" then
        local width = background.width
            or background.w
            or Config.screen.width

        local height = background.height
            or background.h
            or Config.screen.height

        Render.drawTiledImage(
            image,
            drawX,
            drawY,
            width,
            height,
            textureOffsetX,
            textureOffsetY
        )

        return
    end

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(
        image,
        drawX,
        drawY,
        0,
        scaleX,
        scaleY
    )

    love.graphics.setColor(1, 1, 1)
end

-- Рисует debug-точку в мировых координатах.
function Render.drawWorldPoint(x, y, camera, color, radius)
    color = color or {0.6, 1, 0.2, 1}
    radius = radius or 3

    love.graphics.setColor(color)
    love.graphics.circle(
        "fill",
        Render.worldToScreenX(x, camera),
        Render.worldToScreenY(y, camera),
        radius
    )
    love.graphics.setColor(1, 1, 1)
end

-- Рисует debug-текст в мировых координатах.
function Render.drawWorldText(text, x, y, camera, color)
    if not text then
        return
    end

    color = color or {1, 1, 1, 1}

    love.graphics.setColor(color)
    love.graphics.print(
        tostring(text),
        Render.worldToScreenX(x, camera),
        Render.worldToScreenY(y, camera)
    )
    love.graphics.setColor(1, 1, 1)
end

-- Рисует debug decor: центр, anchor-точку, примерный rect и имя.
function Render.drawDecorDebug(decor, camera)
    if not decor then
        return
    end

    local canvas = decor.canvas or {}
    local offset = decor.offset or {}

    local width = canvas.width or canvas.w or 0
    local height = canvas.height or canvas.h or 0

    local offsetX = offset.x or 0
    local offsetY = offset.y or 0

    local rect = {
        x = decor.x - offsetX,
        y = decor.y - offsetY,
        w = width,
        h = height
    }

    local centerX = rect.x + rect.w / 2
    local centerY = rect.y + rect.h / 2

    -- Серый rect — примерная визуальная область decor.
    Render.drawWorldRect(rect, camera, {0.65, 0.65, 0.65, 0.9})

    -- Салатовая точка — центр decor.
    Render.drawWorldPoint(centerX, centerY, camera, {0.6, 1, 0.2, 1}, 3)

    -- Белая точка — реальная anchor-позиция decor.x/decor.y.
    Render.drawWorldPoint(decor.x, decor.y, camera, {1, 1, 1, 1}, 2)

    Render.drawWorldText(
        decor.id or decor.name or "decor",
        centerX + 5,
        centerY - 10,
        camera,
        {0.8, 1, 0.8, 1}
    )
end

-- Рисует debug платформы: физический bbox, visual rect, walkY и размеры.
function Render.drawPlatformDebug(platform, camera)
    if not platform then
        return
    end

    local physicalRect = {
        x = platform.x or 0,
        y = platform.y or 0,
        w = platform.w or 0,
        h = platform.h or 0
    }

    local visualRect = {
        x = platform.x or 0,
        y = platform.visualY or platform.y or 0,
        w = platform.w or 0,
        h = platform.visualHeight or platform.h or 0
    }

    local walkY = platform.walkY or platform.y or 0

    -- Голубой rect — настоящая физика платформы.
    Render.drawWorldRect(physicalRect, camera, {0, 0.9, 1, 1})

    -- Синий rect — визуальная область картинки, если она отличается от физики.
    if visualRect.y ~= physicalRect.y or visualRect.h ~= physicalRect.h then
        Render.drawWorldRect(visualRect, camera, {0.2, 0.35, 1, 0.9})
    end

    -- Салатовая линия — линия, на которой стоят ноги.
    love.graphics.setColor(0.6, 1, 0.2, 1)
    love.graphics.line(
        Render.worldToScreenX(physicalRect.x, camera),
        Render.worldToScreenY(walkY, camera),
        Render.worldToScreenX(physicalRect.x + physicalRect.w, camera),
        Render.worldToScreenY(walkY, camera)
    )
    love.graphics.setColor(1, 1, 1)

    Render.drawWorldPoint(
        physicalRect.x + physicalRect.w / 2,
        walkY,
        camera,
        {0.6, 1, 0.2, 1},
        3
    )

    Render.drawWorldText(
        string.format(
            "%s x:%d y:%d w:%d h:%d walkY:%d",
            platform.id or "platform",
            physicalRect.x,
            physicalRect.y,
            physicalRect.w,
            physicalRect.h,
            walkY
        ),
        physicalRect.x,
        physicalRect.y - 16,
        camera,
        {0, 1, 1, 1}
    )
end

return Render