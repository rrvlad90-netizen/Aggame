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
	
-----для раннер акторов - игнорирование правого ула жкрана (не застряют)	
	actor.ignoreLevelBounds = config.ignoreLevelBounds == true
        or config.ignore_level_bounds == true
        or config.allowOutsideLevelBounds == true
        or config.allow_outside_level_bounds == true
-------

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
		
-- Позволяет actor-у выходить за bounds уровня.
    -- Полезно для runner-врагов, которые должны уйти за экран в despawn_zone.
    actor.ignoreLevelBounds = config.ignoreLevelBounds == true
        or config.ignore_level_bounds == true
        or config.canLeaveLevelBounds == true
        or config.can_leave_level_bounds == true		
		
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

-------Scale --Чисто визуальный эффект, на bbox и hitbox не влияет
	actor.scale = config.scale or 1

    actor.scaleX = config.scaleX
        or config.scale_x
        or actor.scale

    actor.scaleY = config.scaleY
        or config.scale_y
        or actor.scale		
-----Смещение для Scale если спрайт сьехал в сторону
	actor.drawOffsetX = config.drawOffsetX
        or config.draw_offset_x
        or config.visualOffsetX
        or config.visual_offset_x
        or 0

    actor.drawOffsetY = config.drawOffsetY
        or config.draw_offset_y
        or config.visualOffsetY
        or config.visual_offset_y
        or 0
-----
	actor.animationGroups = config.animationGroups
		or config.animation_groups
		or {}
	

    actor.hates = config.hates or {}
    actor.damageTargets = config.damageTargets
        or config.damage_targets
        or {}
		
----------Contact damage - если враг соприкоснется с игроком то дамажит
	actor.contactDamage = config.contactDamage
        or config.contact_damage
        or config.touchDamage
        or config.touch_damage
        or 0

    actor.contactDamageCooldown = config.contactDamageCooldown
        or config.contact_damage_cooldown
        or config.touchDamageCooldown
        or config.touch_damage_cooldown
        or 0.5

    actor.contactDamageTimer = 0

    actor.contactDeathType = config.contactDeathType
        or config.contact_death_type
        or "normal"

    actor.contactDamageTargets = config.contactDamageTargets
        or config.contact_damage_targets
        or config.touchDamageTargets
        or config.touch_damage_targets
        or actor.damageTargets
		
---------ТЕНИ опционально

actor.shadowType = config.shadowType
        or config.shadow_type
        or 0

    actor.shadowAlpha = config.shadowAlpha
        or config.shadow_alpha
        or 0.3

    actor.shadowWidth = config.shadowWidth
        or config.shadow_width

    actor.shadowHeight = config.shadowHeight
        or config.shadow_height

    actor.shadowOffsetX = config.shadowOffsetX
        or config.shadow_offset_x
        or 0

    actor.shadowOffsetY = config.shadowOffsetY
        or config.shadow_offset_y
        or 0

    actor.shadowScaleX = config.shadowScaleX
        or config.shadow_scale_x

    actor.shadowScaleY = config.shadowScaleY
        or config.shadow_scale_y

    actor.shadowVisible = false
    actor.shadowX = 0
    actor.shadowY = 0
-------

	
		
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
------NPC Следует за игроком
	actor.followPlayer = config.followPlayer == true
        or config.follow_player == true

    actor.followDistance = config.followDistance
        or config.follow_distance
        or 90

    actor.followMaxDistance = config.followMaxDistance
        or config.follow_max_distance
        or 900

    actor.followSpeed = config.followSpeed
        or config.follow_speed
        or actor.speed

    actor.followVertical = config.followVertical == true
        or config.follow_vertical == true

    actor.followVerticalDistance = config.followVerticalDistance
        or config.follow_vertical_distance
        or 60
----------		
	
	if config.runnerMode == true--раннер, бежит и атакует
			or config.runner_mode == true
		then
			actor.movementMode = "runner"
		end		
		
	actor.keepMovingDuringAttack = config.keepMovingDuringAttack == true
        or config.keep_moving_during_attack == true

    actor.attackMoveSpeed = config.attackMoveSpeed
        or config.attack_move_speed		

    actor.showHealthBar = config.showHealthBar == true
        or config.show_health_bar == true

	actor.sceneIfActorDeath = config.SceneIfActorDeath
        or config.sceneIfActorDeath
        or config.scene_if_actor_death

    actor.sceneIfPlayerDieByActor = config.SceneIfPlayerDieByActor
        or config.sceneIfPlayerDieByActor
        or config.scene_if_player_die_by_actor

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
	
	-- Обычные actor-ы перед атакой разворачиваются к цели.
    -- Runner не разворачивается: он атакует только по своему facing.
    if not self:isRunner() and self:faceTarget(target) then
        return true
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

--RUNNER
-- Возвращает true, если actor работает как runner. не разворачивается к игроку, а всегда идёт по своему facing
function Actor:isRunner()
    return self.movementMode == "runner"
end

-- Возвращает true, если target находится впереди actor-а по его facing.
-- facing = 1  значит впереди справа.
-- facing = -1 значит впереди слева.
function Actor:isTargetInFront(target)
    if not target then
        return false
    end

    local dx = (target.x or 0) - self.x
    local facing = self.facing or 1

    if facing >= 0 then
        return dx >= 0
    end

    return dx <= 0
end

-- Обновляет AI actor-а.
-- Возвращает игрока как цель следования.
-- Это не hostile target: NPC не будет атаковать игрока из-за followPlayer.
function Actor:getFollowPlayerTarget(world)
    if not self.followPlayer then
        return nil
    end

    if not world or not world.player then
        return nil
    end

    if world.player.dead then
        return nil
    end

    return world.player
end

-- Двигает actor-а за игроком, если включён followPlayer.
-- Возвращает true, если follow-логика обработала AI в этом кадре.
function Actor:tryFollowPlayer(world)
    local target = self:getFollowPlayerTarget(world)

    if not target then
        return false
    end

    local dx = target.x - self.x
    local distanceX = math.abs(dx)

    if distanceX > self.followMaxDistance then
        self.vx = 0

        if self.flying then
            self.vy = 0
        end

        self.state = "idle"
        self.animationSet:set("idle")

        return true
    end

    local moving = false

    if distanceX > self.followDistance then
        local facing = dx > 0 and 1 or -1

        if self:startTurn(facing) then
            return true
        end

        self.facing = facing
        self.vx = self.facing * self.followSpeed
        moving = true
    else
        self.vx = 0
    end

    if self.flying and self.followVertical then
        local dy = target.y - self.y
        local distanceY = math.abs(dy)

        if distanceY > self.followVerticalDistance then
            self.vy = dy > 0 and self.followSpeed or -self.followSpeed
            moving = true
        else
            self.vy = 0
        end
    end

    if moving then
        self.state = "walk"
        self.animationSet:set("walk")
    else
        self.state = "idle"
        self.animationSet:set("idle")
    end

    return true
end


-- Обновляет AI actor-а.
function Actor:updateAi(dt, world)
    if self.dead then
        return
    end

    -- Пока идёт turn, actor стоит и ждёт конца анимации.
    if self.state == "turn" then
        self.vx = 0

        if self.flying then
            self.vy = 0
        end

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
        self.vx = 0

        if self.flying then
            self.vy = 0
        end

        return
    end

    local target = self:selectTarget(world and world:getTargetGroups() or {})

-- Runner mode: actor всегда идёт только вперёд.
    -- Он не разворачивается за целью и не ждёт searchRange.
    if self.movementMode == "runner" then
        local target = self:selectTarget(world and world:getTargetGroups() or {})

        if target then
            local animationName = self:chooseAttackAnimation(target)

            if animationName then
                if self.keepMovingDuringAttack then
                    self.vx = self.facing * (self.attackMoveSpeed or self.speed)
                else
                    self.vx = 0
                end

                if self.flying then
                    self.vy = 0
                end

                self.state = animationName
                self.animationSet:set(animationName, true)

                return
            end
        end

        self.vx = self.facing * self.speed

        if self.flying then
            self.vy = 0
        end

        self.state = "walk"
        self.animationSet:set("walk")

        return
    end



    -- 1. Сначала hostile target: враги важнее следования за игроком.
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

            if self.flying then
                self.vy = 0
            end

            self.state = "walk"
            self.animationSet:set("walk")
            return
        end
    end

    -- 2. Если врагов нет или actor не пошёл к ним — следуем за игроком.
    if self:tryFollowPlayer(world) then
        return
    end

    -- 3. Иначе idle.
    self.vx = 0

    if self.flying then
        self.vy = 0
    end

    self.state = "idle"
    self.animationSet:set("idle")
end


-- Обновляет runner AI.
-- Runner:
-- - не разворачивается к цели;
-- - всегда идёт вперёд по facing;
-- - атакует только если цель впереди и попадает в attackGroups;
-- - если цель сзади, игнорирует её и продолжает движение.
function Actor:updateRunnerAi(dt, world)
    local target = self:selectTarget(world and world:getTargetGroups() or {})

    if target and self:isTargetInFront(target) then
        if self:tryStartAttack(target) then
            return
        end
    end

    self.vx = (self.facing or 1) * (self.speed or 0)
    self.state = "walk"
    self.animationSet:set("walk")
end

-----------------------------------------





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


-- Возвращает true, если actor может нанести contact damage сейчас.
-- Contact damage — это урон телом actor-а при пересечении bbox с целью.
function Actor:canApplyContactDamage()
    return not self.dead
        and (self.contactDamage or 0) > 0
        and (self.contactDamageTimer or 0) <= 0
end

-- Создаёт DamageInfo для contact damage.
function Actor:createContactDamageInfo()
    return {
        amount = self.contactDamage or 1,
        source = self,
        owner = self,
        deathType = self.contactDeathType or "normal",
        damageTargets = self.contactDamageTargets or self.damageTargets
    }
end

-- Запускает cooldown после contact damage.
function Actor:markContactDamageApplied()
    self.contactDamageTimer = self.contactDamageCooldown or 0.5
end

-- Обновляет cooldown contact damage.
function Actor:updateContactDamage(dt)
    if not self.contactDamageTimer or self.contactDamageTimer <= 0 then
        return
    end

    self.contactDamageTimer = math.max(0, self.contactDamageTimer - dt)
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

    damageInfo = damageInfo or {}

    local source = damageInfo.source
    local owner = damageInfo.owner

------------

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
	self:updateContactDamage(dt)--враг наносит урон при соприкосновении

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