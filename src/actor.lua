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
---Неузвимый	
	actor.invulnerable = config.invulnerable == true --неуязвимость (блок сделает)
    actor.invulnerableTimer = 0

    actor.canvas = config.canvas or {
        width = config.w or config.width or 48,
        height = config.h or config.height or 48
    }
---Удар или проджектайл пролетит насквозь (призрак)	
	actor.hittable = config.hittable ~= false
        and config.canBeHit ~= false
        and config.can_be_hit ~= false

    actor.hittableTimer = 0

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
-------Аплитуда для летающих (вверх вниз)	
	actor.flyAmplitude = config.flyAmplitude
        or config.fly_amplitude
        or 0

    actor.flyFrequency = config.flyFrequency
        or config.fly_frequency
        or 0

    actor.flyTime = 0
    actor.flyBaseY = config.flyBaseY
        or config.fly_base_y
        or actor.y

    if actor.gravity == nil then
        actor.gravity = 900
    end

    actor.flying = config.flying == true
        or config.isFlying == true
        or config.is_flying == true
		
-- solid = true означает, что через actor нельзя пройти.
-- Работает для player и других actor-ов.
actor.solid = config.solid == true
    or config.blocking == true
    or config.blocksMovement == true
    or config.blocks_movement == true	

    actor.vx = config.vx or 0
    actor.vy = config.vy or 0

    actor.facing = config.facing or -1
    actor.flipSprite = config.flipSprite == true
        or config.flip_sprite == true

    actor.alpha = config.alpha or 1
    actor.color = config.color or {0.8, 0.2, 0.2}
	
	
	actor.animationGroups = config.animationGroups
		or config.animation_groups
		or {}
	

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
        or "chase"  --охота, идет на игрока
		
	actor.keepMovingDuringAttack = config.keepMovingDuringAttack == true
        or config.keep_moving_during_attack == true

    actor.attackMoveSpeed = config.attackMoveSpeed
        or config.attack_move_speed		

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

	actor.painChance = config.painChance
        or config.pain_chance

    if actor.painChance == nil then
        actor.painChance = 1
    end

    -- Поддерживаем оба формата:
    -- painChance = 0.35  -- 35%
    -- painChance = 35    -- 35%
    if actor.painChance > 1 then
        actor.painChance = actor.painChance / 100
    end

    actor.heavyDeathEffect = config.heavyDeathEffect
        or config.heavy_death_effect
		
	actor.heavyDeathAnimation = config.heavyDeathAnimation
        or config.heavy_death_animation
        or "heavydeath"		

    actor.dead = false
    actor.deathFinished = false
    actor.onGround = false

    actor.state = "idle"
    actor.target = nil
	
	-- Optional turn-анимация.
    -- Если у actor-а есть animations.turn, разворот будет плавным.
    -- Если turn нет, actor разворачивается мгновенно как раньше.
    actor.turnAnimation = config.turnAnimation
        or config.turn_animation
        or "turn"

    actor.pendingFacing = nil

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

    actor:playSpawnAnimation()

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

-- ФУНКЦИИ РАЗВОРОТА
-- Возвращает направление, в которое actor должен смотреть на цель.
function Actor:getFacingToTarget(target)
    if not target then
        return nil
    end

    if target.x > self.x then
        return 1
    end

    if target.x < self.x then
        return -1
    end

    return nil
end

-- Возвращает true, если actor сейчас проигрывает turn-анимацию.
function Actor:isTurning()
    return self.state == "turn"
        and not self.animationSet:isCurrentFinished()
end

-- Применяет отложенный разворот.
function Actor:applyPendingFacing()
    if not self.pendingFacing then
        return
    end

    self.facing = self.pendingFacing
    self.pendingFacing = nil
end

-- Пытается начать плавный разворот.
-- Возвращает true, если turn-анимация реально запущена и AI должен ждать.
function Actor:startTurn(facing)
    if not facing then
        return false
    end

    if facing == self.facing then
        return false
    end

    if not self.animationSet:has(self.turnAnimation) then
        self.facing = facing
        return false
    end

    self.pendingFacing = facing
    self.vx = 0
    self.state = "turn"
    self.animationSet:set(self.turnAnimation, true)

    return true
end

-- Поворачивает actor к цели.
-- Если есть turn-анимация, запускает её и возвращает true.
-- Если turn-анимации нет, разворачивает мгновенно и возвращает false.
function Actor:faceTarget(target)
    local facing = self:getFacingToTarget(target)

    return self:startTurn(facing)
end

-- Возвращает дистанцию до цели.
function Actor:getDistanceToTarget(target)
    if not target then
        return math.huge
    end

    return math.abs(target.x - self.x)
end

-- Возвращает список существующих анимаций из набора names.
function Actor:getExistingAnimations(names)
    local result = {}

    for _, name in ipairs(names or {}) do
        if self.animationSet:has(name) then
            table.insert(result, name)
        end
    end

    return result
end



-- Запускает animation actor-а по имени.
-- Нужен для animation events setState/randomState/randomStateGroup.
function Actor:playAnimation(name, force)
    if not self.animationSet then
        return false
    end

    if not self.animationSet:has(name) then
        return false
    end

    self.state = name
    self.animationSet:set(name, force)

    return true
end

-- Выбирает случайную существующую анимацию из списка.
-- Если в списке одна подходящая анимация, вернётся она.
function Actor:chooseAnimationFromGroup(names, fallback)
    local available = self:getExistingAnimations(names)

    if #available > 0 then
        return Utils.randomChoice(available)
    end

    if fallback and self.animationSet:has(fallback) then
        return fallback
    end

    return nil
end

-- Запускает случайную существующую анимацию из animationGroups.
function Actor:playAnimationGroup(groupName, fallback, force)
    local group = self.animationGroups[groupName]

    if not group then
        return false
    end

    local animationName = self:chooseAnimationFromGroup(group, fallback)

    if not animationName then
        return false
    end

    return self:playAnimation(animationName, force)
end

-- Запускает случайную spawn-анимацию actor-а.
-- Можно задать animationGroups.spawn, иначе ищет spawn01/spawn02/spawn03.
function Actor:playSpawnAnimation()
    local animationName = self:chooseAnimationFromGroup({
        "spawn",
        "spawn01",
        "spawn02",
        "spawn03"
    }, "idle")

    if animationName then
        self.state = animationName
        self.animationSet:set(animationName, true)
    end
end

-- Выбирает attack animation по attackGroups.
-- Если actor в воздухе, сначала пробует group.jumpAnimations.
-- Если jumpAnimations не задан, пробует общий набор jump_attack01/02/03.
function Actor:chooseAttackAnimation(target)
    if not target then
        return nil
    end

    local distance = self:getDistanceToTarget(target)

    for _, group in ipairs(self.attackGroups or {}) do
        local minDistance = group.minDistance or group.min_distance or 0
        local maxDistance = group.maxDistance or group.max_distance or math.huge

        if distance >= minDistance and distance <= maxDistance then
            if not self.onGround then
                local jumpAnimations = group.jumpAnimations
                    or group.jump_animations
                    or {
                        "jump_attack01",
                        "jump_attack02",
                        "jump_attack03"
                    }

                local jumpAnimation = self:chooseAnimationFromGroup(jumpAnimations)

                if jumpAnimation then
                    return jumpAnimation
                end
            end

            return Utils.randomChoice(group.animations or {})
        end
    end

    return nil
end

-- Пытается начать атаку.
-- Возвращает true, если actor начал атаку или занялся разворотом.
function Actor:tryStartAttack(target)
    if not target then
        return false
    end

    local animationName = self:chooseAttackAnimation(target)

    if not animationName then
        return false
    end

    -- Если перед атакой нужно развернуться, сначала проигрываем turn.
    if self:faceTarget(target) then
        return true
    end

	if self.keepMovingDuringAttack then
        local attackSpeed = self.attackMoveSpeed or self.speed or 0

        if self.movementMode == "chase" then
            self.vx = self.facing * attackSpeed
        end
    else
        self.vx = 0
    end

    self.state = animationName
    self.animationSet:set(animationName, true)

    return true
end

-- Обновляет AI actor-а.
function Actor:updateAi(dt, world)
    if self.dead then
        return
    end

    -- Обычные наземные actor-ы не должны начинать chase/attack,
    -- пока физика не поставила их на платформу.
    -- Это убирает смещение центра ног у заспавненных/offscreen монстров.
    if not self.flying and not self.onGround then
        self.vx = 0
        return
    end

    -- Пока идёт turn, actor стоит и ждёт конца анимации.
    if self.state == "turn" then
        self.vx = 0

        if self.animationSet:isCurrentFinished() then
            self:applyPendingFacing()

            self.state = "idle"
            self.animationSet:set("idle")
        end

        return
    end

    if self.animationSet:isCurrentFinished()
        and self.state ~= "idle"
        and self.state ~= "walk"
    then
        self.state = "idle"
        self.animationSet:set("idle")
    end

    -- Атака, pain и другие lockInput-анимации должны закончиться до конца.
	if not self.animationSet:isCurrentFinished()
			and self.animationSet:isInputLocked()
		then
			if self.keepMovingDuringAttack then
				local attackSpeed = self.attackMoveSpeed or self.speed or 0

				if self.movementMode == "chase" then
					self.vx = self.facing * attackSpeed
				end
			else
				self.vx = 0
			end

			return
		end

    local target = self:selectTarget(world and world:getTargetGroups() or {})

    if target then
        if self:tryStartAttack(target) then
            return
        end

        -- Если нужно развернуться перед ходьбой, сначала проигрываем turn.
        if self:faceTarget(target) then
            return
        end

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

    -- Запоминаем прошлую позицию для платформенной физики.
    self.previousX = self.x
    self.previousY = self.y

    self.x = self.x + self.vx * dt

    if self.flying then
        local flyAmplitude = self.flyAmplitude or 0
        local flyFrequency = self.flyFrequency or 0

        if flyAmplitude ~= 0 and flyFrequency ~= 0 then
            self.flyTime = (self.flyTime or 0) + dt
            self.flyBaseY = (self.flyBaseY or self.y) + (self.vy or 0) * dt
            self.y = self.flyBaseY + math.sin(self.flyTime * flyFrequency) * flyAmplitude
        else
            self.y = self.y + self.vy * dt
            self.flyBaseY = self.y
        end

        return
    end

    self.vy = self.vy + self.gravity * dt
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
    if self.dead then --если актор мертв
        return false --урон не нанесется
    end

	if self.invulnerable then --если актор неуязвимый
        return false --урон не нанесется
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


-- Включает/выключает возможность попасть по actor-у.
-- hittable = false значит projectile/melee/effect проходят сквозь actor-а.
-- duration optional: если задан, hittable автоматически вернётся в true.
function Actor:setHittable(value, duration)
    self.hittable = value == true
    self.hittableTimer = duration or 0
end

function Actor:updateHittable(dt)
    if self.hittable then
        return
    end

    if not self.hittableTimer or self.hittableTimer <= 0 then
        return
    end

    self.hittableTimer = self.hittableTimer - dt

    if self.hittableTimer <= 0 then
        self.hittable = true
        self.hittableTimer = 0
    end
end

-- Включает/выключает неуязвимость actor-а.
-- duration optional: если задан, invulnerable выключится автоматически.
function Actor:setInvulnerable(value, duration)
    self.invulnerable = value == true
    self.invulnerableTimer = duration or 0
end

function Actor:updateInvulnerability(dt)
    if not self.invulnerable then
        return
    end

    if not self.invulnerableTimer or self.invulnerableTimer <= 0 then
        return
    end

    self.invulnerableTimer = self.invulnerableTimer - dt

    if self.invulnerableTimer <= 0 then
        self.invulnerable = false
        self.invulnerableTimer = 0
    end
end

-- Проигрывает pain-анимацию, если она есть, nopain не включён
-- и прошёл roll по painChance.
-- painChance:
-- 1 или 100 = pain всегда
-- 0 = pain никогда
-- 0.35 или 35 = pain примерно 35% получений урона
function Actor:playPain()
    if self.nopain then
        return
    end

    local painChance = self.painChance

    if painChance == nil then
        painChance = 1
    end

    if painChance > 1 then
        painChance = painChance / 100
    end

    if painChance <= 0 then
        return
    end

    if painChance < 1 and not Utils.roll(painChance) then
        return
    end

    if self.animationSet:has("pain") then
        -- Pain перебивает turn, поэтому actor сразу получает нужный facing.
        self:applyPendingFacing()

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

-- Death перебивает turn, поэтому actor сразу получает нужный facing.
    self:applyPendingFacing()

    damageInfo = damageInfo or {}

    if damageInfo.deathType == "heavy" then
        if self.animationSet:has(self.heavyDeathAnimation) then
            self.state = self.heavyDeathAnimation
            self.animationSet:set(self.heavyDeathAnimation, true)
            return
        end

        if self:createHeavyDeathEffect(damageInfo) then
            self.deathFinished = true
            return
        end
    end

    self.state = "death"
    self.animationSet:set("death", true)
end

-- Обновляет actor-а.
function Actor:update(dt, world)
    if self.deathFinished then
        return
    end

	self:updateInvulnerability(dt)--неуязвимость
	self:updateHittable(dt)--удар или проджектайл пролетит насквозь

    if not self.dead then
        self:updateAi(dt, world)
        self:updatePhysics(dt)
    end

    local events = self.animationSet:update(dt)

    for _, event in ipairs(events) do
        table.insert(self.entitySpawnRequests, event)
    end

	if self.dead
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