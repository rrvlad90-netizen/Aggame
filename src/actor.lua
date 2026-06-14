local AnimationSet = require("src.animation_set")
local Collision = require("src.collision")
local Targeting = require("src.targeting")
local Render = require("src.render")
local Utils = require("src.utils")

local Actor = {}
Actor.__index = Actor

-- Создаёт actor из definition.
-- Actor используется для врагов, NPC, турелей, спавнеров и объектов с HP.
function Actor:new(config)
    config = config or {}

    local actor = setmetatable({}, Actor)

    actor.id = config.id or "actor"

    actor.entityType = config.entityType
        or config.entity_type
        or "enemy"

    actor.targetGroup = config.targetGroup
        or config.target_group
        or actor.entityType

    actor.x = config.x or 0
    actor.y = config.y or 0

    actor.canvas = config.canvas or {
        width = config.w or config.width or 48,
        height = config.h or config.height or 48
    }

    actor.offset = config.offset or {
        x = actor.canvas.width / 2,
        y = actor.canvas.height
    }

    actor.bbox = config.bbox or {
        x = 0,
        y = 0,
        w = actor.canvas.width,
        h = actor.canvas.height
    }

    actor.defaultBboxName = config.defaultBbox or config.default_bbox or "stand"
    actor.bboxes = config.bboxes or {}
    actor.hitboxes = config.hitboxes or {}

    actor.health = config.health or config.hp or 1
    actor.maxHealth = actor.health

    actor.speed = config.speed or 120

    actor.gravity = config.gravity

    if actor.gravity == nil then
        actor.gravity = 900
    end

    actor.flying = config.flying == true
        or config.isFlying == true
        or config.is_flying == true

    actor.vx = config.vx or 0
    actor.vy = config.vy or 0

    actor.facing = config.facing or -1
    actor.flipSprite = config.flipSprite == true
        or config.flip_sprite == true

    actor.alpha = config.alpha or 1
    actor.color = config.color or {0.8, 0.2, 0.2}

    actor.hates = config.hates or {}
    actor.damageTargets = config.damageTargets
        or config.damage_targets
        or {}

    actor.ignoreFlyingTargets = config.ignoreFlyingTargets == true
        or config.ignore_flying_targets == true
        or config.ignoreFlying == true
        or config.ignore_flying == true

    actor.attackGroups = config.attackGroups
        or config.attack_groups
        or {}

    actor.searchRange = config.searchRange
        or config.search_range
        or 600

    actor.movementMode = config.movementMode
        or config.movement_mode
        or "chase"

    actor.showHealthBar = config.showHealthBar == true
        or config.show_health_bar == true

    actor.VictoryIfDeath = config.VictoryIfDeath == true
        or config.victoryIfDeath == true
        or config.victory_if_death == true

    actor.DefeatIfDeath = config.DefeatIfDeath == true
        or config.defeatIfDeath == true
        or config.defeat_if_death == true

    actor.nopain = config.nopain == true
        or config.noPain == true
        or config.no_pain == true

    actor.heavyDeathEffect = config.heavyDeathEffect
        or config.heavy_death_effect

    actor.dead = false
    actor.deathFinished = false
    actor.onGround = false

    actor.state = "idle"
    actor.target = nil

    actor.entitySpawnRequests = {}

    actor.animationSet = AnimationSet:new({
        default = config.defaultAnimation or config.default_animation or "idle",
        animations = config.animations or {
            idle = {
                loop = true,
                frames = {}
            }
        }
    })

    actor.animationSet:set("idle", true)

    return actor
end

-- Возвращает true, если actor жив.
function Actor:isAlive()
    return not self.dead
end

-- Возвращает bbox actor-а в мировых координатах.
function Actor:getHitbox()
    return Collision.localBoxToWorld(self, self.bbox)
end

-- Устанавливает bbox по имени из self.bboxes.
function Actor:setBbox(name)
    local bbox = self.bboxes[name]

    if bbox then
        self.bbox = bbox
    end
end

-- Возвращает hitbox по имени в мировых координатах.
function Actor:getNamedHitbox(name)
    local hitbox = self.hitboxes[name]

    if not hitbox then
        return nil
    end

    return Collision.hitboxToWorld(self, hitbox)
end

-- Возвращает true, если actor может быть целью.
function Actor:canBeTargeted()
    return not self.dead
end

-- Выбирает ближайшую цель через Targeting.
function Actor:selectTarget(targetGroups)
    local target = Targeting.findNearest(self, targetGroups)

    if not target then
        self.target = nil
        return nil
    end

    if Targeting.distance(self, target) > self.searchRange then
        self.target = nil
        return nil
    end

    self.target = target

    return target
end

-- Поворачивает actor к цели.
function Actor:faceTarget(target)
    if not target then
        return
    end

    if target.x > self.x then
        self.facing = 1
    elseif target.x < self.x then
        self.facing = -1
    end
end

-- Возвращает дистанцию до цели.
function Actor:getDistanceToTarget(target)
    if not target then
        return math.huge
    end

    return math.abs(target.x - self.x)
end

-- Выбирает attack animation по attackGroups.
function Actor:chooseAttackAnimation(target)
    if not target then
        return nil
    end

    local distance = self:getDistanceToTarget(target)

    for _, group in ipairs(self.attackGroups or {}) do
        local minDistance = group.minDistance or group.min_distance or 0
        local maxDistance = group.maxDistance or group.max_distance or math.huge

        if distance >= minDistance and distance <= maxDistance then
            return Utils.randomChoice(group.animations or {})
        end
    end

    return nil
end

-- Пытается начать атаку.
-- Возвращает true, если атака началась.
function Actor:tryStartAttack(target)
    if not target then
        return false
    end

    local animationName = self:chooseAttackAnimation(target)

    if not animationName then
        return false
    end

    self:faceTarget(target)
    self.state = animationName
    self.animationSet:set(animationName, true)

    return true
end

-- Обновляет AI actor-а.
function Actor:updateAi(dt, world)
    if self.dead then
        return
    end

    if self.animationSet:isCurrentFinished()
        and self.state ~= "idle"
        and self.state ~= "walk"
    then
        self.state = "idle"
        self.animationSet:set("idle")
    end

    if not self.animationSet:isCurrentFinished()
        and self.animationSet:isInputLocked()
    then
        return
    end

    local target = self:selectTarget(world and world:getTargetGroups() or {})

    if target then
        if self:tryStartAttack(target) then
            return
        end

        self:faceTarget(target)

        if self.movementMode == "chase" then
            self.vx = self.facing * self.speed
            self.state = "walk"
            self.animationSet:set("walk")
            return
        end
    end

    self.vx = 0
    self.state = "idle"
    self.animationSet:set("idle")
end

-- Обновляет физику actor-а.
function Actor:updatePhysics(dt)
    if self.dead then
        self.vx = 0
        return
    end

    if not self.flying then
        self.vy = self.vy + self.gravity * dt
    end

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

-- Создаёт DamageInfo для прямого melee-hitbox.
function Actor:createDamageInfo(event)
    return {
        amount = event.damage or 1,
        source = self,
        owner = self,
        deathType = event.deathType or event.death_type or "normal",
        damageTargets = event.damageTargets
            or event.damage_targets
            or self.damageTargets
    }
end

-- Получает урон.
-- damageInfo — единый формат урона от projectile/effect/melee/hazard.
function Actor:takeDamage(damageInfo)
    if self.dead then
        return false
    end

    damageInfo = damageInfo or {}

    local amount = damageInfo.amount or 1

    self.health = math.max(0, self.health - amount)

    if self.health <= 0 then
        self:die(damageInfo)
        return true
    end

    self:playPain()

    return false
end

-- Проигрывает pain-анимацию, если она есть и nopain не включён.
function Actor:playPain()
    if self.nopain then
        return
    end

    if self.animationSet:has("pain") then
        self.vx = 0
        self.state = "pain"
        self.animationSet:set("pain", true)
    end
end

-- Создаёт heavy death effect.
function Actor:createHeavyDeathEffect(damageInfo)
    if not self.heavyDeathEffect then
        return false
    end

    local request = {
        id = self.heavyDeathEffect,
        x = self.x,
        y = self.y,
        direction = "opposite",
        facing = self.facing
    }

    table.insert(self.entitySpawnRequests, {
        type = "createEntity",
        id = request.id,
        x = request.x,
        y = request.y,
        direction = request.direction,
        facing = request.facing
    })

    return true
end

-- Запускает смерть actor-а.
function Actor:die(damageInfo)
    if self.dead then
        return
    end

    self.dead = true
    self.vx = 0
    self.vy = 0

    damageInfo = damageInfo or {}

    if damageInfo.deathType == "heavy"
        and self:createHeavyDeathEffect(damageInfo)
    then
        self.deathFinished = true
        return
    end

    self.state = "death"
    self.animationSet:set("death", true)
end

-- Обновляет actor-а.
function Actor:update(dt, world)
    if self.deathFinished then
        return
    end

    if not self.dead then
        self:updateAi(dt, world)
        self:updatePhysics(dt)
    end

    local events = self.animationSet:update(dt)

    for _, event in ipairs(events) do
        table.insert(self.entitySpawnRequests, event)
    end

    if self.dead
        and self.state == "death"
        and self.animationSet:isCurrentFinished()
    then
        self.deathFinished = true
    end
end

-- Возвращает и очищает события actor-а.
function Actor:consumeEntitySpawnRequests()
    local requests = self.entitySpawnRequests

    self.entitySpawnRequests = {}

    return requests
end

-- Рисует actor-а.
function Actor:draw(camera)
    Render.drawEntity(self, camera)
end

-- Возвращает true, если actor можно удалить.
function Actor:isRemovable()
    return self.deathFinished
end

return Actor