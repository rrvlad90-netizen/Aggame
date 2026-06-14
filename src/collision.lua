local Collision = {}

-- Возвращает true, если два прямоугольника пересекаются.
-- Все прямоугольники должны быть в формате:
-- {
--     x = 0,
--     y = 0,
--     w = 32,
--     h = 32
-- }
function Collision.intersects(a, b)
    if not a or not b then
        return false
    end

    if a.w <= 0 or a.h <= 0 then
        return false
    end

    if b.w <= 0 or b.h <= 0 then
        return false
    end

    return a.x < b.x + b.w
        and b.x < a.x + a.w
        and a.y < b.y + b.h
        and b.y < a.y + a.h
end

-- Возвращает true, если точка находится внутри прямоугольника.
function Collision.pointInRect(x, y, rect)
    if not rect then
        return false
    end

    return x >= rect.x
        and x <= rect.x + rect.w
        and y >= rect.y
        and y <= rect.y + rect.h
end

-- Преобразует локальный bbox entity в мировой прямоугольник.
-- bbox задаётся в координатах canvas.
-- entity.x/entity.y считаются игровой позицией anchor-точки.
-- entity.offset задаёт anchor внутри canvas.
function Collision.localBoxToWorld(entity, box)
    if not entity or not box then
        return {
            x = 0,
            y = 0,
            w = 0,
            h = 0
        }
    end

    local offset = entity.offset or {x = 0, y = 0}

    return {
        x = entity.x - offset.x + box.x,
        y = entity.y - offset.y + box.y,
        w = box.w,
        h = box.h
    }
end

-- Возвращает мировой bbox entity.
-- Если bbox отсутствует, возвращает пустой прямоугольник.
function Collision.getEntityBBox(entity)
    if not entity or not entity.bbox then
        return {
            x = 0,
            y = 0,
            w = 0,
            h = 0
        }
    end

    return Collision.localBoxToWorld(entity, entity.bbox)
end

-- Возвращает hitbox entity по имени.
-- Используется для melee-ударов и damageHitbox events.
function Collision.getNamedHitbox(entity, hitboxName)
    if not entity or not entity.hitboxes then
        return nil
    end

    return entity.hitboxes[hitboxName]
end

-- Преобразует hitbox в мировой прямоугольник с учётом facing.
-- Если actor смотрит вправо, hitbox остаётся как есть.
-- Если actor смотрит влево, hitbox зеркалится относительно canvas.
function Collision.hitboxToWorld(entity, hitbox)
    if not entity or not hitbox then
        return {
            x = 0,
            y = 0,
            w = 0,
            h = 0
        }
    end

    local canvas = entity.canvas or {width = 0, height = 0}
    local offset = entity.offset or {x = 0, y = 0}
    local facing = entity.facing or 1

    local localX = hitbox.x

    if facing < 0 then
        localX = canvas.width - hitbox.x - hitbox.w
    end

    return {
        x = entity.x - offset.x + localX,
        y = entity.y - offset.y + hitbox.y,
        w = hitbox.w,
        h = hitbox.h
    }
end

-- Возвращает true, если entity имеет непустой bbox.
function Collision.hasSolidBBox(entity)
    if not entity or not entity.bbox then
        return false
    end

    return entity.bbox.w > 0
        and entity.bbox.h > 0
end

return Collision