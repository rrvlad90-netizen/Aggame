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

-- Генерирует объекты.
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

        local groupName =
            self:getObjectGroup(
                objectType
            )

        self.objects[
            #self.objects + 1
        ] = {
            type = objectType,
            imageGroup = groupName,

            variant =
                self:chooseVariant(
                    groupName
                ),

            x = x,
            z = z,

            size = size,
            visual = visual,

            collidable = collidable,

            collisionRadius =
                (
                    visual.collisionRadius or
                    0
                ) *
                Config.worldUnitsPerMeter *
                size *
                (visual.scale or 1)
        }
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
        local shouldCheck =
            object.collidable and
            (
                not columnsOnly or
                object.type == "column"
            )

        if shouldCheck then
            local dx = x - object.x
            local dz = z - object.z

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
    return true
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
    player
)
    self:updateArrowBundles(
        dt,
        player
    )
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
        finishDistance
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