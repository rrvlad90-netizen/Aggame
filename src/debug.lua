local Config = require("src.config")
local Render = require("src.render")

local Debug = {}

local activeHitboxes = {}

local COLORS = {
    bbox = {0.1, 1.0, 0.1, 0.9},
    hitbox = {1.0, 0.15, 0.1, 0.9},
    hitboxFill = {1.0, 0.15, 0.1, 0.18},
    origin = {0.65, 1.0, 0.1, 1.0},
    text = {1.0, 1.0, 1.0, 1.0},
    textShadow = {0.0, 0.0, 0.0, 0.8}
}

-- Возвращает текущее время Love2D.
-- Используется, чтобы коротко подсвечивать активные hitboxes.
local function getTime()
    if love and love.timer then
        return love.timer.getTime()
    end

    return 0
end

-- Создаёт копию rect, чтобы debug-хитбокс не зависел от дальнейших изменений entity.
local function copyRect(rect)
    if not rect then
        return nil
    end

    return {
        x = rect.x,
        y = rect.y,
        w = rect.w,
        h = rect.h
    }
end

-- Переключает debug-режим целиком.
function Debug.toggle()
    Config.debug.enabled = not Config.debug.enabled

    Config.debug.drawBboxes = Config.debug.enabled
    Config.debug.drawHitboxes = Config.debug.enabled
    Config.debug.drawOrigins = Config.debug.enabled
    Config.debug.drawNames = Config.debug.enabled
end

-- Возвращает отображаемое имя entity для debug-подписи.
function Debug.getEntityName(entity)
    if not entity then
        return "nil"
    end

    local entityType = entity.entityType or "entity"
    local id = entity.id or entity.name or "unknown"

    return entityType .. ":" .. id
end

-- Регистрирует активный damage hitbox.
-- Используется для melee/attack событий, которые существуют только один кадр.
function Debug.recordHitbox(owner, hitbox, label, duration)
    if not Config.debug.enabled then
        return
    end

    if not hitbox then
        return
    end

    local rect = copyRect(hitbox)

    if not rect or rect.w <= 0 or rect.h <= 0 then
        return
    end

    table.insert(activeHitboxes, {
        owner = owner,
        rect = rect,
        label = label or Debug.getEntityName(owner),
        expiresAt = getTime() + (duration or Config.debug.hitboxFlashDuration or 0.12)
    })
end

-- Удаляет debug-hitboxes, время показа которых истекло.
function Debug.pruneActiveHitboxes()
    local now = getTime()

    for index = #activeHitboxes, 1, -1 do
        if activeHitboxes[index].expiresAt <= now then
            table.remove(activeHitboxes, index)
        end
    end
end

-- Возвращает screen-space координату X.
function Debug.toScreenX(x, camera)
    return Render.worldToScreenX(x, camera)
end

-- Возвращает screen-space координату Y.
function Debug.toScreenY(y, camera)
    return Render.worldToScreenY(y, camera)
end

-- Рисует прямоугольник в мировых координатах.
function Debug.drawRect(rect, camera, color)
    if not rect then
        return
    end

    if rect.w <= 0 or rect.h <= 0 then
        return
    end

    Render.drawWorldRect(rect, camera, color)
end

-- Рисует полупрозрачную заливку прямоугольника в мировых координатах.
function Debug.drawFilledRect(rect, camera, color)
    if not rect then
        return
    end

    if rect.w <= 0 or rect.h <= 0 then
        return
    end

    love.graphics.setColor(color)
    love.graphics.rectangle(
        "fill",
        Debug.toScreenX(rect.x, camera),
        Debug.toScreenY(rect.y, camera),
        rect.w,
        rect.h
    )
    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует bbox entity зелёным прямоугольником.
function Debug.drawBbox(entity, camera)
    if not Config.debug.drawBboxes then
        return
    end

    if not entity or not entity.getHitbox then
        return
    end

    Debug.drawRect(entity:getHitbox(), camera, COLORS.bbox)
end

-- Рисует damage hitbox effect-а, только если effect сейчас может наносить урон.
function Debug.drawEffectHitbox(effect, camera)
    if not effect or not effect.getDamageHitbox then
        return
    end

    if effect.canApplyDamage and not effect:canApplyDamage() then
        return
    end

    local hitbox = effect:getDamageHitbox()

    Debug.drawFilledRect(hitbox, camera, COLORS.hitboxFill)
    Debug.drawRect(hitbox, camera, COLORS.hitbox)
end

-- Рисует hitbox projectile-а.
-- У projectile bbox одновременно является collision/damage hitbox.
function Debug.drawProjectileHitbox(projectile, camera)
    if not projectile or not projectile.getHitbox then
        return
    end

    if projectile.dead then
        return
    end

    local hitbox = projectile:getHitbox()

    Debug.drawFilledRect(hitbox, camera, COLORS.hitboxFill)
    Debug.drawRect(hitbox, camera, COLORS.hitbox)
end

-- Рисует постоянные active hitboxes для entity-типов, у которых hitbox живёт вместе с entity.
-- Для player/actor здесь ничего не рисуем: их attack hitbox приходит через recordHitbox.
function Debug.drawEntityHitboxes(entity, camera)
    if not Config.debug.drawHitboxes then
        return
    end

    if not entity then
        return
    end

    if entity.entityType == "effect" then
        Debug.drawEffectHitbox(entity, camera)
        return
    end

    if entity.entityType == "projectile" then
        Debug.drawProjectileHitbox(entity, camera)
        return
    end
end

-- Рисует временные hitboxes, зарегистрированные через Debug.recordHitbox.
function Debug.drawRecordedHitboxes(camera)
    if not Config.debug.drawHitboxes then
        return
    end

    Debug.pruneActiveHitboxes()

    for _, entry in ipairs(activeHitboxes) do
        Debug.drawFilledRect(entry.rect, camera, COLORS.hitboxFill)
        Debug.drawRect(entry.rect, camera, COLORS.hitbox)

        love.graphics.setColor(COLORS.textShadow)
        love.graphics.print(
            entry.label,
            Debug.toScreenX(entry.rect.x, camera) + 1,
            Debug.toScreenY(entry.rect.y, camera) - 13
        )

        love.graphics.setColor(COLORS.text)
        love.graphics.print(
            entry.label,
            Debug.toScreenX(entry.rect.x, camera),
            Debug.toScreenY(entry.rect.y, camera) - 14
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует центр ног entity.
-- Для actor/player берём нижний центр физического bbox.
-- Если bbox нет, fallback — anchor-точка x/y.
function Debug.drawOrigin(entity, camera)
    if not Config.debug.drawOrigins then
        return
    end

    if not entity then
        return
    end

    local x = entity.x
    local y = entity.y

    if entity.getHitbox then
        local bbox = entity:getHitbox()

        if bbox and bbox.w > 0 and bbox.h > 0 then
            x = bbox.x + bbox.w / 2
            y = bbox.y + bbox.h
        end
    end

    if not x or not y then
        return
    end

    local screenX = Debug.toScreenX(x, camera)
    local screenY = Debug.toScreenY(y, camera)

    love.graphics.setColor(COLORS.origin)
    love.graphics.circle("fill", screenX, screenY, 4)
    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует название entity рядом с anchor-точкой.
function Debug.drawName(entity, camera)
    if not Config.debug.drawNames then
        return
    end

    if not entity or not entity.x or not entity.y then
        return
    end

    local text = Debug.getEntityName(entity)
    local screenX = Debug.toScreenX(entity.x, camera) + 6
    local screenY = Debug.toScreenY(entity.y, camera) - 18

    love.graphics.setColor(COLORS.textShadow)
    love.graphics.print(text, screenX + 1, screenY + 1)

    love.graphics.setColor(COLORS.text)
    love.graphics.print(text, screenX, screenY)

    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует полный debug-оверлей одной entity.
function Debug.drawEntity(entity, camera)
    if not Config.debug.enabled then
        return
    end

    Debug.drawBbox(entity, camera)
    Debug.drawEntityHitboxes(entity, camera)
    Debug.drawOrigin(entity, camera)
    Debug.drawName(entity, camera)
end

-----ПЛТФОРМЫ 

-- Переводит мировую X-координату в экранную для debug-отрисовки.
local function debugScreenX(x, camera)
    return (x or 0) - (camera and camera.x or 0)
end

-- Переводит мировую Y-координату в экранную для debug-отрисовки.
local function debugScreenY(y, camera)
    return (y or 0) - (camera and camera.y or 0)
end

-- Рисует debug-прямоугольник в мировых координатах.
local function drawDebugRect(rect, camera, color)
    if not rect then
        return
    end

    color = color or {1, 1, 1, 1}

    love.graphics.setColor(color)
    love.graphics.rectangle(
        "line",
        debugScreenX(rect.x, camera),
        debugScreenY(rect.y, camera),
        rect.w or 0,
        rect.h or 0
    )
    love.graphics.setColor(1, 1, 1)
end

-- Рисует debug-точку в мировых координатах.
local function drawDebugPoint(x, y, camera, color, radius)
    color = color or {0.6, 1, 0.2, 1}
    radius = radius or 3

    love.graphics.setColor(color)
    love.graphics.circle(
        "fill",
        debugScreenX(x, camera),
        debugScreenY(y, camera),
        radius
    )
    love.graphics.setColor(1, 1, 1)
end

-- Рисует debug-текст в мировых координатах.
local function drawDebugText(text, x, y, camera, color)
    if not text then
        return
    end

    color = color or {1, 1, 1, 1}

    love.graphics.setColor(color)
    love.graphics.print(
        tostring(text),
        debugScreenX(x, camera),
        debugScreenY(y, camera)
    )
    love.graphics.setColor(1, 1, 1)
end

-- Рисует debug для платформы: реальную физику, visual rect и walkY.
function Debug.drawPlatform(platform, camera)
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

    -- Голубой — реальный физический bbox платформы.
    drawDebugRect(physicalRect, camera, {0, 0.9, 1, 1})

    -- Синий — визуальный размер платформы, если он отличается от физики.
    if visualRect.y ~= physicalRect.y or visualRect.h ~= physicalRect.h then
        drawDebugRect(visualRect, camera, {0.2, 0.35, 1, 1})
    end

    -- Салатовая линия — линия, на которой стоят ноги.
    love.graphics.setColor(0.6, 1, 0.2, 1)
    love.graphics.line(
        debugScreenX(physicalRect.x, camera),
        debugScreenY(walkY, camera),
        debugScreenX(physicalRect.x + physicalRect.w, camera),
        debugScreenY(walkY, camera)
    )
    love.graphics.setColor(1, 1, 1)

    drawDebugPoint(
        physicalRect.x + physicalRect.w / 2,
        walkY,
        camera,
        {0.6, 1, 0.2, 1},
        3
    )

    drawDebugText(
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

-- Рисует debug для decor: примерный rect, центр, anchor и имя.
function Debug.drawDecor(decor, camera)
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
        x = (decor.x or 0) - offsetX,
        y = (decor.y or 0) - offsetY,
        w = width,
        h = height
    }

    local centerX = rect.x + rect.w / 2
    local centerY = rect.y + rect.h / 2

    -- Серый — примерная визуальная область decor.
    drawDebugRect(rect, camera, {0.65, 0.65, 0.65, 1})

    -- Салатовый — центр decor.
    drawDebugPoint(centerX, centerY, camera, {0.6, 1, 0.2, 1}, 3)

    -- Белый — anchor decor.x/decor.y.
    drawDebugPoint(decor.x or 0, decor.y or 0, camera, {1, 1, 1, 1}, 2)

    drawDebugText(
        decor.id or decor.name or "decor",
        centerX + 5,
        centerY - 10,
        camera,
        {0.8, 1, 0.8, 1}
    )
end
-------------




-- Рисует debug-оверлей для всех runtime entity в world.
function Debug.drawWorld(world)
    if not Config.debug.enabled then
        return
    end

    if not world then
        return
    end

    local camera = world.camera

    if world.player then
        Debug.drawEntity(world.player, camera)
    end

    for _, actor in ipairs(world.actors or {}) do
        Debug.drawEntity(actor, camera)
    end

    for _, effect in ipairs(world.effects or {}) do
        Debug.drawEntity(effect, camera)
    end

    for _, projectile in ipairs(world.projectiles or {}) do
        Debug.drawEntity(projectile, camera)
    end

    if world.level then
        for _, platform in ipairs(world.level.platforms or {}) do
            Debug.drawPlatform(platform, camera)
        end

        for _, decor in ipairs(world.level.decors or {}) do
            Debug.drawDecor(decor, camera)
        end
    end

    Debug.drawRecordedHitboxes(camera)
end

return Debug