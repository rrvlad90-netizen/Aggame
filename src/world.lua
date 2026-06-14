local Config = require("src.config")
local EntityFactory = require("src.entity_factory")
local EventRunner = require("src.event_runner")
local Collision = require("src.collision")
local Targeting = require("src.targeting")
local Render = require("src.render")
local Assets = require("src.assets")

local World = {}
World.__index = World

-- Создаёт runtime-мир уровня.
-- World хранит все активные entity и управляет их update/draw.
function World:new(level, player)
    local world = setmetatable({}, World)

    world.level = level
    world.player = player

    world.actors = {}
    world.projectiles = {}
    world.effects = {}
    world.pickups = {}

    world.camera = {
        x = 0,
        y = 0
    }

    world.result = nil

    world.music = nil

    if level and level.music then
        world.music = Assets.getMusic(level.music)
    end

    if world.music then
        world.music:stop()
        world.music:play()
    end

    world:addLevelObjects()

    return world
end

-- Добавляет объекты уровня в world.
function World:addLevelObjects()
    if not self.level then
        return
    end

    for _, pickup in ipairs(self.level.pickups or {}) do
        table.insert(self.pickups, pickup)
    end

    for _, effect in ipairs(self.level.effects or {}) do
        table.insert(self.effects, effect)
    end
end

-- Останавливает музыку мира.
function World:stop()
    if self.music then
        self.music:stop()
    end
end

-- Создаёт entity по id и сразу добавляет её в world.
function World:createEntity(id, x, y, overrides)
    local kind, entity = EntityFactory.createEntity(id, x, y, overrides)

    self:addEntity(kind, entity)

    return entity
end

-- Добавляет entity в нужный список.
function World:addEntity(kind, entity)
    if kind == "actor" then
        table.insert(self.actors, entity)
        return
    end

    if kind == "projectile" then
        table.insert(self.projectiles, entity)
        return
    end

    if kind == "effect" then
        table.insert(self.effects, entity)
        return
    end

    if kind == "pickup" then
        table.insert(self.pickups, entity)
        return
    end
end

-- Возвращает группы целей для targeting.
function World:getTargetGroups()
    return {
        player = self.player and {self.player} or {},
        actors = self.actors
    }
end

-- Обновляет камеру.
function World:updateCamera(dt)
    if not self.player then
        return
    end

    local targetX = self.player.x - Config.screen.width * Config.camera.playerScreenXFactor
    local targetY = self.player.y - Config.screen.height * 0.65

    self.camera.x = self.camera.x + (targetX - self.camera.x) * Config.camera.followSpeed * dt
    self.camera.y = self.camera.y + (targetY - self.camera.y) * Config.camera.followSpeed * dt

    if self.level and self.level.bounds then
        self.camera.x = math.max(self.level.bounds.left, self.camera.x)
        self.camera.y = math.max(self.level.bounds.top, self.camera.y)
    end
end

-- Применяет damageHitbox к actor-ам и игроку.
function World:applyDamageHitbox(owner, hitbox, damageInfo)
    if not hitbox or not damageInfo then
        return
    end

    if self.player
        and self.player ~= owner
        and Targeting.canDamage(damageInfo.damageTargets, self.player)
        and Collision.intersects(hitbox, self.player:getHitbox())
    then
        self.player:takeDamage(damageInfo)
    end

    for _, actor in ipairs(self.actors) do
        if actor ~= owner
            and Targeting.canDamage(damageInfo.damageTargets, actor)
            and Collision.intersects(hitbox, actor:getHitbox())
        then
            actor:takeDamage(damageInfo)
        end
    end
end

-- Обрабатывает события entity.
function World:processEntityEvents(entity)
    if not entity.consumeEntitySpawnRequests then
        return
    end

    local events = entity:consumeEntitySpawnRequests()

    EventRunner.runAll(self, entity, events)
end

-- Обрабатывает effect requests у entity.
function World:processEffectRequests(entity)
    if not entity.consumeEffectSpawnRequests then
        return
    end

    for _, request in ipairs(entity:consumeEffectSpawnRequests()) do
        local id = request.id or request.model

        if id then
            self:createEntity(id, request.x or entity.x, request.y or entity.y, request)
        end
    end
end

-- Проверяет projectile collisions с player/actors.
-- Применяет простую физику платформ к entity.
function World:resolvePlatforms(entity)
    if not self.level then
        return
    end

    local bbox = entity:getHitbox()
    local currentBottom = bbox.y + bbox.h

    for _, platform in ipairs(self.level.platforms or {}) do
        local platformBox = platform:getHitbox()
        local platformTop = platformBox.y

        local overlapsX = bbox.x < platformBox.x + platformBox.w
            and platformBox.x < bbox.x + bbox.w

        -- Разрешаем небольшое "влипание" в платформу.
        -- Это нужно, потому что после gravity игрок каждый кадр чуть проваливается вниз.
        local landingToleranceTop = 8
        local landingToleranceBottom = 24

        local closeToPlatformTop = currentBottom >= platformTop - landingToleranceTop
            and currentBottom <= platformTop + landingToleranceBottom

        local fallingOrStanding = (entity.vy or 0) >= 0

        if overlapsX and closeToPlatformTop and fallingOrStanding then
            local correctedY = entity.y - (currentBottom - platformTop)

            if entity.landOn then
                entity:landOn(correctedY)
            else
                entity.y = correctedY
                entity.vy = 0
                entity.onGround = true
            end

            return
        end
    end
end

-- Проверяет damage от effects.
function World:resolveEffectDamage(effect)
    if not effect:canApplyDamage() then
        return
    end

    local hitbox = effect:getDamageHitbox()
    local damageInfo = effect:createDamageInfo()
    local didDamage = false

    if self.player
        and self.player ~= effect.owner
        and Targeting.canDamage(damageInfo.damageTargets, self.player)
        and Collision.intersects(hitbox, self.player:getHitbox())
    then
        self.player:takeDamage(damageInfo)
        didDamage = true
    end

    for _, actor in ipairs(self.actors) do
        if actor ~= effect.owner
            and Targeting.canDamage(damageInfo.damageTargets, actor)
            and Collision.intersects(hitbox, actor:getHitbox())
        then
            actor:takeDamage(damageInfo)
            didDamage = true
        end
    end

    if didDamage then
        effect:markDamageApplied()
    end
end

-- Приземляет entity на землю уровня.
function World:resolveGround(entity)
    if not self.level or not self.level.ground then
        return
    end

    if entity.flying then
        return
    end

    local bbox = entity:getHitbox()
    local groundY = self.level.ground.y
    local bottom = bbox.y + bbox.h

    if bottom >= groundY then
        local correctedY = entity.y - (bottom - groundY)

        if entity.landOn then
            entity:landOn(correctedY)
        else
            entity.y = correctedY
            entity.vy = 0
            entity.onGround = true
        end
    else
        entity.onGround = false
    end
end

-- Применяет простую физику платформ к entity.
function World:resolvePlatforms(entity)
    if not self.level then
        return
    end

    local bbox = entity:getHitbox()

    for _, platform in ipairs(self.level.platforms or {}) do
        if Collision.intersects(bbox, platform:getHitbox()) then
            local platformBox = platform:getHitbox()

            if bbox.y + bbox.h <= platformBox.y + 16
                and entity.vy >= 0
            then
                entity.y = entity.y - ((bbox.y + bbox.h) - platformBox.y)
                entity.vy = 0
                entity.onGround = true
            end
        end
    end
end

-- Обновляет игрока.
function World:updatePlayer(dt)
    if not self.player then
        return
    end

    self.player:update(dt)

    self:resolveGround(self.player)
    self:resolvePlatforms(self.player)

    self:processEntityEvents(self.player)

    if self.player.deathFinished then
        if self.player.lives > 1 then
            self.player.lives = self.player.lives - 1
            self.result = "restart"
        else
            self.result = "game_over"
        end
    end
end

-- Обновляет actor-ов.
function World:updateActors(dt)
    for index = #self.actors, 1, -1 do
        local actor = self.actors[index]

        actor:update(dt, self)

        self:resolveGround(actor)
        self:resolvePlatforms(actor)

        self:processEntityEvents(actor)

        if actor.deathFinished then
            if actor.VictoryIfDeath then
                self.result = "victory"
            end

            if actor.DefeatIfDeath then
                self.result = "defeat"
            end
        end

        if actor:isRemovable() then
            table.remove(self.actors, index)
        end
    end
end

-- Обновляет projectile-ы.
function World:updateProjectiles(dt)
    for index = #self.projectiles, 1, -1 do
        local projectile = self.projectiles[index]

        projectile:update(dt, self)

        self:resolveProjectileHits(projectile)

        self:processEntityEvents(projectile)
        self:processEffectRequests(projectile)

        if projectile:isRemovable() then
            table.remove(self.projectiles, index)
        end
    end
end

-- Обновляет effects.
function World:updateEffects(dt)
    for index = #self.effects, 1, -1 do
        local effect = self.effects[index]

        effect:update(dt, self)

        self:resolveEffectDamage(effect)

        self:processEntityEvents(effect)
        self:processEffectRequests(effect)

        if effect:isRemovable() then
            table.remove(self.effects, index)
        end
    end
end

-- Обновляет pickups.
function World:updatePickups(dt)
    for index = #self.pickups, 1, -1 do
        local pickup = self.pickups[index]

        pickup:update(dt)

        if self.player
            and pickup:canCollect()
            and Collision.intersects(pickup:getHitbox(), self.player:getHitbox())
        then
            pickup:applyToPlayer(self.player)
        end

        if pickup:isRemovable() then
            table.remove(self.pickups, index)
        end
    end
end

-- Проверяет LevelEnd.
function World:updateLevelEnd()
    if not self.level then
        return
    end

    if self.level:checkLevelEnd(self.player) then
        self.level.levelEnd:trigger()
        self.result = "victory"
    end
end

-- Обновляет world.
function World:update(dt)
    if self.result then
        return
    end

    for _, actor in ipairs(self.level:spawnPendingActors(self.player)) do
        table.insert(self.actors, actor)
    end

    self.level:update(dt, self)

    self:updatePlayer(dt)
    self:updateActors(dt)
    self:updateProjectiles(dt)
    self:updateEffects(dt)
    self:updatePickups(dt)
    self:updateLevelEnd()

    self:updateCamera(dt)
end

-- Рисует background layers.
function World:drawBackgrounds()
    if not self.level then
        return
    end

    for _, background in ipairs(self.level.backgrounds or {}) do
        if background.layer ~= "front" then
            Render.drawTiledX(
                background.image,
                self.camera,
                background.y or 0,
                background.scrollFactor or 1
            )
        end
    end
end

-- Рисует front background layers.
function World:drawFrontBackgrounds()
    if not self.level then
        return
    end

    for _, background in ipairs(self.level.backgrounds or {}) do
        if background.layer == "front" then
            Render.drawTiledX(
                background.image,
                self.camera,
                background.y or 0,
                background.scrollFactor or 1
            )
        end
    end
end

-- Рисует землю уровня.
function World:drawGround()
    if not self.level or not self.level.ground then
        return
    end

    local ground = self.level.ground

    if ground.image then
        Render.drawTiledX(
            ground.image,
            self.camera,
            ground.visualY or ground.y,
            1
        )
    else
        love.graphics.setColor(0.18, 0.22, 0.26)
        love.graphics.rectangle(
            "fill",
            0,
            (ground.visualY or ground.y) - self.camera.y,
            Config.screen.width,
            ground.visualHeight or 120
        )
        love.graphics.setColor(1, 1, 1)
    end
end

-- Рисует debug-информацию.
function World:drawDebug()
    if not Config.debug.enabled then
        return
    end

    if Config.debug.drawBboxes then
        if self.player then
            Render.drawEntityBBox(self.player, self.camera)
        end

        for _, actor in ipairs(self.actors) do
            Render.drawEntityBBox(actor, self.camera)
        end
    end
end

-- Рисует world.
function World:draw()
    self:drawBackgrounds()
    self:drawGround()

    for _, decor in ipairs(self.level.decors or {}) do
        if decor.layer ~= "front" then
            decor:draw(self.camera)
        end
    end

    for _, platform in ipairs(self.level.platforms or {}) do
        platform:draw(self.camera)
    end

    for _, pickup in ipairs(self.pickups) do
        pickup:draw(self.camera)
    end

    for _, effect in ipairs(self.effects) do
        effect:draw(self.camera)
    end

    for _, projectile in ipairs(self.projectiles) do
        projectile:draw(self.camera)
    end

    for _, actor in ipairs(self.actors) do
        actor:draw(self.camera)
    end

    if self.player then
        self.player:draw(self.camera)
    end

    if self.level.levelEnd then
        self.level.levelEnd:draw(self.camera)
    end

    for _, decor in ipairs(self.level.decors or {}) do
        if decor.layer == "front" then
            decor:draw(self.camera)
        end
    end

    self:drawFrontBackgrounds()
    self:drawDebug()
end


return World