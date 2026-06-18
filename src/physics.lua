local Config = require("src.config")

local Physics = {}

-- Приземляет entity на указанную позицию.
-- Для Player вызывает landOn, чтобы сбросить vy, onGround и jumpCount.
-- Для Actor делает то же самое вручную.
local function landEntity(entity, groundY)
    if entity.landOn then
        entity:landOn(groundY)
        return
    end

    entity.y = groundY
    entity.vy = 0
    entity.onGround = true
    entity.jumpCount = 0
    entity.jumpsUsed = 0
end

-- Возвращает прошлую нижнюю грань bbox.
-- Это нужно, чтобы ловить пересечение платформы даже при быстром падении.
local function getPreviousBottom(entity, currentBottom)
    local previousY = entity.previousY or entity.y
    local deltaY = entity.y - previousY

    return currentBottom - deltaY
end

-- Не даёт entity выйти за горизонтальные границы уровня.
local function clampEntityToLevelBounds(level, entity)
    if entity and entity.ignoreLevelBounds then
        return false
    end

    if not level or not level.bounds or not entity or not entity.getHitbox then
        return false
    end

    local bounds = level.bounds
    local bbox = entity:getHitbox()
    local hitboxOffsetX = bbox.x - entity.x
    local didClamp = false

    if bounds.left and bbox.x < bounds.left then
        entity.x = bounds.left - hitboxOffsetX
        entity.vx = math.max(0, entity.vx or 0)
        didClamp = true
    end

    if bounds.right and bbox.x + bbox.w > bounds.right then
        entity.x = bounds.right - hitboxOffsetX - bbox.w
        entity.vx = math.min(0, entity.vx or 0)
        didClamp = true
    end

    return didClamp
end

-- Возвращает true, если entity должна приземлиться на верх платформы.
-- Проверяем и bbox bottom, и линию ног entity.y.
local function crossedPlatformTop(entity, currentBottom, platformTop)
    local previousBottom = getPreviousBottom(entity, currentBottom)
    local previousY = entity.previousY or entity.y

    local landingToleranceTop = 8
    local landingToleranceBottom = 32

    local crossedByBottom = previousBottom <= platformTop + landingToleranceTop
        and currentBottom >= platformTop - landingToleranceTop

    local crossedByFeet = previousY <= platformTop + landingToleranceTop
        and entity.y >= platformTop - landingToleranceTop

    local closeToPlatformTop = currentBottom >= platformTop - landingToleranceTop
        and currentBottom <= platformTop + landingToleranceBottom

    return (crossedByBottom or crossedByFeet or closeToPlatformTop)
        and (entity.vy or 0) >= 0
end

-- Обрабатывает столкновение entity с платформами уровня.
-- Платформа остаётся единственным источником "земли" для player и actor-ов.
-- ground не используется.
-- solid-платформы дополнительно блокируют боковые границы.
function Physics.resolvePlatforms(level, entity)
    if not level or not entity or not entity.getHitbox then
        return false
    end

    if entity.flying then
        return false
    end

    local previousX = entity.previousX or entity.x
    local previousY = entity.previousY or entity.y

    local bbox = entity:getHitbox()
    local hitboxOffsetX = bbox.x - entity.x
    local hitboxOffsetY = bbox.y - entity.y

    local previousBox = {
        x = previousX + hitboxOffsetX,
        y = previousY + hitboxOffsetY,
        w = bbox.w,
        h = bbox.h
    }

    local currentBottom = bbox.y + bbox.h
    local didLand = false
    local didBlock = false

    -- Сначала обрабатываем приземление сверху.
    for _, platform in ipairs(level.platforms or {}) do
        local platformBox = platform:getHitbox()
        local platformTop = platform.walkY or platformBox.y

        local overlapsX = bbox.x < platformBox.x + platformBox.w
            and platformBox.x < bbox.x + bbox.w

        if overlapsX and crossedPlatformTop(entity, currentBottom, platformTop) then
            local correctedY = entity.y - (currentBottom - platformTop)
            landEntity(entity, correctedY)

            if platform.deltaX then
                entity.x = entity.x + platform.deltaX
            end

            didLand = true
            break
        end
    end

    bbox = entity:getHitbox()

    -- Затем обрабатываем боковые/нижние столкновения только для solid-платформ.
    for _, platform in ipairs(level.platforms or {}) do
        if platform.solid then
            local platformBox = platform:getHitbox()

            local overlaps = bbox.x < platformBox.x + platformBox.w
                and platformBox.x < bbox.x + bbox.w
                and bbox.y < platformBox.y + platformBox.h
                and platformBox.y < bbox.y + bbox.h

            if overlaps then
                -- Удар снизу.
                if previousBox.y >= platformBox.y + platformBox.h
                    and (entity.vy or 0) < 0
                then
                    entity.y = platformBox.y + platformBox.h - hitboxOffsetY
                    entity.vy = 0
                    didBlock = true
                    break
                end

                -- Упёрся в левую сторону платформы.
                if previousBox.x + previousBox.w <= platformBox.x then
                    entity.x = platformBox.x - hitboxOffsetX - bbox.w
                    entity.vx = 0
                    didBlock = true
                    break
                end

                -- Упёрся в правую сторону платформы.
                if previousBox.x >= platformBox.x + platformBox.w then
                    entity.x = platformBox.x + platformBox.w - hitboxOffsetX
                    entity.vx = 0
                    didBlock = true
                    break
                end
            end
        end
    end

    local didClamp = clampEntityToLevelBounds(level, entity)

    if not didLand then
        entity.onGround = false
    end

    return didLand or didBlock or didClamp
end

-- Убивает игрока, если его bbox полностью ушёл ниже нижней границы экрана.
-- Под платформами теперь яма: ground не используется.
function Physics.killPlayerBelowScreen(player, camera)
    if not player or player.dead then
        return false
    end

    local screenBottom = (camera and camera.y or 0) + Config.screen.height
    local bbox = player:getHitbox()

    if bbox.y > screenBottom then
        player:die()
        return true
    end

    return false
end

return Physics