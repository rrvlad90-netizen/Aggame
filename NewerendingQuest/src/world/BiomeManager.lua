local SceneWorld =
    require("src.world.SceneWorld")

local SkeletonData =
    require("data.entities.enemies.skeleton")

local Config = require("src.config")

local DungeonWorld =
    require("src.world.DungeonWorld")

local SwampWorld =
    require("src.world.SwampWorld")

local ForestWorld =
    require("src.world.World")

local LevelBackground =
    require("src.rendering.LevelBackground")

local LevelLoader =
    require("src.levels.LevelLoader")

local LevelTransition =
    require("src.transitions.LevelTransition")

local WorldCamera =
    require("src.camera.WorldCamera")

local Arrow =
    require("src.projectiles.Arrow")

local WyvernFireball =
    require("src.projectiles.WyvernFireball")

local Skeleton =
    require("src.entities.enemies.Skeleton")

local Wyvern =
    require("src.entities.enemies.Wyvern")

local ArrowBundle =
    require("src.items.ArrowBundle")

local HealthPotion =
    require("src.items.HealthPotion")

local ShieldPickup =
    require("src.items.ShieldPickup")

local PlayerData =
    require("data.entities.player")

local BiomeManager = {}
BiomeManager.__index = BiomeManager

-- Создаёт менеджер кампании, камеры и сущностей.
function BiomeManager.new(
    projection,
    assets,
    player,
    campaignId
)
    local self =
        setmetatable(
            {},
            BiomeManager
        )

    self.projection = projection
    self.assets = assets

    self.loader =
        LevelLoader.new(
            campaignId or "easy"
        )

    self.transition =
        LevelTransition.new(
            assets
        )

    self.camera =
        WorldCamera.new()

    self.background =
        LevelBackground.new(
            assets
        )

    self.level = nil
    self.world = nil
    self.completed = false

    self.playerArrows = {}
    self.enemyProjectiles = {}
    self.enemies = {}
    self.pickups = {}

    self.random =
        love.math.newRandomGenerator(
            os.time()
        )

    self:preloadPreviews()
    self:loadFirstLevel(player)

    return self
end

-- Предварительно загружает превью уровней.
function BiomeManager:preloadPreviews()
    for _, level in ipairs(
        self.loader:getLevels()
    ) do
        if
            level.preview and
            level.preview.image
        then
            self.assets:getFileImage(
                level.preview.image
            )
        end
    end
end

-- Создаёт мир указанного биома.
function BiomeManager:createWorld(level)

	if level.biome == "scene" then
		return SceneWorld.new(
			self.projection,
			self.assets,
			level
		)
	end

    if level.biome == "swamp" then
        return SwampWorld.new(
            self.projection,
            self.assets,
            level
        )
    end

    if level.biome == "forest" then
        return ForestWorld.new(
            self.projection,
            self.assets,
            level
        )
    end

    if level.biome == "dungeon" then
        return DungeonWorld.new(
            self.projection,
            self.assets,
            level
        )
    end

    error(
        "Unknown biome: " ..
        tostring(level.biome)
    )
end

-- Загружает первый уровень кампании.
function BiomeManager:loadFirstLevel(player)
    local level =
        self.loader:loadNext()

    assert(
        level,
        "Campaign has no levels"
    )

    self:activateLevel(
        level,
        player
    )
end

-- Активирует новый уровень.
function BiomeManager:activateLevel(
    level,
    player
)

	if
		self.world and
		self.world.leave
	then
		self.world:leave()
	end

    self.level = level

    self.background:configure(
        level.background
    )

    self.world =
        self:createWorld(level)

    self.playerArrows = {}
    self.enemyProjectiles = {}
    self.enemies = {}
    self.pickups = {}

    local spawnX = 0
    local spawnZ = 0

    if self.world.getSpawnPosition then
        spawnX, spawnZ =
            self.world:
            getSpawnPosition()
    end

    player:enterBiome(
        spawnX,
        spawnZ
    )

    local bounds =
        self.world:getCameraBounds()

    self.camera:configure(bounds)
    self.camera:reset(player)

    self:applyCamera()

    self:generateEnemies(player)
    self:generatePickups(player)
end

-- Передаёт положение камеры активному миру.
function BiomeManager:applyCamera()
    if
        self.world and
        self.world.setCameraPosition
    then
        self.world:setCameraPosition(
            self.camera:getX(),
            self.camera:getZ()
        )
    end
end

-- Возвращает случайную позицию внутри мира.
function BiomeManager:getRandomWorldPosition(
    player,
    minimumDistance,
    collisionRadius
)
    local minimum =
        minimumDistance or
        8 *
        Config.worldUnitsPerMeter

    local minX =
        self.world.minX or
        -400

    local maxX =
        self.world.maxX or
        400

    local minZ =
        self.world.minZ or
        0

    local maxZ =
        self.world.maxZ or
        (
            player.z +
            1500
        )

    for _ = 1, 80 do
        local x =
            minX +
            self.random:random() *
            (maxX - minX)

        local z =
            minZ +
            self.random:random() *
            (maxZ - minZ)

        local dx =
            x - player.x

        local dz =
            z - player.z

        local farEnough =
            dx * dx + dz * dz >=
            minimum * minimum

        local safePosition = true

        -- Only ground enemies request this check.
        if
            collisionRadius and
            self.world.isSafePosition
        then
            safePosition =
                self.world:isSafePosition(
                    x,
                    z,
                    collisionRadius
                )
        end

        if
            farEnough and
            safePosition
        then
            return x, z
        end
    end

    -- The player position should always be reachable.
    return player.x, player.z
end

-- Создаёт врагов текущего уровня.
function BiomeManager:generateEnemies(player)
    local settings =
        self.level.enemies or {}

    local skeletonCount =
        settings.skeletonCount

    if skeletonCount == nil then
        if
            self.level.biome == "forest" or
            self.level.biome == "dungeon"
        then
            skeletonCount = 2
        else
            skeletonCount = 0
        end
    end

    local shieldSkeletonCount =
        settings.shieldSkeletonCount

    if shieldSkeletonCount == nil then
        shieldSkeletonCount =
            skeletonCount > 0 and
            1 or
            0
    end

    for index = 1, skeletonCount do
        local x, z =
            self:getRandomWorldPosition(
                player,
                10 *
                Config.worldUnitsPerMeter,
                SkeletonData.collisionRadius
            )

        local skeleton =
            Skeleton.new(
                self.assets,
                x,
                z,
                {
                    hasShield =
                        index <=
                        shieldSkeletonCount,

                    dropsVisible =
                        self.level.
                        monsterDropsVisible
                }
            )

        self.enemies[
            #self.enemies + 1
        ] = skeleton
    end

    local wyvernCount =
        settings.wyvernCount

    if wyvernCount == nil then
        if self.level.biome == "forest" then
            wyvernCount = 2
        else
            wyvernCount = 0
        end
    end

    for _ = 1, wyvernCount do
        local x, z =
            self:getRandomWorldPosition(
                player,
                12 *
                Config.worldUnitsPerMeter
            )

        local wyvern =
            Wyvern.new(
                self.assets,
                x,
                z,
                {
                    rangedOnly =
                        settings.
                        wyvernRangedOnly
                }
            )

        self.enemies[
            #self.enemies + 1
        ] = wyvern
    end
end

function BiomeManager:hasClearPath(
    startX,
    startZ,
    targetX,
    targetZ,
    collisionRadius
)
    if not self.world.hasClearPath then
        return true
    end

    return self.world:hasClearPath(
        startX,
        startZ,
        targetX,
        targetZ,
        collisionRadius
    )
end

function BiomeManager:findPath(
    startX,
    startZ,
    targetX,
    targetZ,
    collisionRadius,
    options
)
    if not self.world.findPath then
        return nil
    end

    return self.world:findPath(
        startX,
        startZ,
        targetX,
        targetZ,
        collisionRadius,
        options
    )
end

-- Создаёт предметы уровня.
function BiomeManager:generatePickups(player)
    local settings =
        self.level.pickups or {}

    if settings.shield == false then
        return
    end

    if
        self.level.biome ~= "forest" and
        self.level.biome ~= "dungeon"
    then
        return
    end

    local x =
        settings.shieldX or
        player.x

    local z =
        settings.shieldZ or
        (
            player.z +
            8 *
            Config.worldUnitsPerMeter
        )

    self.pickups[
        #self.pickups + 1
    ] =
        ShieldPickup.new(
            self.assets,
            x,
            z
        )
end

-- Создаёт стрелу игрока.
function BiomeManager:spawnPlayerArrow(player)
    local arrow =
        Arrow.new(
            self.assets,
            player
        )

    self.playerArrows[
        #self.playerArrows + 1
    ] = arrow
end

-- Создаёт вражеский снаряд.
function BiomeManager:createEnemyProjectile(
    definition
)
    if not definition then
        return
    end

    if
        definition.type ~=
        "wyvern_fireball"
    then
        return
    end

    local projectile =
        WyvernFireball.new(
            self.assets,
            definition
        )

    self.enemyProjectiles[
        #self.enemyProjectiles + 1
    ] = projectile
end

-- Проверяет попадание стрелы во врага.
function BiomeManager:checkArrowHit(
    arrow,
    enemy
)
    if
        not arrow.active or
        not arrow:canDamage() or
        not enemy.active or
        enemy:isDead()
    then
        return false
    end

    local dx =
        arrow.x - enemy.x

    local dz =
        arrow.z - enemy.z

    local radius =
        (
            arrow.collisionRadius or
            10
        ) +
        (
            enemy.collisionRadius or
            22
        )

    if
        dx * dx + dz * dz >
        radius * radius
    then
        return false
    end

    local blocked =
        enemy:receiveAttackHit(
            arrow.damage or 1,
            "ranged"
        )

    arrow:hit(
        enemy.x,
        enemy.z,
        blocked
    )

    return true
end

-- Обновляет стрелы игрока.
function BiomeManager:updatePlayerArrows(dt)
    for index =
        #self.playerArrows,
        1,
        -1
    do
        local arrow =
            self.playerArrows[index]

        arrow:update(dt)

        if arrow:canDamage() then
            for _, enemy in ipairs(
                self.enemies
            ) do
                if self:checkArrowHit(
                    arrow,
                    enemy
                ) then
                    break
                end
            end
        end

        if not arrow.active then
            table.remove(
                self.playerArrows,
                index
            )
        end
    end
end

-- Обновляет вражеские снаряды.
function BiomeManager:updateEnemyProjectiles(
    dt,
    player
)
    for index =
        #self.enemyProjectiles,
        1,
        -1
    do
        local projectile =
            self.enemyProjectiles[index]

        projectile:update(dt)

        if
            projectile.canDamage and
            projectile:canDamage() and
            projectile.isHitPlayer and
            projectile:isHitPlayer(player)
        then
            player:takeDamage(
                projectile.damage or 1,
                projectile.sourceX,
                projectile.sourceZ
            )

            projectile:hit(
                player.x,
                player.z
            )
        end

        if not projectile.active then
            table.remove(
                self.enemyProjectiles,
                index
            )
        end
    end
end

-- Создаёт предметы, выпавшие из врага.
function BiomeManager:createEnemyDrops(enemy)
    if not enemy.takePendingDrops then
        return
    end

	local drops =
		enemy:takePendingDrops()

	if type(drops) ~= "table" then
		return
	end

    for _, drop in ipairs(drops) do
        if drop.type == "arrow_bundle" then
            self.pickups[
                #self.pickups + 1
            ] =
                ArrowBundle.new(
                    self.assets,
                    drop.x,
                    drop.z,
                    drop.amount,
                    {
                        visible =
                            drop.visible,

                        isMonsterDrop =
                            true
                    }
                )
        elseif
            drop.type ==
            "health_potion"
        then
            self.pickups[
                #self.pickups + 1
            ] =
                HealthPotion.new(
                    self.assets,
                    drop.x,
                    drop.z,
                    drop.amount,
                    {
                        visible =
                            drop.visible,

                        isMonsterDrop =
                            true
                    }
                )
        end
    end
end

-- Обновляет врагов и принимает их снаряды.
function BiomeManager:updateEnemies(
    dt,
    player
)
    for index =
        #self.enemies,
        1,
        -1
    do
        local enemy =
            self.enemies[index]

        -- Передаём менеджер как единый интерфейс мира.
		enemy:update(
			dt,
			player,
			self.camera:getZ(),
			self
		)

        if enemy.takePendingProjectile then
            local projectile =
                enemy:
                takePendingProjectile()

            if projectile then
                self:createEnemyProjectile(
                    projectile
                )
            end
        end

        self:createEnemyDrops(enemy)

			local removeEnemy =
				enemy.active == false

			if enemy.shouldRemove then
				removeEnemy =
					removeEnemy or
					enemy:shouldRemove(
						self.camera:getZ()
					)
			elseif enemy.shouldDespawn then
				removeEnemy =
					removeEnemy or
					enemy:shouldDespawn(
						self.camera:getZ()
					)
			end

			if removeEnemy then
				table.remove(
					self.enemies,
					index
				)
			end
    end
end

-- Обновляет предметы.
function BiomeManager:updatePickups(
    dt,
    player
)
    for index =
        #self.pickups,
        1,
        -1
    do
        local pickup =
            self.pickups[index]

        pickup:update(
            dt,
            player,
            self.camera:getZ()
        )

        if
            pickup.active == false or
            pickup.collected
        then
            table.remove(
                self.pickups,
                index
            )
        end
    end
end

-- Выполняет ближний удар игрока.
function BiomeManager:performPlayerMelee(
    player,
    attack
)
    local vector =
        PlayerData.directionVectors[
            player.facing
        ]

    local range =
        attack.range *
        Config.worldUnitsPerMeter

    local width =
        attack.width *
        Config.worldUnitsPerMeter

    for _, enemy in ipairs(
        self.enemies
    ) do
        if
            enemy.active and
            not enemy:isDead()
        then
            local dx =
                enemy.x - player.x

            local dz =
                enemy.z - player.z

            local forward =
                dx * vector.x +
                dz * vector.y

            local side =
                math.abs(
                    dx * -vector.y +
                    dz * vector.x
                )

            if
                forward >= 0 and
                forward <= range and
                side <= width
            then
                enemy:receiveAttackHit(
                    attack.damage,
                    "melee"
                )
            end
        end
    end
end

-- Выполняет ударную волну появления.
function BiomeManager:performSpawnShockwave(
    player,
    spawnData
)
    local radius =
        spawnData.radius *
        Config.worldUnitsPerMeter

    for _, enemy in ipairs(self.enemies) do
        if
            enemy.active and
            not enemy:isDead()
        then
            local dx =
                enemy.x - player.x

            local dz =
                enemy.z - player.z

            if
                dx * dx + dz * dz <=
                radius * radius
            then
                if enemy.applySpawnShockwave then
                    enemy:applySpawnShockwave(
                        player,
                        spawnData,
                        self
                    )

                elseif enemy.applyShockwave then
                    enemy:applyShockwave(
                        player.x,
                        player.z,
                        spawnData.force,
                        spawnData.damage
                    )
                end
            end
        end
    end
end

-- Возвращает общий список снарядов.
function BiomeManager:getRenderProjectiles()
    local projectiles = {}

    for _, arrow in ipairs(
        self.playerArrows
    ) do
        projectiles[
            #projectiles + 1
        ] = arrow
    end

    for _, projectile in ipairs(
        self.enemyProjectiles
    ) do
        projectiles[
            #projectiles + 1
        ] = projectile
    end

    return projectiles
end

-- Переходит по назначению портала.
function BiomeManager:activateDestination(
    destination,
    player
)
    local level =
        self.loader:
        loadDestination(
            destination
        )

    if not level then
        self.completed = true
        return
    end

    self.transition:start(
        level,

        function()
            self:activateLevel(
                level,
                player
            )
        end
    )
end

-- Переходит к следующему уровню.
function BiomeManager:beginNextLevel(player)
    self:activateDestination(
        {
            type = "next"
        },
        player
    )
end

-- Проверяет активацию портала.
function BiomeManager:checkPortal(player)
    if
        not self.world.getExitDestination or
        not self.world.isLevelComplete
    then
        return false
    end

    if
        player.state ~= "grounded" or
        not self.world:isLevelComplete(player)
    then
        return false
    end

    local destination =
        self.world:getExitDestination()

    if not destination then
        return false
    end

    self:activateDestination(
        destination,
        player
    )

    return true
end

-- Обновляет мир и игровые сущности.
function BiomeManager:update(
    dt,
    player
)

		if
			not self.world.takePortalDestination and
			self.world.isLevelComplete and
			player.state == "grounded" and
			self.world:isLevelComplete(player)
		then
			self:beginNextLevel(player)
		end

    self.background:update(dt)

	if self.world and player then
		local minimumZ =
			self.world.minZ or 0

		local maximumZ =
			self.world.maxZ or
			minimumZ + 1

		local levelLength =
			math.max(
				1,
				maximumZ - minimumZ
			)

		self.background:setProgress(
			(player.z - minimumZ) /
			levelLength
		)
	end

    if self.transition:isActive() then
        self.transition:update(dt)
        return
    end

    if self.completed then
        return
    end

    self.camera:update(
        dt,
        player
    )

    self:applyCamera()

	self.world:update(
		dt,
		player,
		self.enemies
	)

    self:updatePlayerArrows(dt)

    self:updateEnemyProjectiles(
        dt,
        player
    )

    self:updateEnemies(
        dt,
        player
    )

    self:updatePickups(
        dt,
        player
    )

    if self:checkPortal(player) then
        return
    end

    -- Поддержка старых уровней без портала.
	if
		not self.world.getExitDestination and
		player.state == "grounded" and
		self.world:isLevelComplete(
			player
		)
	then
		self:beginNextLevel(player)
	end
end

-- Рисует фон уровня.
function BiomeManager:drawBackground()
    self.background:draw(
        self.camera:getX()
    )
end

-- Рисует активный мир.
function BiomeManager:draw(player)
    if not self.world then
        return
    end

    self.world:draw(
        player,
        self:getRenderProjectiles(),
        self.enemies,
        self.pickups
    )
end

-- Рисует переход.
function BiomeManager:drawTransition()
    self.transition:draw()
end

-- Проверяет блокировку управления.
function BiomeManager:isInputLocked()
    return
        self.completed or
        self.transition:isActive() or
        (
            self.world and
            self.world.blocksPlayerInput and
            self.world:blocksPlayerInput()
        )
end

-- Возвращает горизонтальную позицию камеры.
function BiomeManager:getCameraX()
    return self.camera:getX()
end

-- Возвращает глубину камеры.
function BiomeManager:getCameraZ()
    return self.camera:getZ()
end

-- Проверяет безопасность позиции.
function BiomeManager:isSafePosition(
    x,
    z,
    collisionRadius
)
    return self.world:isSafePosition(
        x,
        z,
        collisionRadius
    )
end

-- Рассчитывает цель прыжка.
function BiomeManager:getJumpTarget(
    player,
    jumpType,
    direction
)
    return self.world:getJumpTarget(
        player,
        jumpType,
        direction
    )
end

-- Возвращает правила прыжков.
function BiomeManager:usesForwardOnlyJumps()
    return
        self.world:
        usesForwardOnlyJumps()
end

-- Проверяет возможность ходьбы.
function BiomeManager:allowsWalking()
    return
        self.world:
        allowsWalking()
end

-- Ограничивает позицию размерами мира.
function BiomeManager:clampPosition(x, z)
    if self.world.clampPosition then
        return self.world:clampPosition(
            x,
            z
        )
    end

    return x, z
end

-- Разрешает движение с учётом препятствий.
function BiomeManager:resolveMovement(
    currentX,
    currentZ,
    candidateX,
    candidateZ,
    collisionRadius
)
    if self.world.resolveMovement then
        return self.world:resolveMovement(
            currentX,
            currentZ,
            candidateX,
            candidateZ,
            collisionRadius
        )
    end

    return candidateX, candidateZ
end

-- Подготавливает точку возрождения.
function BiomeManager:prepareRespawn(
    x,
    z,
    collisionRadius
)
    if self.world.prepareRespawn then
        self.world:prepareRespawn(
            x,
            z,
            collisionRadius
        )
    end
end

-- Возвращает название уровня.
function BiomeManager:getLevelName()
    return
        self.level and
        self.level.name or
        ""
end

-- Возвращает идентификатор биома.
function BiomeManager:getBiomeId()
    return
        self.level and
        self.level.biome or
        ""
end

-- Возвращает номер уровня.
function BiomeManager:getLevelNumber()
    return self.loader:getIndex()
end

function BiomeManager:getControlProfile()
    return
        self.level and
        self.level.controls or
        nil
end

function BiomeManager:getControlHint()
    local controls =
        self:getControlProfile()

    return
        controls and
        controls.hint or
        nil
end

function BiomeManager:getLevelId()
    return
        self.level and
        self.level.id or
        nil
end

function BiomeManager:isScene()
    return
        self.world and
        self.world.isScene and
        self.world:isScene() or
        false
end

function BiomeManager:keypressed(key)
    if
        self.world and
        self.world.keypressed
    then
        return
            self.world:keypressed(key)
    end

    return false
end

-- Проверяет завершение кампании.
function BiomeManager:isCompleted()
    return self.completed
end

return BiomeManager