local PlayerData =
    require("data.entities.player")

local Animator =
    require("src.animation.Animator")

local SoundCache =
    require("src.audio.SoundCache")

local Player = {}
Player.__index = Player

-- Создаёт игрока.
function Player.new(assets)
    local self =
        setmetatable({}, Player)

    self.assets = assets

    self.fallbackImage =
        assets:getImage(
            "playerFallback"
        )

    self.x = 0
    self.z = 0
    self.height = 0

    self.safeX = 0
    self.safeZ = 0

    self.hazardRespawnX = 0
    self.hazardRespawnZ = 0

    self.state = "grounded"
    self.stateTime = 0

    self.facing =
        PlayerData.defaultDirection

    self.pendingJumpType = nil
    self.jumpPreparationTime = 0
    self.jumpPreparationDuration = 0.1

    self.health =
        PlayerData.maxHealth

    self.maxHealth =
        PlayerData.maxHealth

    self.continues =
        PlayerData.continues

    self.collisionRadius =
        PlayerData.collisionRadius

    local arrowData =
        PlayerData.ammo.arrows

    self.arrows =
        arrowData.startAmount

    self.maximumArrows =
        arrowData.maximumAmount

    self.hasShield = false
    self.shieldDurability = 0

    self.maximumShieldDurability =
        PlayerData.shield.maximumDurability

    self.shieldMustBeReleased = false

    self.rangedAttackReleased = false
    self.meleeHitDone = false
    self.spawnShockwaveReleased = false

    self.invulnerabilityTime = 0

    self.gameOver = false

    self.animator =
        Animator.new(
            assets,
            PlayerData.animations,
            "idle_" .. self.facing
        )

    return self
end

-- Возвращает имя направленной анимации.
function Player:getAnimationName(action)
    local baseName =
        action ..
        "_" ..
        self.facing

    if self.hasShield then
        local shieldName =
            "shield_" ..
            baseName

        if
            PlayerData.animations[
                shieldName
            ]
        then
            return shieldName
        end
    end

    return baseName
end

-- Выбирает направленную анимацию.
function Player:setAnimation(
    action,
    restart
)
    local animationName =
        self:getAnimationName(
            action
        )

    if
        PlayerData.animations[
            animationName
        ]
    then
        self.animator:play(
            animationName,
            restart
        )
    end
end

-- Запускает ненаправленную spawn-анимацию.
function Player:setSpawnAnimation()
    local animationName =
        self.hasShield and
        "shield_spawn" or
        "spawn"

    self.animator:play(
        animationName,
        true
    )
end

-- Определяет направление взгляда.
function Player:updateFacing(
    horizontal,
    vertical
)
    if
        horizontal == 0 and
        vertical == 0
    then
        return
    end

    if vertical > 0 then
        if horizontal < 0 then
            self.facing =
                "north_west"
        elseif horizontal > 0 then
            self.facing =
                "north_east"
        else
            self.facing =
                "north"
        end
    elseif vertical < 0 then
        if horizontal < 0 then
            self.facing =
                "south_west"
        elseif horizontal > 0 then
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

-- Устанавливает направление болотного прыжка.
function Player:setJumpFacing(direction)
    if direction < 0 then
        self.facing =
            "north_west"
    elseif direction > 0 then
        self.facing =
            "north_east"
    else
        self.facing =
            "north"
    end
end

-- Переносит игрока в новый биом.
function Player:enterBiome(x, z)
    self.x = x or 0
    self.z = z or 0
    self.height = 0

    self.safeX = self.x
    self.safeZ = self.z

    self.hazardRespawnX =
        self.x

    self.hazardRespawnZ =
        self.z

    self.state = "grounded"
    self.stateTime = 0

    self.facing =
        PlayerData.defaultDirection

    self.pendingJumpType = nil
    self.jumpPreparationTime = 0

    self.rangedAttackReleased = false
    self.meleeHitDone = false
    self.spawnShockwaveReleased = false

    self.shieldMustBeReleased = false
    self.invulnerabilityTime = 0

    self:setAnimation(
        "idle",
        true
    )
end

-- Обновляет игрока.
function Player:update(
    dt,
    input,
    world
)
    self.animator:update(dt)

	self.invulnerabilityTime =
		math.max(
			0,
			(self.invulnerabilityTime or 0) -
			dt
		)

    if self.state == "dying" then
        self:updateDeath(
            dt,
            world
        )

        return
    end

    if self.state == "respawning" then
        self:updateSpawn(
            dt,
            world
        )

        return
    end

    if self.gameOver then
        return
    end

    if self.state == "block_pain" then
        self:updateBlockPain(dt)
        return
    end

    if self.state == "blocking" then
        self:updateBlock(input)
        return
    end

    if self.state == "melee" then
        self:updateMeleeAttack(
            dt,
            world
        )

        return
    end

    if self.state == "shooting" then
        self:updateRangedAttack(
            dt,
            world
        )

        return
    end

    if self.pendingJumpType then
        self:updateJumpPreparation(
            dt,
            input,
            world
        )

        return
    end

    if self.state == "jumping" then
        self:updateJump(
            dt,
            world
        )

        return
    end

    if self.state == "falling" then
        self:updateFall(
            dt,
            world
        )

        return
    end

    -- После block_pain кнопку необходимо отпустить.
    if
        self.shieldMustBeReleased and
        not input:isDown("shield")
    then
        self.shieldMustBeReleased =
            false
    end

    if
        self.hasShield and
        not self.shieldMustBeReleased and
        input:isDown("shield")
    then
        self:startBlock()
        return
    end

    if
        input:
        getPressedMeleeAttack()
    then
        if self:startMeleeAttack() then
            return
        end
    end

    if
        input:
        getPressedRangedAttack()
    then
        if self:startRangedAttack() then
            return
        end
    end

    local jumpType =
        input:getPressedJump()

    if jumpType then
        if
            world:
            usesForwardOnlyJumps()
        then
            self:beginJumpPreparation(
                jumpType,
                input
            )
        else
            self:startJump(
                jumpType,
                input,
                world
            )
        end

        return
    end

    if world:allowsWalking() then
        self:updateWalking(
            dt,
            input,
            world
        )
    else
        self:updateSwampControls(
            input
        )
    end
end

-- Обновляет болотное направление.
function Player:updateSwampControls(input)
    local horizontal =
        select(
            1,
            input:getMovement()
        )

    local direction = 0

    if horizontal < 0 then
        direction = -1
    elseif horizontal > 0 then
        direction = 1
    end

    self:setJumpFacing(
        direction
    )

    self:setAnimation(
        "idle"
    )
end

-- Начинает подготовку прыжка.
function Player:beginJumpPreparation(
    jumpType,
    input
)
    self.pendingJumpType =
        jumpType

    self.jumpPreparationTime =
        0

    self:updateSwampControls(
        input
    )
end

-- Обновляет подготовку прыжка.
function Player:updateJumpPreparation(
    dt,
    input,
    world
)
    self.jumpPreparationTime =
        self.jumpPreparationTime +
        dt

    self:updateSwampControls(
        input
    )

    if
        self.jumpPreparationTime <
        self.jumpPreparationDuration
    then
        return
    end

    local jumpType =
        self.pendingJumpType

    self.pendingJumpType = nil
    self.jumpPreparationTime = 0

    self:startJump(
        jumpType,
        input,
        world
    )
end

-- Обновляет ходьбу или бег.
function Player:updateWalking(
    dt,
    input,
    world
)
    local horizontal, vertical =
        input:getMovement()

    self:updateFacing(
        horizontal,
        vertical
    )

    local moving =
        horizontal ~= 0 or
        vertical ~= 0

    local running =
        moving and
        input:isRunning()

    if not moving then
        self:setAnimation(
            "idle"
        )
    elseif running then
        self:setAnimation(
            "run"
        )
    else
        self:setAnimation(
            "walk"
        )
    end

    local speedMultiplier =
        running and
        PlayerData.runSpeedMultiplier or
        1

    local candidateX =
        self.x +
        horizontal *
        PlayerData.sideSpeed *
        speedMultiplier *
        dt

    local candidateZ =
        self.z

    if vertical > 0 then
        candidateZ =
            candidateZ +
            vertical *
            PlayerData.forwardSpeed *
            speedMultiplier *
            dt
    elseif vertical < 0 then
        candidateZ =
            candidateZ +
            vertical *
            PlayerData.backwardSpeed *
            speedMultiplier *
            dt
    end

    candidateX, candidateZ =
        world:clampPosition(
            candidateX,
            candidateZ
        )

    candidateX, candidateZ =
        world:resolveMovement(
            self.x,
            self.z,
            candidateX,
            candidateZ,
            self.collisionRadius
        )

    if world:isSafePosition(
        candidateX,
        candidateZ,
        self.collisionRadius
    ) then
        self.x = candidateX
        self.z = candidateZ

        self.safeX = self.x
        self.safeZ = self.z
    elseif moving then
        self:startFall(
            self.safeX,
            self.safeZ
        )
    end
end

-- Начинает прыжок.
function Player:startJump(
    jumpType,
    input,
    world
)
    local jump =
        PlayerData.jumps[
            jumpType
        ]

    local horizontal, vertical =
        input:getMovement()

    local direction = 0

    if horizontal < 0 then
        direction = -1
    elseif horizontal > 0 then
        direction = 1
    end

    if
        world:
        usesForwardOnlyJumps()
    then
        self:setJumpFacing(
            direction
        )
    else
        self:updateFacing(
            horizontal,
            vertical
        )
    end

    local targetX, targetZ =
        world:getJumpTarget(
            self,
            jumpType,
            direction
        )

    self.jumpDuration =
        jump.duration

    self.jumpStartX = self.x
    self.jumpStartZ = self.z

    self.hazardRespawnX =
        self.x

    self.hazardRespawnZ =
        self.z

    self.jumpTargetX =
        targetX

    self.jumpTargetZ =
        targetZ

    self.safeX = self.x
    self.safeZ = self.z

    self.state = "jumping"
    self.stateTime = 0

    self:setAnimation(
        "jump",
        true
    )
end

-- Обновляет прыжок.
function Player:updateJump(
    dt,
    world
)
    self.stateTime =
        self.stateTime +
        dt

    local progress =
        math.min(
            1,
            self.stateTime /
            self.jumpDuration
        )

    self.x =
        self.jumpStartX +
        (
            self.jumpTargetX -
            self.jumpStartX
        ) *
        progress

    self.z =
        self.jumpStartZ +
        (
            self.jumpTargetZ -
            self.jumpStartZ
        ) *
        progress

    self.height =
        math.sin(
            progress *
            math.pi
        ) *
        PlayerData.jumpHeight

    if progress < 1 then
        return
    end

    self.height = 0

    if world:isSafePosition(
        self.x,
        self.z,
        self.collisionRadius
    ) then
        self.state = "grounded"
        self.stateTime = 0

        self.safeX = self.x
        self.safeZ = self.z

        if
            world:
            usesForwardOnlyJumps()
        then
            self:setJumpFacing(0)
        end

        self:setAnimation(
            "idle",
            true
        )
    else
        self:startFall(
            self.jumpStartX,
            self.jumpStartZ
        )
    end
end

-- Начинает падение.
function Player:startFall(
    respawnX,
    respawnZ
)
    self.pendingJumpType = nil
    self.jumpPreparationTime = 0

    self.rangedAttackReleased = false
    self.meleeHitDone = false

    self.state = "falling"
    self.stateTime = 0

    self.respawnX = respawnX
    self.respawnZ = respawnZ

    self:setAnimation(
        "fall",
        true
    )
end

-- Обновляет падение.
function Player:updateFall(
    dt,
    world
)
    self.stateTime =
        self.stateTime +
        dt

    local duration = 0.65

    local progress =
        math.min(
            1,
            self.stateTime /
            duration
        )

    self.height =
        -55 *
        progress

    if progress < 1 then
        return
    end

    self.x = self.respawnX
    self.z = self.respawnZ
    self.height = 0

    self.safeX = self.x
    self.safeZ = self.z

    world:prepareRespawn(
        self.x,
        self.z,
        self.collisionRadius
    )

    self:loseHealth(1)

    if self.state == "dying" then
        return
    end

    self.state = "grounded"
    self.stateTime = 0

    if
        world:
        usesForwardOnlyJumps()
    then
        self:setJumpFacing(0)
    end

    self:setAnimation(
        "idle",
        true
    )
end

-- Восстанавливает здоровье.
function Player:addHealth(amount)
    local previousHealth =
        self.health

    self.health =
        math.min(
            self.maxHealth,
            self.health +
            (amount or 1)
        )

    return
        self.health -
        previousHealth
end

-- Начинает блок щитом.
function Player:startBlock()
    if
        not self.hasShield or
        self.state ~= "grounded"
    then
        return false
    end

    self.state = "blocking"
    self.stateTime = 0

    self:setAnimation(
        "block",
        true
    )

    return true
end

-- Удерживает или завершает блок.
function Player:updateBlock(input)
    if
        self.hasShield and
        input:isDown("shield")
    then
        return
    end

    self.state = "grounded"
    self.stateTime = 0

    self:setAnimation(
        "idle",
        true
    )
end

-- Обновляет реакцию на удар по щиту.
function Player:updateBlockPain(dt)
    self.stateTime =
        self.stateTime +
        dt

    if
        self.stateTime <
        PlayerData.shield.blockPainDuration
    then
        return
    end

    self.state = "grounded"
    self.stateTime = 0

    -- Блок не включится, пока кнопка не будет отпущена.
    self:setAnimation(
        "idle",
        true
    )
end

-- Проверяет положение источника урона.
function Player:isAttackInFront(
    sourceX,
    sourceZ
)
    if
        sourceX == nil or
        sourceZ == nil
    then
        return false
    end

    local dx =
        sourceX - self.x

    local dz =
        sourceZ - self.z

    local distance =
        math.sqrt(
            dx * dx +
            dz * dz
        )

    if distance < 0.001 then
        return true
    end

    local facingVector =
        PlayerData.directionVectors[
            self.facing
        ]

    local dot =
        dx / distance *
        facingVector.x +
        dz / distance *
        facingVector.y

    return
        dot >=
        PlayerData.shield.minimumFrontDot
end

-- Обрабатывает удар по щиту.
function Player:blockDamage()
    if not self.hasShield then
        return false
    end

    self.shieldDurability =
        math.max(
            0,
            self.shieldDurability - 1
        )

    self.state = "block_pain"
    self.stateTime = 0

    self.shieldMustBeReleased =
        true

    -- Сначала включаем shield-анимацию.
    self:setAnimation(
        "block_pain",
        true
    )

	local blockPainDuration =
		PlayerData.shield.blockPainDuration or
		0.36

	self.invulnerabilityTime =
		blockPainDuration

    SoundCache:play(
        PlayerData.shield.blockSound
    )

    if self.shieldDurability <= 0 then
        self.hasShield = false

        SoundCache:play(
            PlayerData.shield.breakSound
        )
    end

    return true
end

-- Начинает удар мечом.
function Player:startMeleeAttack()
    if self.state ~= "grounded" then
        return false
    end

    self.state = "melee"
    self.stateTime = 0
    self.meleeHitDone = false

    self:setAnimation(
        "melee",
        true
    )

    return true
end

-- Обновляет удар мечом.
function Player:updateMeleeAttack(
    dt,
    world
)
    self.stateTime =
        self.stateTime +
        dt

    local attack =
        PlayerData.meleeAttack

    if
        not self.meleeHitDone and
        self.stateTime >=
        attack.hitTime
    then
        self.meleeHitDone = true

        world:performPlayerMelee(
            self,
            attack
        )
    end

    if
        self.stateTime <
        attack.duration
    then
        return
    end

    self.state = "grounded"
    self.stateTime = 0
    self.meleeHitDone = false

    self:setAnimation(
        "idle",
        true
    )
end

-- Начинает выстрел.
function Player:startRangedAttack()
    if self.state ~= "grounded" then
        return false
    end

    if not self:consumeArrow() then
        return false
    end

    self.state = "shooting"
    self.stateTime = 0

    self.rangedAttackReleased =
        false

    self:setAnimation(
        "shoot",
        true
    )

    return true
end

-- Обновляет выстрел.
function Player:updateRangedAttack(
    dt,
    world
)
    self.stateTime =
        self.stateTime +
        dt

    local attack =
        PlayerData.rangedAttack

    if
        not self.rangedAttackReleased and
        self.stateTime >=
        attack.releaseTime
    then
        self.rangedAttackReleased =
            true

        world:spawnPlayerArrow(
            self
        )
    end

    if
        self.stateTime <
        attack.duration
    then
        return
    end

    self.state = "grounded"
    self.stateTime = 0

    self.rangedAttackReleased =
        false

    self:setAnimation(
        "idle",
        true
    )
end

-- Начинает смерть.
function Player:startDeath()
    self.pendingJumpType = nil
    self.jumpPreparationTime = 0

    self.rangedAttackReleased = false
    self.meleeHitDone = false
    self.spawnShockwaveReleased = false

    self.invulnerabilityTime = 0

    self.state = "dying"
    self.stateTime = 0
    self.height = 0

    self:setAnimation(
        "death",
        true
    )
end

-- Завершает смерть.
function Player:updateDeath(
    dt,
    world
)
    self.stateTime =
        self.stateTime +
        dt

    if
        self.stateTime <
        PlayerData.deathDuration
    then
        return
    end

    self.continues =
        math.max(
            0,
            self.continues - 1
        )

    if self.continues <= 0 then
        self.state = "dead"
        self.stateTime = 0
        self.gameOver = true
        return
    end

    self.health =
        self.maxHealth

    self.x = self.safeX
    self.z = self.safeZ
    self.height = 0

    world:prepareRespawn(
        self.x,
        self.z,
        self.collisionRadius
    )

    self:startSpawn()
end

-- Начинает появление.
function Player:startSpawn()
    self.state = "respawning"
    self.stateTime = 0

    self.spawnShockwaveReleased =
        false

    self.invulnerabilityTime =
        PlayerData.spawn.duration

    self:setSpawnAnimation()
end

-- Обновляет появление.
function Player:updateSpawn(
    dt,
    world
)
    self.stateTime =
        self.stateTime +
        dt

    local spawn =
        PlayerData.spawn

    local shockwave =
        spawn.shockwave

    if
        shockwave.enabled and
        not self.spawnShockwaveReleased and
        self.stateTime >=
        shockwave.time
    then
        self.spawnShockwaveReleased =
            true

		if
			world.performSpawnShockwave
		then
			world:performSpawnShockwave(
				self,
				shockwave
			)
		end
    end

    if
        self.stateTime <
        spawn.duration
    then
        return
    end

    self.state = "grounded"
    self.stateTime = 0

    self.spawnShockwaveReleased =
        false

    self.invulnerabilityTime = 0

    self:setAnimation(
        "idle",
        true
    )
end

-- Проверяет наличие стрел.
function Player:hasArrows()
    return self.arrows > 0
end

-- Расходует стрелу.
function Player:consumeArrow()
    if self.arrows <= 0 then
        return false
    end

    self.arrows =
        self.arrows - 1

    return true
end

-- Добавляет стрелы.
function Player:addArrows(amount)
    local previousAmount =
        self.arrows

    self.arrows =
        math.min(
            self.maximumArrows,
            self.arrows +
            (amount or 1)
        )

    return
        self.arrows -
        previousAmount
end

-- Проверяет заполнение колчана.
function Player:isArrowQuiverFull()
    return
        self.arrows >=
        self.maximumArrows
end

-- Проверяет возможность подобрать щит.
function Player:canPickupShield()
    return
        not self.hasShield or
        self.shieldDurability <
        self.maximumShieldDurability
end

-- Надевает или ремонтирует щит.
function Player:equipShield()
    self.hasShield = true

    self.shieldDurability =
        self.maximumShieldDurability

    if self.state == "grounded" then
        self:setAnimation(
            "idle",
            true
        )
    end
end

-- Наносит игроку урон или блокирует его щитом.
function Player:takeDamage(
    amount,
    sourceX,
    sourceZ
)
    if
        self.gameOver or
        self.state == "dying" or
        self.state == "respawning" or
        self.state == "dead" or
        self.state == "falling" or
        self.state == "block_pain" or
        self.invulnerabilityTime > 0
    then
        return false
    end

    if
        self.state == "blocking" and
        self.hasShield
    then
        local sourceIsUnknown =
            sourceX == nil or
            sourceZ == nil

        if
            sourceIsUnknown or
            self:isAttackInFront(
                sourceX,
                sourceZ
            )
        then
            self:blockDamage()
            return false
        end
    end

    self.invulnerabilityTime =
        PlayerData.damageInvulnerability

    self:loseHealth(
        amount or 1
    )

    return true
end

-- Обрабатывает захват кикиморой.
function Player:beGrabbed()
    if
        self.state ~= "grounded" and
        self.state ~= "blocking"
    then
        return
    end

    self:startFall(
        self.hazardRespawnX,
        self.hazardRespawnZ
    )
end

-- Отнимает здоровье.
function Player:loseHealth(amount)
    if
        self.state == "dying" or
        self.state == "dead"
    then
        return
    end

    self.health =
        math.max(
            0,
            self.health -
            (amount or 1)
        )

    if self.health > 0 then
        return
    end

    self:startDeath()
end

-- Рисует игрока.
function Player:draw(
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
        getCurrentImage() or
        self.fallbackImage

    if image then
        local spriteScale =
            perspectiveScale *
            PlayerData.spriteHeight /
            image:getHeight() *
            PlayerData.scale

        love.graphics.setColor(
            1,
            1,
            1
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

        return
    end

    self:drawPlaceholder(
        x,
        y,
        perspectiveScale
    )
end

-- Рисует временного игрока.
function Player:drawPlaceholder(
    x,
    y,
    scale
)
    local width =
        44 * scale

    local height =
        82 * scale

    love.graphics.setColor(
        0.18,
        0.28,
        0.72
    )

    love.graphics.rectangle(
        "fill",
        x - width / 2,
        y - height,
        width,
        height
    )

    love.graphics.setColor(
        0.92,
        0.75,
        0.58
    )

    love.graphics.circle(
        "fill",
        x,
        y - height - 12 * scale,
        17 * scale
    )

    love.graphics.setColor(1, 1, 1)
end

return Player