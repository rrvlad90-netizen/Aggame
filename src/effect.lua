local AnimationSet = require("src.animation_set")
local Collision = require("src.collision")
local Render = require("src.render")

local Effect = {}
Effect.__index = Effect

-- Создаёт effect из definition.
-- Effect используется для визуала, AoE, трупов, hazards и heavy death.
function Effect:new(config)
    config = config or {}

    local effect = setmetatable({}, Effect)

    effect.id = config.id or "effect"
    effect.entityType = "effect"
    effect.targetGroup = config.targetGroup or config.target_group or "effect"

    effect.x = config.x or 0
    effect.y = config.y or 0

    effect.canvas = config.canvas or {
        width = config.w or config.width or 32,
        height = config.h or config.height or 32
    }

    effect.offset = config.offset or {
        x = effect.canvas.width / 2,
        y = effect.canvas.height / 2
    }

    effect.bbox = config.bbox or {
        x = 0,
        y = 0,
        w = effect.canvas.width,
        h = effect.canvas.height
    }

    effect.hitbox = config.hitbox or effect.bbox

    effect.image = config.image
    effect.hidden = config.hidden == true

    effect.alpha = config.alpha or 1
    effect.color = config.color or {1, 0.5, 0.1}
	
-------Scale --Чисто визуальный эффект, на bbox и hitbox не влияет
effect.scale = config.scale or 1

    effect.scaleX = config.scaleX
        or config.scale_x
        or effect.scale

    effect.scaleY = config.scaleY
        or config.scale_y
        or effect.scale
-----Смещение для Scale если спрайт сьехал в сторону
	effect.drawOffsetX = config.drawOffsetX
        or config.draw_offset_x
        or config.visualOffsetX
        or config.visual_offset_x
        or 0

    effect.drawOffsetY = config.drawOffsetY
        or config.draw_offset_y
        or config.visualOffsetY
        or config.visual_offset_y
        or 0
--------------
    effect.facing = config.facing or 1
    effect.flipSprite = config.flipSprite == true
        or config.flip_sprite == true

    effect.damage = config.damage or 0
    effect.deathType = config.deathType or config.death_type or "normal"

    effect.damageTargets = config.damageTargets
        or config.damage_targets
        or {}

    effect.damageOnce = config.damageOnce ~= false
        and config.damage_once ~= false

    effect.damageApplied = false
	
---------ТЕНИ опционально

	effect.shadowType = config.shadowType
        or config.shadow_type
        or 0

    effect.shadowAlpha = config.shadowAlpha
        or config.shadow_alpha
        or 0.3

    effect.shadowWidth = config.shadowWidth
        or config.shadow_width

    effect.shadowHeight = config.shadowHeight
        or config.shadow_height

    effect.shadowOffsetX = config.shadowOffsetX
        or config.shadow_offset_x
        or 0

    effect.shadowOffsetY = config.shadowOffsetY
        or config.shadow_offset_y
        or 0

    effect.shadowScaleX = config.shadowScaleX
        or config.shadow_scale_x

    effect.shadowScaleY = config.shadowScaleY
        or config.shadow_scale_y

    effect.shadowVisible = false
    effect.shadowX = 0
    effect.shadowY = 0
-------	
	

    effect.flight = config.flight

    effect.vx = config.vx or config.speedX or config.speed_x or 0
    effect.vy = config.vy or config.speedY or config.speed_y or 0

    effect.speed = config.speed or 0
    effect.gravity = config.gravity or 0

    effect.maxDistance = config.maxDistance
        or config.max_distance

    effect.lifeTime = config.lifeTime
        or config.life_time

    effect.age = 0
    effect.traveledDistance = 0

    effect.collideGround = config.collideGround == true
        or config.collide_ground == true

    effect.collidePlatforms = config.collidePlatforms == true
        or config.collide_platforms == true

    effect.removeOnImpact = config.removeOnImpact ~= false
        and config.remove_on_impact ~= false

    effect.impactEffect = config.impactEffect
        or config.impact_effect
		
	effect.impactOffsetX = config.impactOffsetX
        or config.impact_offset_x
        or 0

    effect.impactOffsetY = config.impactOffsetY
        or config.impact_offset_y
        or 0		

    effect.dead = false
    effect.effectSpawnRequests = {}
    effect.entitySpawnRequests = {}

    effect.removeWhenAnimationFinished = config.removeWhenAnimationFinished

    if effect.removeWhenAnimationFinished == nil then
        effect.removeWhenAnimationFinished = true
    end

    effect.animationSet = AnimationSet:new({
        default = config.defaultAnimation or config.default_animation or "idle",
        animations = config.animations or {
            idle = {
                loop = true,
                frames = config.image and {config.image} or {}
            }
        }
    })

    return effect
end

-- Возвращает bbox effect-а в мировых координатах.
function Effect:getHitbox()
    return Collision.localBoxToWorld(self, self.bbox)
end

-- Возвращает damage hitbox effect-а в мировых координатах.
function Effect:getDamageHitbox()
    return Collision.localBoxToWorld(self, self.hitbox)
end

-- Возвращает true, если effect может наносить урон.
function Effect:canApplyDamage()
    if self.damage <= 0 then
        return false
    end

    if self.damageOnce and self.damageApplied then
        return false
    end

    return true
end

-- Создаёт DamageInfo от effect-а.
function Effect:createDamageInfo()
    return {
        amount = self.damage,
        source = self,
        owner = self.owner,
        deathType = self.deathType,
        damageTargets = self.damageTargets
    }
end

-- Помечает, что damage уже был применён.
function Effect:markDamageApplied()
    self.damageApplied = true
end

-- Создаёт effect при столкновении.
function Effect:createImpactEffect()
    if not self.impactEffect then
        return
    end

    local impactX = self.x + self.impactOffsetX
    local impactY = self.y + self.impactOffsetY

    local request = {
        id = self.impactEffect,
        x = impactX,
        y = impactY
    }

    if type(self.impactEffect) == "table" then
        request = {}

        for key, value in pairs(self.impactEffect) do
            request[key] = value
        end

        request.x = (request.x or self.x) + self.impactOffsetX
        request.y = (request.y or self.y) + self.impactOffsetY
    end

    table.insert(self.effectSpawnRequests, request)
end

-- Вызывается при ударе effect-а о землю или платформу.
function Effect:onImpact()
    self:createImpactEffect()

    if self.removeOnImpact then
        self.dead = true
    end
end

-- Проверяет столкновение effect-а с землёй.
function Effect:resolveGroundCollision(level)
    if not self.collideGround or not level or not level.ground then
        return false
    end

    local groundY = level.ground.y

    if self.y >= groundY then
        self.y = groundY
        self.vy = 0
        self:onImpact()
        return true
    end

    return false
end

-- Проверяет столкновение effect-а с solid-платформами.
function Effect:resolvePlatformCollision(level)
    if not self.collidePlatforms or not level then
        return false
    end

    local hitbox = self:getHitbox()

    for _, platform in ipairs(level.platforms or {}) do
        if platform.solid
            and Collision.intersects(hitbox, platform:getHitbox())
        then
            self:onImpact()
            return true
        end
    end

    return false
end

-- Обновляет движение effect-а.
function Effect:updateMovement(dt)
    local previousX = self.x
    local previousY = self.y

    if self.gravity ~= 0 then
        self.vy = self.vy + self.gravity * dt
    end

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    local dx = self.x - previousX
    local dy = self.y - previousY

    self.traveledDistance = self.traveledDistance + math.sqrt(dx * dx + dy * dy)
end

-- Обновляет effect.
function Effect:update(dt, world)
    if self.dead then
        return
    end

    self.age = self.age + dt

    if self.lifeTime and self.age >= self.lifeTime then
        self.dead = true
        return
    end

    self:updateMovement(dt)

    if self.maxDistance and self.traveledDistance >= self.maxDistance then
        self.dead = true
        return
    end

    if world and world.level then
        if self:resolveGroundCollision(world.level) then
            return
        end

        if self:resolvePlatformCollision(world.level) then
            return
        end
    end

    local events = self.animationSet:update(dt)

    for _, event in ipairs(events) do
        table.insert(self.entitySpawnRequests, event)
    end

    if self.removeWhenAnimationFinished
        and self.animationSet:isCurrentFinished()
    then
        self.dead = true
    end
end

-- Возвращает и очищает запросы на создание effects.
function Effect:consumeEffectSpawnRequests()
    local requests = self.effectSpawnRequests

    self.effectSpawnRequests = {}

    return requests
end

-- Возвращает и очищает события анимации.
function Effect:consumeEntitySpawnRequests()
    local requests = self.entitySpawnRequests

    self.entitySpawnRequests = {}

    return requests
end

-- Рисует effect.
function Effect:draw(camera)
    if self.hidden then
        return
    end

    Render.drawEntity(self, camera)
end

-- Возвращает true, если effect можно удалить.
function Effect:isRemovable()
    return self.dead
end

return Effect