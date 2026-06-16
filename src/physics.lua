local Config = require("src.config")

local Physics = {}

-- Приземляет entity на указанную линию ног.
-- Для Player/Actor предпочтительно вызывает landOn, чтобы сбросить vy, onGround и jumpCount.
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

-- Возвращает true, если entity пересекла верх платформы сверху вниз.
local function crossedPlatformTop(entity, currentBottom, platformTop)
    local previousBottom = getPreviousBottom(entity, currentBottom)
    local landingToleranceTop = 8

    return previousBottom <= platformTop + landingToleranceTop
        and currentBottom >= platformTop - landingToleranceTop
        and (entity.vy or 0) >= 0
end

-- Обрабатывает столкновение entity с платформами уровня.
-- Платформа теперь является единственным источником "земли" для игрока и actor-ов.
function Physics.resolvePlatforms(level, entity)
    if not level or not entity or not entity.getHitbox then
        return false
    end

    if entity.flying then
        return false
    end

    local bbox = entity:getHitbox()
    local currentBottom = bbox.y + bbox.h
    local didLand = false

    for _, platform in ipairs(level.platforms or {}) do
        local platformBox = platform:getHitbox()
        local platformTop = platform.walkY or platformBox.y

        local overlapsX = bbox.x < platformBox.x + platformBox.w
            and platformBox.x < bbox.x + bbox.w

        if overlapsX and crossedPlatformTop(entity, currentBottom, platformTop) then
            local correctedY = entity.y - (currentBottom - platformTop)

            landEntity(entity, correctedY)
            didLand = true

            break
        end
    end

    if not didLand then
        entity.onGround = false
    end

    return didLand
end

-- Убивает игрока, если его bbox полностью ушёл ниже нижней границы экрана.
-- Это заменяет старую "землю": под платформами теперь яма.
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