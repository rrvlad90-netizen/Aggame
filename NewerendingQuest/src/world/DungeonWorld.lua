local DungeonTraps = require("src.world.DungeonTraps")
local DungeonEncounters = require("src.world.DungeonEncounters")
local Pathfinder = require("src.world.Pathfinder")
local DungeonRooms = require("src.world.DungeonRooms")
local Config = require("src.config")
local Dungeon = require("data.biomes.dungeon")
local PlayerData = require("data.entities.player")

local Ground = require("src.rendering.Ground")
local ArrowBundle = require("src.items.ArrowBundle")

local DungeonWorld = {}
DungeonWorld.__index = DungeonWorld

-- Создаёт открытое подземелье.
function DungeonWorld.new(
    projection,
    assets,
    level
)
    local self =
        setmetatable(
            {},
            DungeonWorld
        )

    self.projection = projection
    self.assets = assets
    self.level = level
    self.biome = Dungeon

    self.cameraX = 0
    self.cameraZ = 0

	self.lightingTime = 0

	self.lighting =
		level.lighting or {}

	self.lightingEnabled =
		self.lighting.enabled ~= false

	self.lightCanvas = nil

	if self.lightingEnabled then
		self.lightCanvas =
			love.graphics.newCanvas(
				Config.virtualWidth,
				Config.virtualHeight
			)

		self.lightCanvas:setFilter(
			"linear",
			"linear"
		)
	end

    self.random =
        love.math.newRandomGenerator(
            level.seed or 3001
        )

    local size =
        level.size or {
            width = 70,
            length = 160
        }

    self.width =
        size.width *
        Config.worldUnitsPerMeter

    self.length =
        size.length *
        Config.worldUnitsPerMeter

    self.minX = -self.width / 2
    self.maxX = self.width / 2

    self.minZ = 0
    self.maxZ = self.length

    local generator =
        level.generator or {}

    self.objectCount =
        generator.objectCount or 240

    self.columnChance =
        generator.columnChance or 0.28

    self.rockChance =
        generator.rockChance or 0.48

    self.mushroomChance =
        generator.mushroomChance or 0.24

    self.arrowBundleCount =
        generator.arrowBundleCount or 7

    self.decorationWidth =
        (
            generator.decorationWidth or
            size.width
        ) *
        Config.worldUnitsPerMeter

    self.safeCorridorHalfWidth =
        (
            generator.safeCorridorWidth or 8
        ) *
        Config.worldUnitsPerMeter /
        2

    self.startSafeRadius =
        (
            generator.startSafeRadius or 8
        ) *
        Config.worldUnitsPerMeter

    self.finishSafeRadius =
        (
            generator.finishSafeRadius or 8
        ) *
        Config.worldUnitsPerMeter

    self.visuals = {
        column =
            self:resolveVisual("column"),

        rock =
            self:resolveVisual("rock"),

        mushroom =
            self:resolveVisual("mushroom")
    }
	
	self.objects = {}
	self.arrowBundles = {}

	self.layout =
		DungeonRooms.new(
			self.assets,
			self.level,
			self.minX,
			self.maxX,
			self.minZ,
			self.maxZ,
			level.seed or 3001
		)

	for _, wall in ipairs(
		self.layout:getWalls()
	) do
		self.objects[#self.objects + 1] = wall
	end
	
	self.encounters =
    DungeonEncounters.new(
        self.assets,
        self.level,
        self.layout,
        self.minZ,
        self.maxZ
    )

	for _, door in ipairs(
		self.encounters:getDoors()
	) do
		self.objects[
			#self.objects + 1
		] = door
	end
	
	self.traps =
    DungeonTraps.new(
        self.assets,
        self.level,
        self.layout,
        self.minX,
        self.maxX,
        self.minZ,
        self.maxZ,
        level.seed or 3001
    )

	for _, trap in ipairs(
		self.traps:getTraps()
	) do
		self.objects[
			#self.objects + 1
		] = trap
	end

    self.ground =
        Ground.new(
            projection,
            assets,
            Dungeon
        )

    self:generateObjects()
    self:generateArrowBundles()

    return self
end

-- Объединяет настройки объекта.
function DungeonWorld:resolveVisual(
    objectType
)
    local defaults =
        Dungeon.visuals[
            objectType
        ] or {}

    local override =
        (self.level.visuals or {})[
            objectType
        ] or {}

    local defaultOffset =
        defaults.offset or {}

    local overrideOffset =
        override.offset or {}

    return {
        spriteHeight =
            override.spriteHeight or
            defaults.spriteHeight or
            64,

        scale =
            override.scale or
            defaults.scale or
            1,

        alpha =
            override.alpha or
            defaults.alpha or
            1,

        collisionRadius =
            override.collisionRadius or
            defaults.collisionRadius or
            0,

        offset = {
            x =
                overrideOffset.x or
                defaultOffset.x or
                0,

            y =
                overrideOffset.y or
                defaultOffset.y or
                0
        }
    }
end

-- Возвращает группу изображений.
function DungeonWorld:getObjectGroup(
    objectType
)
    if objectType == "column" then
        return Dungeon.columnGroup
    elseif objectType == "rock" then
        return Dungeon.rockGroup
    end

    return Dungeon.mushroomGroup
end

-- Выбирает вариант изображения.
function DungeonWorld:chooseVariant(
    groupName
)
    local count =
        self.assets:getVariantCount(
            groupName
        )

    if count <= 0 then
        return 1
    end

    return self.random:random(
        1,
        count
    )
end

-- Выбирает тип объекта.
function DungeonWorld:chooseObjectType()
    local total =
        self.columnChance +
        self.rockChance +
        self.mushroomChance

    local value =
        self.random:random() *
        total

    if value < self.mushroomChance then
        return "mushroom"
    end

    value =
        value -
        self.mushroomChance

    if value < self.columnChance then
        return "column"
    end

    return "rock"
end

-- Возвращает размер объекта.
function DungeonWorld:getRandomSize(
    objectType
)
    if objectType == "column" then
        return
            0.9 +
            self.random:random() *
            0.25
    elseif objectType == "rock" then
        return
            0.75 +
            self.random:random() *
            0.5
    end

    return
        0.65 +
        self.random:random() *
        0.45
end

-- Генерирует объекты подземелья.
function DungeonWorld:generateObjects()
    local halfDecorationWidth =
        self.decorationWidth / 2

    for _ = 1, self.objectCount do
        local objectType =
            self:chooseObjectType()

        local x =
            (
                self.random:random() *
                2 - 1
            ) *
            halfDecorationWidth

        local z =
            self.random:random() *
            self.length

        local size =
            self:getRandomSize(
                objectType
            )

        local visual =
            self.visuals[
                objectType
            ]

        local insidePlayableArea =
            x >= self.minX and
            x <= self.maxX

        local outsideSafeCorridor =
            math.abs(x) >
            self.safeCorridorHalfWidth

        local outsideStart =
            x * x + z * z >
            self.startSafeRadius *
            self.startSafeRadius

        local finishDistance =
            self.maxZ - z

        local outsideFinish =
            x * x +
            finishDistance *
            finishDistance >
            self.finishSafeRadius *
            self.finishSafeRadius

        local collidable =
            objectType ~= "mushroom" and
            insidePlayableArea and
            outsideSafeCorridor and
            outsideStart and
            outsideFinish

        local collisionRadius =
            (
                visual.collisionRadius or 0
            ) *
            Config.worldUnitsPerMeter *
            size *
            (visual.scale or 1)

		local reserved =
			self.layout:isReserved(
				x,
				z,
				collisionRadius
			) or
			self.traps:isReserved(
				x,
				z,
				collisionRadius
			)

        if not reserved then
            local groupName =
                self:getObjectGroup(
                    objectType
                )

            self.objects[
                #self.objects + 1
            ] = {
                type = objectType,

                imageGroup =
                    groupName,

                variant =
                    self:chooseVariant(
                        groupName
                    ),

                x = x,
                z = z,

                size = size,
                visual = visual,

                collidable =
                    collidable,

                collisionRadius =
                    collisionRadius
            }
        end
    end
end

-- Генерирует связки стрел.
function DungeonWorld:generateArrowBundles()
    local margin =
        4 *
        Config.worldUnitsPerMeter

    local usableWidth =
        math.max(
            1,
            self.width -
            margin * 2
        )

    local usableLength =
        math.max(
            1,
            self.length -
            margin * 2
        )

    for _ = 1,
        self.arrowBundleCount
    do
        local placed = false

        for _ = 1, 40 do
            local x =
                self.minX +
                margin +
                self.random:random() *
                usableWidth

            local z =
                margin +
                self.random:random() *
                usableLength

            if not self:collidesWithObjects(
                x,
                z,
                20,
                false
            ) then
                self:addArrowBundle(
                    x,
                    z
                )

                placed = true
                break
            end
        end

        if not placed then
            break
        end
    end
end

-- Добавляет связку стрел.
function DungeonWorld:addArrowBundle(
    x,
    z,
    amount
)
    self.arrowBundles[
        #self.arrowBundles + 1
    ] = ArrowBundle.new(
        self.assets,
        x,
        z,
        amount
    )
end

-- Обновляет связки стрел.
function DungeonWorld:updateArrowBundles(
    dt,
    player
)
    for _, bundle in ipairs(
        self.arrowBundles
    ) do
        bundle:update(dt, player)
    end
end

-- Принимает положение камеры.
function DungeonWorld:setCameraPosition(
    x,
    z
)
    self.cameraX = x
    self.cameraZ = z
end

-- Возвращает границы камеры.
function DungeonWorld:getCameraBounds()
    return {
        minX = self.minX,
        maxX = self.maxX
    }
end

-- Возвращает точку появления.
function DungeonWorld:getSpawnPosition()
    return 0, 0
end

-- Ограничивает позицию уровнем.
function DungeonWorld:clampPosition(
    x,
    z
)
    return
        math.max(
            self.minX,
            math.min(self.maxX, x)
        ),
        math.max(
            self.minZ,
            math.min(self.maxZ, z)
        )
end

function DungeonWorld:collidesAt(
    x,
    z,
    collisionRadius
)
    return self:collidesWithObjects(
        x,
        z,
        collisionRadius,
        false
    )
end

function DungeonWorld:hasClearPath(
    startX,
    startZ,
    targetX,
    targetZ,
    collisionRadius
)
    local dx = targetX - startX
    local dz = targetZ - startZ

    local distance =
        math.sqrt(dx * dx + dz * dz)

    if distance <= 0.001 then
        return true
    end

    local step =
        Config.worldUnitsPerMeter

    local steps =
        math.max(
            1,
            math.ceil(distance / step)
        )

    for index = 1, steps do
        local progress =
            index / steps

        local x =
            startX + dx * progress

        local z =
            startZ + dz * progress

        if self:collidesAt(
            x,
            z,
            collisionRadius
        ) then
            return false
        end
    end

    return true
end

function DungeonWorld:findPath(
    startX,
    startZ,
    targetX,
    targetZ,
    collisionRadius,
    options
)
    return Pathfinder.find(
        self,
        startX,
        startZ,
        targetX,
        targetZ,
        collisionRadius,
        options
    )
end

-- Проверяет столкновение.
function DungeonWorld:collidesWithObjects(
    x,
    z,
    playerRadius,
    columnsOnly
)
    for _, object in ipairs(
        self.objects
    ) do
        if
            object.type ==
            "dungeon_door"
        then
            if
                self.encounters:isDoorBlocked(
                    object,
                    x,
                    z,
                    playerRadius
                )
            then
                return true
            end
        else
            local shouldCheck =
                object.collidable and
                (
                    not columnsOnly or
                    object.type == "column" or
                    object.type ==
                    "dungeon_wall"
                )

            if shouldCheck then
                local dx =
                    x - object.x

                local dz =
                    z - object.z

                local radius =
                    playerRadius +
                    object.collisionRadius

                if
                    dx * dx + dz * dz <
                    radius * radius
                then
                    return true
                end
            end
        end
    end

    return false
end

-- Разрешает движение вдоль препятствий.
function DungeonWorld:resolveMovement(
    currentX,
    currentZ,
    candidateX,
    candidateZ,
    playerRadius
)
    candidateX, candidateZ =
        self:clampPosition(
            candidateX,
            candidateZ
        )

    if not self:collidesWithObjects(
        candidateX,
        candidateZ,
        playerRadius,
        false
    ) then
        return candidateX, candidateZ
    end

    local resolvedX = currentX
    local resolvedZ = currentZ

    if not self:collidesWithObjects(
        candidateX,
        currentZ,
        playerRadius,
        false
    ) then
        resolvedX = candidateX
    end

    if not self:collidesWithObjects(
        resolvedX,
        candidateZ,
        playerRadius,
        false
    ) then
        resolvedZ = candidateZ
    end

    return resolvedX, resolvedZ
end

-- В подземелье разрешена ходьба.
function DungeonWorld:allowsWalking()
    return true
end

-- Прыжки зависят от направления.
function DungeonWorld:usesForwardOnlyJumps()
    return false
end

-- Рассчитывает прыжок через камни.
function DungeonWorld:getJumpTarget(
    player,
    jumpType,
    direction
)
    local jump =
        PlayerData.jumps[
            jumpType
        ]

    local vector =
        PlayerData.directionVectors[
            player.facing
        ]

    local targetX =
        player.x +
        vector.x *
        jump.forward

    local targetZ =
        player.z +
        vector.y *
        jump.forward

    targetX, targetZ =
        self:clampPosition(
            targetX,
            targetZ
        )

    if self:collidesWithObjects(
        targetX,
        targetZ,
        player.collisionRadius,
        false
    ) then
        return player.x, player.z
    end

    local steps = 24
    local lastX = player.x
    local lastZ = player.z

    for step = 1, steps do
        local progress =
            step / steps

        local sampleX =
            player.x +
            (
                targetX -
                player.x
            ) *
            progress

        local sampleZ =
            player.z +
            (
                targetZ -
                player.z
            ) *
            progress

        if self:collidesWithObjects(
            sampleX,
            sampleZ,
            player.collisionRadius,
            true
        ) then
            return lastX, lastZ
        end

        lastX = sampleX
        lastZ = sampleZ
    end

    return targetX, targetZ
end

-- Поверхность безопасна.
function DungeonWorld:isSafePosition(
    x,
    z,
    collisionRadius
)
    collisionRadius =
        collisionRadius or 0

    return
        not self:collidesAt(
            x,
            z,
            collisionRadius
        ) and
        not self.traps:isReserved(
            x,
            z,
            collisionRadius
        )
end

-- Не требует подготовки возрождения.
function DungeonWorld:prepareRespawn(
    x,
    z,
    collisionRadius
)
end

-- Обновляет подземелье.
function DungeonWorld:update(
    dt,
    player,
    enemies
)
    self.lightingTime =
        self.lightingTime + dt

    self:updateArrowBundles(
        dt,
        player
    )

    self.traps:update(
        dt,
        player
    )

    self.encounters:update(
        dt,
        player,
        enemies
    )
end

function DungeonWorld:drawDoorObject(
    door
)
    local x, y, perspectiveScale =
        self.projection:project(
            door.x,
            door.z,
            self.cameraX,
            self.cameraZ
        )

    local alpha =
        self.projection:getVisibilityAlpha(
            door.z,
            self.cameraZ
        )

    local image

    if door.locked then
        image = door.closedImage
    else
        image = door.openImage
    end

    if image then
        local scale =
            perspectiveScale *
            door.height /
            image:getHeight()

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
            scale,
            scale,
            image:getWidth() / 2,
            image:getHeight()
        )

        love.graphics.setColor(1, 1, 1, 1)
        return
    end

    local leftX =
        self.projection:project(
            door.x - door.width / 2,
            door.z,
            self.cameraX,
            self.cameraZ
        )

    local rightX =
        self.projection:project(
            door.x + door.width / 2,
            door.z,
            self.cameraX,
            self.cameraZ
        )

    local height =
        door.height *
        perspectiveScale

    local color = door.color
    local dark = door.darkColor
    local metal = door.metalColor

    if door.locked then
        love.graphics.setColor(
            color[1],
            color[2],
            color[3],
            alpha * (color[4] or 1)
        )

        love.graphics.rectangle(
            "fill",
            leftX,
            y - height,
            rightX - leftX,
            height
        )

        love.graphics.setColor(
            dark[1],
            dark[2],
            dark[3],
            alpha * (dark[4] or 1)
        )

        local plankCount = 5

        for index = 1,
            plankCount - 1
        do
            local plankX =
                leftX +
                (
                    rightX - leftX
                ) *
                index /
                plankCount

            love.graphics.line(
                plankX,
                y,
                plankX,
                y - height
            )
        end

        love.graphics.setColor(
            metal[1],
            metal[2],
            metal[3],
            alpha * (metal[4] or 1)
        )

        love.graphics.rectangle(
            "fill",
            leftX,
            y - height * 0.58,
            rightX - leftX,
            math.max(
                2,
                8 * perspectiveScale
            )
        )
    else
        -- Открытая дверь отображается двумя
        -- створками у краёв прохода.
        local leafWidth =
            (rightX - leftX) * 0.14

        love.graphics.setColor(
            color[1],
            color[2],
            color[3],
            alpha * 0.8
        )

        love.graphics.rectangle(
            "fill",
            leftX,
            y - height,
            leafWidth,
            height
        )

        love.graphics.rectangle(
            "fill",
            rightX - leafWidth,
            y - height,
            leafWidth,
            height
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

-- Проверяет завершение уровня.
function DungeonWorld:isLevelComplete(
    player
)
    local finishDistance =
        2 *
        Config.worldUnitsPerMeter

    return
        player.z >=
        self.maxZ -
        finishDistance and
        self.encounters:
        isFinalRoomCleared()
end

-- Проверяет горизонтальную видимость.
function DungeonWorld:isObjectOnScreen(
    object
)
    local x, _, scale =
        self.projection:project(
            object.x,
            object.z,
            self.cameraX,
            self.cameraZ
        )

    local margin =
        220 *
        math.max(scale, 0.2)

    return
        x >= -margin and
        x <=
        Config.virtualWidth +
        margin
end

-- Собирает объекты, предметы, стрелы, врагов и игрока.
function DungeonWorld:collectVisibleObjects(
    player,
    projectiles,
    enemies,
    pickups
)
    local queue = {}

    for _, object in ipairs(
        self.objects
    ) do
        if
            self.projection:isDepthVisible(
                object.z,
                self.cameraZ
            ) and
            self:isObjectOnScreen(object)
        then
            queue[#queue + 1] =
                object
        end
    end

    for _, bundle in ipairs(
        self.arrowBundles
    ) do
        if
            bundle.active ~= false and
            bundle.visible ~= false and
            not bundle.collected and
            self.projection:isDepthVisible(
                bundle.z,
                self.cameraZ
            ) and
            self:isObjectOnScreen(bundle)
        then
            queue[#queue + 1] = {
                type = "arrow_bundle",
                x = bundle.x,
                z = bundle.z,
                reference = bundle
            }
        end
    end

    for _, arrow in ipairs(
        projectiles or {}
    ) do
        if
            arrow.active and
            self.projection:isDepthVisible(
                arrow.z,
                self.cameraZ
            ) and
            self:isObjectOnScreen(arrow)
        then
            queue[#queue + 1] = {
                type = "player_arrow",
                x = arrow.x,
                z = arrow.z,
                reference = arrow
            }
        end
    end

    for _, enemy in ipairs(
        enemies or {}
    ) do
        if
            enemy.active and
            self.projection:isDepthVisible(
                enemy.z,
                self.cameraZ
            ) and
            self:isObjectOnScreen(enemy)
        then
            queue[#queue + 1] = {
                type = "enemy",
                x = enemy.x,
                z = enemy.z,
                reference = enemy
            }
        end
    end

    for _, pickup in ipairs(
        pickups or {}
    ) do
        if
            pickup.active ~= false and
            pickup.visible ~= false and
            not pickup.collected and
            self.projection:isDepthVisible(
                pickup.z,
                self.cameraZ
            ) and
            self:isObjectOnScreen(pickup)
        then
            queue[#queue + 1] = {
                type = "pickup",
                x = pickup.x,
                z = pickup.z,
                reference = pickup
            }
        end
    end

    queue[#queue + 1] = {
        type = "player",
        x = player.x,
        z = player.z,
        reference = player
    }

    table.sort(
        queue,
        function(a, b)
            return a.z > b.z
        end
    )

    return queue
end

-- Добавляет мягкий круг света на карту освещения.
function DungeonWorld:drawRadialLight(
    x,
    y,
    radius,
    color,
    intensity
)
    if radius <= 0 or intensity <= 0 then
        return
    end

    color = color or {
        1,
        1,
        1
    }

    local steps = 28

    local stepAlpha =
        intensity / steps

    -- Круги накладываются друг на друга:
    -- в центре свет получается наиболее ярким.
    for index = steps, 1, -1 do
        local progress =
            index / steps

        local currentRadius =
            radius * progress

        love.graphics.setColor(
            color[1] or 1,
            color[2] or 1,
            color[3] or 1,
            stepAlpha
        )

        love.graphics.circle(
            "fill",
            x,
            y,
            currentRadius
        )
    end
end

-- Рисует свет вокруг игрока.
function DungeonWorld:drawPlayerLight(
    player
)
    local settings =
        self.lighting.player or {}

    if settings.enabled == false then
        return
    end

    local x, y, perspectiveScale =
        self.projection:project(
            player.x,
            player.z,
            self.cameraX,
            self.cameraZ
        )

    y =
        y -
        player.height *
        perspectiveScale

    y =
        y -
        (settings.offsetY or 48) *
        perspectiveScale

    local flicker =
        settings.flicker or 0

    local flickerValue =
        1 +
        math.sin(
            self.lightingTime * 8.3
        ) *
        flicker +
        math.sin(
            self.lightingTime * 13.7
        ) *
        flicker *
        0.45

    local radius =
        (settings.radius or 285) *
        flickerValue

    local intensity =
        settings.intensity or 0.74

    if
        player.state == "dying" or
        player.state == "dead"
    then
        intensity = intensity * 0.45
    end

    self:drawRadialLight(
        x,
        y,
        radius,
        settings.color or {
            1,
            0.88,
            0.68
        },
        intensity
    )
end

-- Рисует свечение грибов.
function DungeonWorld:drawMushroomLights()
    local settings =
        self.lighting.mushrooms or {}

    if settings.enabled == false then
        return
    end

    for _, object in ipairs(
        self.objects
    ) do
        if
            object.type == "mushroom" and
            self.projection:isDepthVisible(
                object.z,
                self.cameraZ
            ) and
            self:isObjectOnScreen(object)
        then
            local x, y, perspectiveScale =
                self.projection:project(
                    object.x,
                    object.z,
                    self.cameraX,
                    self.cameraZ
                )

            local flicker =
                settings.flicker or 0.08

            local phase =
                object.x * 0.013 +
                object.z * 0.007

            local flickerValue =
                1 +
                math.sin(
                    self.lightingTime * 4.5 +
                    phase
                ) *
                flicker

            local radius =
                (settings.radius or 115) *
                math.max(
                    0.2,
                    perspectiveScale
                ) *
                flickerValue

            y =
                y -
                (settings.offsetY or 12) *
                perspectiveScale

            self:drawRadialLight(
                x,
                y,
                radius,
                settings.color or {
                    0.28,
                    0.78,
                    0.5
                },
                settings.intensity or 0.4
            )
        end
    end
end

-- Накладывает карту освещения на мир.
function DungeonWorld:drawLighting(
    player
)
    if
        not self.lightingEnabled or
        not self.lightCanvas
    then
        return
    end

    local previousCanvas =
        love.graphics.getCanvas()

    love.graphics.setCanvas(
        self.lightCanvas
    )

    local ambient =
        self.lighting.ambient or {
            0.24,
            0.22,
            0.2
        }

    love.graphics.clear(
        ambient[1] or 0.24,
        ambient[2] or ambient[1] or 0.22,
        ambient[3] or ambient[1] or 0.2,
        1
    )

    love.graphics.setBlendMode(
        "add",
        "alphamultiply"
    )

    self:drawMushroomLights()
    self:drawPlayerLight(player)

    love.graphics.setBlendMode(
        "alpha",
        "alphamultiply"
    )

    love.graphics.setCanvas(
        previousCanvas
    )

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setBlendMode(
        "multiply",
        "premultiplied"
    )

    love.graphics.draw(
        self.lightCanvas,
        0,
        0
    )

    love.graphics.setBlendMode(
        "alpha",
        "alphamultiply"
    )

    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует подземелье.
function DungeonWorld:draw(
    player,
    projectiles,
    enemies,
    pickups
)
    self.ground:draw(
        self.cameraX,
        self.cameraZ
    )

    local queue =
        self:collectVisibleObjects(
            player,
            projectiles,
            enemies,
            pickups
        )

    for _, object in ipairs(queue) do
        if
            object.type == "player" or
            object.type == "arrow_bundle" or
            object.type == "player_arrow" or
            object.type == "enemy" or
            object.type == "pickup"
        then
            object.reference:draw(
                self.projection,
                self.cameraX,
                self.cameraZ
            )
        else
            self:drawWorldObject(
                object
            )
        end
    end
	
	self:drawLighting(player)
end

-- Рисует каменный блок стены.
function DungeonWorld:drawWallObject(object)
    local x, y, perspectiveScale =
        self.projection:project(
            object.x,
            object.z,
            self.cameraX,
            self.cameraZ
        )

    local alpha =
        self.projection:getVisibilityAlpha(
            object.z,
            self.cameraZ
        )

    if object.image then
        local image = object.image

        local scale =
            perspectiveScale *
            object.wallHeight /
            image:getHeight()

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
            scale,
            scale,
            image:getWidth() / 2,
            image:getHeight()
        )

        love.graphics.setColor(1, 1, 1, 1)
        return
    end

    local halfWidth =
        object.wallWidth / 2

    local leftX =
        self.projection:project(
            object.x - halfWidth,
            object.z,
            self.cameraX,
            self.cameraZ
        )

    local rightX =
        self.projection:project(
            object.x + halfWidth,
            object.z,
            self.cameraX,
            self.cameraZ
        )

    local height =
        object.wallHeight *
        perspectiveScale

    local color =
        object.wallColor

    love.graphics.setColor(
        color[1],
        color[2],
        color[3],
        alpha * (color[4] or 1)
    )

    love.graphics.polygon(
        "fill",

        leftX,
        y,

        rightX,
        y,

        rightX,
        y - height,

        leftX,
        y - height
    )

    local topColor =
        object.wallTopColor

    local topDepth =
        math.max(
            2,
            10 * perspectiveScale
        )

    love.graphics.setColor(
        topColor[1],
        topColor[2],
        topColor[3],
        alpha * (topColor[4] or 1)
    )

    love.graphics.polygon(
        "fill",

        leftX,
        y - height,

        rightX,
        y - height,

        rightX - topDepth,
        y - height - topDepth,

        leftX + topDepth,
        y - height - topDepth
    )

    local lineColor =
        object.wallLineColor

    love.graphics.setColor(
        lineColor[1],
        lineColor[2],
        lineColor[3],
        alpha * (lineColor[4] or 1)
    )

    love.graphics.setLineWidth(
        math.max(
            1,
            perspectiveScale * 2
        )
    )

    love.graphics.line(
        leftX,
        y - height * 0.5,
        rightX,
        y - height * 0.5
    )

    love.graphics.line(
        x,
        y,
        x,
        y - height * 0.5
    )

    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует напольную ловушку.
function DungeonWorld:drawSpikeTrap(trap)
    local x, y, perspectiveScale =
        self.projection:project(
            trap.x,
            trap.z,
            self.cameraX,
            self.cameraZ
        )

    local alpha =
        self.projection:getVisibilityAlpha(
            trap.z,
            self.cameraZ
        )

    local image

    if trap.state == "active" then
        image = trap.activeImage
    elseif trap.state == "warning" then
        image = trap.warningImage
    else
        image = trap.idleImage
    end

    if image then
        local desiredHeight =
            trap.spikeHeight +
            trap.visualRadius

        local scale =
            perspectiveScale *
            desiredHeight /
            image:getHeight()

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
            scale,
            scale,
            image:getWidth() / 2,
            image:getHeight()
        )

        love.graphics.setColor(1, 1, 1, 1)
        return
    end

    local radius =
        trap.visualRadius *
        perspectiveScale

    local plateHeight =
        math.max(
            3,
            radius * 0.3
        )

    local color =
        trap.idleColor

    if trap.state == "warning" then
        local flash =
            math.sin(
                trap.stateTime * 22
            ) > 0

        if flash then
            color = trap.warningColor
        end
    elseif trap.state == "active" then
        color = trap.darkColor
    end

    love.graphics.setColor(
        color[1],
        color[2],
        color[3],
        alpha * (color[4] or 1)
    )

    love.graphics.ellipse(
        "fill",
        x,
        y,
        radius,
        plateHeight
    )

    if trap.state == "active" then
        local spikeColor =
            trap.activeColor

        love.graphics.setColor(
            spikeColor[1],
            spikeColor[2],
            spikeColor[3],
            alpha *
            (spikeColor[4] or 1)
        )

        local spikeHeight =
            trap.spikeHeight *
            perspectiveScale

        local spikeCount = 5

        for index = 1, spikeCount do
            local progress =
                index /
                (spikeCount + 1)

            local spikeX =
                x - radius +
                radius * 2 * progress

            local halfWidth =
                math.max(
                    2,
                    radius * 0.1
                )

            love.graphics.polygon(
                "fill",

                spikeX - halfWidth,
                y,

                spikeX,
                y - spikeHeight,

                spikeX + halfWidth,
                y
            )
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует объект подземелья.
function DungeonWorld:drawWorldObject(
    object
)
    local x, y, perspectiveScale =
        self.projection:project(
            object.x,
            object.z,
            self.cameraX,
            self.cameraZ
        )

    local alpha =
        self.projection:
        getVisibilityAlpha(
            object.z,
            self.cameraZ
        )

    local image =
        self.assets:getVariant(
            object.imageGroup,
            object.variant
        )
		
		
	if object.type == "dungeon_spikes" then
		self:drawSpikeTrap(object)
		return
	end

	if object.type == "dungeon_door" then
		self:drawDoorObject(object)
		return
	end

	if object.type == "dungeon_wall" then
		self:drawWallObject(object)
		return
	end	
		
	if object.type == "dungeon_door" then
		self:drawDoorObject(object)
		return
	end

	if object.type == "dungeon_wall" then
		self:drawWallObject(object)
		return
	end	
		
	if object.type == "dungeon_wall" then
		self:drawWallObject(object)
		return
	end	

    if image then
        self:drawImageObject(
            image,
            object,
            x,
            y,
            perspectiveScale,
            alpha
        )
    else
        self:drawPlaceholder(
            object,
            x,
            y,
            perspectiveScale,
            alpha
        )
    end
end

-- Рисует PNG объекта.
function DungeonWorld:drawImageObject(
    image,
    object,
    x,
    y,
    perspectiveScale,
    alpha
)
    local visual =
        object.visual or {}

    local spriteScale =
        perspectiveScale *
        object.size *
        (visual.scale or 1) *
        (visual.spriteHeight or 64) /
        image:getHeight()

    local offset =
        visual.offset or {}

    love.graphics.setColor(
        1,
        1,
        1,
        alpha *
        (visual.alpha or 1)
    )

    love.graphics.draw(
        image,
        x +
        (offset.x or 0) *
        spriteScale,
        y +
        (offset.y or 0) *
        spriteScale,
        0,
        spriteScale,
        spriteScale,
        image:getWidth() / 2,
        image:getHeight()
    )

    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует объект без PNG.
function DungeonWorld:drawPlaceholder(
    object,
    x,
    y,
    perspectiveScale,
    alpha
)
    local scale =
        perspectiveScale *
        object.size

    if object.type == "column" then
        love.graphics.setColor(
            0.38,
            0.36,
            0.34,
            alpha
        )

        love.graphics.rectangle(
            "fill",
            x - 15 * scale,
            y - 150 * scale,
            30 * scale,
            150 * scale
        )
    elseif object.type == "rock" then
        love.graphics.setColor(
            0.3,
            0.29,
            0.28,
            alpha
        )

        love.graphics.ellipse(
            "fill",
            x,
            y - 20 * scale,
            34 * scale,
            22 * scale
        )
    else
        love.graphics.setColor(
            0.7,
            0.25,
            0.18,
            alpha
        )

        love.graphics.circle(
            "fill",
            x,
            y - 10 * scale,
            9 * scale
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return DungeonWorld