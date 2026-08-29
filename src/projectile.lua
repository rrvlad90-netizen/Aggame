local AnimationSet = require("src.animation_set")
local Collision = require("src.collision")
local Render = require("src.render")

local Projectile = {}
Projectile.__index = Projectile

local function atan2(y, x)
    if math.atan2 then
        return math.atan2(y, x)
    end

    if x > 0 then
        return math.atan(y / x)
    end

    if x < 0 and y >= 0 then
        return math.atan(y / x) + math.pi
    end

    if x < 0 and y < 0 then
        return math.atan(y / x) - math.pi
    end

    if x == 0 and y > 0 then
        return math.pi / 2
    end

    if x == 0 and y < 0 then
        return -math.pi / 2
    end

    return 0
end

local function normalizeAngle(angle)
    while angle > math.pi do
        angle = angle - math.pi * 2
    end

    while angle < -math.pi do
        angle = angle + math.pi * 2
    end

    return angle
end

local function approachAngle(current, target, factor)
    local delta = normalizeAngle(target - current)

    return current + delta * factor
end

-- Создаёт projectile из definition.
-- Projectile используется для стрел, камней, магии, бомб и других летящих объектов.
function Projectile:new(config)
    config = config or {}

    local projectile = setmetatable({}, Projectile)

    projectile.id = config.id or "projectile"
    projectile.entityType = "projectile"
    projectile.targetGroup = config.targetGroup or config.target_group or "projectile"

    projectile.x = config.x or 0
    projectile.y = config.y or 0

    projectile.canvas = config.canvas or {
        width = config.w or config.width or 24,
        height = config.h or config.height or 24
    }

    projectile.offset = config.offset or {
        x = projectile.canvas.width / 2,
        y = projectile.canvas.height / 2
    }

    projectile.bbox = config.bbox or {
        x = 0,
        y = 0,
        w = projectile.canvas.width,
        h = projectile.canvas.height
    }

    projectile.image = config.image

    projectile.alpha = config.alpha or 1
    projectile.color = config.color or {1, 1, 1}

    projectile.facing = config.facing or 1
    projectile.flipSprite = config.flipSprite == true
        or config.flip_sprite == true

    projectile.owner = config.owner

    projectile.damage = config.damage or 1
    projectile.deathType = config.deathType or config.death_type or "normal"

    projectile.damageTargets = config.damageTargets
        or config.damage_targets
        or {}

    projectile.flight = config.flight or "straight"

    projectile.speed = config.speed or 0

    -- Если vx явно задан, используем его как раньше.
    -- Если vx не задан, строим горизонтальную скорость из speed и facing.
    local configuredVx = config.vx
        or config.speedX
        or config.speed_x

    if configuredVx ~= nil then
        projectile.vx = configuredVx
    else
        projectile.vx = projectile.speed * projectile.facing
    end

    projectile.vy = config.vy
        or config.speedY
        or config.speed_y
        or 0

    projectile.gravity = config.gravity or 0
	
	
---------ТЕНИ опционально

	projectile.shadowType = config.shadowType
        or config.shadow_type
        or 0

    projectile.shadowAlpha = config.shadowAlpha
        or config.shadow_alpha
        or 0.3

    projectile.shadowWidth = config.shadowWidth
        or config.shadow_width

    projectile.shadowHeight = config.shadowHeight
        or config.shadow_height

    projectile.shadowOffsetX = config.shadowOffsetX
        or config.shadow_offset_x
        or 0

    projectile.shadowOffsetY = config.shadowOffsetY
        or config.shadow_offset_y
        or 0

    projectile.shadowScaleX = config.shadowScaleX
        or config.shadow_scale_x

    projectile.shadowScaleY = config.shadowScaleY
        or config.shadow_scale_y

    projectile.shadowVisible = false
    projectile.shadowX = 0
    projectile.shadowY = 0
-------		

    -- Опциональный визуальный поворот sprite-а по направлению движения.
    -- Удобно для стрел и снарядов по дуге.
    projectile.rotateToVelocity = config.rotateToVelocity == true
        or config.rotate_to_velocity == true
		
-- Если projectile сам поворачивается по velocity, facing-зеркало не нужно.
    -- Иначе будет двойной разворот: rotation + scaleX = -scaleX.
    local ignoreFacingFlip = config.ignoreFacingFlip

    if ignoreFacingFlip == nil then
        ignoreFacingFlip = config.ignore_facing_flip
    end

    if ignoreFacingFlip == nil then
        ignoreFacingFlip = projectile.rotateToVelocity
    end

    projectile.ignoreFacingFlip = ignoreFacingFlip == true

    -- Для projectile без rotateToVelocity можно автоматически зеркалить sprite по vx.
    local mirrorToVelocity = config.mirrorToVelocity

    if mirrorToVelocity == nil then
        mirrorToVelocity = config.mirror_to_velocity
    end

    if mirrorToVelocity == nil then
        mirrorToVelocity = config.faceVelocity
            or config.face_velocity
    end

    if mirrorToVelocity == nil then
        mirrorToVelocity = not projectile.rotateToVelocity
    end

    projectile.mirrorToVelocity = mirrorToVelocity == true		

    -- Поправка угла под то, как нарисован исходный sprite.
    -- 0 подходит, если sprite смотрит вправо.
    projectile.rotationOffset = config.rotationOffset
        or config.rotation_offset
        or 0

    -- 0 = мгновенно следует за дугой.
    -- Значение вроде 12-24 даст плавный доворот.
    projectile.rotationSmoothing = config.rotationSmoothing
        or config.rotation_smoothing
        or 0

    -- Если скорость почти нулевая, угол не обновляем.
    projectile.rotationMinSpeed = config.rotationMinSpeed
        or config.rotation_min_speed
        or 1

    projectile.rotation = config.rotation
        or config.angle
        or 0

    projectile.rotationInitialized = false

    projectile.maxDistance = config.maxDistance
        or config.max_distance

    projectile.lifeTime = config.lifeTime
        or config.life_time

    projectile.age = 0
    projectile.traveledDistance = 0

    projectile.collides = config.collides or {
        actors = true,
        player = true,
        platforms = true,
        ground = true
    }

    projectile.impactEffect = config.impactEffect
        or config.impact_effect

    projectile.state = "idle"
    projectile.dead = false
    projectile.hitSomething = false

    projectile.effectSpawnRequests = {}
    projectile.entitySpawnRequests = {}

    projectile.animationSet = AnimationSet:new({
        default = config.defaultAnimation or config.default_animation or "idle",
        animations = config.animations or {
            idle = {
                loop = true,
                frames = config.image and {config.image} or {{}}
            },

            death = {
                loop = false,
                frames = config.image and {config.image} or {{}}
            }
        }
    })

	projectile.animationSet:set("idle", true)

	projectile:updateFacingFromVelocity()
	projectile:updateRotationFromVelocity(0)

	return projectile
end

-- Возвращает hitbox projectile-а в мировых координатах.
function Projectile:getHitbox()
    return Collision.localBoxToWorld(self, self.bbox)
end

-- Создаёт DamageInfo от projectile-а.
function Projectile:createDamageInfo()
    return {
        amount = self.damage,
        source = self,
        owner = self.owner,
        deathType = self.deathType,
        damageTargets = self.damageTargets
    }
end

-- Возвращает true, если projectile ещё может наносить урон.
function Projectile:canDamage()
    return not self.dead
        and not self.hitSomething
        and self.state == "idle"
end

-- Переводит projectile в death-состояние.
-- Death animation может создать impactEffect через frame events.
function Projectile:die()
    if self.dead or self.state == "death" then
        return
    end

    self.state = "death"
    self.hitSomething = true
    self.vx = 0
    self.vy = 0

    self.animationSet:set("death", true)

    if self.impactEffect then
        table.insert(self.effectSpawnRequests, {
            id = self.impactEffect,
            x = self.x,
            y = self.y
        })
    end
end

-- Обрабатывает попадание projectile-а.
-- World вызывает именно hit(), поэтому этот метод должен существовать.
function Projectile:hit()
    self:die()
end

-- Проверяет столкновение projectile-а с землёй.
-- После перехода на платформенную землю обычно ground отсутствует или выключен.
function Projectile:resolveGroundCollision(level)
    if not self.collides.ground or not level or not level.ground then
        return false
    end

    if self.y >= level.ground.y then
        self.y = level.ground.y
        self:die()
        return true
    end

    return false
end

-- Проверяет столкновение projectile-а с платформами.
-- Projectile сталкивается только с solid=true платформами.
-- Если у платформы solid=false или solid не указан, снаряд пролетает сквозь неё.
function Projectile:resolvePlatformCollision(level)
    if not self.collides.platforms or not level then
        return false
    end

    local hitbox = self:getHitbox()
    local platforms = level.platforms or {}

    -- При наличии индекса берём платформы только из ближайших секций.
    if level.getPlatformsNearRect then
        platforms = level:getPlatformsNearRect(
            hitbox,
            8
        )
    end

    for _, platform in ipairs(platforms) do
        if platform.collisionEnabled ~= false
            and platform.solid == true
        then
            local platformBox = platform:getHitbox()

            if platform.slope then
                local centerX =
                    hitbox.x + hitbox.w / 2

                local insideX =
                    centerX >= platformBox.x
                    and centerX
                        <= platformBox.x
                            + platformBox.w

                if insideX
                    and platform.getWalkYAtX
                then
                    local slopeY =
                        platform:getWalkYAtX(centerX)

                    local projectileBottomY =
                        hitbox.y + hitbox.h

                    local projectileTopY =
                        hitbox.y

                    local slopeBottomY = nil

                    if platform.getSlopeBottomY then
                        slopeBottomY =
                            platform:getSlopeBottomY()
                    else
                        slopeBottomY =
                            platformBox.y
                            + platformBox.h
                    end

                    -- Столкновение происходит только у линии склона.
                    if projectileBottomY >= slopeY
                        and projectileTopY
                            <= slopeBottomY
                    then
                        self:die()
                        return true
                    end
                end
            elseif Collision.intersects(
                hitbox,
                platformBox
            ) then
                self:die()
                return true
            end
        end
    end

    return false
end

-- Зеркалит projectile по горизонтальной скорости.
-- Работает для снарядов, которые НЕ используют rotateToVelocity.
function Projectile:updateFacingFromVelocity()
    if not self.mirrorToVelocity then
        return
    end

    local vx = self.vx or 0
    local minSpeed = self.rotationMinSpeed or 1

    if math.abs(vx) < minSpeed then
        return
    end

    if vx < 0 then
        self.facing = -1
    else
        self.facing = 1
    end
end

-- Поворачивает projectile по направлению текущей скорости.
-- rotateToVelocity включается отдельно в data/projectiles/*.lua.
function Projectile:updateRotationFromVelocity(dt)
    if not self.rotateToVelocity then
        return
    end

    local vx = self.vx or 0
    local vy = self.vy or 0
    local speedSquared = vx * vx + vy * vy
    local minSpeed = self.rotationMinSpeed or 1

    if speedSquared < minSpeed * minSpeed then
        return
    end

    local targetRotation = atan2(vy, vx) + (self.rotationOffset or 0)
    local smoothing = self.rotationSmoothing or 0

    if not self.rotationInitialized or smoothing <= 0 or not dt or dt <= 0 then
        self.rotation = targetRotation
        self.rotationInitialized = true
        return
    end

    local factor = math.min(1, smoothing * dt)

    self.rotation = approachAngle(self.rotation or 0, targetRotation, factor)
    self.rotationInitialized = true
end

-- Обновляет движение projectile-а.
function Projectile:updateMovement(dt)
    local previousX = self.x
    local previousY = self.y

    if self.gravity ~= 0 then
        self.vy = self.vy + self.gravity * dt
    end

	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt

	self:updateFacingFromVelocity()
	self:updateRotationFromVelocity(dt)

    local dx = self.x - previousX
    local dy = self.y - previousY

    self.traveledDistance = self.traveledDistance + math.sqrt(dx * dx + dy * dy)
end

-- Обновляет projectile: движение, столкновения, animation events и смерть.
function Projectile:update(dt, world)
    if self.dead then
        return
    end

    self.age = self.age + dt

    if self.lifeTime and self.age >= self.lifeTime then
        self:die()
    end

    if self.state == "idle" then
        self:updateMovement(dt)

        if self.maxDistance and self.traveledDistance >= self.maxDistance then
            self:die()
        end

        if world and world.level then
            if self:resolveGroundCollision(world.level) then
                return
            end

            if self:resolvePlatformCollision(world.level) then
                return
            end
        end
    end

    local events = self.animationSet:update(dt)

    for _, event in ipairs(events) do
        table.insert(self.entitySpawnRequests, event)
    end

    if self.state == "death"
        and self.animationSet:isCurrentFinished()
    then
        self.dead = true
    end
end

-- Возвращает и очищает запросы на создание effects.
function Projectile:consumeEffectSpawnRequests()
    local requests = self.effectSpawnRequests

    self.effectSpawnRequests = {}

    return requests
end

-- Возвращает и очищает события анимации.
function Projectile:consumeEntitySpawnRequests()
    local requests = self.entitySpawnRequests

    self.entitySpawnRequests = {}

    return requests
end

-- Рисует projectile.
function Projectile:draw(camera)
    Render.drawEntity(self, camera)
end

-- Возвращает true, если projectile можно удалить.
function Projectile:isRemovable()
    return self.dead
end

return Projectile