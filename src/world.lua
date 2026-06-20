local Config = require("src.config")
local EntityFactory = require("src.entity_factory")
local EventRunner = require("src.event_runner")
local Collision = require("src.collision")
local Targeting = require("src.targeting")
local Render = require("src.render")
local Assets = require("src.assets")
local Physics = require("src.physics")
local Shadow = require("src.shadow")
local Debug = require("src.debug")

local World = {}
World.__index = World

-- Создаёт runtime-мир уровня.
-- World хранит активные entity, камеру, музыку и состояние результата уровня.
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

	world.oneSideCameraX = 0

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

-- Добавляет статичные объекты уровня в активные списки world.
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

-- Останавливает музыку текущего мира.
function World:stop()
    if self.music then
        self.music:stop()
    end
end

-- Создаёт entity по id и сразу добавляет её в нужный список world.
function World:createEntity(id, x, y, overrides)
    local kind, entity = EntityFactory.createEntity(id, x, y, overrides)

    self:addEntity(kind, entity)

    return entity
end

-- Добавляет entity в список по типу: actor, projectile, effect или pickup.
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

    if kind == "platform" then
        table.insert(self.level.platforms, entity)
        return
    end

    if kind == "decor" then
        table.insert(self.level.decors, entity)
        return
    end

    if kind == "levelEnd" then
        self.level.levelEnd = entity
        return
    end
end

-- Возвращает группы целей для targeting-системы.
function World:getTargetGroups()
    return {
        player = self.player and {self.player} or {},
        actors = self.actors
    }
end

-- Обновляет позицию камеры относительно игрока.
function World:updateCamera(dt)
    if not self.player then
        return
    end

    local targetX = self.player.x - Config.screen.width * Config.camera.playerScreenXFactor
    local targetY = self.player.y - Config.screen.height * 0.65

    self.camera.x = self.camera.x + (targetX - self.camera.x) * Config.camera.followSpeed * dt
    self.camera.y = self.camera.y + (targetY - self.camera.y) * Config.camera.followSpeed * dt

    if self.level and self.level.bounds then
        local bounds = self.level.bounds

        local minX = bounds.left or self.camera.x
        local minY = bounds.top or self.camera.y

        local maxX = self.camera.x
        local maxY = self.camera.y

        if bounds.right then
            maxX = bounds.right - Config.screen.width
        end

        if bounds.bottom then
            maxY = bounds.bottom - Config.screen.height
        end

        if maxX < minX then
            maxX = minX
        end

        if maxY < minY then
            maxY = minY
        end

        self.camera.x = math.max(minX, math.min(self.camera.x, maxX))
        self.camera.y = math.max(minY, math.min(self.camera.y, maxY))
    end
	--Если по уровню можно идти только в одну сторону
	if self.level and self.level.oneSide then
        self.oneSideCameraX = math.max(
            self.oneSideCameraX or self.camera.x,
            self.camera.x
        )

        self.camera.x = self.oneSideCameraX
    end	
end

-- Применяет damageHitbox к игроку и actor-ам.
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

-- Забирает и выполняет entity events, созданные анимацией или логикой entity.
function World:processEntityEvents(entity)
    if not entity.consumeEntitySpawnRequests then
        return
    end

    local events = entity:consumeEntitySpawnRequests()

    EventRunner.runAll(self, entity, events)
end

-- Забирает effect spawn requests у entity и создаёт нужные effects.
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

-- Удаляет decor-объекты, которые завершили removeDecor-анимацию.
function World:removeDeadDecors()
    if not self.level then
        return
    end

    for index = #self.level.decors, 1, -1 do
        local decor = self.level.decors[index]

        if decor.isRemovable and decor:isRemovable() then
            table.remove(self.level.decors, index)
        end
    end
end

-- Разруливает горизонтальное столкновение entity с solid-объектом.
-- Двигаем только entity, obstacle остаётся на месте.
function World:resolveEntityAgainstSolidObstacle(entity, obstacle)
    if not entity or not obstacle then
        return false
    end

    if entity == obstacle then
        return false
    end

    if entity.dead or obstacle.dead then
        return false
    end

    if not entity.getHitbox or not obstacle.getHitbox then
        return false
    end

    local entityBox = entity:getHitbox()
    local obstacleBox = obstacle:getHitbox()

    if not Collision.intersects(entityBox, obstacleBox) then
        return false
    end

    local hitboxOffsetX = entityBox.x - entity.x
    local previousX = entity.previousX or entity.x

    local previousBox = {
        x = previousX + hitboxOffsetX,
        y = entityBox.y,
        w = entityBox.w,
        h = entityBox.h
    }

    -- Пришёл слева и упёрся в левую сторону obstacle.
    if previousBox.x + previousBox.w <= obstacleBox.x then
        entity.x = obstacleBox.x - hitboxOffsetX - entityBox.w
        entity.vx = math.min(0, entity.vx or 0)
        return true
    end

    -- Пришёл справа и упёрся в правую сторону obstacle.
    if previousBox.x >= obstacleBox.x + obstacleBox.w then
        entity.x = obstacleBox.x + obstacleBox.w - hitboxOffsetX
        entity.vx = math.max(0, entity.vx or 0)
        return true
    end

    -- Fallback: если уже оказались внутри, выталкиваем в ближайшую сторону.
    local entityCenterX = entityBox.x + entityBox.w / 2
    local obstacleCenterX = obstacleBox.x + obstacleBox.w / 2

    if entityCenterX < obstacleCenterX then
        entity.x = obstacleBox.x - hitboxOffsetX - entityBox.w
        entity.vx = math.min(0, entity.vx or 0)
    else
        entity.x = obstacleBox.x + obstacleBox.w - hitboxOffsetX
        entity.vx = math.max(0, entity.vx or 0)
    end

    return true
end

-- Не даёт entity проходить сквозь solid actor-ов.
function World:resolveSolidActorCollisions(entity)
    if not entity then
        return false
    end

    local didResolve = false

    for _, actor in ipairs(self.actors or {}) do
        if actor.solid then
            if self:resolveEntityAgainstSolidObstacle(entity, actor) then
                didResolve = true
            end
        end
    end

    return didResolve
end

-- Не даёт solid actor-у пройти сквозь player.
function World:resolveSolidActorAgainstPlayer(actor)
    if not actor or not actor.solid then
        return false
    end

    if not self.player or self.player.dead then
        return false
    end

    return self:resolveEntityAgainstSolidObstacle(actor, self.player)
end

-- Проверяет projectile collisions с player/actors.
-- После первого попадания projectile умирает, чтобы не наносить урон каждый кадр.
function World:resolveProjectileHits(projectile)
    if not projectile or not projectile.canDamage then
        return
    end

    if not projectile:canDamage() then
        return
    end

    local hitbox = projectile:getHitbox()
    local damageInfo = projectile:createDamageInfo()
    local collides = projectile.collides or {}

    if collides.player ~= false
        and self.player
        and self.player ~= projectile.owner
        and Targeting.canDamage(damageInfo.damageTargets, self.player)
        and Collision.intersects(hitbox, self.player:getHitbox())
    then
        self.player:takeDamage(damageInfo)
        projectile:hit()
        return
    end

    if collides.actors ~= false then
        for _, actor in ipairs(self.actors) do
            if actor ~= projectile.owner
                and Targeting.canDamage(damageInfo.damageTargets, actor)
                and Collision.intersects(hitbox, actor:getHitbox())
            then
		
                actor:takeDamage(damageInfo)
                projectile:hit()
                return
            end
        end
    end
end


-- Проверяет contact damage actor-а по игроку.
-- Это урон телом: если bbox actor-а пересёк bbox player-а,
-- player получает damage, а actor запускает contactDamageCooldown.
function World:resolveActorContactDamage(actor)
    if not actor or not actor.canApplyContactDamage then
        return false
    end

    if not actor:canApplyContactDamage() then
        return false
    end

    if not self.player or self.player.dead then
        return false
    end

    if not actor.getHitbox or not self.player.getHitbox then
        return false
    end

    local damageInfo = actor:createContactDamageInfo()

    if not Targeting.canDamage(damageInfo.damageTargets, self.player) then
        return false
    end

    if not Collision.intersects(actor:getHitbox(), self.player:getHitbox()) then
        return false
    end

    self.player:takeDamage(damageInfo)
    actor:markContactDamageApplied()

    return true
end


-- Проверяет damage от effects по игроку и actor-ам.
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


-- Возвращает actor-а, который стал причиной смерти игрока.
-- Для projectile берём owner, для melee/contact — source или owner.
function World:getPlayerDeathActor()
    if not self.player or not self.player.lastDamageInfo then
        return nil
    end

    local damageInfo = self.player.lastDamageInfo
    local owner = damageInfo.owner
    local source = damageInfo.source

    if owner and owner.sceneIfPlayerDieByActor then
        return owner
    end

    if source and source.sceneIfPlayerDieByActor then
        return source
    end

    if source and source.owner and source.owner.sceneIfPlayerDieByActor then
        return source.owner
    end

    return nil
end

-- Возвращает scene, которую нужно запустить после смерти игрока от actor-а.
function World:getPlayerDeathScene()
    local actor = self:getPlayerDeathActor()

    if actor then
        return actor.sceneIfPlayerDieByActor
    end

    return nil
end


-- Не даёт игроку вернуться назад на oneSide-уровне.
function World:resolveOneSidePlayerLimit()
    if not self.level or not self.level.oneSide then
        return
    end

    if not self.player or not self.player.getHitbox then
        return
    end

    local minX = (self.oneSideCameraX or self.camera.x or 0)
        + (self.level.oneSideBackMargin or 0)

    local hitbox = self.player:getHitbox()
    local hitboxOffsetX = hitbox.x - self.player.x

    if hitbox.x < minX then
        self.player.x = minX - hitboxOffsetX
        self.player.vx = math.max(0, self.player.vx or 0)
    end
end

-- Возвращает true, если cleanup-zone пересекает entity.
function World:cleanupZoneTouchesEntity(zone, entity)
    if not zone or not entity then
        return false
    end

    if entity == zone then
        return false
    end

    if entity.dead then
        return false
    end

    if not zone.getHitbox or not entity.getHitbox then
        return false
    end

    return Collision.intersects(zone:getHitbox(), entity:getHitbox())
end

-- Удаляет entity, которые попали в cleanup-zone.
function World:updateCleanupZones()
    if not self.level or not self.level.decors then
        return
    end

    for _, zone in ipairs(self.level.decors) do
        if zone.cleanupZone then
            self:cleanupActors(zone)
            self:cleanupProjectiles(zone)
            self:cleanupEffects(zone)
            self:cleanupPickups(zone)
            self:cleanupPlatforms(zone)
            self:cleanupDecors(zone)
        end
    end
end

function World:cleanupActors(zone)
    for index = #self.actors, 1, -1 do
        local actor = self.actors[index]

        if self:cleanupZoneTouchesEntity(zone, actor) then
            print("[CLEANUP ZONE] remove actor", actor.id or "actor", actor.x, actor.y)
            table.remove(self.actors, index)
        end
    end
end

function World:cleanupProjectiles(zone)
    for index = #self.projectiles, 1, -1 do
        local projectile = self.projectiles[index]

        if self:cleanupZoneTouchesEntity(zone, projectile) then
            print("[CLEANUP ZONE] remove projectile", projectile.id or "projectile", projectile.x, projectile.y)
            table.remove(self.projectiles, index)
        end
    end
end

function World:cleanupEffects(zone)
    for index = #self.effects, 1, -1 do
        local effect = self.effects[index]

        if self:cleanupZoneTouchesEntity(zone, effect) then
            print("[CLEANUP ZONE] remove effect", effect.id or "effect", effect.x, effect.y)
            table.remove(self.effects, index)
        end
    end
end

function World:cleanupPickups(zone)
    for index = #self.pickups, 1, -1 do
        local pickup = self.pickups[index]

        if self:cleanupZoneTouchesEntity(zone, pickup) then
            print("[CLEANUP ZONE] remove pickup", pickup.id or "pickup", pickup.x, pickup.y)
            table.remove(self.pickups, index)
        end
    end
end

function World:cleanupPlatforms(zone)
    if not self.level or not self.level.platforms then
        return
    end

    for index = #self.level.platforms, 1, -1 do
        local platform = self.level.platforms[index]

        if self:cleanupZoneTouchesEntity(zone, platform) then
            print("[CLEANUP ZONE] remove platform", platform.id or "platform", platform.x, platform.y)
            table.remove(self.level.platforms, index)
        end
    end
end

function World:cleanupDecors(zone)
    if not self.level or not self.level.decors then
        return
    end

    for index = #self.level.decors, 1, -1 do
        local decor = self.level.decors[index]

        if decor ~= zone
            and not decor.cleanupZone
            and self:cleanupZoneTouchesEntity(zone, decor)
        then
            print("[CLEANUP ZONE] remove decor", decor.id or "decor", decor.x, decor.y)
            table.remove(self.level.decors, index)
        end
    end
end

-- Обновляет игрока, применяет платформенную физику и проверяет падение в яму.
function World:updatePlayer(dt)
    if not self.player then
        return
    end

    self.player:update(dt)

    Physics.resolvePlatforms(self.level, self.player)
	
	self:resolveOneSidePlayerLimit() --Уроень в одну сторону, вернутсяигроку нельзя
	
	self:resolveSolidActorCollisions(self.player) --игрок не может пройти сквозь блокируюзих монстров
--    Physics.killPlayerBelowScreen(self.player, self.camera)

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


-- Печатает удаление entity через cleanup zone.
function World:printCleanupZoneRemove(cleanupZone, kind, entity)
    if not cleanupZone.printCleanup then
        return
    end

    print(
        "[CLEANUP ZONE]",
        tostring(cleanupZone.id),
        "removed",
        tostring(kind),
        tostring(entity and entity.id),
        "x=" .. tostring(entity and entity.x),
        "y=" .. tostring(entity and entity.y)
    )
end

-- Молча удаляет entity из списка, если она пересекла cleanup zone.
function World:cleanupEntityList(cleanupZone, kind, list)
    if not list or not cleanupZone or not cleanupZone.getHitbox then
        return
    end

    local zoneHitbox = cleanupZone:getHitbox()

    for index = #list, 1, -1 do
        local entity = list[index]

        if entity ~= cleanupZone
            and not entity.cleanupZone
            and entity.getHitbox
            and Collision.intersects(zoneHitbox, entity:getHitbox())
        then
            self:printCleanupZoneRemove(cleanupZone, kind, entity)
            table.remove(list, index)
        end
    end
end

-- Обрабатывает одну cleanup zone.
-- Это silent remove: без death, pain, sound и effects.
function World:processCleanupZone(cleanupZone)
    if not cleanupZone or cleanupZone.cleanupZone ~= true then
        return
    end

    if cleanupZone.removeActors then
        self:cleanupEntityList(cleanupZone, "actor", self.actors)
    end

    if cleanupZone.removeProjectiles then
        self:cleanupEntityList(cleanupZone, "projectile", self.projectiles)
    end

    if cleanupZone.removeEffects then
        self:cleanupEntityList(cleanupZone, "effect", self.effects)
    end

    if cleanupZone.removePickups then
        self:cleanupEntityList(cleanupZone, "pickup", self.pickups)
    end

    if self.level then
        if cleanupZone.removePlatforms then
            self:cleanupEntityList(cleanupZone, "platform", self.level.platforms)
        end

        if cleanupZone.removeDecors then
            self:cleanupEntityList(cleanupZone, "decor", self.level.decors)
        end

        if cleanupZone.removeLevelEnd
            and self.level.levelEnd
            and self.level.levelEnd.getHitbox
            and Collision.intersects(cleanupZone:getHitbox(), self.level.levelEnd:getHitbox())
        then
            self:printCleanupZoneRemove(cleanupZone, "levelEnd", self.level.levelEnd)
            self.level.levelEnd = nil
        end
    end

    if cleanupZone.removePlayer
        and self.player
        and self.player.getHitbox
        and Collision.intersects(cleanupZone:getHitbox(), self.player:getHitbox())
    then
        self:printCleanupZoneRemove(cleanupZone, "player", self.player)
        self.result = "player_dead"
    end
end

-- Обрабатывает все cleanup zones уровня.
function World:updateCleanupZones()
    if not self.level then
        return
    end

    for _, decor in ipairs(self.level.decors or {}) do
        if decor.cleanupZone then
            self:processCleanupZone(decor)
        end
    end
end

-- Обновляет actor-ов, применяет платформенную физику и удаляет завершивших смерть.
function World:updateActors(dt)
    for index = #self.actors, 1, -1 do
        local actor = self.actors[index]

		actor:update(dt, self)

        Physics.resolvePlatforms(self.level, actor)

        self:resolveActorContactDamage(actor)

        self:resolveSolidActorCollisions(actor)
        self:resolveSolidActorAgainstPlayer(actor)

        self:processEntityEvents(actor)

		if actor.deathFinished then
            if actor.sceneIfActorDeath then
                self.nextTarget = {
                    type = "scene",
                    id = actor.sceneIfActorDeath
                }
                self.result = "transition"
            end
        end
		
        if actor:isRemovable() then

            table.remove(self.actors, index)
        end
    end
end

-- Обновляет projectile-ы, проверяет попадания и обрабатывает их события.
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

-- Обновляет effects, применяет их damage и удаляет завершённые effects.
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

-- Обновляет pickups и применяет подбор игроком.
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
-- Если у LevelEnd есть nextTarget, запускаем явный transition.
-- Если nextTarget нет, оставляем старую victory/flow-логику.
function World:updateLevelEnd()
    if not self.level then
        return
    end

    if self.level:checkLevelEnd(self.player) then
        local levelEnd = self.level.levelEnd

        levelEnd:trigger()

        self.nextTarget = levelEnd:getNextTarget()

        if self.nextTarget then
            self.result = "transition"
        else
            self.result = "victory"
        end
    end
end

-- Обновляет весь world за один кадр.
function World:update(dt)
    if self.result then
        return
    end

	for _, actor in ipairs(self.level:spawnPendingActors(self.player, self.camera)) do
		table.insert(self.actors, actor)
	end

    self.level:update(dt, self)
	
	self:updateCleanupZones()
	
	self:removeDeadDecors()

    self:updatePlayer(dt)
    self:updateActors(dt)
    self:updateProjectiles(dt)
    self:updateEffects(dt)
    self:updatePickups(dt)
	self:updateCleanupZones()
    self:updateLevelEnd()

    self:updateCamera(dt)
end

-- Рисует background layers кроме переднего слоя
-- Поддерживает parallax и optional texture scroll.
function World:drawBackgrounds()
    if not self.level then
        return
    end

    for _, background in ipairs(self.level.backgrounds or {}) do
        if background.layer ~= "front" then
            Render.drawBackgroundLayer(background, self.camera)
        end
    end
end

-- Рисует front background layers.
-- Это те же backgrounds, но поверх gameplay.
function World:drawFrontBackgrounds()
    if not self.level then
        return
    end

    for _, background in ipairs(self.level.backgrounds or {}) do
        if background.layer == "front" then
            Render.drawBackgroundLayer(background, self.camera)
        end
    end
end

-- Рисует debug-оверлей runtime entity: bbox, hitbox, origin и имя.
function World:drawDebug()
    Debug.drawWorld(self)
end

-- Обновляет позицию тени и рисует runtime entity.
function World:drawEntityWithShadow(entity)
    Shadow.update(entity, self.level)
    entity:draw(self.camera)
end

-- Рисует весь world в порядке слоёв.
-- Рисует весь world в порядке слоёв.
function World:draw()
    self:drawBackgrounds()

    for _, decor in ipairs(self.level.decors or {}) do
        if decor.layer == "back" or decor.layer == nil then
            self:drawEntityWithShadow(decor)
        end
    end

    for _, platform in ipairs(self.level.platforms or {}) do
        platform:draw(self.camera)
    end

    for _, decor in ipairs(self.level.decors or {}) do
        if decor.layer == "middle" then
            self:drawEntityWithShadow(decor)
        end
    end

    for _, pickup in ipairs(self.pickups) do
        self:drawEntityWithShadow(pickup)
    end

    for _, effect in ipairs(self.effects) do
        self:drawEntityWithShadow(effect)
    end

    for _, projectile in ipairs(self.projectiles) do
        self:drawEntityWithShadow(projectile)
    end

    for _, actor in ipairs(self.actors) do
        self:drawEntityWithShadow(actor)
    end

    if self.player then
        self:drawEntityWithShadow(self.player)
    end

	if self.level.levelEnd then
        self:drawEntityWithShadow(self.level.levelEnd)
    end

    for _, decor in ipairs(self.level.decors or {}) do
        if decor.layer == "front" then
            self:drawEntityWithShadow(decor)
        end
    end

    self:drawFrontBackgrounds()
    self:drawDebug()
end

return World