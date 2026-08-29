local Targeting = {}

-- Кеширует преобразованные таблицы правил hates/damageTargets.
-- Слабые ключи позволяют Lua удалить запись вместе с исходной таблицей.
Targeting.ruleCache = setmetatable({}, {
    __mode = "k"
})

-- Преобразует правило целей в set-таблицу.
function Targeting.toSet(rule)
    if rule == nil then
        return {}
    end

    if rule == "all" then
        return {
            all = true
        }
    end

    if type(rule) == "string" then
        return {
            [rule] = true
        }
    end

    if type(rule) ~= "table" then
        return {}
    end

    local cached = Targeting.ruleCache[rule]

    if cached then
        return cached
    end

    local result = {}

    for key, value in pairs(rule) do
        if type(key) == "number" then
            result[value] = true
        elseif value == true then
            result[key] = true
        end
    end

    Targeting.ruleCache[rule] = result

    return result
end

-- Возвращает targetGroup сущности.
function Targeting.getGroup(entity)
    if not entity then
        return "unknown"
    end

    return entity.targetGroup
        or entity.target_group
        or entity.entityType
        or entity.entity_type
        or "unknown"
end

-- Проверяет соответствие сущности правилу целей.
function Targeting.matches(rule, entity)
    local set = Targeting.toSet(rule)

    if set.all then
        return true
    end

    local group = Targeting.getGroup(entity)

    return set[group] == true
end

-- Проверяет, жива ли сущность.
function Targeting.isAlive(entity)
    if not entity then
        return false
    end

    if entity.dead then
        return false
    end

    if entity.isAlive then
        return entity:isAlive()
    end

    return true
end

-- Проверяет, может ли actor выбрать target своей целью.
function Targeting.canTarget(actor, target)
    if actor == target then
        return false
    end

    if not Targeting.isAlive(target) then
        return false
    end

    if actor.ignoreFlyingTargets == true
        and target.flying == true
    then
        return false
    end

    return Targeting.matches(
        actor.hates,
        target
    )
end

-- Проверяет, может ли damageInfo нанести урон target.
function Targeting.canDamage(damageTargets, target)
    if not Targeting.isAlive(target) then
        return false
    end

    if target.hittable == false then
        return false
    end

    return Targeting.matches(
        damageTargets,
        target
    )
end

-- Возвращает центральную X-координату сущности.
function Targeting.centerX(entity)
    return entity.x
end

-- Возвращает центральную Y-координату сущности.
function Targeting.centerY(entity)
    return entity.y
end

-- Возвращает квадрат расстояния между сущностями.
-- Используется в AI без дорогого вычисления квадратного корня.
function Targeting.distanceSquared(a, b)
    local dx =
        Targeting.centerX(a)
        - Targeting.centerX(b)

    local dy =
        Targeting.centerY(a)
        - Targeting.centerY(b)

    return dx * dx + dy * dy
end

-- Возвращает обычное расстояние между сущностями.
function Targeting.distance(a, b)
    return math.sqrt(
        Targeting.distanceSquared(a, b)
    )
end

-- Ищет ближайшую допустимую цель.
-- maxDistance позволяет сразу исключить слишком далёкие цели.
function Targeting.findNearest(
    actor,
    targetGroups,
    maxDistance
)
    local bestTarget = nil
    local bestDistanceSquared = nil
    local maxDistanceSquared = nil

    if maxDistance then
        maxDistanceSquared =
            maxDistance * maxDistance
    end

    for _, targets in pairs(
        targetGroups or {}
    ) do
        for _, target in ipairs(
            targets or {}
        ) do
            if Targeting.canTarget(
                actor,
                target
            ) then
                local distanceSquared =
                    Targeting.distanceSquared(
                        actor,
                        target
                    )

                local insideRange =
                    not maxDistanceSquared
                    or distanceSquared
                        <= maxDistanceSquared

                if insideRange
                    and (
                        not bestDistanceSquared
                        or distanceSquared
                            < bestDistanceSquared
                    )
                then
                    bestDistanceSquared =
                        distanceSquared

                    bestTarget = target
                end
            end
        end
    end

    return bestTarget
end

return Targeting