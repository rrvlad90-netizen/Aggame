local Ladder = require("src.ladder")
local Physics = require("src.physics")
local Utils = require("src.utils")

local LadderSystem = {
    installed = false
}

-- Создаёт копию анимации для движения по лестнице.
local function createLadderAnimation(animations)
    local source = animations.run or animations.idle

    if not source then
        return {
            loop = true,
            frameDuration = 0.12,
            frames = {}
        }
    end

    local animation = Utils.deepCopy(source)

    animation.loop = true
    animation.lockInput = false
    animation.events = nil

    return animation
end

-- Добавляет игроку отсутствующие анимации лестницы.
-- Пока используются кадры run; позже их можно заменить в player definition.
local function addDefaultLadderAnimations(config)
    config.animations = config.animations or {}

    if not config.animations.move_ledder_uo then
        config.animations.move_ledder_uo =
            createLadderAnimation(config.animations)
    end

    if not config.animations.move_ledder_down then
        config.animations.move_ledder_down =
            createLadderAnimation(config.animations)
    end
end

-- Устанавливает поддержку лестниц в Level, World и Player.
function LadderSystem.install(Player, World, Level, Input)
    if LadderSystem.installed then
        return
    end

    LadderSystem.installed = true

    local originalPlayerNew = Player.new
    local originalPlayAnimation = Player.playAnimation
    local originalSetMoveDirection = Player.setMoveDirection
    local originalJump = Player.jump
    local originalChooseShootAnimation = Player.chooseShootAnimation
    local originalUpdatePhysics = Player.updatePhysics
    local originalRespawn = Player.respawn
    local originalLevelNew = Level.new
    local originalWorldUpdate = World.update

    -- Создаёт игрока с runtime-состоянием лестницы.
    function Player:new(config)
        config = config or {}

        addDefaultLadderAnimations(config)

        local player = originalPlayerNew(self, config)

        player.onLadder = false
        player.activeLadder = nil
        player.ladderMoveDirection = 0

        return player
    end

    -- Покидает текущую лестницу.
    function Player:leaveLadder(keepVerticalVelocity)
        if not self.onLadder then
            return
        end

        self.onLadder = false
        self.activeLadder = nil
        self.ladderMoveDirection = 0
        self.onGround = false
        self.currentPlatform = nil

        if not keepVerticalVelocity then
            self.vy = 0
        end
    end

    -- Включает движение игрока по лестнице.
    function Player:setLadderMovement(ladder, direction)
        if self.dead or not ladder then
            return false
        end

        -- Action-анимации не перебиваются лестницей.
        -- Благодаря этому игрок может остановиться и выстрелить.
        if self:isHardLocked() then
            if self.onLadder then
                self.vx = 0
                self.vy = 0
                self.ladderMoveDirection = 0
            end

            return self.onLadder
        end

        self:cancelBlock()

        self.isCrouching = false
        self:setStandBbox()

        self.onLadder = true
        self.activeLadder = ladder
        self.onGround = false
        self.currentPlatform = nil

        self.vx = 0
        self.ladderMoveDirection = direction or 0
        self.vy = self.ladderMoveDirection * ladder.climbSpeed

        if self.ladderMoveDirection < 0 then
            self:playAnimation("move_ledder_uo")
        elseif self.ladderMoveDirection > 0 then
            self:playAnimation("move_ledder_down")
        else
            -- При остановке на лестнице сразу включается idle.
            self:playAnimation("idle")
        end

        return true
    end

    -- Не позволяет обычной воздушной логике перебить анимацию лестницы.
    function Player:playAnimation(name, force)
        if self.onLadder
            and (
                name == "jump"
                or name == "fall"
                or name == "run"
            )
        then
            return false
        end

        return originalPlayAnimation(self, name, force)
    end

    -- Горизонтальное движение снимает игрока с лестницы.
    function Player:setMoveDirection(direction)
        if self.onLadder and direction ~= 0 then
            self:leaveLadder(true)
        end

        return originalSetMoveDirection(self, direction)
    end

    -- Прыжок снимает игрока с лестницы и запускает обычный прыжок.
    function Player:jump()
        if self.onLadder then
            self:leaveLadder(false)

            -- Даём jump() выполнить первый прыжок.
            self.onGround = true
            self.jumpCount = 0
        end

        return originalJump(self)
    end

    -- На лестнице используется обычная стоячая стрельба.
    function Player:chooseShootAnimation(inputContext)
        if self.onLadder and self:hasAnimation("shoot_stand") then
            return "shoot_stand"
        end

        return originalChooseShootAnimation(self, inputContext)
    end

    -- На лестнице отключает гравитацию и двигает игрока только по vy.
    function Player:updatePhysics(dt)
        if not self.onLadder then
            return originalUpdatePhysics(self, dt)
        end

        if self.dead then
            return
        end

        self.previousX = self.x
        self.previousY = self.y

        self.x = self.x + (self.vx or 0) * dt
        self.y = self.y + (self.vy or 0) * dt
    end

    -- Сбрасывает состояние лестницы при возрождении.
    function Player:respawn(x, y, options)
        self.onLadder = false
        self.activeLadder = nil
        self.ladderMoveDirection = 0

        return originalRespawn(self, x, y, options)
    end

    -- Создаёт лестницы, описанные в level.ladders.
    function Level:new(config)
        config = config or {}

        local level = originalLevelNew(self, config)

        level.ladders = {}

        for _, ladderConfig in ipairs(config.ladders or {}) do
            local ladder = Ladder:new(ladderConfig)

            table.insert(level.ladders, ladder)

            -- Лестница рисуется существующей системой слоёв decor.
            table.insert(level.decors, ladder)
        end

        return level
    end

    -- Ищет лестницу, доступную игроку.
    function World:findPlayerLadder()
        if not self.player or not self.level then
            return nil
        end

        for _, ladder in ipairs(self.level.ladders or {}) do
            if ladder:canUse(self.player) then
                return ladder
            end
        end

        return nil
    end

    -- Обрабатывает вертикальный ввод игрока на лестнице.
    function World:updatePlayerLadderInput()
        local player = self.player

        if not player or player.dead then
            if player and player.leaveLadder then
                player:leaveLadder(false)
            end

            return false
        end

        local direction = 0

        if Input.isDown("up") then
            direction = direction - 1
        end

        if Input.isDown("down") then
            direction = direction + 1
        end

        local ladder = player.activeLadder

        if ladder and not ladder:canUse(player) then
            player:leaveLadder(true)
            ladder = nil
        end

        -- Игрок входит на лестницу только после Up или Down.
        if not ladder and direction ~= 0 then
            ladder = self:findPlayerLadder()
        end

        if not ladder then
            return false
        end

        return player:setLadderMovement(ladder, direction)
    end

    -- Обновляет игрока без platform collision, пока он на лестнице.
    function World:updatePlayer(dt)
        if not self.player then
            return
        end

        self.player:update(dt)

        if not self.player.onLadder then
            Physics.resolvePlatforms(self.level, self.player)
        end

        self:resolveOneSidePlayerLimit()
        self:resolveSolidActorCollisions(self.player)
        self:processEntityEvents(self.player)

        if self.player.deathFinished then
            local deathScene = self:getPlayerDeathScene()

            if deathScene then
                self.nextTarget = {
                    type = "scene",
                    id = deathScene
                }

                self.result = "transition"
            else
                self.result = "player_dead"
            end
        end
    end

    -- Проверяет лестницу перед обычным обновлением мира.
    function World:update(dt, levelEndActivatePressed)
        self:updatePlayerLadderInput()

        return originalWorldUpdate(
            self,
            dt,
            levelEndActivatePressed
        )
    end
end

return LadderSystem