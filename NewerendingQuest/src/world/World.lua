local Pathfinder = require("src.world.Pathfinder")
local Config = require("src.config")
local Forest = require("data.biomes.forest")
local PlayerData = require("data.entities.player")

local Ground = require("src.rendering.Ground")
local ArrowBundle = require("src.items.ArrowBundle")
local Portal = require("src.entities.Portal")
local ForestRivers = require("src.world.ForestRivers")

local World = {}
World.__index = World

function World.new(projection, assets, level)
    local self = setmetatable({}, World)

    self.projection = projection
    self.assets = assets
    self.biome = Forest

    self.level = level or {
        id = "debug_forest",
        name = "Debug Forest",
        biome = "forest",
        seed = Config.world.seed,

        size = {
            width = 50,
            length = 80
        },

        generator = {}
    }

    local size =
        self.level.size or {
            width = 50,
            length = 80
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

    local rendering =
        self.level.rendering or {}

    self.renderDistance =
        (
            rendering.distance or
            34
        ) *
        Config.worldUnitsPerMeter

    self.renderBehindDistance =
        (
            rendering.behindDistance or
            8
        ) *
        Config.worldUnitsPerMeter

    self.decorationMaxZ =
        self.maxZ +
        Config.projection.visibleDepth

    self.seed =
        self.level.seed or
        Config.world.seed

    self.rivers =
        ForestRivers.new(
            self.projection,
            self.level,
            self.minX,
            self.maxX,
            self.minZ,
            self.maxZ,
            self.seed
        )

    self.chunkLength =
        Config.world.chunkLength

    local generator =
        self.level.generator or {}

    self.chunksAhead =
        generator.chunksAhead or
        Config.world.chunksAhead

    self.objectsPerChunk =
        generator.objectsPerChunk or
        Config.world.objectsPerChunk

    self.treeChance =
        generator.treeChance or 0.55

    self.bushChance =
        generator.bushChance or 0.32

    self.rockChance =
        generator.rockChance or 0.09

    self.mushroomChance =
        generator.mushroomChance or 0.04

    self.arrowBundleCount =
        generator.arrowBundleCount or 8

    self.decorationWidth =
        (
            generator.decorationWidth or
            size.width
        ) *
        Config.worldUnitsPerMeter

    self.safeCorridorHalfWidth =
        (
            generator.safeCorridorWidth or
            0
        ) *
        Config.worldUnitsPerMeter /
        2

    self.startSafeRadius =
        (
            generator.startSafeRadius or
            0
        ) *
        Config.worldUnitsPerMeter

    self.visuals = {
        tree =
            self:resolveVisual("tree"),

        bush =
            self:resolveVisual("bush"),

        rock =
            self:resolveVisual("rock"),

        mushroom =
            self:resolveVisual("mushroom")
    }

    self.chunks = {}
    self.arrowBundles = {}

    self.cameraX = 0
    self.cameraZ = 0

    self.ground =
        Ground.new(
            projection,
            assets,
            Forest
        )

    self:generateArrowBundles()
    self:ensureChunks(0)

    self.portal =
        self:createPortal()

    return self
end

function World:isWithinRenderDistance(
    z,
    margin
)
    margin = margin or 0

    return
        z + margin >=
        self.cameraZ -
        self.renderBehindDistance and

        z - margin <=
        self.cameraZ +
        self.renderDistance
end

function World:resolveVisual(objectType)
    local defaults =
        (
            Forest.visuals or {}
        )[objectType] or {}

    local override =
        (
            self.level.visuals or {}
        )[objectType] or {}

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

function World:getObjectGroup(objectType)
    if objectType == "tree" then
        return Forest.treeGroup

    elseif objectType == "bush" then
        return Forest.bushGroup

    elseif objectType == "rock" then
        return Forest.rockGroup
    end

    return Forest.mushroomGroup
end

function World:chooseObjectType(random)
    local total =
        self.treeChance +
        self.bushChance +
        self.rockChance +
        self.mushroomChance

    local value =
        random:random() *
        total

    if value < self.treeChance then
        return "tree"
    end

    value =
        value -
        self.treeChance

    if value < self.bushChance then
        return "bush"
    end

    value =
        value -
        self.bushChance

    if value < self.rockChance then
        return "rock"
    end

    return "mushroom"
end

function World:chooseVariant(
    random,
    groupName
)
    local count =
        self.assets:getVariantCount(
            groupName
        )

    if count <= 0 then
        return 1
    end

    return random:random(
        1,
        count
    )
end

function World:createPortal()
    local definition =
        self.level.exit

    if
        not definition or
        definition.type ~= "portal"
    then
        return nil
    end

    local x =
        (definition.x or 0) *
        Config.worldUnitsPerMeter

    local z =
        self.maxZ -
        (
            definition.distanceFromEnd or
            4
        ) *
        Config.worldUnitsPerMeter

    return Portal.new(
        self.assets,
        x,
        z,
        definition
    )
end

function World:generateArrowBundles()
    local random =
        love.math.newRandomGenerator(
            self.seed + 49057
        )

    local sideMargin =
        3 *
        Config.worldUnitsPerMeter

    local depthMargin =
        5 *
        Config.worldUnitsPerMeter

    local usableWidth =
        math.max(
            1,
            self.width -
            sideMargin * 2
        )

    local usableLength =
        math.max(
            1,
            self.length -
            depthMargin * 2
        )

    for _ = 1,
        self.arrowBundleCount
    do
        for _ = 1, 40 do
            local x =
                self.minX +
                sideMargin +
                random:random() *
                usableWidth

            local z =
                depthMargin +
                random:random() *
                usableLength

            if not self.rivers:isReserved(
                x,
                z,
                0
            ) then
                self:addArrowBundle(
                    x,
                    z
                )

                break
            end
        end
    end
end

function World:addArrowBundle(
    x,
    z,
    amount
)
    self.arrowBundles[
        #self.arrowBundles + 1
    ] =
        ArrowBundle.new(
            self.assets,
            x,
            z,
            amount
        )
end

function World:updateArrowBundles(
    dt,
    player
)
    for _, bundle in ipairs(
        self.arrowBundles
    ) do
        bundle:update(
            dt,
            player
        )
    end
end

function World:setCameraPosition(x, z)
    self.cameraX = x
    self.cameraZ = z
end

function World:getCameraBounds()
    return {
        minX = self.minX,
        maxX = self.maxX
    }
end

function World:clampPosition(x, z)
    return
        math.max(
            self.minX,
            math.min(
                self.maxX,
                x
            )
        ),

        math.max(
            self.minZ,
            math.min(
                self.maxZ,
                z
            )
        )
end

function World:hasClearPath(
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

    local sampleStep =
        Config.worldUnitsPerMeter

    local steps =
        math.max(
            1,
            math.ceil(
                distance / sampleStep
            )
        )

    for step = 1, steps do
        local progress =
            step / steps

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

-- Ищет путь вокруг деревьев, камней и рек.
function World:findPath(
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

function World:update(dt, player)
    self:ensureChunks(player.z)

    self:updateArrowBundles(
        dt,
        player
    )

    if self.portal then
        self.portal:update(
            dt,
            player
        )
    end
end

function World:ensureChunks(playerZ)
    local currentIndex =
        math.floor(
            playerZ /
            self.chunkLength
        )

    local firstIndex =
        math.max(
            0,
            currentIndex - 1
        )

    local maximumIndex =
        math.max(
            0,
            math.ceil(
                self.decorationMaxZ /
                self.chunkLength
            ) - 1
        )

    local lastIndex =
        math.min(
            maximumIndex,
            currentIndex +
            self.chunksAhead
        )

    for index = firstIndex,
        lastIndex
    do
        if not self.chunks[index] then
            self.chunks[index] =
                self:generateChunk(
                    index
                )
        end
    end

    for index in pairs(
        self.chunks
    ) do
        if
            index < firstIndex or
            index > lastIndex
        then
            self.chunks[index] = nil
        end
    end
end

function World:generateChunk(index)
    local random =
        love.math.newRandomGenerator(
            self.seed +
            index * 7919
        )

    local objects = {}

    local startZ =
        index *
        self.chunkLength

    local endZ =
        math.min(
            startZ +
            self.chunkLength,
            self.decorationMaxZ
        )

    local chunkDepth =
        math.max(
            0,
            endZ - startZ
        )

    local decorationHalfWidth =
        self.decorationWidth / 2

    for _ = 1,
        self.objectsPerChunk
    do
        local x =
            (
                random:random() *
                2 - 1
            ) *
            decorationHalfWidth

        local z =
            startZ +
            random:random() *
            chunkDepth

        local objectType

        if z > self.maxZ then
            objectType = "tree"
        else
            objectType =
                self:chooseObjectType(
                    random
                )
        end

        local groupName =
            self:getObjectGroup(
                objectType
            )

        local size =
            0.75 +
            random:random() *
            0.5

        local visual =
            self.visuals[
                objectType
            ]

        local insidePlayableArea =
            x >= self.minX and
            x <= self.maxX and
            z >= self.minZ and
            z <= self.maxZ

        local outsideSafeCorridor =
            math.abs(x) >
            self.safeCorridorHalfWidth

        local outsideStartArea =
            x * x + z * z >
            self.startSafeRadius *
            self.startSafeRadius

        local collidable =
            (
                objectType == "tree" or
                objectType == "rock"
            ) and
            insidePlayableArea and
            outsideSafeCorridor and
            outsideStartArea

        local collisionRadius =
            (
                visual.collisionRadius or
                0
            ) *
            Config.worldUnitsPerMeter *
            size *
            (visual.scale or 1)

        local reservedByRiver =
            self.rivers:isReserved(
                x,
                z,
                collisionRadius
            )

        if not reservedByRiver then
            objects[#objects + 1] = {
                type = objectType,

                imageGroup =
                    groupName,

                variant =
                    self:chooseVariant(
                        random,
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

    return objects
end

function World:collidesWithObjects(
    x,
    z,
    playerRadius,
    treesOnly
)
    for _, chunk in pairs(
        self.chunks
    ) do
        for _, object in ipairs(
            chunk
        ) do
            local shouldCheck =
                object.collidable and
                (
                    not treesOnly or
                    object.type == "tree"
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
                    dx * dx +
                    dz * dz <
                    radius * radius
                then
                    return true
                end
            end
        end
    end

    return false
end

function World:collidesAt(
    x,
    z,
    collisionRadius
)
    if self.rivers:isBlocked(
        x,
        z,
        collisionRadius
    ) then
        return true
    end

    return self:collidesWithObjects(
        x,
        z,
        collisionRadius,
        false
    )
end

function World:resolveMovement(
    currentX,
    currentZ,
    candidateX,
    candidateZ,
    playerRadius
)
    if not self:collidesAt(
        candidateX,
        candidateZ,
        playerRadius
    ) then
        return candidateX, candidateZ
    end

    local resolvedX = currentX
    local resolvedZ = currentZ

    if not self:collidesAt(
        candidateX,
        currentZ,
        playerRadius
    ) then
        resolvedX = candidateX
    end

    if not self:collidesAt(
        resolvedX,
        candidateZ,
        playerRadius
    ) then
        resolvedZ = candidateZ
    end

    return resolvedX, resolvedZ
end

function World:usesForwardOnlyJumps()
    return false
end

function World:getJumpTarget(
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

    if
        self:collidesAt(
            targetX,
            targetZ,
            player.collisionRadius
        )
    then
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

        if self.rivers:isBlocked(
            sampleX,
            sampleZ,
            player.collisionRadius
        ) then
            return lastX, lastZ
        end

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

function World:isSafePosition(
    x,
    z,
    collisionRadius
)
    return
        not self.rivers:isBlocked(
            x,
            z,
            collisionRadius
        )
end

function World:isLevelComplete(player)
    return
        self.portal and
        self.portal:isActivated() or
        false
end

function World:getExitDestination()
    if not self.portal then
        return nil
    end

    return
        self.portal:
        getDestination()
end

function World:isObjectOnScreen(object)
    if not self:isWithinRenderDistance(
        object.z,
        object.renderMargin or 0
    ) then
        return false
    end

    local x, _, scale =
        self.projection:project(
            object.x,
            object.z,
            self.cameraX,
            self.cameraZ
        )

    local margin =
        200 *
        math.max(
            scale,
            0.2
        )

    return
        x >= -margin and
        x <=
        Config.virtualWidth +
        margin
end

function World:collectVisibleObjects(
    player,
    projectiles,
    enemies,
    pickups
)
    local queue = {}

    for _, chunk in pairs(
        self.chunks
    ) do
        for _, object in ipairs(
            chunk
        ) do
            if
                self.projection:
                isDepthVisible(
                    object.z,
                    self.cameraZ
                ) and
                self:isObjectOnScreen(
                    object
                )
            then
                queue[#queue + 1] =
                    object
            end
        end
    end

    for _, bundle in ipairs(
        self.arrowBundles
    ) do
        if
            bundle.active ~= false and
            bundle.visible ~= false and
            not bundle.collected and
            self.projection:
            isDepthVisible(
                bundle.z,
                self.cameraZ
            ) and
            self:isObjectOnScreen(
                bundle
            )
        then
            queue[#queue + 1] = {
                type = "arrow_bundle",
                x = bundle.x,
                z = bundle.z,
                reference = bundle
            }
        end
    end

    for _, projectile in ipairs(
        projectiles or {}
    ) do
        if
            projectile.active and
            self.projection:
            isDepthVisible(
                projectile.z,
                self.cameraZ
            ) and
            self:isObjectOnScreen(
                projectile
            )
        then
            queue[#queue + 1] = {
                type = "projectile",
                x = projectile.x,
                z = projectile.z,
                reference = projectile
            }
        end
    end

    for _, enemy in ipairs(
        enemies or {}
    ) do
        if
            enemy.active and
            self.projection:
            isDepthVisible(
                enemy.z,
                self.cameraZ
            ) and
            self:isObjectOnScreen(
                enemy
            )
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
            self.projection:
            isDepthVisible(
                pickup.z,
                self.cameraZ
            ) and
            self:isObjectOnScreen(
                pickup
            )
        then
            queue[#queue + 1] = {
                type = "pickup",
                x = pickup.x,
                z = pickup.z,
                reference = pickup
            }
        end
    end

    if
        self.portal and
        self.projection:
        isDepthVisible(
            self.portal.z,
            self.cameraZ
        ) and
        self:isObjectOnScreen(
            self.portal
        )
    then
        queue[#queue + 1] = {
            type = "portal",
            x = self.portal.x,
            z = self.portal.z + 0.1,
            reference = self.portal
        }
    end

    queue[#queue + 1] = {
        type = "player",
        x = player.x,
        z = player.z,
        reference = player
    }

    self.rivers:addRailingsToQueue(
        queue,
        self.cameraZ
    )

    table.sort(
        queue,
        function(first, second)
            return
                first.z >
                second.z
        end
    )

    return queue
end

function World:allowsWalking()
    return true
end

function World:prepareRespawn(
    x,
    z,
    collisionRadius
)
end

function World:draw(
    player,
    projectiles,
    enemies,
    pickups
)
    self.ground:draw(
        self.cameraX,
        self.cameraZ
    )

    self.rivers:drawSurface(
        self.cameraX,
        self.cameraZ
    )

    if Config.debug.showDepthLines then
        self:drawDepthLines()
    end

    local queue =
        self:collectVisibleObjects(
            player,
            projectiles,
            enemies,
            pickups
        )

    for _, object in ipairs(
        queue
    ) do
        if
            object.type ==
            "river_railing"
        then
            self.rivers:
            drawRailingSegment(
                object,
                self.cameraX,
                self.cameraZ
            )

        elseif
            object.type == "player" or
            object.type == "arrow_bundle" or
            object.type == "projectile" or
            object.type == "enemy" or
            object.type == "pickup" or
            object.type == "portal"
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

function World:drawDepthLines()
    local step =
        Config.projection.depthLineSize

    local firstLine =
        math.floor(
            self.cameraZ /
            step
        ) * step

    love.graphics.setColor(
        1,
        1,
        1,
        0.12
    )

    local lastLine =
        math.min(
            self.cameraZ +
            self.renderDistance,
            self.maxZ
        )

    for z = firstLine,
        lastLine,
        step
    do
        local _, y =
            self.projection:project(
                self.cameraX,
                z,
                self.cameraX,
                self.cameraZ
            )

        love.graphics.line(
            0,
            math.floor(y) + 0.5,
            Config.virtualWidth,
            math.floor(y) + 0.5
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function World:drawWorldObject(object)
    local x,
        y,
        perspectiveScale =
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
        self:drawPlaceholderObject(
            object,
            x,
            y,
            perspectiveScale,
            alpha
        )
    end
end

function World:drawImageObject(
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

function World:drawPlaceholderObject(
    object,
    x,
    y,
    perspectiveScale,
    alpha
)
    local visual =
        object.visual or {}

    local scale =
        perspectiveScale *
        object.size *
        (visual.scale or 1)

    local offset =
        visual.offset or {}

    x =
        x +
        (offset.x or 0) *
        scale

    y =
        y +
        (offset.y or 0) *
        scale

    alpha =
        alpha *
        (visual.alpha or 1)

    if object.type == "tree" then
        love.graphics.setColor(
            0.3,
            0.18,
            0.09,
            alpha
        )

        love.graphics.rectangle(
            "fill",
            x - 8 * scale,
            y - 75 * scale,
            16 * scale,
            75 * scale
        )

        love.graphics.setColor(
            0.08,
            0.38,
            0.16,
            alpha
        )

        love.graphics.circle(
            "fill",
            x,
            y - 92 * scale,
            42 * scale
        )

    elseif object.type == "rock" then
        love.graphics.setColor(
            0.34,
            0.33,
            0.3,
            alpha
        )

        love.graphics.ellipse(
            "fill",
            x,
            y - 17 * scale,
            34 * scale,
            20 * scale
        )

    elseif object.type == "mushroom" then
        love.graphics.setColor(
            0.72,
            0.25,
            0.18,
            alpha
        )

        love.graphics.circle(
            "fill",
            x,
            y - 12 * scale,
            10 * scale
        )

    else
        love.graphics.setColor(
            0.12,
            0.48,
            0.2,
            alpha
        )

        love.graphics.ellipse(
            "fill",
            x,
            y - 18 * scale,
            36 * scale,
            22 * scale
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return World