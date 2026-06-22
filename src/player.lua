local AnimationSet = require("src.animation_set")
local Collision = require("src.collision")
local Render = require("src.render")
local Utils = require("src.utils")
local Registry = require("src.registry")

local Player = {}
Player.__index = Player

-- Возвращает количество прыжков из config.
-- Приоритет: явный maxJumps/max_jumps, затем abilities.canDoubleJump.
local function resolveMaxJumps(config, abilities)
    local configuredMaxJumps = config.maxJumps or config.max_jumps

    if configuredMaxJumps then
        return configuredMaxJumps
    end

    if config.canDoubleJump == true
        or config.can_double_jump == true
        or abilities.canDoubleJump == true
        or abilities.can_double_jump == true
    then
        return 2
    end

    return 1
end

-- Создаёт игрока из player definition.
function Player:new(config)
    config = config or {}

    local player = setmetatable({}, Player)

    player.id = config.id or "player"
    player.entityType = "player"
    player.targetGroup = "player"

    -- x/y у игрока — это точка ног/якорь, как в OpenBOR.
    -- offset.y обычно равен высоте canvas.
    player.x = config.x or 0
    player.y = config.y or 0

    player.canvas = config.canvas or {
        width = config.w or config.width or 48,
        height = config.h or config.height or 64
    }

    player.offset = config.offset or {
        x = player.canvas.width / 2,
        y = player.canvas.height
    }

    -- Оставляем w/h как удобные алиасы для старой логики.
    player.w = player.canvas.width
    player.h = player.canvas.height

    player.bboxes = config.bboxes or {}

    player.bbox = config.bbox
        or player.bboxes.stand
        or {
            x = 0,
            y = 0,
            w = player.canvas.width,
            h = player.canvas.height
        }

    player.hitboxes = config.hitboxes or {}

    player.health = config.health or 5
    player.maxHealth = player.health

    player.lives = config.lives or 3

    player.speed = config.speed or 180
    player.jumpPower = config.jumpPower or config.jump_power or -420
    player.gravity = config.gravity or 900

    player.abilities = config.abilities or {}
	
	player.animationGroups = config.animationGroups
        or config.animation_groups
        or {}
		
-------управление и комбо 
	player.comboWindow = config.comboWindow
        or config.combo_window
        or 0.35

    player.comboTimer = 0
    player.comboIndex = 0
    player.comboGroupName = nil

    player.isCrouching = false
    player.isBlocking = false

    player.invulnerable = config.invulnerable == true
    player.invulnerableTimer = 0

    player.defaultBboxName = config.defaultBbox
        or config.default_bbox
        or "stand"

    player.crouchBboxName = config.crouchBbox
        or config.crouch_bbox
        or "crouch"
		
---------ТЕНИ опционально

	player.shadowType = config.shadowType
        or config.shadow_type
        or 0

    player.shadowAlpha = config.shadowAlpha
        or config.shadow_alpha
        or 0.3

    player.shadowWidth = config.shadowWidth
        or config.shadow_width

    player.shadowHeight = config.shadowHeight
        or config.shadow_height

    player.shadowOffsetX = config.shadowOffsetX
        or config.shadow_offset_x
        or 0

    player.shadowOffsetY = config.shadowOffsetY
        or config.shadow_offset_y
        or 0

    player.shadowScaleX = config.shadowScaleX
        or config.shadow_scale_x

    player.shadowScaleY = config.shadowScaleY
        or config.shadow_scale_y

    player.shadowVisible = false
    player.shadowX = 0
    player.shadowY = 0
-------


    -- Количество прыжков.
    -- 1 = обычный прыжок, 2 = двойной прыжок.
    -- abilities.canDoubleJump = true автоматически даёт 2 прыжка.
    player.maxJumps = resolveMaxJumps(config, player.abilities)

    player.jumpCount = 0

    player.vx = 0
    player.vy = 0

    player.facing = config.facing or 1
    player.flipSprite = config.flipSprite == true
        or config.flip_sprite == true

    player.alpha = config.alpha or 1
    player.color = config.color or {0.2, 0.55, 1.0}
	
-------Scale --Чисто визуальный эффект, на bbox и hitbox не влияет
	player.scale = config.scale or 1

    player.scaleX = config.scaleX
        or config.scale_x
        or player.scale

    player.scaleY = config.scaleY
        or config.scale_y
        or player.scale	
-----Смещение для Scale если спрайт сьехал в сторону
	player.drawOffsetX = config.drawOffsetX
        or config.draw_offset_x
        or config.visualOffsetX
        or config.visual_offset_x
        or 0

    player.drawOffsetY = config.drawOffsetY
        or config.draw_offset_y
        or config.visualOffsetY
        or config.visual_offset_y
        or 0
-----

    player.onGround = false
    player.dead = false
	player.lastDamageInfo = nil
    player.deathFinished = false

    player.state = "idle"

    player.ammo = config.ammo or {}
	
-- Сообщение игроку, например если weapon-форма не найдена.
--(если допустил ошибку в названии weapon и игре ее не нашла)
    player.messageText = nil
    player.messageTimer = 0	

-- Weapon transform runtime.(превращаем игрока в дргой тип по weapon который онподобрал)
    player.weaponUses = config.weaponUses
        or config.weapon_uses

    player.weaponPlayerId = config.weaponPlayerId
        or config.weapon_player_id

    player.weaponBasePlayerId = config.weaponBasePlayerId
        or config.weapon_base_player_id

    player.pendingWeaponReturn = false

    player.entitySpawnRequests = {}

    player.animationSet = AnimationSet:new({
        default = config.defaultAnimation or config.default_animation or "idle",
        animations = config.animations or {
            idle = {
                loop = true,
                frames = {}
            }
        }
    })

-- playSpawn управляет тем, нужно ли проигрывать spawn-анимацию при создании Player.
    -- По умолчанию true: обычный старт уровня/создание игрока проигрывает spawn.
    -- Для weapon-transform можно передать playSpawn=false, чтобы не запускать spawn.
    local playSpawn = config.playSpawn

    if playSpawn == nil then
        playSpawn = config.play_spawn
    end

    if playSpawn == nil then
        playSpawn = true
    end

    if playSpawn then
        player:playSpawnAnimation()
    elseif player.animationSet and player.animationSet:has("idle") then
        player:playAnimation("idle", true)
    end

    return player
end

-- Возвращает true, если у игрока есть способность abilityName.
-- Если ability не указана, считаем что она разрешена.
-- Поддерживает старые имена canShoot/canMelee и новые shoot/melee.
function Player:can(abilityName)
    local aliases = {
        canMove = "move",
        canJump = "jump",
        canShoot = "shoot",
        canMelee = "melee",
        canCrouch = "crouch",
        canStrafe = "strafe",
        canBlock = "block"
    }

    local resolvedName = aliases[abilityName] or abilityName

    if self.abilities[resolvedName] == nil then
        return true
    end

    return self.abilities[resolvedName] == true
end


-- Проверяет, есть ли animation у игрока.
function Player:hasAnimation(name)
    return self.animationSet and self.animationSet:has(name)
end

-- Возвращает true, если текущее состояние является block-состоянием.
function Player:isBlockState()
    return self.state == "block"
        or self.state == "crouch_block"
end

-- Возвращает true, если игрок в жёстком lock-состоянии.
-- Block сюда не входит: его можно перебить любым другим действием.
function Player:isHardLocked()
    if self.dead then
        return true
    end

    if self:isBlockState() then
        return false
    end

    return self:isInputLocked()
end

-- Устанавливает bbox по имени.
function Player:setBbox(name)
    if not name then
        return false
    end

    local bbox = self.bboxes[name]

    if not bbox then
        return false
    end

    self.bbox = bbox

    return true
end

-- Возвращает bbox в stand-состояние.
function Player:setStandBbox()
    self:setBbox(self.defaultBboxName)
end

-- Возвращает bbox в crouch-состояние.
function Player:setCrouchBbox()
    self:setBbox(self.crouchBboxName)
end

-- Выключает block.
function Player:cancelBlock()
    if not self.isBlocking and not self:isBlockState() then
        return
    end

    self.isBlocking = false
    self.invulnerable = false
    self.invulnerableTimer = 0
end

-- Возвращает true, если игрок жив.
function Player:isAlive()
    return not self.dead
end

-- Возвращает bbox игрока в мировых координатах.
function Player:getHitbox()
    return Collision.localBoxToWorld(self, self.bbox)
end

-- Устанавливает bbox по имени.
function Player:setBbox(name)
    local bbox = self.bboxes[name]

    if bbox then
        self.bbox = bbox
    end
end

-- Возвращает named hitbox в мировых координатах.
function Player:getNamedHitbox(name)
    local hitbox = self.hitboxes[name]

    if not hitbox then
        return nil
    end

    return Collision.hitboxToWorld(self, hitbox)
end

-- Возвращает true, если текущая анимация блокирует ввод.
function Player:isInputLocked()
    return self.animationSet:isInputLocked()
        and not self.animationSet:isCurrentFinished()
end

-- Запускает animation, если она есть.
-- Если animation нет — ничего не делает и возвращает false.
function Player:playAnimation(name, force)
    if not self.animationSet or not self.animationSet:has(name) then
        return false
    end

    self.state = name
    self.animationSet:set(name, force)

    return true
end


-- Возвращает список существующих анимаций из набора names.
function Player:getExistingAnimations(names)
    local result = {}

    for _, name in ipairs(names or {}) do
        if self.animationSet:has(name) then
            table.insert(result, name)
        end
    end

    return result
end

-- Выбирает случайную существующую анимацию из группы.
-- Если в группе одна анимация, вернётся она.
function Player:chooseAnimationFromGroup(names, fallback)
    local available = self:getExistingAnimations(names)

    if #available > 0 then
        return Utils.randomChoice(available)
    end

    if fallback and self.animationSet:has(fallback) then
        return fallback
    end

    return nil
end

-- Запускает случайную анимацию из группы с fallback.
function Player:playAnimationGroup(names, fallback, force)
    local animationName = self:chooseAnimationFromGroup(names, fallback)

    if animationName then
        self:playAnimation(animationName, force)
        return true
    end

    return false
end

-- Запускает spawn-анимацию игрока.
-- Если spawn01/02/03/spawn нет, запускает idle.
function Player:playSpawnAnimation()
    local spawnAnimation = self:chooseAnimationFromGroup({
        "spawn01",
        "spawn02",
        "spawn03",
        "spawn"
    })

    if spawnAnimation then
        self:playAnimation(spawnAnimation, true)
        return
    end

    self:playAnimation("idle", true)
end

-- Лочит игрока для перехода через LevelEnd.
-- Игрок становится неуязвимым, останавливается и, если есть win/Win-анимация,
-- запускает её. Возвращает true, если нужно ждать окончание win-анимации.
function Player:startLevelEndWin()
    if self.dead then
        return false
    end

    -- Сначала сбрасываем состояния, которые могут конфликтовать с win.
    self:cancelBlock()
    self.isCrouching = false
    self:setStandBbox()

    self.vx = 0
    self.vy = 0

    self.levelEndLocked = true
    self.levelEndWinPlaying = false
    self.levelEndWinFinished = false

    -- invulnerableTimer = 0 в текущей логике означает постоянную неуязвимость.
    -- Это нормально: после win всё равно будет transition на другой уровень/сцену.
    self.invulnerable = true
    self.invulnerableTimer = 0

    local winAnimation = self:chooseAnimationFromGroup({
        "win",
        "Win"
    })

    if not winAnimation then
        return false
    end

    self.levelEndWinPlaying = true
    self:playAnimation(winAnimation, true)

    return true
end

-- Возвращает true, если игрок сейчас залочен дверью/LevelEnd.
function Player:isLevelEndLocked()
    return self.levelEndLocked == true
end

-- Возвращает true, когда win-анимация закончилась.
-- Если win-анимации не было, считаем что ждать нечего.
function Player:isLevelEndWinFinished()
    if not self.levelEndWinPlaying then
        return true
    end

    return self.levelEndWinFinished == true
end

-- Включает crouch, если можно.
function Player:startCrouch()
    if self.dead or not self.onGround then
        return false
    end

    if self:isHardLocked() then
        return false
    end

    if not self:can("crouch") then
        return false
    end

    if not self:hasAnimation("crouch") then
        return false
    end

    self:cancelBlock()

    self.isCrouching = true
    self.vx = 0
    self:setCrouchBbox()
    self:playAnimation("crouch")

    return true
end

-- Выключает crouch.
function Player:stopCrouch()
    if not self.isCrouching then
        return
    end

    self.isCrouching = false
    self:setStandBbox()

    if self.onGround then
        if math.abs(self.vx or 0) > 1 then
            self:playAnimation("run")
        else
            self:playAnimation("idle")
        end
    end
end

-- Обновляет crouch по удержанию кнопки.
function Player:setCrouchHeld(isHeld)
    if isHeld then
        self:startCrouch()
        return
    end

    self:stopCrouch()
end

-- Включает block, если можно.
function Player:startBlock()
    if self.dead or not self.onGround then
        return false
    end

    if self:isHardLocked() then
        return false
    end

    if not self:can("block") then
        return false
    end

    -- В беге block запрещён.
    if math.abs(self.vx or 0) > 1 then
        return false
    end

    local animationName = "block"

    if self.isCrouching then
        animationName = "crouch_block"
    end

    if not self:hasAnimation(animationName) then
        return false
    end

    self.isBlocking = true
    self.invulnerable = true
    self.vx = 0
    self:playAnimation(animationName)

    return true
end

-- Выключает block.
function Player:stopBlock()
    if not self.isBlocking then
        return
    end

    self:cancelBlock()

    if self.isCrouching then
        self:playAnimation("crouch")
        return
    end

    if self.onGround then
        self:playAnimation("idle")
    end
end

-- Обновляет block по удержанию кнопки.
function Player:setBlockHeld(isHeld)
    if isHeld then
        self:startBlock()
        return
    end

    self:stopBlock()
end



-- Начинает движение влево/вправо.
function Player:setMoveDirection(direction)
    if self.dead then
        return
    end

    if self:isHardLocked() then
        return
    end

    if not self:can("move") then
        return
    end

    -- Любое движение перебивает block.
    if direction ~= 0 then
        self:cancelBlock()
    end

    -- В crouch движения нет.
    if self.isCrouching then
        self.vx = 0
        return
    end

    self.vx = direction * self.speed

    if direction ~= 0 then
        self.facing = direction

        if self.onGround then
            self:playAnimation("run")
        end
    elseif self.onGround then
        self:playAnimation("idle")
    end
end

-- Останавливает горизонтальное движение.
function Player:stopMoving()
    if self.dead then
        return
    end

    if self:isHardLocked() then
        return
    end

    if self.isBlocking then
        self.vx = 0
        return
    end

    self.vx = 0

    if self.isCrouching then
        self:playAnimation("crouch")
        return
    end

    if self.onGround then
        self:playAnimation("idle")
    end
end

-- Выполняет прыжок.
-- Первый прыжок доступен с земли, второй — только если maxJumps больше 1.
function Player:jump()
    if self.dead then
        return
    end

    if not self:can("jump") then
        return
    end

    -- Из crouch не прыгаем.
    if self.isCrouching then
        return
    end

    -- Jump перебивает block.
    self:cancelBlock()

    if self.onGround then
        self.jumpCount = 0
    end

    if self:isHardLocked() and self.state ~= "jump" then
        return
    end

    if self.jumpCount >= self.maxJumps then
        return
    end

    self.vy = self.jumpPower
    self.onGround = false
    self.jumpCount = self.jumpCount + 1

    self:playAnimation("jump", true)
end

-- Приземляет игрока на платформу.
-- groundY — это линия, где должны стоять ноги игрока.
function Player:landOn(groundY)
    local wasOnGround = self.onGround

    self.y = groundY
    self.vy = 0
    self.onGround = true
    self.jumpCount = 0

    if self.dead then
        return
    end

    -- Если игрок уже стоял на платформе, не сбрасываем текущую action-анимацию.
    -- Иначе shoot/melee/strafe/crouch будут каждый кадр перебиваться в idle/run.
    if wasOnGround and self.state ~= "jump" then
        return
    end

    if math.abs(self.vx or 0) > 1 then
        self:playAnimation("run")
    else
        self:playAnimation("idle")
    end
end


-- Возвращает true, если игрок летит вверх.
function Player:isJumpingUp()
    return not self.onGround and (self.vy or 0) < 0
end

-- Возвращает true, если игрок падает вниз.
function Player:isFalling()
    return not self.onGround and (self.vy or 0) >= 0
end

-- Возвращает true, если игрок считается бегущим.
function Player:isRunning(inputContext)
    if inputContext and inputContext.moving ~= nil then
        return inputContext.moving == true
    end

    return self.onGround and math.abs(self.vx or 0) > 1
end

-- Возвращает группу анимаций из config или fallback.
function Player:getAnimationGroup(name, fallback)
    return self.animationGroups[name] or fallback or {}
end

-- Выбирает следующий combo animation из группы.
function Player:chooseComboAnimation(groupName, fallbackNames)
    local names = self:getAnimationGroup(groupName, fallbackNames)
    local available = self:getExistingAnimations(names)

    if #available == 0 then
        return nil
    end

    if self.comboGroupName ~= groupName or (self.comboTimer or 0) <= 0 then
        self.comboIndex = 1
    else
        self.comboIndex = self.comboIndex + 1
    end

    if self.comboIndex > #available then
        self.comboIndex = 1
    end

    self.comboGroupName = groupName
    self.comboTimer = self.comboWindow or 0.35

    return available[self.comboIndex]
end

-- Сбрасывает melee combo.
function Player:resetCombo()
    self.comboIndex = 0
    self.comboTimer = 0
    self.comboGroupName = nil
end

-- Выбирает shoot animation по состоянию и input.
function Player:chooseShootAnimation(inputContext)
    inputContext = inputContext or {}

    local up = inputContext.up == true
    local forward = inputContext.forward == true
    local moving = self:isRunning(inputContext)

    -- В crouch up игнорируется.
    if self.isCrouching then
        if self:hasAnimation("shoot_crouch") then
            return "shoot_crouch"
        end

        return nil
    end

    -- Диагональ вверх-вперёд.
    if up and forward then
        if self:isJumpingUp() and self:hasAnimation("shoot_diagonal_up_jump") then
            return "shoot_diagonal_up_jump"
        end

        if self:isFalling() and self:hasAnimation("shoot_diagonal_up_fall") then
            return "shoot_diagonal_up_fall"
        end

        if self.onGround and moving and self:hasAnimation("shoot_diagonal_up_run") then
            return "shoot_diagonal_up_run"
        end

        return nil
    end

    -- Стрельба вверх.
    if up then
        if self:isJumpingUp() and self:hasAnimation("shoot_up_jump") then
            return "shoot_up_jump"
        end

        if self:isFalling() and self:hasAnimation("shoot_up_fall") then
            return "shoot_up_fall"
        end

        if self.onGround and moving and self:hasAnimation("shoot_up_run") then
            return "shoot_up_run"
        end

        if self.onGround and self:hasAnimation("shoot_up_stand") then
            return "shoot_up_stand"
        end

        return nil
    end

    -- Обычная стрельба.
    if self:isJumpingUp() and self:hasAnimation("shoot_jump") then
        return "shoot_jump"
    end

    if self:isFalling() and self:hasAnimation("shoot_fall") then
        return "shoot_fall"
    end

    if self.onGround and moving and self:hasAnimation("shoot_run") then
        return "shoot_run"
    end

    if self.onGround and self:hasAnimation("shoot_stand") then
        return "shoot_stand"
    end

    return nil
end

-- Выбирает melee animation по состоянию и input.
function Player:chooseMeleeAnimation(inputContext)
    inputContext = inputContext or {}

    local moving = self:isRunning(inputContext)

    if self.isCrouching then
        if self:hasAnimation("melee_crouch") then
            self:resetCombo()
            return "melee_crouch"
        end

        return nil
    end

    if self:isJumpingUp() then
        if self:hasAnimation("melee_jump") then
            self:resetCombo()
            return "melee_jump"
        end

        return nil
    end

    if self:isFalling() then
        if self:hasAnimation("melee_fall") then
            self:resetCombo()
            return "melee_fall"
        end

        return nil
    end

    if moving then
        return self:chooseComboAnimation("melee_run", {
            "melee_run01",
            "melee_run02",
            "melee_run03"
        })
    end

    return self:chooseComboAnimation("melee_stand", {
        "melee_stand01",
        "melee_stand02",
        "melee_stand03"
    })
end


-- Запускает дальнюю атаку.
-- Конкретная shoot animation выбирается по состоянию игрока и input.
function Player:shoot(inputContext)
    if self.dead then
        return false
    end

    if self:isHardLocked() then
        return false
    end

    if not self:can("shoot") then
        return false
    end

    local animationName = self:chooseShootAnimation(inputContext)

    if not animationName then
        return false
    end

    self:cancelBlock()
    self:resetCombo()

    self:playAnimation(animationName, true)

    return true
end

-- Запускает melee-атаку.
-- На земле использует combo, в воздухе — одиночные melee_jump/melee_fall.
function Player:melee(inputContext)
    if self.dead then
        return false
    end

    if self:isHardLocked() then
        return false
    end

    if not self:can("melee") then
        return false
    end

    local animationName = self:chooseMeleeAnimation(inputContext)

    if not animationName then
        return false
    end

    self:cancelBlock()

    self:playAnimation(animationName, true)

    return true
end

-- Запускает crouch-анимацию.
-- Оставлено для совместимости со старым input.
function Player:crouch()
    self:setCrouchHeld(true)
end

-- Запускает strafe/special-анимацию.
-- Strafe блокирует все действия, кроме pain/death.
function Player:strafe()
    if self.dead then
        return
    end

    if self:isHardLocked() then
        return
    end

    if not self:can("strafe") then
        return
    end

    if not self:hasAnimation("strafe") then
        return
    end

    self:cancelBlock()
    self:stopCrouch()

    self.vx = 0
    self:playAnimation("strafe", true)
end

-- Добавляет патроны указанного типа.
function Player:addAmmo(ammoType, amount)
    if not ammoType then
        return false
    end

    self.ammo[ammoType] = (self.ammo[ammoType] or 0) + amount

    return true
end

-- Добавляет игроку жизни.
function Player:addLife(amount)
    if self.dead then
        return false
    end

    amount = amount or 1

    if amount <= 0 then
        return false
    end

    self.lives = (self.lives or 0) + amount

    return true
end

-- Лечит игрока на указанное количество здоровья.
function Player:heal(amount)
    if self.dead then
        return false
    end

    if self.health >= self.maxHealth then
        return false
    end

    self.health = math.min(self.maxHealth, self.health + amount)

    return true
end

-- Создаёт DamageInfo для melee-hitbox игрока.
function Player:createDamageInfo(event)
    return {
        amount = event.damage or 1,
        source = self,
        owner = self,
        deathType = event.deathType or event.death_type or "normal",
        damageTargets = event.damageTargets
            or event.damage_targets
            or {
                enemy = true
            }
    }
end

-- Получает урон и запускает pain/death-анимацию при необходимости.
function Player:takeDamage(damageInfo)
    if self.dead then
        return false
    end
---неуязвимость	
	if self.invulnerable then
        return false
    end
------
    damageInfo = damageInfo or {}
	self.lastDamageInfo = damageInfo

    local amount = damageInfo.amount or 1

    self.health = math.max(0, self.health - amount)

    if self.health <= 0 then
        self:die()
        return true
    end

    if self.animationSet:has("pain") then
        self.vx = 0
        self:playAnimation("pain", true)
    end

    return false
end

-- Запускает смерть игрока.
function Player:die()
    if self.dead then
        return
    end

    self.dead = true
    self.vx = 0
    self.vy = 0

    self:playAnimation("death", true)
end

--Подгоняем HP игрока обратно если в предыдущей форме у него было больше шкала HP чем сейчас
local function clampHealthByRatio(oldHealth, oldMaxHealth, newMaxHealth)
    oldHealth = oldHealth or 1
    oldMaxHealth = oldMaxHealth or oldHealth or 1
    newMaxHealth = newMaxHealth or 1

    if oldMaxHealth <= 0 then
        oldMaxHealth = 1
    end

    local ratio = oldHealth / oldMaxHealth
    local newHealth = math.ceil(newMaxHealth * ratio)

    if oldHealth > 0 then
        newHealth = math.max(1, newHealth)
    end

    return math.max(0, math.min(newMaxHealth, newHealth))
end

-- Пересобирает текущий Player в другой player config, но сохраняет сам Lua-объект.
-- Это важно: world.player и game.player остаются тем же объектом.
function Player:transformToPlayer(playerId, options)
    if not playerId then
        return false
    end

    options = options or {}

    local definition = Registry.loadPlayer(playerId)

    if not definition then
        return false
    end

-- Важно: Player:new() сам решает, играть spawn или нет.
    -- Поэтому передаём playSpawn в definition ДО создания transformed.
    -- Для weapon-transform ставим playSpawn=false.
    definition.playSpawn = options.playSpawn ~= false

    local oldHealth = self.health or 1
    local oldMaxHealth = self.maxHealth or oldHealth or 1

    local runtime = {
        x = self.x,
        y = self.y,

        previousX = self.previousX,
        previousY = self.previousY,

        vx = self.vx or 0,
        vy = self.vy or 0,

        facing = self.facing or 1,
        lives = self.lives or 1,

        onGround = self.onGround == true,

        invulnerable = self.invulnerable == true,
        invulnerableTimer = self.invulnerableTimer or 0,

        currentPlatform = self.currentPlatform
    }

    definition.x = runtime.x
    definition.y = runtime.y
    definition.facing = runtime.facing
    definition.lives = runtime.lives

    local transformed = Player:new(definition)

    transformed.previousX = runtime.previousX or runtime.x
    transformed.previousY = runtime.previousY or runtime.y

    transformed.vx = runtime.vx
    transformed.vy = runtime.vy

    transformed.facing = runtime.facing
    transformed.lives = runtime.lives

    transformed.onGround = runtime.onGround
    transformed.currentPlatform = runtime.currentPlatform

    transformed.invulnerable = runtime.invulnerable
    transformed.invulnerableTimer = runtime.invulnerableTimer

    transformed.health = clampHealthByRatio(
        oldHealth,
        oldMaxHealth,
        transformed.maxHealth
    )

    transformed.weaponUses = options.weaponUses
    transformed.weaponPlayerId = options.weaponPlayerId
    transformed.weaponBasePlayerId = options.weaponBasePlayerId
    transformed.pendingWeaponReturn = options.pendingWeaponReturn == true

    -- После transform не держим старые action-состояния.
    transformed.comboTimer = 0
    transformed.comboIndex = 0
    transformed.comboGroupName = nil

    transformed.isBlocking = false
    transformed.isCrouching = false

    if transformed.setStandBbox then
        transformed:setStandBbox()
    end

    for key, _ in pairs(self) do
        self[key] = nil
    end

    for key, value in pairs(transformed) do
        self[key] = value
    end

    setmetatable(self, Player)

-- Spawn уже был обработан внутри Player:new() через definition.playSpawn.
    -- Если transform был без spawn, гарантированно оставляем игрока в idle,
    -- чтобы он не завис в старой action/spawn-анимации.
    if options.playSpawn == false
        and self.animationSet
        and self.animationSet:has("idle")
    then
        self:playAnimation("idle", true)
    end

    return true
end

-- Подбирает weapon pickup.
-- То же оружие добавляет uses, другое заменяет форму и стирает старые uses.
-- Подбирает weapon pickup.
-- То же оружие добавляет uses, другое заменяет форму и стирает старые uses.
-- weaponPlayerId может быть явным: "warrior_bow"
-- или шаблонным: "NAME_названиеоружия где в NAME - это имя выбранного в player_screen игрока".
function Player:addWeapon(weaponPlayerId, weaponUses)
    if self.dead then
        return false
    end

    local resolvedWeaponPlayerId = self:resolveWeaponPlayerId(weaponPlayerId)

    if not resolvedWeaponPlayerId then
        return false
    end

    weaponUses = weaponUses or 0

    if weaponUses <= 0 then
        self:showMessage("Weapon uses is 0", 2.0)
        return false
    end

    if self.weaponPlayerId == resolvedWeaponPlayerId then
        self.weaponUses = (self.weaponUses or 0) + weaponUses
        self.pendingWeaponReturn = false
        return true
    end

    local basePlayerId = self.weaponBasePlayerId or self.id

    return self:transformToPlayer(
        resolvedWeaponPlayerId,
        {
            weaponUses = weaponUses,
            weaponPlayerId = resolvedWeaponPlayerId,
            weaponBasePlayerId = basePlayerId,
            pendingWeaponReturn = false,
-- Weapon-transform не является respawn, поэтому spawn не проигрываем.
            playSpawn = false
        }
    )
end


-- Тратит uses у текущей weapon-формы.
-- Когда uses закончились, возврат произойдёт после завершения текущей анимации.
function Player:consumeWeaponUse(amount)
    if self.dead then
        return false
    end

    if not self.weaponPlayerId then
        return false
    end

    amount = amount or 1

    if amount <= 0 then
        return false
    end

    self.weaponUses = math.max(0, (self.weaponUses or 0) - amount)

    if self.weaponUses <= 0 then
        self.weaponUses = 0
        self.pendingWeaponReturn = true
    end

    return true
end

-- Возвращает игрока из weapon-формы в базового player-а.
function Player:returnFromWeapon()
    if self.dead then
        return false
    end

    if not self.weaponBasePlayerId then
        return false
    end

    local basePlayerId = self.weaponBasePlayerId

    return self:transformToPlayer(
        basePlayerId,
        {
            weaponUses = nil,
            weaponPlayerId = nil,
            weaponBasePlayerId = nil,
            pendingWeaponReturn = false,
-- Возврат из weapon-формы не должен проигрывать spawn.
-- Spawn нужен только при появлении после потери Life/respawn.
             playSpawn = false
        }
    )
end

-- Показывает короткое сообщение в HUD.
function Player:showMessage(text, duration)
    self.messageText = text
    self.messageTimer = duration or 2.0
end

-- Возвращает базовый player id для NAME-подстановки.
-- Если игрок уже в weapon-форме, берём исходного базового игрока.
function Player:getWeaponBaseName()
    return self.weaponBasePlayerId or self.id
end

-- Подставляет NAME в weaponPlayerId и проверяет, существует ли такой player.
function Player:resolveWeaponPlayerId(weaponPlayerId)
    if not weaponPlayerId then
        self:showMessage("Weapon player not set", 2.0)
        return nil
    end

    local baseName = self:getWeaponBaseName()
    local resolvedPlayerId = string.gsub(
        weaponPlayerId,
        "NAME",
        baseName
    )

    if Registry.hasId
        and Registry.hasId(Registry.playerList, resolvedPlayerId)
    then
        return resolvedPlayerId
    end

    self:showMessage(
        "Weapon player not found: " .. tostring(resolvedPlayerId),
        2.0
    )

    print("[WEAPON] player not found", resolvedPlayerId)

    return nil
end

-- Сбрасывает weapon-форму при потере Life.
-- Используется перед checkpoint-respawn или обычной обработкой смерти.
function Player:resetWeaponOnLifeLoss()
    if not self.weaponPlayerId and not self.weaponBasePlayerId then
        self.weaponUses = nil
        self.pendingWeaponReturn = false
        return false
    end

    local basePlayerId = self.weaponBasePlayerId

    if not basePlayerId then
        self.weaponUses = nil
        self.weaponPlayerId = nil
        self.pendingWeaponReturn = false
        return false
    end

    local wasDead = self.dead == true
    local wasDeathFinished = self.deathFinished == true

    -- transformToPlayer не должен блокироваться из-за dead-состояния.
    self.dead = false
    self.deathFinished = false

    local ok = self:transformToPlayer(
        basePlayerId,
        {
            weaponUses = nil,
            weaponPlayerId = nil,
            weaponBasePlayerId = nil,
            pendingWeaponReturn = false,

            -- Spawn проиграет уже respawn(), если он нужен.
            playSpawn = false
        }
    )

    self.weaponUses = nil
    self.weaponPlayerId = nil
    self.weaponBasePlayerId = nil
    self.pendingWeaponReturn = false

    self.dead = wasDead
    self.deathFinished = wasDeathFinished

    return ok
end

------


-- Возрождает игрока без перезапуска уровня.
function Player:respawn(x, y, options)
    options = options or {}

    self.x = x or self.x
    self.y = y or self.y

    self.previousX = self.x
    self.previousY = self.y

    self.vx = 0
    self.vy = 0

    self.health = self.maxHealth

    self.dead = false
    self.deathFinished = false
    self.lastDamageInfo = nil

    self.onGround = false
    self.currentPlatform = nil

    self.jumpCount = 0
    self.jumpsUsed = 0

    self.comboTimer = 0
    self.comboIndex = 0
    self.comboGroupName = nil

    self.isBlocking = false
    self.isCrouching = false

    if self.setStandBbox then
        self:setStandBbox()
    end

    self.invulnerable = true
    self.invulnerableTimer = options.invulnerableTime or 1.0

    if options.facing then
        self.facing = options.facing
    end

    self.state = "idle"

    if self.playSpawnAnimation then
        self:playSpawnAnimation()
    elseif self.animationSet and self.animationSet:has("idle") then
        self.animationSet:set("idle", true)
    end
end

-- Обновляет физику игрока: gravity и движение по vx/vy.
function Player:updatePhysics(dt)
    if self.dead then
        return
    end

    -- Запоминаем прошлую позицию.
    -- Это нужно, чтобы платформы понимали:
    -- игрок упал сверху или уже оказался внутри объекта.
    self.previousX = self.x
    self.previousY = self.y

    self.vy = self.vy + self.gravity * dt

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

--обновить состояние неуязвимости
function Player:updateInvulnerability(dt)
    if not self.invulnerable then
        return
    end

    -- Если timer не задан или 0, значит неуязвимость постоянная.
    if not self.invulnerableTimer or self.invulnerableTimer <= 0 then
        return
    end

    self.invulnerableTimer = self.invulnerableTimer - dt

    if self.invulnerableTimer <= 0 then
        self.invulnerable = false
        self.invulnerableTimer = 0
    end
end

-- Обновляет игрока: physics, animation events и состояния death/idle/run/jump/fall.
function Player:update(dt)
    -- Специальный lock для LevelEnd/дверей.
    -- В этом состоянии игрок не двигается, не падает, не принимает input
    -- и только проигрывает win-анимацию, если она есть.
    if self.levelEndLocked then
        self:updateInvulnerability(dt)

        local events = self.animationSet:update(dt)

        for _, event in ipairs(events) do
            table.insert(self.entitySpawnRequests, event)
        end

        if self.levelEndWinPlaying
            and self.animationSet:isCurrentFinished()
        then
            self.levelEndWinFinished = true
        end

        return
    end

    self:updatePhysics(dt)
    self:updateInvulnerability(dt)

    ---сообщение если оружие неверно описано
    if self.messageTimer and self.messageTimer > 0 then
        self.messageTimer = math.max(0, self.messageTimer - dt)

        if self.messageTimer <= 0 then
            self.messageText = nil
        end
    end

    if self.comboTimer and self.comboTimer > 0 then
        self.comboTimer = math.max(0, self.comboTimer - dt)

        if self.comboTimer <= 0 then
            self.comboIndex = 0
            self.comboGroupName = nil
        end
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

    if self.dead then
        return
    end

    -- Если weaponUses закончились, возвращаемся после завершения текущей action-анимации.
    if self.pendingWeaponReturn
        and self.animationSet:isCurrentFinished()
    then
        self:returnFromWeapon()
        return
    end

    if self:isInputLocked() then
        return
    end

    if self.isBlocking then
        return
    end

    if self.isCrouching then
        if self.state ~= "crouch" then
            self:playAnimation("crouch")
        end

        return
    end

    if not self.onGround then
        if (self.vy or 0) < 0 then
            self:playAnimation("jump")
        else
            self:playAnimation("fall")
        end

        return
    end

    if math.abs(self.vx or 0) > 1 then
        self:playAnimation("run")
    else
        self:playAnimation("idle")
    end
end

-- Возвращает и очищает события игрока.
function Player:consumeEntitySpawnRequests()
    local requests = self.entitySpawnRequests

    self.entitySpawnRequests = {}

    return requests
end

-- Рисует игрока.
function Player:draw(camera)
    Render.drawEntity(self, camera)
end

return Player