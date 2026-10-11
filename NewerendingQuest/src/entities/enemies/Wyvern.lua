local Config =
    require("src.config")

local Animator =
    require("src.animation.Animator")

local WyvernData =
    require("data.entities.enemies.wyvern")

local Wyvern = {}
Wyvern.__index = Wyvern

-- Создаёт летающую виверну.
function Wyvern.new(
    assets,
    x,
    z
)
    local self =
        setmetatable(
            {},
            Wyvern
        )

    self.assets = assets

    self.type = "wyvern"

    self.x = x or 0
    self.z = z or 0

    self.height =
        WyvernData.flyingHeight

    self.health =
        WyvernData.health

    self.maximumHealth =
        WyvernData.health

    self.speed =
        WyvernData.speed *
        Config.worldUnitsPerMeter

    self.retreatSpeed =
        WyvernData.retreatSpeed *
        Config.worldUnitsPerMeter

    self.detectionRange =
        WyvernData.detectionRange *
        Config.worldUnitsPerMeter

    self.preferredMinimumRange =
        WyvernData.preferredMinimumRange *
        Config.worldUnitsPerMeter

    self.preferredMaximumRange =
        WyvernData.preferredMaximumRange *
        Config.worldUnitsPerMeter

    self.collisionRadius =
        WyvernData.collisionRadius

    self.facing =
        WyvernData.defaultDirection

    self.state = "idle"
    self.stateTime = 0

    self.attackCooldown = 0
    self.projectileReleased = false
    self.pendingProjectile = nil

    self.active = true
    self.dead = false
    self.removeRequested = false

    self.animator =
        Animator.new(
            assets,
            WyvernData.animations,
            "idle_" .. self.facing
        )

    return self
end

-- Возвращает название направленной анимации.
function Wyvern:getAnimationName(action)
    return
        action ..
        "_" ..
        self.facing
end

-- Включает направленную анимацию.
function Wyvern:setAnimation(
    action,
    restart
)
    local animationName =
        self:getAnimationName(
            action
        )

    if
        WyvernData.animations[
            animationName
        ]
    then
        self.animator:play(
            animationName,
            restart
        )
    end
end

-- Выбирает направление по вектору.
function Wyvern:updateFacing(dx, dz)
    if
        math.abs(dx) < 0.001 and
        math.abs(dz) < 0.001
    then
        return
    end

    local horizontalThreshold =
        0.42

    local length =
        math.sqrt(
            dx * dx +
            dz * dz
        )

    local horizontal =
        dx / length

    local vertical =
        dz / length

    if vertical > horizontalThreshold then
        if horizontal < -horizontalThreshold then
            self.facing =
                "north_west"
        elseif horizontal > horizontalThreshold then
            self.facing =
                "north_east"
        else
            self.facing =
                "north"
        end
    elseif vertical < -horizontalThreshold then
        if horizontal < -horizontalThreshold then
            self.facing =
                "south_west"
        elseif horizontal > horizontalThreshold then
            self.facing =
                "south_east"
        else
            self.facing =
                "south"
        end
    elseif horizontal < 0 then
        self.facing =
            "west"
    else
        self.facing =
            "east"
    end
end

-- Проверяет, доступен ли игрок для атаки.
function Wyvern:playerIsAvailable(player)
    return
        not player.gameOver and
        player.state ~= "dying" and
        player.state ~= "dead" and
        player.state ~= "respawning"
end

-- Возвращает расстояние до игрока.
function Wyvern:getDistanceToPlayer(player)
    local dx =
        player.x - self.x

    local dz =
        player.z - self.z

    return math.sqrt(
        dx * dx +
        dz * dz
    )
end

-- Ограничивает позицию границами мира.
function Wyvern:clampPosition(
    x,
    z,
    world
)
    if
        world and
        world.clampPosition
    then
        return world:clampPosition(
            x,
            z
        )
    end

    return x, z
end

-- Перемещает виверну по указанному вектору.
function Wyvern:moveByVector(
    dt,
    dx,
    dz,
    speed,
    world
)
    local length =
        math.sqrt(
            dx * dx +
            dz * dz
        )

    if length < 0.001 then
        return
    end

    dx = dx / length
    dz = dz / length

    local targetX =
        self.x +
        dx *
        speed *
        dt

    local targetZ =
        self.z +
        dz *
        speed *
        dt

    targetX, targetZ =
        self:clampPosition(
            targetX,
            targetZ,
            world
        )

    self.x = targetX
    self.z = targetZ
end

-- Приближается к игроку.
function Wyvern:moveTowards(
    dt,
    player,
    world
)
    local dx =
        player.x - self.x

    local dz =
        player.z - self.z

    self:updateFacing(dx, dz)

    self:moveByVector(
        dt,
        dx,
        dz,
        self.speed,
        world
    )

    self:setAnimation("fly")
end

-- Отдаляется от игрока.
function Wyvern:moveAway(
    dt,
    player,
    world
)
    local dx =
        self.x - player.x

    local dz =
        self.z - player.z

    self:updateFacing(
        player.x - self.x,
        player.z - self.z
    )

    self:moveByVector(
        dt,
        dx,
        dz,
        self.speed,
        world
    )

    self:setAnimation("fly")
end

-- Разлетается в сторону после смерти игрока.
function Wyvern:retreat(
    dt,
    player,
    world
)
    local dx =
        self.x - player.x

    local dz =
        self.z - player.z

    if
        math.abs(dx) < 0.001 and
        math.abs(dz) < 0.001
    then
        dx = 1
    end

    self:updateFacing(dx, dz)

    self:moveByVector(
        dt,
        dx,
        dz,
        self.retreatSpeed,
        world
    )

    self:setAnimation("fly")
end

-- Начинает дальнюю атаку.
function Wyvern:startAttack(player)
    self.state = "attacking"
    self.stateTime = 0

    self.projectileReleased =
        false

    self:updateFacing(
        player.x - self.x,
        player.z - self.z
    )

    self:setAnimation(
        "attack",
        true
    )
end

-- Подготавливает огненный шар.
function Wyvern:createFireball(player)
    self.pendingProjectile = {
        type = "wyvern_fireball",

        x = self.x,
        z = self.z,

        height =
            self.height *
            0.75,

        targetX =
            player.x,

        targetZ =
            player.z,

        targetHeight =
            math.max(
                20,
                player.height or 0
            ),

        sourceX =
            self.x,

        sourceZ =
            self.z
    }
end

-- Возвращает подготовленный снаряд.
function Wyvern:takePendingProjectile()
    local projectile =
        self.pendingProjectile

    self.pendingProjectile = nil

    return projectile
end

-- Обновляет дальнюю атаку.
function Wyvern:updateAttack(
    dt,
    player
)
    self.stateTime =
        self.stateTime +
        dt

    self:updateFacing(
        player.x - self.x,
        player.z - self.z
    )

    if
        not self.projectileReleased and
        self.stateTime >=
        WyvernData.attackFireTime
    then
        self.projectileReleased =
            true

        self:createFireball(
            player
        )
    end

    if
        self.stateTime <
        WyvernData.attackDuration
    then
        return
    end

    self.state = "idle"
    self.stateTime = 0

    self.attackCooldown =
        WyvernData.attackCooldown

    self:setAnimation(
        "idle",
        true
    )
end

-- Начинает реакцию на урон.
function Wyvern:startHurt()
    self.state = "hurt"
    self.stateTime = 0

    self:setAnimation(
        "hurt",
        true
    )
end

-- Обновляет реакцию на урон.
function Wyvern:updateHurt(dt)
    self.stateTime =
        self.stateTime +
        dt

    if
        self.stateTime <
        WyvernData.hurtDuration
    then
        return
    end

    self.state = "idle"
    self.stateTime = 0

    self:setAnimation(
        "idle",
        true
    )
end

-- Начинает смерть виверны.
function Wyvern:startDeath()
    if self.dead then
        return
    end

    self.dead = true

    self.state = "dying"
    self.stateTime = 0

    self.pendingProjectile = nil

    self:setAnimation(
        "death",
        true
    )
end

-- Обновляет смерть виверны.
function Wyvern:updateDeath(dt)
    self.stateTime =
        self.stateTime +
        dt

    self.height =
        math.max(
            0,
            self.height -
            90 * dt
        )

    if
        self.stateTime <
        WyvernData.deathDuration
    then
        return
    end

    self.state = "corpse"
    self.stateTime = 0
    self.height = 0
end

-- Получает урон от игрока.
function Wyvern:receiveAttackHit(
    damage,
    attackType
)
    if self.dead then
        return false
    end

    self.health =
        math.max(
            0,
            self.health -
            (damage or 1)
        )

    if self.health <= 0 then
        self:startDeath()
    else
        self:startHurt()
    end

    return false
end

-- Отбрасывает виверну ударной волной.
function Wyvern:applyShockwave(
    sourceX,
    sourceZ,
    force,
    damage
)
    if self.dead then
        return
    end

    local dx =
        self.x - sourceX

    local dz =
        self.z - sourceZ

    local length =
        math.sqrt(
            dx * dx +
            dz * dz
        )

    if length < 0.001 then
        dx = 1
        dz = 0
        length = 1
    end

    self.x =
        self.x +
        dx / length *
        (force or 0)

    self.z =
        self.z +
        dz / length *
        (force or 0)

    if
        damage and
        damage > 0
    then
        self:receiveAttackHit(
            damage,
            "shockwave"
        )
    end
end

-- Проверяет смерть врага.
function Wyvern:isDead()
    return self.dead
end

-- Проверяет необходимость удаления.
function Wyvern:shouldRemove(cameraZ)
    if self.removeRequested then
        return true
    end

    if self.state ~= "corpse" then
        return false
    end

    return
        self.z <
        cameraZ -
        Config.projection.
        visibleBehindDepth
end

-- Обновляет виверну.
-- cameraZ оставлен третьим аргументом для общего интерфейса врагов.
function Wyvern:update(
    dt,
    player,
    cameraZ,
    world
)
    self.animator:update(dt)

    if not self.active then
        return
    end

    if self.state == "dying" then
        self:updateDeath(dt)
        return
    end

    if self.state == "corpse" then
        return
    end

    if self.state == "hurt" then
        self:updateHurt(dt)
        return
    end

    if self.state == "attacking" then
        self:updateAttack(
            dt,
            player
        )

        return
    end

    self.attackCooldown =
        math.max(
            0,
            self.attackCooldown -
            dt
        )

    if not self:playerIsAvailable(player) then
        self:retreat(
            dt,
            player,
            world
        )

        return
    end

    local dx =
        player.x - self.x

    local dz =
        player.z - self.z

    self:updateFacing(dx, dz)

    local distance =
        self:getDistanceToPlayer(
            player
        )

    if distance > self.detectionRange then
        self.state = "idle"
        self:setAnimation("idle")
        return
    end

    if
        distance >
        self.preferredMaximumRange
    then
        self.state = "flying"

        self:moveTowards(
            dt,
            player,
            world
        )

        return
    end

    if
        distance <
        self.preferredMinimumRange
    then
        self.state = "flying"

        self:moveAway(
            dt,
            player,
            world
        )

        return
    end

    if self.attackCooldown <= 0 then
        self:startAttack(player)
        return
    end

    self.state = "idle"
    self:setAnimation("idle")
end

-- Рисует виверну.
function Wyvern:draw(
    projection,
    cameraX,
    cameraZ
)
    local x, y, perspectiveScale =
        projection:project(
            self.x,
            self.z,
            cameraX,
            cameraZ
        )

    y =
        y -
        self.height *
        perspectiveScale

    local image =
        self.animator:
        getCurrentImage()

    if not image then
        return
    end

    local spriteScale =
        perspectiveScale *
        WyvernData.spriteHeight /
        image:getHeight() *
        WyvernData.scale

    local alpha =
        projection:
        getVisibilityAlpha(
            self.z,
            cameraZ
        )

    love.graphics.setColor(
        1,
        1,
        1,
        alpha
    )

    love.graphics.draw(
        image,
        x,
        y,
        0,
        spriteScale,
        spriteScale,
        image:getWidth() / 2,
        image:getHeight()
    )

    love.graphics.setColor(
        1,
        1,
        1,
        1
    )
end

return Wyvern