local SoundCache =
    require("src.audio.SoundCache")

local Config =
    require("src.config")

local SkeletonData =
    require("data.entities.enemies.skeleton")

local Animator =
    require("src.animation.Animator")

local Skeleton = {}
Skeleton.__index = Skeleton

-- Создаёт обычного скелета или вариант со щитом.
function Skeleton.new(
    assets,
    x,
    z,
    options
)
    local self =
        setmetatable({}, Skeleton)

    options = options or {}

    self.assets = assets

    self.type =
        options.hasShield and
        "shield_skeleton" or
        "skeleton"

    self.hasShield =
        options.hasShield == true

    self.random =
        love.math.newRandomGenerator(
            options.seed or 1
        )

    self.x = x
    self.z = z
    self.height = 0

    self.health =
        SkeletonData.health

    self.maximumHealth =
        SkeletonData.health

    self.collisionRadius =
        SkeletonData.collisionRadius

    self.detectionRange =
        SkeletonData.detectionRange *
        Config.worldUnitsPerMeter

    self.attackRange =
        SkeletonData.attackRange *
        Config.worldUnitsPerMeter

    self.facing =
        SkeletonData.defaultDirection

    self.state = "idle"
    self.stateTime = 0

    self.attackCooldown = 0
    self.attackHitDone = false

    self.active = true

    self.currentAction = "idle"
    self.animationFacing = self.facing
	
	self.dropRolled = false
	self.pendingDrops = {}

	if options.dropsVisible == nil then
		self.dropsVisible =
			SkeletonData.drops.visible
	else
		self.dropsVisible =
			options.dropsVisible
	end

    self.animator =
        Animator.new(
            assets,
            SkeletonData.animations,
            "idle_" .. self.facing
        )

    return self
end

-- Запускает направленную анимацию.
function Skeleton:setAnimation(
    action,
    restart
)
    local animationName =
        action ..
        "_" ..
        self.facing

    if
        not SkeletonData.animations[
            animationName
        ]
    then
        return
    end

    local changed =
        self.currentAction ~= action or
        self.animationFacing ~= self.facing

    if
        not changed and
        not restart
    then
        return
    end

    self.currentAction = action
    self.animationFacing =
        self.facing

    self.animator:play(
        animationName,
        restart == true
    )
end

-- Выбирает направление взгляда.
function Skeleton:updateFacing(dx, dz)
    if dx == 0 and dz == 0 then
        return
    end

    local horizontal = 0
    local vertical = 0

    local threshold = 0.38

    if dx < -threshold then
        horizontal = -1
    elseif dx > threshold then
        horizontal = 1
    end

    if dz < -threshold then
        vertical = -1
    elseif dz > threshold then
        vertical = 1
    end

    if vertical > 0 then
        if horizontal < 0 then
            self.facing = "north_west"
        elseif horizontal > 0 then
            self.facing = "north_east"
        else
            self.facing = "north"
        end
    elseif vertical < 0 then
        if horizontal < 0 then
            self.facing = "south_west"
        elseif horizontal > 0 then
            self.facing = "south_east"
        else
            self.facing = "south"
        end
    elseif horizontal < 0 then
        self.facing = "west"
    else
        self.facing = "east"
    end
end

-- Проверяет возможность получить урон.
function Skeleton:isDamageable()
    return
        self.active and
        self.state ~= "death" and
        self.state ~= "corpse"
end

-- Проверяет попадание снаряда.
function Skeleton:isHitBy(projectile)
    if not self:isDamageable() then
        return false
    end

    local dx =
        projectile.x - self.x

    local dz =
        projectile.z - self.z

    local radius =
        self.collisionRadius +
        projectile.collisionRadius

    return
        dx * dx +
        dz * dz <=
        radius * radius
end

-- Обрабатывает попадание меча или стрелы.
function Skeleton:receiveAttackHit(
    damage,
    attackType
)
    if not self:isDamageable() then
        return false
    end

    if
        self.hasShield and
        self.random:random() <
        SkeletonData.shieldBlockChance
    then
        self.state = "block"
        self.stateTime = 0

        self:setAnimation(
            "block",
            true
        )

        SoundCache:play(
            SkeletonData.shieldBlockSound
        )

        return true
    end

    local damaged =
        self:takeDamage(
            damage
        )

    if damaged then
        SoundCache:play(
            SkeletonData.hitSound
        )
    end

    return damaged
end

-- Оставляет совместимость со стрелами.
function Skeleton:receiveArrowHit(damage)
    return self:receiveAttackHit(
        damage,
        "arrow"
    )
end

-- Наносит скелету урон.
function Skeleton:takeDamage(amount)
    if not self:isDamageable() then
        return false
    end

    self.health =
        math.max(
            0,
            self.health -
            (amount or 1)
        )

    self.stateTime = 0

    if self.health <= 0 then
        self.state = "death"

        self:setAnimation(
            "death",
            true
        )
    else
        self.state = "hurt"

        self:setAnimation(
            "hurt",
            true
        )
    end

    return true
end

-- Определяет все предметы после смерти.
function Skeleton:rollDeathDrop()
    if self.dropRolled then
        return
    end

    self.dropRolled = true

    local drops =
        SkeletonData.drops

    local forwardOffset =
        drops.forwardOffset *
        Config.worldUnitsPerMeter

    local sideOffset =
        drops.sideOffset *
        Config.worldUnitsPerMeter

    local dropZ =
        self.z -
        forwardOffset

    -- Стрелы и пузырёк проверяются независимо.
    if
        self.random:random() <
        drops.arrowBundleChance
    then
        self.pendingDrops[
            #self.pendingDrops + 1
        ] = {
            type = "arrow_bundle",

            x =
                self.x -
                sideOffset,

            z = dropZ,

            visible =
                self.dropsVisible
        }
    end

    if
        self.random:random() <
        drops.healthPotionChance
    then
        local variant = "small"

        if
            self.random:random() <
            drops.largePotionChance
        then
            variant = "large"
        end

        self.pendingDrops[
            #self.pendingDrops + 1
        ] = {
            type = "health_potion",

            x =
                self.x +
                sideOffset,

            z = dropZ,

            variant = variant,

            visible =
                self.dropsVisible
        }
    end
end

-- Забирает все ожидающие предметы.
function Skeleton:takePendingDrops()
    if #self.pendingDrops == 0 then
        return nil
    end

    local drops =
        self.pendingDrops

    self.pendingDrops = {}

    return drops
end

-- Начинает ближнюю атаку.
function Skeleton:startAttack()
    self.state = "attack"
    self.stateTime = 0

    self.attackHitDone = false

    self:setAnimation(
        "attack",
        true
    )
end

-- Обновляет ближнюю атаку скелета.
function Skeleton:updateAttack(
    dt,
    player
)
    self.stateTime =
        self.stateTime + dt

    if
        not self.attackHitDone and
        self.stateTime >=
        SkeletonData.attackHitTime
    then
        self.attackHitDone = true

        local dx =
            player.x - self.x

        local dz =
            player.z - self.z

        local distanceSquared =
            dx * dx + dz * dz

        local hitRange =
            self.attackRange +
            player.collisionRadius

        if
            distanceSquared <=
            hitRange * hitRange
        then
            player:takeDamage(
                SkeletonData.attackDamage,

                -- Координаты нужны для проверки щита.
                self.x,
                self.z
            )
        end
    end

    if
        self.stateTime <
        SkeletonData.attackDuration
    then
        return
    end

    self.state = "idle"
    self.stateTime = 0

    self.attackCooldown =
        SkeletonData.attackCooldown

    self:setAnimation(
        "idle",
        true
    )
end

-- Перемещает скелета к игроку.
function Skeleton:moveTowardsPlayer(
    dt,
    player,
    world,
    dx,
    dz,
    distance
)
    if distance <= 0 then
        return
    end

    local directionX =
        dx / distance

    local directionZ =
        dz / distance

    self:updateFacing(
        directionX,
        directionZ
    )

    local candidateX =
        self.x +
        directionX *
        SkeletonData.speed *
        dt

    local candidateZ =
        self.z +
        directionZ *
        SkeletonData.speed *
        dt

    if world.clampPosition then
        candidateX, candidateZ =
            world:clampPosition(
                candidateX,
                candidateZ
            )
    end

    if world.resolveMovement then
        candidateX, candidateZ =
            world:resolveMovement(
                self.x,
                self.z,
                candidateX,
                candidateZ,
                self.collisionRadius
            )
    end

    self.x = candidateX
    self.z = candidateZ

    self:setAnimation(
        "walk"
    )
end

-- Проверяет, должен ли враг прекратить атаку.
function Skeleton:playerIsUnavailable(player)
    return
        player.gameOver or
        player.state == "dying" or
        player.state == "respawning" or
        player.state == "dead"
end

-- Отходит от погибшего или возрождающегося игрока.
function Skeleton:moveAwayFromPlayer(
    dt,
    player,
    world
)
    local dx =
        self.x - player.x

    local dz =
        self.z - player.z

    local distanceSquared =
        dx * dx + dz * dz

    local retreatRange =
        SkeletonData.retreatRange *
        Config.worldUnitsPerMeter

    if
        distanceSquared <= 0 or
        distanceSquared >
        retreatRange * retreatRange
    then
        self.state = "idle"

        self:setAnimation(
            "idle"
        )

        return
    end

    local distance =
        math.sqrt(distanceSquared)

    local directionX =
        dx / distance

    local directionZ =
        dz / distance

    self:updateFacing(
        directionX,
        directionZ
    )

    local candidateX =
        self.x +
        directionX *
        SkeletonData.retreatSpeed *
        dt

    local candidateZ =
        self.z +
        directionZ *
        SkeletonData.retreatSpeed *
        dt

    if world.clampPosition then
        candidateX, candidateZ =
            world:clampPosition(
                candidateX,
                candidateZ
            )
    end

    if world.resolveMovement then
        candidateX, candidateZ =
            world:resolveMovement(
                self.x,
                self.z,
                candidateX,
                candidateZ,
                self.collisionRadius
            )
    end

    self.x = candidateX
    self.z = candidateZ

    self.state = "walking"

    self:setAnimation(
        "walk"
    )
end

-- Применяет волну возрождения игрока.
function Skeleton:applySpawnShockwave(
    player,
    settings,
    world
)
    if not self:isDamageable() then
        return false
    end

    local dx =
        self.x - player.x

    local dz =
        self.z - player.z

    local distance =
        math.sqrt(
            dx * dx + dz * dz
        )

    local radius =
        settings.radius *
        Config.worldUnitsPerMeter

    if distance > radius then
        return false
    end

    if distance < 0.001 then
        dx = 1
        dz = 0
        distance = 1
    end

    local strength =
        settings.force *
        (
            1 -
            math.min(
                1,
                distance / radius
            )
        )

    local candidateX =
        self.x +
        dx / distance *
        strength

    local candidateZ =
        self.z +
        dz / distance *
        strength

    if world.clampPosition then
        candidateX, candidateZ =
            world:clampPosition(
                candidateX,
                candidateZ
            )
    end

    if world.resolveMovement then
        candidateX, candidateZ =
            world:resolveMovement(
                self.x,
                self.z,
                candidateX,
                candidateZ,
                self.collisionRadius
            )
    end

    self.x = candidateX
    self.z = candidateZ

    self.state = "idle"
    self.stateTime = 0
    self.attackHitDone = true

    self.attackCooldown =
        SkeletonData.attackCooldown

    self:setAnimation(
        "idle",
        true
    )

    if
        settings.damage and
        settings.damage > 0
    then
        self:takeDamage(
            settings.damage
        )
    end

    return true
end

-- Обновляет скелета.
function Skeleton:update(
    dt,
    player,
    cameraZ,
    world
)
    if not self.active then
        return
    end

    if self.state == "corpse" then
        local behindLimit =
            cameraZ -
            Config.projection.visibleBehindDepth

        if self.z < behindLimit then
            self.active = false
        end

        return
    end

    self.animator:update(dt)

	if self.state == "death" then
        self.stateTime =
            self.stateTime + dt

        if
            self.stateTime >=
            SkeletonData.deathDuration
        then
            self.state = "corpse"
            self.stateTime = 0

            self:rollDeathDrop()
        end

        return
    end

    if self.state == "hurt" then
        self.stateTime =
            self.stateTime + dt

        if
            self.stateTime >=
            SkeletonData.hurtDuration
        then
            self.state = "idle"
            self.stateTime = 0

            self:setAnimation(
                "idle",
                true
            )
        end

        return
    end
		
	if self.state == "block" then
        self.stateTime =
            self.stateTime + dt

        if
            self.stateTime >=
            SkeletonData.blockDuration
        then
            self.state = "idle"
            self.stateTime = 0

            self:setAnimation(
                "idle",
                true
            )
        end

        return
    end

	if self:playerIsUnavailable(player) then
			self.attackHitDone = true

			self:moveAwayFromPlayer(
				dt,
				player,
				world
			)

			return
		end	

    if self.state == "attack" then
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

    -- Живой враг позади экрана остаётся на месте.
    if
        self.z <
        cameraZ -
        Config.projection.visibleBehindDepth
    then
        self.state = "idle"

        self:setAnimation(
            "idle"
        )

        return
    end

    local dx =
        player.x - self.x

    local dz =
        player.z - self.z

    local distanceSquared =
        dx * dx +
        dz * dz

    if
        distanceSquared >
        self.detectionRange *
        self.detectionRange
    then
        self.state = "idle"

        self:setAnimation(
            "idle"
        )

        return
    end

    local distance =
        math.sqrt(
            distanceSquared
        )

    local attackDistance =
        self.attackRange +
        player.collisionRadius

    self:updateFacing(
        dx / math.max(distance, 0.001),
        dz / math.max(distance, 0.001)
    )

    if
        distance <= attackDistance and
        self.attackCooldown <= 0
    then
        self:startAttack()
        return
    end

    if distance > attackDistance then
        self.state = "walking"

        self:moveTowardsPlayer(
            dt,
            player,
            world,
            dx,
            dz,
            distance
        )
    else
        self.state = "idle"

        self:setAnimation(
            "idle"
        )
    end
end

-- Рисует скелета или тело.
function Skeleton:draw(
    projection,
    cameraX,
    cameraZ
)
    if not self.active then
        return
    end

    local x, y, perspectiveScale =
        projection:project(
            self.x,
            self.z,
            cameraX,
            cameraZ
        )

    local alpha =
        projection:getVisibilityAlpha(
            self.z,
            cameraZ
        )

    local image =
        self.animator:
        getCurrentImage()

    if image then
        local spriteScale =
            perspectiveScale *
            SkeletonData.spriteHeight /
            image:getHeight() *
            SkeletonData.scale

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
    else
        self:drawPlaceholder(
            x,
            y,
            perspectiveScale,
            alpha
        )
    end

    if SkeletonData.showHealthBar then
        self:drawHealthBar(
            x,
            y,
            perspectiveScale,
            alpha
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует временного скелета.
function Skeleton:drawPlaceholder(
    x,
    y,
    scale,
    alpha
)
    love.graphics.setColor(
        0.78,
        0.78,
        0.7,
        alpha
    )

    if self.state == "corpse" then
        love.graphics.rectangle(
            "fill",
            x - 38 * scale,
            y - 12 * scale,
            76 * scale,
            12 * scale
        )

        return
    end

    love.graphics.circle(
        "fill",
        x,
        y - 76 * scale,
        16 * scale
    )

    love.graphics.rectangle(
        "fill",
        x - 11 * scale,
        y - 60 * scale,
        22 * scale,
        48 * scale
    )
end

-- Рисует опциональное здоровье.
function Skeleton:drawHealthBar(
    x,
    y,
    scale,
    alpha
)
    if
        self.state == "death" or
        self.state == "corpse"
    then
        return
    end

    local width =
        52 * scale

    local height =
        math.max(
            3,
            5 * scale
        )

    local ratio =
        self.health /
        self.maximumHealth

    local barY =
        y - 112 * scale

    love.graphics.setColor(
        0.12,
        0.08,
        0.08,
        alpha
    )

    love.graphics.rectangle(
        "fill",
        x - width / 2,
        barY,
        width,
        height
    )

    love.graphics.setColor(
        0.75,
        0.12,
        0.12,
        alpha
    )

    love.graphics.rectangle(
        "fill",
        x - width / 2,
        barY,
        width * ratio,
        height
    )
end

return Skeleton