local AnimationSet = require("src.animation_set")
local Collision = require("src.collision")
local Render = require("src.render")

local Projectile = {}
Projectile.__index = Projectile

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
function Projectile:resolvePlatformCollision(level)
    if not self.collides.platforms or not level then
        return false
    end

    local hitbox = self:getHitbox()

    for _, platform in ipairs(level.platforms or {}) do
        if Collision.intersects(hitbox, platform:getHitbox()) then
            self:die()
            return true
        end
    end

    return false
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