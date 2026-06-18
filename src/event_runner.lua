local Assets = require("src.assets")
local Collision = require("src.collision")
local Targeting = require("src.targeting")
local Utils = require("src.utils")
local Debug = require("src.debug")

local EventRunner = {}

-- Возвращает позицию события относительно owner-а.
-- offset x зеркалится по facing, если entity смотрит влево.
function EventRunner.getEventPosition(owner, event)
    local facing = owner and owner.facing or 1

    local offsetX = event.x
        or event.offsetX
        or event.offset_x
        or 0

    local offsetY = event.y
        or event.offsetY
        or event.offset_y
        or 0

    return {
        x = owner.x + offsetX * facing,
        y = owner.y + offsetY
    }
end


-- Возвращает facing для создаваемой entity.
function EventRunner.getEventFacing(owner, event)
    if event.facing then
        return event.facing
    end

    if event.direction == "opposite" then
        return -(owner and owner.facing or 1)
    end

    return owner and owner.facing or 1
end



-- Выполняет случайный переход в animation group actor-а/entity.
function EventRunner.randomStateGroup(owner, event)
    if not owner or not owner.playAnimationGroup then
        return
    end

    local groupName = event.group
        or event.groupName
        or event.group_name
        or "special"

    owner:playAnimationGroup(groupName, event.fallback, true)
end

-- Выполняет событие playSound.
function EventRunner.playSound(event)
    Assets.playSound(event.sound)
end

-- Выполняет событие move.
-- x/y задаются в пикселях.
-- x двигается относительно facing owner-а.
function EventRunner.move(owner, event)
    if not owner then
        return
    end

    local facing = owner.facing or 1

    owner.x = owner.x + (event.x or 0) * facing
    owner.y = owner.y + (event.y or 0)
end

-- Выполняет событие jump.
-- Это animation-event рывка/прыжка по дуге.
function EventRunner.jump(owner, event)
    if not owner then
        return
    end

    local facing = owner.facing or 1
    local distance = event.distance or 0
    local height = event.height or 0
    local speed = event.speed or 240

    owner.vx = facing * speed

    if distance > 0 and speed > 0 then
        owner.jumpEventDistanceLeft = distance
    end

    if height > 0 then
        owner.vy = -height
    end
end

-- Выполняет событие setVelocity.
function EventRunner.setVelocity(owner, event)
    if not owner then
        return
    end

    local facing = owner.facing or 1

    if event.vx then
        owner.vx = event.vx * facing
    end

    if event.vy then
        owner.vy = event.vy
    end
end

-- Выполняет событие setBbox.
function EventRunner.setBbox(owner, event)
    if not owner or not owner.setBbox then
        return
    end

    owner:setBbox(event.bbox)
end

-- Выполняет событие setState.
function EventRunner.setState(owner, event)
    if not owner or not owner.playAnimation then
        return
    end

    owner:playAnimation(event.state, true)
end


----Направляем снаряд в последний x и y игрока который зафиксировали
local function getEntityCenter(entity)
    if entity and entity.getHitbox then
        local bbox = entity:getHitbox()

        if bbox then
            return bbox.x + bbox.w / 2, bbox.y + bbox.h / 2
        end
    end

    return Targeting.centerX(entity), Targeting.centerY(entity)
end

function EventRunner.shouldAimAtTarget(event)
    return event.aimAtTarget == true
        or event.aim_at_target == true
        or event.aim == true
end

function EventRunner.getAimTarget(world, owner, event)
    if event.target == "player" and world then
        return world.player
    end

    if owner and owner.target and Targeting.canTarget(owner, owner.target) then
        return owner.target
    end

    if world and world.getTargetGroups and owner then
        return Targeting.findNearest(owner, world:getTargetGroups())
    end

    return world and world.player
end

function EventRunner.applyProjectileAim(world, owner, event, overrides)
    if not EventRunner.shouldAimAtTarget(event) then
        return
    end

    local target = EventRunner.getAimTarget(world, owner, event)

    if not target then
        return
    end

    local spawnX = overrides.x or 0
    local spawnY = overrides.y or 0

    local targetX, targetY = getEntityCenter(target)

    targetX = targetX + (
        event.targetOffsetX
        or event.target_offset_x
        or 0
    )

    targetY = targetY + (
        event.targetOffsetY
        or event.target_offset_y
        or 0
    )

    local dx = targetX - spawnX
    local dy = targetY - spawnY

    local aimMode = event.aimMode
        or event.aim_mode
        or "straight"

    if aimMode == "arc" then
        local travelTime = event.travelTime
            or event.travel_time
            or 1

        if travelTime <= 0 then
            travelTime = 1
        end

        local gravity = event.projectileGravity
            or event.projectile_gravity
            or overrides.gravity
            or 0

        overrides.gravity = gravity
        overrides.vx = dx / travelTime
        overrides.vy = (dy - 0.5 * gravity * travelTime * travelTime) / travelTime

        return
    end

    local speed = event.projectileSpeed
        or event.projectile_speed
        or overrides.speed
        or 0

    if speed <= 0 then
        return
    end

    local distance = math.sqrt(dx * dx + dy * dy)

    if distance <= 0 then
        return
    end

    overrides.vx = dx / distance * speed
    overrides.vy = dy / distance * speed
end
----------

-- Выполняет событие createEntity.
function EventRunner.createEntity(world, owner, event)
    if not world or not event.id then
        return
    end

    local position = EventRunner.getEventPosition(owner, event)
    local facing = EventRunner.getEventFacing(owner, event)

    local overrides = Utils.copyTable(event.overrides or {})

    overrides.x = event.spawnX or event.spawn_x or position.x
    overrides.y = event.spawnY or event.spawn_y or position.y
    overrides.facing = facing
    overrides.owner = owner

    EventRunner.applyProjectileAim(world, owner, event, overrides)

    world:createEntity(event.id, overrides.x, overrides.y, overrides)
end

-- Возвращает debug-label для damageHitbox события.
function EventRunner.getDamageHitboxLabel(owner, event)
    local ownerId = owner and owner.id or "unknown"
    local hitboxName = event.hitbox

    if type(hitboxName) ~= "string" then
        hitboxName = "hitbox"
    end

    return ownerId .. ":" .. hitboxName
end

-- Выполняет событие damageHitbox.
-- Используется для melee и прямого урона на конкретном кадре анимации.
function EventRunner.damageHitbox(world, owner, event)
    if not world or not owner then
        return
    end

    local hitbox = nil

    if type(event.hitbox) == "string" then
        hitbox = owner:getNamedHitbox(event.hitbox)
    elseif type(event.hitbox) == "table" then
        hitbox = Collision.hitboxToWorld(owner, event.hitbox)
    end

    if not hitbox then
        return
    end

    Debug.recordHitbox(
        owner,
        hitbox,
        EventRunner.getDamageHitboxLabel(owner, event),
        event.debugDuration or event.debug_duration
    )

    local damageInfo = owner:createDamageInfo(event)

    world:applyDamageHitbox(owner, hitbox, damageInfo)
end

-- Выполняет событие screenShake.
-- Пока world может не поддерживать shake, поэтому проверяем метод.
function EventRunner.screenShake(world, event)
    if world and world.screenShake then
        world:screenShake(event.amount or 4, event.duration or 0.2)
    end
end


-- Выполняет событие setTracking.
-- Используется decor-ами, которые временно или навсегда перестают следить за игроком.
function EventRunner.setTracking(owner, event)
    if not owner or not owner.setTracking then
        return
    end

    owner:setTracking(event.enabled == true)
end

-- Выполняет случайный переход в одну из указанных animation states.
function EventRunner.randomState(owner, event)
    if not owner or not owner.playAnimation then
        return
    end

    local states = event.states
        or event.animations
        or event.options
        or {}

    local state = Utils.randomChoice(states)

    if state then
        owner:playAnimation(state, true)
    end
end

-- Выполняет событие setInvulnerable - Включить неуязвимость
function EventRunner.setInvulnerable(owner, event)
    if not owner or not owner.setInvulnerable then
        return
    end

    local value = event.value

    if value == nil then
        value = event.enabled
    end

    if value == nil then
        value = true
    end

    owner:setInvulnerable(value == true, event.duration)
end


-- Выполняет одно событие animation frame.
function EventRunner.run(world, owner, event)
    if not event then
        return
    end
	
	if eventType == "setInvulnerable" --Если включили неуязвиомсть
        or eventType == "set_invulnerable"
        or eventType == "invulnerable"
    then
        EventRunner.setInvulnerable(owner, event)--то устанавливаем ее эвентом для того кто вызвал
        return
    end

    local eventType = event.type or event.action

    if eventType == "playSound" or eventType == "sound" then
        EventRunner.playSound(event)
        return
    end

    if eventType == "createEntity" then
        EventRunner.createEntity(world, owner, event)
        return
    end

    if eventType == "damageHitbox" then
        EventRunner.damageHitbox(world, owner, event)
        return
    end

    if eventType == "move" then
        EventRunner.move(owner, event)
        return
    end

    if eventType == "jump" then
        EventRunner.jump(owner, event)
        return
    end

    if eventType == "setVelocity" then
        EventRunner.setVelocity(owner, event)
        return
    end

    if eventType == "setBbox" then
        EventRunner.setBbox(owner, event)
        return
    end

    if eventType == "setState" then
        EventRunner.setState(owner, event)
        return
    end

    if eventType == "screenShake" then
        EventRunner.screenShake(world, event)
        return
    end
	
	if eventType == "setTracking" or eventType == "set_tracking" then
		EventRunner.setTracking(owner, event)
		return
	end
	
	if eventType == "randomStateGroup" or eventType == "random_state_group" then
		EventRunner.randomStateGroup(owner, event)
		return
	end	

	if eventType == "randomState" or eventType == "random_state" then
		EventRunner.randomState(owner, event)
		return
	end	
	
end

-- Выполняет список событий.
function EventRunner.runAll(world, owner, events)
    for _, event in ipairs(events or {}) do
        EventRunner.run(world, owner, event)
    end
end

return EventRunner