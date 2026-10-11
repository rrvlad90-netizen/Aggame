local Config = require("src.config")
local Swamp = require("data.biomes.swamp")
local PlayerData = require("data.entities.player")

local Ground = require("src.rendering.Ground")
local Kikimora = require("src.entities.Kikimora")
local Portal = require("src.entities.Portal")

local SwampWorld = {}
SwampWorld.__index = SwampWorld

-- Создаёт фиксированное или процедурное болото.
function SwampWorld.new(
    projection,
    assets,
    level
)
    local self =
        setmetatable(
            {},
            SwampWorld
        )

    self.projection = projection
    self.assets = assets
    self.biome = Swamp

    self.level = level or {
        id = "debug_swamp",
        biome = "swamp",
        seed = Config.swamp.seed,
        generationMode = "procedural"
    }

    self.cameraX = 0
    self.cameraZ = 0

    self.hummocks = {}
    self.occupiedCells = {}

    self.mainPathCount = 0
    self.lastPathHummock = nil
    self.goalPlatform = nil

    self.portal = nil

    self.random =
        love.math.newRandomGenerator(
            self.level.seed or
            Config.swamp.seed
        )

    self.ground =
        Ground.new(
            projection,
            assets,
            Swamp
        )

    if
        self.level.generationMode ==
        "fixed"
    then
        self:loadFixedPlatforms(
            self.level.platforms
        )
    else
        local centerLane =
            math.ceil(
                Config.swamp.laneCount /
                2
            )

        self:addHummock(
            centerLane,
            0,
            125,
            true,
            "hummock"
        )

        self:generateUntil(
            Config.swamp.generateAhead
        )
    end

    self.portal =
        self:createPortal()

    return self
end

-- Передаёт положение камеры.
function SwampWorld:setCameraPosition(
    x,
    z
)
    self.cameraX = x
    self.cameraZ = z
end

-- Закрепляет горизонтальную камеру.
function SwampWorld:getCameraBounds()
    return {
        minX = 0,
        maxX = 0
    }
end

-- На кочках запрещена ходьба.
function SwampWorld:allowsWalking()
    return false
end

-- Возвращает расстояние между дорожками.
function SwampWorld:getLaneSpacing()
    return
        Config.swamp.laneSpacing
end

-- Возвращает координату дорожки.
function SwampWorld:getLaneX(lane)
    if
        lane < 1 or
        lane >
        Config.swamp.laneCount
    then
        return nil
    end

    local centerLane =
        (
            Config.swamp.laneCount +
            1
        ) / 2

    return
        (
            lane -
            centerLane
        ) *
        Config.swamp.laneSpacing
end

-- Возвращает ближайшую дорожку.
function SwampWorld:getNearestLane(x)
    local centerLane =
        (
            Config.swamp.laneCount +
            1
        ) / 2

    local lane =
        math.floor(
            x /
            Config.swamp.laneSpacing +
            centerLane +
            0.5
        )

    return
        math.max(
            1,
            math.min(
                Config.swamp.laneCount,
                lane
            )
        )
end

-- Возвращает глубину ряда.
function SwampWorld:getRowZ(row)
    return
        row *
        Config.swamp.rowSpacing
end

-- Создаёт ключ клетки.
function SwampWorld:getCellKey(
    lane,
    row
)
    return
        tostring(lane) ..
        ":" ..
        tostring(row)
end

-- Проверяет занятость клетки.
function SwampWorld:isCellOccupied(
    lane,
    row
)
    local key =
        self:getCellKey(
            lane,
            row
        )

    return
        self.occupiedCells[key] ~=
        nil
end

-- Определяет появление кикиморы.
function SwampWorld:shouldCreateKikimora(
    mainPath,
    row,
    pathNumber
)
    if
        not mainPath or
        row <= 3
    then
        return false
    end

    local guaranteed =
        pathNumber >= 4 and
        pathNumber % 4 == 0

    if guaranteed then
        return true
    end

    return
        self.random:random() <
        Config.swamp.kikimoraChance
end

-- Добавляет кочку или кикимору.
function SwampWorld:addHummock(
    lane,
    row,
    radius,
    mainPath,
    forcedType
)
    local key =
        self:getCellKey(
            lane,
            row
        )

    local existing =
        self.occupiedCells[key]

    if existing then
        if
            mainPath and
            not existing.mainPath
        then
            self.mainPathCount =
                self.mainPathCount + 1

            existing.mainPath = true
        end

        if mainPath then
            self.lastPathHummock =
                existing
        end

        return existing
    end

    local pathNumber =
        self.mainPathCount

    if mainPath then
        pathNumber =
            pathNumber + 1
    end

    local x =
        self:getLaneX(lane)

    local z =
        self:getRowZ(row)

    local createKikimora

    if forcedType then
        createKikimora =
            forcedType ==
            "kikimora"
    else
        createKikimora =
            self:
            shouldCreateKikimora(
                mainPath,
                row,
                pathNumber
            )
    end

    local platform

    if createKikimora then
        platform =
            Kikimora.new(
                lane,
                row,
                x,
                z,
                radius,
                self.assets,
                self.random:random()
            )
    else
        platform = {
            type = "hummock",

            lane = lane,
            row = row,

            x = x,
            z = z,

            radius = radius,
            mainPath =
                mainPath == true
        }
    end

    self.hummocks[
        #self.hummocks + 1
    ] = platform

    self.occupiedCells[key] =
        platform

    if mainPath then
        self.mainPathCount =
            pathNumber

        self.lastPathHummock =
            platform

        self:updateProceduralGoal(
            platform,
            pathNumber
        )
    end

    return platform
end

-- Возвращает любую платформу под позицией.
function SwampWorld:getAnyPlatformAt(
    x,
    z,
    collisionRadius
)
    for _, platform in ipairs(
        self.hummocks
    ) do
        local dx =
            x - platform.x

        local dz =
            z - platform.z

        local radius =
            platform.radius -
            (collisionRadius or 0)

        if
            radius > 0 and
            dx * dx + dz * dz <=
            radius * radius
        then
            return platform
        end
    end

    return nil
end

-- Подготавливает кикимору к возрождению.
function SwampWorld:prepareRespawn(
    x,
    z,
    collisionRadius
)
    local platform =
        self:getAnyPlatformAt(
            x,
            z,
            collisionRadius
        )

    if
        platform and
        platform.type ==
        "kikimora"
    then
        platform:
        resetAndWaitForPlayer()
    end
end

-- Назначает процедурную цель.
function SwampWorld:updateProceduralGoal(
    platform,
    pathNumber
)
    local length =
        self.level.length

    if
        not length or
        length.type ~= "hummocks"
    then
        return
    end

    if
        not self.goalPlatform and
        pathNumber >=
        length.count
    then
        self.goalPlatform =
            platform
    end
end

-- Загружает фиксированные платформы.
function SwampWorld:loadFixedPlatforms(
    platforms
)
    assert(
        type(platforms) == "table",
        "Fixed swamp has no platforms"
    )

    for _, definition in ipairs(
        platforms
    ) do
        local platform =
            self:addHummock(
                definition.lane,
                definition.row,
                definition.radius,
                definition.mainPath ~=
                false,
                definition.type
            )

        if definition.goal then
            self.goalPlatform =
                platform
        end
    end

    assert(
        self.goalPlatform,
        "Fixed swamp has no goal platform"
    )
end

-- Выбирает дальность маршрута.
function SwampWorld:chooseJump()
    local names = {
        "near",
        "medium",
        "far"
    }

    return
        names[
            self.random:random(
                1,
                #names
            )
        ]
end

-- Выбирает направление маршрута.
function SwampWorld:chooseDirection(
    sourceLane
)
    local directions = { 0 }

    if sourceLane > 1 then
        directions[
            #directions + 1
        ] = -1
    end

    if
        sourceLane <
        Config.swamp.laneCount
    then
        directions[
            #directions + 1
        ] = 1
    end

    return
        directions[
            self.random:random(
                1,
                #directions
            )
        ]
end

-- Добавляет кочку основного маршрута.
function SwampWorld:generatePathHummock()
    if self.goalPlatform then
        return
    end

    local source =
        self.lastPathHummock

    local jumpName =
        self:chooseJump()

    local jump =
        PlayerData.jumps[
            jumpName
        ]

    local direction =
        self:chooseDirection(
            source.lane
        )

    local targetLane =
        source.lane +
        direction

    local targetRow =
        source.row +
        jump.rows

    local radius =
        self.random:random(
            Config.swamp.hummockRadiusMin,
            Config.swamp.hummockRadiusMax
        )

    self:addHummock(
        targetLane,
        targetRow,
        radius,
        true
    )

    if
        self.random:random() <
        Config.swamp.decoyChance
    then
        self:addDecoyHummock(
            targetLane,
            targetRow
        )
    end
end

-- Добавляет ложную кочку.
function SwampWorld:addDecoyHummock(
    pathLane,
    pathRow
)
    local availableLanes = {}

    for lane = 1,
        Config.swamp.laneCount
    do
        if
            lane ~= pathLane and
            not self:isCellOccupied(
                lane,
                pathRow
            )
        then
            availableLanes[
                #availableLanes + 1
            ] = lane
        end
    end

    if #availableLanes == 0 then
        return
    end

    local lane =
        availableLanes[
            self.random:random(
                1,
                #availableLanes
            )
        ]

    local radius =
        self.random:random(
            Config.swamp.hummockRadiusMin,
            Config.swamp.hummockRadiusMax
        )

    self:addHummock(
        lane,
        pathRow,
        radius,
        false,
        "hummock"
    )
end

-- Продолжает процедурный маршрут.
function SwampWorld:generateUntil(targetZ)
    while
        not self.goalPlatform and
        self.lastPathHummock.z <
        targetZ
    do
        self:generatePathHummock()
    end
end

-- Создаёт портал на последней кочке.
function SwampWorld:createPortal()
    local definition =
        self.level.exit

    if
        not definition or
        definition.type ~= "portal" or
        not self.goalPlatform
    then
        return nil
    end

    return Portal.new(
        self.assets,
        self.goalPlatform.x,
        self.goalPlatform.z,
        definition
    )
end

-- Болото использует прыжки вперёд.
function SwampWorld:usesForwardOnlyJumps()
    return true
end

-- Рассчитывает болотный прыжок.
function SwampWorld:getJumpTarget(
    player,
    jumpType,
    direction
)
    local jump =
        PlayerData.jumps[
            jumpType
        ]

    local source =
        self:getHummockAt(
            player.x,
            player.z,
            0
        )

    local sourceLane =
        source and
        source.lane or
        self:getNearestLane(
            player.x
        )

    local targetLane =
        sourceLane +
        direction

    local targetX =
        self:getLaneX(
            targetLane
        )

    if not targetX then
        targetX =
            player.x +
            direction *
            self:getLaneSpacing()
    end

    local sourceZ =
        source and
        source.z or
        player.z

    return
        targetX,
        sourceZ +
        jump.forward
end

-- Обновляет болото.
function SwampWorld:update(
    dt,
    player
)
    for _, platform in ipairs(
        self.hummocks
    ) do
        if
            platform.type ==
            "kikimora"
        then
            platform:update(
                dt,
                player
            )
        end
    end

    for _, platform in ipairs(
        self.hummocks
    ) do
        if
            platform.type ==
            "kikimora" and
            platform.z <
            self.cameraZ -
            Config.projection.
            visibleBehindDepth
        then
            platform:
            resetAndWaitForPlayer()
        end
    end

    if
        self.level.generationMode ~=
        "fixed"
    then
        self:generateUntil(
            player.z +
            Config.swamp.generateAhead
        )
    end

    -- Процедурная цель могла появиться после запуска.
    if
        not self.portal and
        self.goalPlatform
    then
        self.portal =
            self:createPortal()
    end

    if self.portal then
        self.portal:update(
            dt,
            player
        )
    end
end

-- Проверяет доступность платформы.
function SwampWorld:isPlatformUsable(
    platform
)
    if
        platform.type ~=
        "kikimora"
    then
        return true
    end

    return
        platform:
        isSafeForLanding()
end

-- Возвращает платформу под позицией.
function SwampWorld:getHummockAt(
    x,
    z,
    collisionRadius
)
    for _, platform in ipairs(
        self.hummocks
    ) do
        local dx =
            x - platform.x

        local dz =
            z - platform.z

        local safeRadius =
            platform.radius -
            (collisionRadius or 0)

        if
            self:isPlatformUsable(
                platform
            ) and
            safeRadius > 0 and
            dx * dx + dz * dz <=
            safeRadius * safeRadius
        then
            return platform
        end
    end

    return nil
end

-- Проверяет безопасность позиции.
function SwampWorld:isSafePosition(
    x,
    z,
    collisionRadius
)
    return
        self:getHummockAt(
            x,
            z,
            collisionRadius
        ) ~= nil
end

-- Проверяет активацию портала.
function SwampWorld:isLevelComplete(player)
    return
        self.portal and
        self.portal:
        isActivated() or
        false
end

-- Возвращает назначение портала.
function SwampWorld:getExitDestination()
    if not self.portal then
        return nil
    end

    return
        self.portal:
        getDestination()
end

-- Собирает платформы, предметы, стрелы, врагов, портал и игрока.
function SwampWorld:collectRenderQueue(
    player,
    projectiles,
    enemies,
    pickups
)
    local queue = {}

    for _, platform in ipairs(
        self.hummocks
    ) do
        if
            self.projection:isDepthVisible(
                platform.z,
                self.cameraZ
            )
        then
            queue[#queue + 1] = {
                type = platform.type,
                x = platform.x,
                z = platform.z,
                reference = platform
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
            )
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
            self.projection:isDepthVisible(
                pickup.z,
                self.cameraZ
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
        self.projection:isDepthVisible(
            self.portal.z,
            self.cameraZ
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

    table.sort(
        queue,
        function(a, b)
            return a.z > b.z
        end
    )

    return queue
end

-- Рисует болото.
function SwampWorld:draw(
    player,
    projectiles,
    enemies
)
    self.ground:draw(
        self.cameraX,
        self.cameraZ
    )

    local queue =
        self:collectRenderQueue(
            player,
            projectiles,
            enemies
        )

    for _, item in ipairs(queue) do
        if
            item.type == "player" or
            item.type ==
            "player_arrow" or
            item.type == "enemy" or
            item.type == "portal"
        then
            item.reference:draw(
                self.projection,
                self.cameraX,
                self.cameraZ
            )
        elseif
            item.type ==
            "kikimora"
        then
            item.reference:draw(
                self.projection,
                self.cameraX,
                self.cameraZ
            )
        else
            self:drawHummock(
                item.reference
            )
        end
    end
end

-- Рисует обычную кочку.
function SwampWorld:drawHummock(
    hummock
)
    local x, y, scale =
        self.projection:project(
            hummock.x,
            hummock.z,
            self.cameraX,
            self.cameraZ
        )

    local alpha =
        self.projection:
        getVisibilityAlpha(
            hummock.z,
            self.cameraZ
        )

    local image =
        self.assets:getImage(
            self.biome.hummockImage
        )

    if image then
        local spriteScale =
            hummock.radius *
            2 *
            scale /
            image:getWidth()

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
            spriteScale,
            spriteScale,
            image:getWidth() / 2,
            image:getHeight()
        )
    else
        love.graphics.setColor(
            0.31,
            0.44,
            0.16,
            alpha
        )

        love.graphics.ellipse(
            "fill",
            x,
            y,
            hummock.radius *
            scale,
            hummock.radius *
            0.38 *
            scale
        )

        love.graphics.setColor(
            0.17,
            0.3,
            0.09,
            alpha
        )

        love.graphics.ellipse(
            "line",
            x,
            y,
            hummock.radius *
            scale,
            hummock.radius *
            0.38 *
            scale
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return SwampWorld