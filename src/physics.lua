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
local function crossedPlatformTop(entity, currentBottom, platformTop, allowCloseSnap)
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

    if allowCloseSnap then
        return (crossedByBottom or crossedByFeet or closeToPlatformTop)
            and (entity.vy or 0) >= 0
    end

    return (crossedByBottom or crossedByFeet)
        and (entity.vy or 0) >= 0
end

-- Проверяет, можно ли entity зайти на slope сбоку.
-- Это нужно, чтобы игрок мог войти на склон с земли,
-- а не только запрыгнуть сверху.
local function canWalkOntoSlope(entity, platform, currentBottom, platformTop)
    if not platform.slope then
        return false
    end

    if not platform.slopeWalkOn then
        return false
    end

    if not entity.onGround then
        return false
    end

    local stepHeight = platform.slopeStepHeight or 24
    local deltaY = math.abs(currentBottom - platformTop)

    return deltaY <= stepHeight
end

-- Возвращает Y поверхности платформы в X-позиции entity.
-- Для обычной платформы это walkY.
-- Для slope-платформы это line interpolation через platform:getWalkYAtX().
local function getPlatformTopAtEntity(platform, entity, platformBox)
    if platform.getWalkYAtX then
        return platform:getWalkYAtX(entity.x)
    end

    return platform.walkY or platformBox.y
end

-- Обрабатывает столкновение entity с платформами уровня.
-- Платформа остаётся единственным источником "земли" для player и actor-ов.
-- ground не используется.
-- solid-платформы дополнительно блокируют боковые границы.
-- collisionEnabled=false полностью выключает collision платформы, но не скрывает её.
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

    -- Сначала ищем лучшую поверхность для приземления.
    -- Важно: не берём первую подходящую платформу.
    -- Если земля и slope подходят одновременно, выбираем ту, что выше по Y.
    local bestPlatform = nil
    local bestPlatformTop = nil
    local bestCorrectedY = nil

    for _, platform in ipairs(level.platforms or {}) do
        if platform.collisionEnabled ~= false then
            local platformBox = platform:getHitbox()
            local platformTop = getPlatformTopAtEntity(platform, entity, platformBox)

            local overlapsX = bbox.x < platformBox.x + platformBox.w
                and platformBox.x < bbox.x + bbox.w

-- Close snap нужен только чтобы entity не дрожал на текущей платформе.
        -- Для новых платформ он опасен: actor может "телепортироваться" на платформу выше,
        -- если оказался рядом с её верхом сбоку или после смены bbox/анимации.
        local allowCloseSnap = entity.currentPlatform == platform

            local crossedTop = crossedPlatformTop(
                entity,
                currentBottom,
                platformTop,
                allowCloseSnap
            )

            -- Если slopeWalkOn = false, то стоящий на земле entity
            -- не должен "войти" на slope сбоку.
            if platform.slope
                and not platform.slopeWalkOn
                and entity.onGround
                and entity.currentPlatform ~= platform
            then
                crossedTop = false
            end

		local canLand = platform.collisionEnabled ~= false
            and overlapsX
            and (
                crossedTop
                or canWalkOntoSlope(entity, platform, currentBottom, platformTop)
            )

            if canLand then
                local correctedY = entity.y - (currentBottom - platformTop)

                -- Меньший Y = поверхность выше.
                if not bestPlatformTop or platformTop < bestPlatformTop then
                    bestPlatform = platform
                    bestPlatformTop = platformTop
                    bestCorrectedY = correctedY
                end
            end
        end
    end

    if bestPlatform then
        landEntity(entity, bestCorrectedY)

        entity.currentPlatform = bestPlatform

        if bestPlatform.deltaX then
            entity.x = entity.x + bestPlatform.deltaX
        end

        didLand = true
    end

    bbox = entity:getHitbox()

    -- Затем обрабатываем боковые/нижние столкновения только для solid-платформ.
    -- Slope-платформы здесь пропускаем: они работают как top-only поверхность,
    -- иначе прямоугольный bbox будет блокировать вход на склон сбоку.
    for _, platform in ipairs(level.platforms or {}) do
        if platform.collisionEnabled ~= false
            and platform.solid
            and not platform.slope
        then
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
        entity.currentPlatform = nil
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