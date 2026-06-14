local Targeting = {}

-- Преобразует правило в набор значений.
-- Поддерживает:
-- "enemy"
-- {"enemy", "npc"}
-- { enemy = true, npc = true }
function Targeting.toSet(rule)
    local result = {}

    if rule == nil then
        return result
    end

    if rule == "all" then
        result.all = true
        return result
    end

    if type(rule) == "string" then
        result[rule] = true
        return result
    end

    if type(rule) == "table" then
        for key, value in pairs(rule) do
            if type(key) == "number" then
                result[value] = true
            elseif value == true then
                result[key] = true
            end
        end
    end

    return result
end

-- Возвращает targetGroup entity.
-- Если targetGroup не указан, используем entityType.
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

-- Проверяет, соответствует ли entity правилу targeting.
function Targeting.matches(rule, entity)
    local set = Targeting.toSet(rule)

    if set.all then
        return true
    end

    local group = Targeting.getGroup(entity)

    return set[group] == true
end

-- Проверяет, жива ли entity.
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

-- Проверяет, может ли actor выбрать target как цель.
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

    return Targeting.matches(actor.hates, target)
end

-- Проверяет, может ли damageSource нанести урон target.
function Targeting.canDamage(damageTargets, target)
    if not Targeting.isAlive(target) then
        return false
    end

    return Targeting.matches(damageTargets, target)
end

-- Возвращает центр entity по X.
function Targeting.centerX(entity)
    return entity.x
end

-- Возвращает центр entity по Y.
-- В нашей системе entity.x/entity.y — anchor-точка.
-- Для расстояния по Y этого достаточно.
function Targeting.centerY(entity)
    return entity.y
end

-- Возвращает квадрат расстояния между двумя entity.
function Targeting.distanceSquared(a, b)
    local dx = Targeting.centerX(a) - Targeting.centerX(b)
    local dy = Targeting.centerY(a) - Targeting.centerY(b)

    return dx * dx + dy * dy
end

-- Возвращает расстояние между двумя entity.
function Targeting.distance(a, b)
    return math.sqrt(Targeting.distanceSquared(a, b))
end

-- Ищет ближайшую цель для actor среди списка targetGroups.
function Targeting.findNearest(actor, targetGroups)
    local bestTarget = nil
    local bestDistance = nil

    for _, targets in pairs(targetGroups or {}) do
        for _, target in ipairs(targets or {}) do
            if Targeting.canTarget(actor, target) then
                local distance = Targeting.distanceSquared(actor, target)

                if not bestDistance or distance < bestDistance then
                    bestDistance = distance
                    bestTarget = target
                end
            end
        end
    end

    return bestTarget
end

return Targeting