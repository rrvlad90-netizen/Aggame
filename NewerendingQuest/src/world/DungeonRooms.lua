local Config = require("src.config")

local DungeonRooms = {}
DungeonRooms.__index = DungeonRooms

function DungeonRooms.new(
    assets,
    level,
    minX,
    maxX,
    minZ,
    maxZ,
    seed
)
    local self =
        setmetatable({}, DungeonRooms)

    self.assets = assets

    self.minX = minX
    self.maxX = maxX
    self.minZ = minZ
    self.maxZ = maxZ

    self.settings =
        level.layout or {}

    self.enabled =
        self.settings.enabled ~= false

    self.walls = {}
    self.passages = {}

    local units =
        Config.worldUnitsPerMeter

    self.roomCount =
        self.settings.roomCount or 5

    self.wallSpacing =
        (
            self.settings.wallSpacing or 2
        ) * units

    self.wallHeight =
        self.settings.wallHeight or 135

    self.openingWidth =
        (
            self.settings.openingWidth or 7
        ) * units

    self.sideMargin =
        (
            self.settings.sideMargin or 6
        ) * units

    self.passageClearance =
        (
            self.settings.passageClearance or 5
        ) * units

    self.decorationClearance =
        (
            self.settings.decorationClearance or 1
        ) * units

    self.wallCollisionRadius =
        (
            self.settings.wallCollisionRadius or
            1.05
        ) * units

    self.wallImage = nil

    local wall =
        self.settings.wall or {}

    self.wallColor =
        wall.color or {
            0.28,
            0.27,
            0.26,
            1
        }

    self.wallTopColor =
        wall.topColor or {
            0.4,
            0.38,
            0.35,
            1
        }

    self.wallLineColor =
        wall.lineColor or {
            0.16,
            0.15,
            0.14,
            1
        }

    if wall.image then
        self.wallImage =
            assets:getFileImage(
                wall.image
            )
    end

    if self.enabled then
        self:generate(seed or 1)
    end

    return self
end

function DungeonRooms:addWall(x, z)
    self.walls[#self.walls + 1] = {
        type = "dungeon_wall",

        x = x,
        z = z,

        size = 1,
        collidable = true,

        collisionRadius =
            self.wallCollisionRadius,

        wallWidth =
            self.wallSpacing * 1.08,

        wallHeight =
            self.wallHeight,

        image =
            self.wallImage,

        wallColor =
            self.wallColor,

        wallTopColor =
            self.wallTopColor,

        wallLineColor =
            self.wallLineColor
    }
end

-- Создаёт стены залов.
function DungeonRooms:generate(seed)
    local random =
        love.math.newRandomGenerator(
            seed + 93491
        )

    local width =
        self.maxX - self.minX

    local length =
        self.maxZ - self.minZ

    local dividerCount =
        math.max(
            0,
            self.roomCount - 1
        )

    local maximumOpeningOffset =
        math.max(
            0,
            width / 2 -
            self.sideMargin -
            self.openingWidth / 2
        )

    local firstSide =
        random:random(0, 1) == 0 and
        -1 or
        1

    -- Поперечные стены между залами.
    for index = 1, dividerCount do
        local z =
            self.minZ +
            length *
            index /
            self.roomCount

        local side

        if index % 2 == 1 then
            side = firstSide
        else
            side = -firstSide
        end

        local openingX =
            side *
            maximumOpeningOffset *
            (
                0.84 +
                random:random() * 0.16
            )

        self.passages[
            #self.passages + 1
        ] = {
            x = openingX,
            z = z,
            width = self.openingWidth
        }

        local x =
            self.minX +
            self.wallSpacing / 2

        while x <
            self.maxX
        do
            local insideOpening =
                math.abs(
                    x - openingX
                ) <=
                self.openingWidth / 2

            if not insideOpening then
                self:addWall(x, z)
            end

            x = x + self.wallSpacing
        end
    end

    -- Боковые стены.
    local sideOffset =
        self.wallCollisionRadius

    local z =
        self.minZ +
        self.wallSpacing / 2

    while z < self.maxZ do
        self:addWall(
            self.minX - sideOffset,
            z
        )

        self:addWall(
            self.maxX + sideOffset,
            z
        )

        z = z + self.wallSpacing
    end
end

function DungeonRooms:getWalls()
    return self.walls
end

-- Не позволяет декорациям перекрывать стены и проходы.
function DungeonRooms:isReserved(
    x,
    z,
    radius
)
    radius = radius or 0

    local clearance =
        self.decorationClearance +
        radius

    for _, wall in ipairs(
        self.walls
    ) do
        local dx = x - wall.x
        local dz = z - wall.z

        local minimumDistance =
            wall.collisionRadius +
            clearance

        if
            dx * dx + dz * dz <
            minimumDistance *
            minimumDistance
        then
            return true
        end
    end

    for _, passage in ipairs(
        self.passages
    ) do
        if
            math.abs(
                x - passage.x
            ) <=
            passage.width / 2 +
            clearance and

            math.abs(
                z - passage.z
            ) <=
            self.passageClearance +
            clearance
        then
            return true
        end
    end

    return false
end

return DungeonRooms