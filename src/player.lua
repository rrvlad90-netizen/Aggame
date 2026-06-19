local AnimationSet = require("src.animation_set")
local Collision = require("src.collision")
local Render = require("src.render")
local Utils = require("src.utils")

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

    player.onGround = false
    player.dead = false
	player.lastDamageInfo = nil
    player.deathFinished = false

    player.state = "idle"

    player.ammo = config.ammo or {}

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

    player:playSpawnAnimation()

    return player
end

-- Возвращает true, если у игрока есть способность abilityName.
-- Если abilities[abilityName] не указано, считаем что способность разрешена.
function Player:can(abilityName)
    if self.abilities[abilityName] == nil then
        return true
    end

    return self.abilities[abilityName] == true
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
function Player:playAnimation(name, force)
    self.state = name
    self.animationSet:set(name, force)
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

-- Запускает случайную spawn-анимацию игрока.
-- Если spawn01/02/03 нет, запускает idle.
function Player:playSpawnAnimation()
    if self:playAnimationGroup({
        "spawn01",
        "spawn02",
        "spawn03"
    }, "idle", true) then
        return
    end

    self.animationSet:set("idle", true)
end

-- Начинает движение влево/вправо.
function Player:setMoveDirection(direction)
    if self.dead then
        return
    end

    if self:isInputLocked() then
        return
    end

    if not self:can("canMove") then
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

    if self:isInputLocked() then
        return
    end

    self.vx = 0

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

    if not self:can("canJump") then
        return
    end

    -- Если физика уже считает игрока стоящим, синхронизируем счётчик прыжков.
    -- Это защищает от старых состояний после приземления на платформу.
    if self.onGround then
        self.jumpCount = 0
    end

    -- Input lock не должен запрещать второй прыжок,
    -- если игрок уже находится в jump-состоянии.
    if self:isInputLocked() and self.state ~= "jump" then
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

-- Запускает дальнюю атаку.
-- В воздухе использует jump_attack01/02/03, если они есть.
function Player:shoot()
    if self.dead then
        return
    end

    if self:isInputLocked() then
        return
    end

    if not self:can("canShoot") then
        return
    end

    if not self.onGround then
        if self:playAnimationGroup({
            "jump_attack01",
            "jump_attack02",
            "jump_attack03"
        }, "shoot", true) then
            return
        end
    end

    self:playAnimation("shoot", true)
end

-- Запускает melee-атаку.
-- В воздухе использует jump_melee01/02/03, если они есть.
function Player:melee()
    if self.dead then
        return
    end

    if self:isInputLocked() then
        return
    end

    if not self:can("canMelee") then
        return
    end

    if not self.onGround then
        if self:playAnimationGroup({
            "jump_melee01",
            "jump_melee02",
            "jump_melee03"
        }, "melee", true) then
            return
        end
    end

    self:playAnimation("melee", true)
end

-- Запускает crouch-анимацию.
function Player:crouch()
    if self.dead then
        return
    end

    if self:isInputLocked() then
        return
    end

    if not self:can("canCrouch") then
        return
    end

    self.vx = 0
    self:playAnimation("crouch", true)
end

-- Запускает strafe/special-анимацию.
-- Strafe специально останавливает текущую скорость и двигает игрока animation-event-ом.
function Player:strafe()
    if self.dead then
        return
    end

    if self:isInputLocked() then
        return
    end

    if not self:can("canStrafe") then
        return
    end

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

-- Обновляет игрока: физику, animation events и состояние death/idle/run.
function Player:update(dt)
    self:updatePhysics(dt)

    local events = self.animationSet:update(dt)

    for _, event in ipairs(events) do
        table.insert(self.entitySpawnRequests, event)
    end

    if self.dead
        and self.animationSet:isCurrentFinished()
    then
        self.deathFinished = true
    end

    if not self.dead
        and self.animationSet:isCurrentFinished()
        and self.state ~= "idle"
        and self.state ~= "run"
        and self.onGround
    then
        if math.abs(self.vx or 0) > 1 then
            self:playAnimation("run")
        else
            self:playAnimation("idle")
        end
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