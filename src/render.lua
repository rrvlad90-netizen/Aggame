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
        image = Assets.createFallbackImage(
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

return Render