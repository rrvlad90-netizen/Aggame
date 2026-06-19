local Assets = require("src.assets")
local Collision = require("src.collision")

local Shadow = {}

-- Возвращает тип тени entity.
function Shadow.getType(entity)
    if not entity then
        return 0
    end

    return entity.shadowType
        or entity.shadow_type
        or 0
end

-- Возвращает alpha тени.
function Shadow.getAlpha(entity)
    return entity.shadowAlpha
        or entity.shadow_alpha
        or 0.3
end

-- Возвращает текущую картинку entity для silhouette-тени.
function Shadow.getEntityImage(entity)
    if not entity then
        return nil
    end

    if entity.animationSet then
        local animation = entity.animationSet:getCurrent()

        if animation and animation.getCurrentImage then
            return animation:getCurrentImage()
        end
    end

    if entity.image then
        return Assets.getImage(entity.image)
    end

    if entity.canvas then
        return Assets.getFallbackImage(
            entity.canvas.width or 32,
            entity.canvas.height or 32
        )
    end

    return nil
end

-- Ищет ближайшую платформу под entity.
-- Тень появляется только если центр entity по X находится над платформой.
function Shadow.findPlatformBelow(entity, level)
    if not entity or not level or not entity.getHitbox then
        return nil
    end

    local bbox = entity:getHitbox()
    local centerX = bbox.x + bbox.w / 2 + (entity.shadowCastOffsetX or entity.shadow_cast_offset_x or 0)
    local bottomY = bbox.y + bbox.h

    local bestPlatform = nil
    local bestY = nil

    for _, platform in ipairs(level.platforms or {}) do
        if platform.getHitbox then
            local platformBox = platform:getHitbox()
            local platformTop = platform.walkY or platformBox.y

            local insideX = centerX >= platformBox.x
                and centerX <= platformBox.x + platformBox.w

            -- Небольшой допуск нужен, чтобы стоящий на платформе actor не терял тень
            -- из-за погрешности в 1-2 пикселя.
            local isBelow = platformTop >= bottomY - 8

            if insideX and isBelow then
                if not bestY or platformTop < bestY then
                    bestY = platformTop
                    bestPlatform = platform
                end
            end
        end
    end

    return bestPlatform, bestY
end

-- Обновляет вычисленную позицию тени entity.
function Shadow.update(entity, level)
    if not entity then
        return
    end

    if Shadow.getType(entity) == 0 then
        entity.shadowVisible = false
        return
    end

    local platform, platformY = Shadow.findPlatformBelow(entity, level)

    if not platform or not platformY then
        entity.shadowVisible = false
        return
    end

    local bbox = entity:getHitbox()
    local centerX = bbox.x + bbox.w / 2

    entity.shadowVisible = true
    entity.shadowX = centerX + (entity.shadowOffsetX or entity.shadow_offset_x or 0)
    entity.shadowY = platformY + (entity.shadowOffsetY or entity.shadow_offset_y or 0)
end

-- Рисует простую oval-тень.
function Shadow.drawOval(entity, camera)
    local canvas = entity.canvas or {}
    local bbox = entity.getHitbox and entity:getHitbox() or nil

    local baseWidth = canvas.width or (bbox and bbox.w) or 32
    local baseHeight = canvas.height or (bbox and bbox.h) or 32

    local width = entity.shadowWidth
        or entity.shadow_width
        or baseWidth * 0.65

    local height = entity.shadowHeight
        or entity.shadow_height
        or math.max(4, baseHeight * 0.12)

    local cameraX = camera and camera.x or 0
    local cameraY = camera and camera.y or 0

    local screenX = entity.shadowX - cameraX
    local screenY = entity.shadowY - cameraY

    love.graphics.setColor(0, 0, 0, Shadow.getAlpha(entity))
    love.graphics.ellipse("fill", screenX, screenY, width / 2, height / 2)
    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует silhouette-тень текущего sprite/animation.
function Shadow.drawSilhouette(entity, camera)
    local image = Shadow.getEntityImage(entity)

    if not image then
        Shadow.drawOval(entity, camera)
        return
    end

    local cameraX = camera and camera.x or 0
    local cameraY = camera and camera.y or 0

    local screenX = entity.shadowX - cameraX
    local screenY = entity.shadowY - cameraY

    local offset = entity.offset or {x = 0, y = 0}

    local scaleX = entity.shadowScaleX
        or entity.shadow_scale_x
        or entity.scaleX
        or entity.scale
        or 1

    local scaleY = entity.shadowScaleY
        or entity.shadow_scale_y
        or 0.16

    local facing = entity.facing or 1
    local flipSprite = entity.flipSprite == true

    if facing < 0 then
        scaleX = -scaleX
    end

    if flipSprite then
        scaleX = -scaleX
    end

    love.graphics.setColor(0, 0, 0, Shadow.getAlpha(entity))
    love.graphics.draw(
        image,
        screenX,
        screenY,
        entity.shadowRotation or entity.shadow_rotation or 0,
        scaleX,
        scaleY,
        offset.x,
        offset.y
    )
    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует тень entity.
function Shadow.draw(entity, camera)
    if not entity or entity.hidden then
        return
    end

    if not entity.shadowVisible then
        return
    end

    local shadowType = Shadow.getType(entity)

    if shadowType == 1 then
        Shadow.drawOval(entity, camera)
        return
    end

    if shadowType == -1 then
        Shadow.drawSilhouette(entity, camera)
        return
    end
end

return Shadow