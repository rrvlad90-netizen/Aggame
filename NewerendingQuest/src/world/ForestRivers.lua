local Config = require("src.config")

local ForestRivers = {}
ForestRivers.__index = ForestRivers

local function clamp(value, minimum, maximum)
    return math.max(
        minimum,
        math.min(maximum, value)
    )
end

local function randomRange(
    random,
    minimum,
    maximum
)
    return
        minimum +
        random:random() *
        (maximum - minimum)
end

local function drawQuad(
    first,
    second,
    third,
    fourth
)
    love.graphics.polygon(
        "fill",
        first.x,
        first.y,
        second.x,
        second.y,
        third.x,
        third.y,
        fourth.x,
        fourth.y
    )
end

function ForestRivers.new(
    projection,
    level,
    minX,
    maxX,
    minZ,
    maxZ,
    seed
)
    local self =
        setmetatable({}, ForestRivers)

    self.projection = projection

    self.minX = minX
    self.maxX = maxX
    self.minZ = minZ
    self.maxZ = maxZ

    self.settings =
        level.rivers or {}

    local units =
        Config.worldUnitsPerMeter

    local bank =
        self.settings.bank or {}

    local bridge =
        self.settings.bridge or {}

    local reveal =
        self.settings.bridgeReveal or {}

    self.renderExtension =
        (
            self.settings.renderExtension or
            20
        ) * units

    self.renderDistance =
        (
            self.settings.renderDistance or
            38
        ) * units

    self.bankWidth =
        (bank.width or 1.5) *
        units

    self.bankDepth =
        (bank.depth or 0.8) *
        units

    self.vegetationClearance =
        (
            bank.vegetationClearance or
            1.5
        ) * units

    self.approachClearance =
        (
            bridge.approachClearance or
            6
        ) * units

    self.bridgeRevealStart =
        (
            reveal.startDistance or
            20
        ) * units

    self.bridgeRevealFull =
        (
            reveal.fullDistance or
            14
        ) * units

    self.rivers = {}

    self:generate(seed or 1)

    return self
end

function ForestRivers:generate(seed)
    local count =
        self.settings.count or 0

    if count <= 0 then
        return
    end

    local random =
        love.math.newRandomGenerator(
            seed + 64091
        )

    local units =
        Config.worldUnitsPerMeter

    local startMargin =
        (
            self.settings.startMargin or
            18
        ) * units

    local finishMargin =
        (
            self.settings.finishMargin or
            18
        ) * units

    local firstZ =
        self.minZ +
        startMargin

    local lastZ =
        self.maxZ -
        finishMargin

    local usableLength =
        math.max(
            0,
            lastZ - firstZ
        )

    local slotLength =
        usableLength /
        (count + 1)

    local minimumSpacing =
        (
            self.settings.minimumSpacing or
            22
        ) * units

    local widthSettings =
        self.settings.width or {}

    local minimumWidth =
        (
            widthSettings.minimum or
            4
        ) * units

    local maximumWidth =
        (
            widthSettings.maximum or
            7
        ) * units

    local bendSettings =
        self.settings.bend or {}

    local minimumBend =
        (
            bendSettings.minimumStrength or
            2
        ) * units

    local maximumBend =
        (
            bendSettings.maximumStrength or
            6
        ) * units

    local bridgeSettings =
        self.settings.bridge or {}

    local bridgeWidth =
        (
            bridgeSettings.width or
            4.5
        ) * units

    local bridgePadding =
        (
            bridgeSettings.lengthPadding or
            1
        ) * units

    local sideMargin =
        (
            bridgeSettings.sideMargin or
            4
        ) * units

    local halfWorldWidth =
        (
            self.maxX -
            self.minX
        ) / 2

    local bridgeOffset =
        math.max(
            0,
            halfWorldWidth -
            sideMargin -
            bridgeWidth / 2
        )

    local maximumJitter =
        math.max(
            0,
            (
                slotLength -
                minimumSpacing
            ) / 2
        )

    maximumJitter =
        math.min(
            maximumJitter,
            slotLength * 0.25
        )

    -- Keeps left and right bridges represented,
    -- while randomizing their order.
    local bridgeSides = {}

    local firstSide =
        random:random(0, 1) == 0 and
        -1 or
        1

    for index = 1, count do
        if index % 2 == 1 then
            bridgeSides[index] =
                firstSide
        else
            bridgeSides[index] =
                -firstSide
        end
    end

    for index = count, 2, -1 do
        local target =
            random:random(1, index)

        bridgeSides[index],
            bridgeSides[target] =
            bridgeSides[target],
            bridgeSides[index]
    end

    for index = 1, count do
        local baseZ =
            firstZ +
            slotLength * index

        baseZ =
            baseZ +
            randomRange(
                random,
                -maximumJitter,
                maximumJitter
            )

        local bendSide =
            random:random(0, 1) == 0 and
            -1 or
            1

        local bendDirection =
            random:random(0, 1) == 0 and
            -1 or
            1

        self.rivers[
            #self.rivers + 1
        ] = {
            baseZ = baseZ,

            width =
                randomRange(
                    random,
                    minimumWidth,
                    maximumWidth
                ),

            bendStrength =
                bendSettings.enabled == false and
                0 or
                randomRange(
                    random,
                    minimumBend,
                    maximumBend
                ),

            bendSide = bendSide,
            bendDirection = bendDirection,

            bridgeX =
                bridgeSides[index] *
                bridgeOffset,

            bridgeWidth =
                bridgeWidth,

            bridgePadding =
                bridgePadding,

            railingHeight =
                (
                    bridgeSettings.railingHeight or
                    0.9
                ) * units
        }
    end
end

function ForestRivers:getCenterZ(
    river,
    x
)
    local halfWidth =
        math.max(
            1,
            (
                self.maxX -
                self.minX
            ) / 2
        )

    local normalizedX =
        clamp(
            x / halfWidth,
            -1,
            1
        )

    local edgeProgress

    if river.bendSide < 0 then
        edgeProgress =
            math.max(
                0,
                -normalizedX
            )
    else
        edgeProgress =
            math.max(
                0,
                normalizedX
            )
    end

    return
        river.baseZ +
        river.bendDirection *
        river.bendStrength *
        edgeProgress *
        edgeProgress
end

function ForestRivers:getBridgeCenterZ(
    river
)
    return self:getCenterZ(
        river,
        river.bridgeX
    )
end

function ForestRivers:isOnBridge(
    river,
    x,
    radius
)
    radius = radius or 0

    local availableHalfWidth =
        river.bridgeWidth / 2 -
        radius

    if availableHalfWidth < 0 then
        return false
    end

    return
        math.abs(
            x - river.bridgeX
        ) <= availableHalfWidth
end

function ForestRivers:isBlocked(
    x,
    z,
    radius
)
    radius = radius or 0

    for _, river in ipairs(
        self.rivers
    ) do
        local centerZ =
            self:getCenterZ(
                river,
                x
            )

        local insideWater =
            math.abs(
                z - centerZ
            ) <=
            river.width / 2 +
            radius

        if
            insideWater and
            not self:isOnBridge(
                river,
                x,
                radius
            )
        then
            return true
        end
    end

    return false
end

function ForestRivers:isReserved(
    x,
    z,
    radius
)
    radius = radius or 0

    for _, river in ipairs(
        self.rivers
    ) do
        local centerZ =
            self:getCenterZ(
                river,
                x
            )

        if
            math.abs(
                z - centerZ
            ) <=
            river.width / 2 +
            self.bankWidth +
            self.vegetationClearance +
            radius
        then
            return true
        end

        local bridgeZ =
            self:getBridgeCenterZ(
                river
            )

        local nearBridge =
            math.abs(
                x - river.bridgeX
            ) <=
            river.bridgeWidth / 2 +
            self.vegetationClearance +
            radius

        local nearApproach =
            math.abs(
                z - bridgeZ
            ) <=
            river.width / 2 +
            self.approachClearance

        if
            nearBridge and
            nearApproach
        then
            return true
        end
    end

    return false
end

function ForestRivers:isRiverVisible(
    river,
    cameraZ
)
    local margin =
        river.width / 2 +
        self.bankWidth +
        math.abs(
            river.bendStrength or 0
        )

    return
        river.baseZ + margin >=
        cameraZ -
        Config.projection.visibleBehindDepth and

        river.baseZ - margin <=
        cameraZ +
        self.renderDistance
end

function ForestRivers:getBridgeAlpha(
    river,
    cameraZ
)
    local bridgeZ =
        self:getBridgeCenterZ(
            river
        )

    local distance =
        bridgeZ - cameraZ

    if
        distance <
        -Config.projection.visibleBehindDepth
    then
        return 0
    end

    if
        distance >=
        self.bridgeRevealStart
    then
        return 0
    end

    if
        distance <=
        self.bridgeRevealFull
    then
        return 1
    end

    local fadeLength =
        self.bridgeRevealStart -
        self.bridgeRevealFull

    if fadeLength <= 0 then
        return 1
    end

    return clamp(
        1 -
        (
            distance -
            self.bridgeRevealFull
        ) /
        fadeLength,
        0,
        1
    )
end

function ForestRivers:projectPoint(
    x,
    z,
    cameraX,
    cameraZ,
    lowered
)
    local screenX,
        screenY,
        scale =
            self.projection:project(
                x,
                z,
                cameraX,
                cameraZ
            )

    if lowered then
        screenY =
            screenY +
            self.bankDepth *
            scale
    end

    return {
        x = screenX,
        y = screenY
    }
end

function ForestRivers:drawWater(
    river,
    cameraX,
    cameraZ
)
    local segmentCount = 48

    local drawMinX =
        self.minX -
        self.renderExtension

    local drawMaxX =
        self.maxX +
        self.renderExtension

    local totalWidth =
        drawMaxX -
        drawMinX

    for index = 0,
        segmentCount - 1
    do
        local x1 =
            drawMinX +
            totalWidth *
            index /
            segmentCount

        local x2 =
            drawMinX +
            totalWidth *
            (index + 1) /
            segmentCount

        local center1 =
            self:getCenterZ(
                river,
                x1
            )

        local center2 =
            self:getCenterZ(
                river,
                x2
            )

        local nearWater1 =
            center1 -
            river.width / 2

        local nearWater2 =
            center2 -
            river.width / 2

        local farWater1 =
            center1 +
            river.width / 2

        local farWater2 =
            center2 +
            river.width / 2

        local nearTop1 =
            nearWater1 -
            self.bankWidth

        local nearTop2 =
            nearWater2 -
            self.bankWidth

        local farTop1 =
            farWater1 +
            self.bankWidth

        local farTop2 =
            farWater2 +
            self.bankWidth

        local nearTopPoint1 =
            self:projectPoint(
                x1,
                nearTop1,
                cameraX,
                cameraZ,
                false
            )

        local nearTopPoint2 =
            self:projectPoint(
                x2,
                nearTop2,
                cameraX,
                cameraZ,
                false
            )

        local nearWaterPoint1 =
            self:projectPoint(
                x1,
                nearWater1,
                cameraX,
                cameraZ,
                true
            )

        local nearWaterPoint2 =
            self:projectPoint(
                x2,
                nearWater2,
                cameraX,
                cameraZ,
                true
            )

        local farWaterPoint1 =
            self:projectPoint(
                x1,
                farWater1,
                cameraX,
                cameraZ,
                true
            )

        local farWaterPoint2 =
            self:projectPoint(
                x2,
                farWater2,
                cameraX,
                cameraZ,
                true
            )

        local farTopPoint1 =
            self:projectPoint(
                x1,
                farTop1,
                cameraX,
                cameraZ,
                false
            )

        local farTopPoint2 =
            self:projectPoint(
                x2,
                farTop2,
                cameraX,
                cameraZ,
                false
            )

        -- Far bank.
        love.graphics.setColor(
            0.20,
            0.16,
            0.10,
            1
        )

        drawQuad(
            farWaterPoint1,
            farWaterPoint2,
            farTopPoint2,
            farTopPoint1
        )

        -- Lowered water.
        love.graphics.setColor(
            0.07,
            0.28,
            0.43,
            1
        )

        drawQuad(
            nearWaterPoint1,
            nearWaterPoint2,
            farWaterPoint2,
            farWaterPoint1
        )

        -- Near cliff.
        love.graphics.setColor(
            0.12,
            0.09,
            0.065,
            1
        )

        drawQuad(
            nearTopPoint1,
            nearTopPoint2,
            nearWaterPoint2,
            nearWaterPoint1
        )

        -- Grass lips.
        love.graphics.setColor(
            0.18,
            0.31,
            0.15,
            1
        )

        love.graphics.line(
            nearTopPoint1.x,
            nearTopPoint1.y,
            nearTopPoint2.x,
            nearTopPoint2.y
        )

        love.graphics.line(
            farTopPoint1.x,
            farTopPoint1.y,
            farTopPoint2.x,
            farTopPoint2.y
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function ForestRivers:drawBridge(
    river,
    cameraX,
    cameraZ,
    alpha
)
    alpha = alpha or 1

    if alpha <= 0 then
        return
    end

    local bridgeZ =
        self:getBridgeCenterZ(
            river
        )

    local halfWidth =
        river.bridgeWidth / 2

    local halfLength =
        river.width / 2 +
        river.bridgePadding

    local left =
        river.bridgeX -
        halfWidth

    local right =
        river.bridgeX +
        halfWidth

    local nearZ =
        bridgeZ -
        halfLength

    local farZ =
        bridgeZ +
        halfLength

    local leftNear =
        self:projectPoint(
            left,
            nearZ,
            cameraX,
            cameraZ,
            false
        )

    local rightNear =
        self:projectPoint(
            right,
            nearZ,
            cameraX,
            cameraZ,
            false
        )

    local leftFar =
        self:projectPoint(
            left,
            farZ,
            cameraX,
            cameraZ,
            false
        )

    local rightFar =
        self:projectPoint(
            right,
            farZ,
            cameraX,
            cameraZ,
            false
        )

    love.graphics.setColor(
        0.34,
        0.20,
        0.10,
        alpha
    )

    drawQuad(
        leftNear,
        rightNear,
        rightFar,
        leftFar
    )

    love.graphics.setColor(
        0.55,
        0.34,
        0.16,
        alpha * 0.9
    )

    local plankCount = 10

    for index = 0, plankCount do
        local progress =
            index / plankCount

        local z =
            nearZ +
            (farZ - nearZ) *
            progress

        local leftPoint =
            self:projectPoint(
                left,
                z,
                cameraX,
                cameraZ,
                false
            )

        local rightPoint =
            self:projectPoint(
                right,
                z,
                cameraX,
                cameraZ,
                false
            )

        love.graphics.line(
            leftPoint.x,
            leftPoint.y,
            rightPoint.x,
            rightPoint.y
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function ForestRivers:addRailingsToQueue(
    queue,
    cameraZ
)
    local segmentCount = 8

    for _, river in ipairs(
        self.rivers
    ) do
        local alpha =
            self:getBridgeAlpha(
                river,
                cameraZ
            )

        if alpha > 0 then
            local bridgeZ =
                self:getBridgeCenterZ(
                    river
                )

            local halfLength =
                river.width / 2 +
                river.bridgePadding

            local startZ =
                bridgeZ -
                halfLength

            local endZ =
                bridgeZ +
                halfLength

            for _, side in ipairs({
                -1,
                1
            }) do
                for index = 0,
                    segmentCount - 1
                do
                    local z1 =
                        startZ +
                        (
                            endZ -
                            startZ
                        ) *
                        index /
                        segmentCount

                    local z2 =
                        startZ +
                        (
                            endZ -
                            startZ
                        ) *
                        (index + 1) /
                        segmentCount

                    queue[#queue + 1] = {
                        type =
                            "river_railing",

                        z =
                            (z1 + z2) / 2,

                        river = river,
                        side = side,
                        z1 = z1,
                        z2 = z2,
                        alpha = alpha
                    }
                end
            end
        end
    end
end

function ForestRivers:drawRailingSegment(
    segment,
    cameraX,
    cameraZ
)
    local river =
        segment.river

    local x =
        river.bridgeX +
        segment.side *
        river.bridgeWidth / 2

    local x1,
        y1,
        scale1 =
            self.projection:project(
                x,
                segment.z1,
                cameraX,
                cameraZ
            )

    local x2,
        y2,
        scale2 =
            self.projection:project(
                x,
                segment.z2,
                cameraX,
                cameraZ
            )

    local topY1 =
        y1 -
        river.railingHeight *
        scale1

    local topY2 =
        y2 -
        river.railingHeight *
        scale2

    love.graphics.setColor(
        0.25,
        0.13,
        0.055,
        segment.alpha or 1
    )

    love.graphics.setLineWidth(
        math.max(
            1,
            3 *
            (
                scale1 +
                scale2
            ) / 2
        )
    )

    love.graphics.line(
        x1,
        y1,
        x1,
        topY1
    )

    love.graphics.line(
        x2,
        y2,
        x2,
        topY2
    )

    love.graphics.line(
        x1,
        topY1,
        x2,
        topY2
    )

    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 1)
end

function ForestRivers:drawSurface(
    cameraX,
    cameraZ
)
    for _, river in ipairs(
        self.rivers
    ) do
        if self:isRiverVisible(
            river,
            cameraZ
        ) then
            self:drawWater(
                river,
                cameraX,
                cameraZ
            )

            local bridgeAlpha =
                self:getBridgeAlpha(
                    river,
                    cameraZ
                )

            if bridgeAlpha > 0 then
                self:drawBridge(
                    river,
                    cameraX,
                    cameraZ,
                    bridgeAlpha
                )
            end
        end
    end
end

return ForestRivers