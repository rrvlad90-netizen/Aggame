local Config = require("src.config")

local DungeonEncounters = {}
DungeonEncounters.__index = DungeonEncounters

local function enemyIsAlive(enemy)
    if not enemy or enemy.active == false then
        return false
    end

    if enemy.isDead then
        return not enemy:isDead()
    end

    return true
end

function DungeonEncounters.new(
    assets,
    level,
    layout,
    minZ,
    maxZ
)
    local self =
        setmetatable(
            {},
            DungeonEncounters
        )

    self.assets = assets
    self.layout = layout

    self.minZ = minZ
    self.maxZ = maxZ

    self.settings =
        level.combatRooms or {}

    self.enabled =
        self.settings.enabled ~= false

    self.doors = {}
    self.rooms = {}

    self.activeRoom = nil

    local units =
        Config.worldUnitsPerMeter

    self.triggerDistance =
        (
            self.settings.triggerDistance or 2
        ) * units

    self.doorHeight =
        self.settings.doorHeight or 150

    self.doorDepth =
        (
            self.settings.doorDepth or 0.7
        ) * units

    local door =
        self.settings.door or {}

    self.doorColor =
        door.color or {
            0.3,
            0.23,
            0.14,
            1
        }

    self.doorDarkColor =
        door.darkColor or {
            0.14,
            0.11,
            0.08,
            1
        }

    self.doorMetalColor =
        door.metalColor or {
            0.42,
            0.43,
            0.44,
            1
        }

    self.closedImage = nil
    self.openImage = nil

    if door.closedImage then
        self.closedImage =
            assets:getFileImage(
                door.closedImage
            )
    end

    if door.openImage then
        self.openImage =
            assets:getFileImage(
                door.openImage
            )
    end

    if self.enabled then
        self:createDoors()
        self:createRooms()
    end

    return self
end

function DungeonEncounters:createDoors()
    for index, passage in ipairs(
        self.layout.passages
    ) do
        self.doors[index] = {
            type = "dungeon_door",

            x = passage.x,
            z = passage.z,

            width =
                passage.width * 0.94,

            depth =
                self.doorDepth,

            height =
                self.doorHeight,

            locked = false,
            collidable = true,

            closedImage =
                self.closedImage,

            openImage =
                self.openImage,

            color =
                self.doorColor,

            darkColor =
                self.doorDarkColor,

            metalColor =
                self.doorMetalColor,

            collisionRadius = 0
        }
    end
end

function DungeonEncounters:createRooms()
    local roomCount =
        self.layout.roomCount

    local roomLength =
        (
            self.maxZ -
            self.minZ
        ) / roomCount

    -- Первый зал является безопасным входом.
    for roomIndex = 2, roomCount do
        local startZ =
            self.minZ +
            roomLength *
            (roomIndex - 1)

        local endZ =
            self.minZ +
            roomLength *
            roomIndex

        self.rooms[
            #self.rooms + 1
        ] = {
            index = roomIndex,

            startZ = startZ,
            endZ = endZ,

            entryDoor =
                self.doors[
                    roomIndex - 1
                ],

            exitDoor =
                self.doors[
                    roomIndex
                ],

            triggered = false,
            cleared = false,

            targets = {}
        }
    end
end

function DungeonEncounters:getDoors()
    return self.doors
end

function DungeonEncounters:setDoorLocked(
    door,
    locked
)
    if door then
        door.locked =
            locked == true
    end
end

function DungeonEncounters:unlockRoom(room)
    if not room then
        return
    end

    self:setDoorLocked(
        room.entryDoor,
        false
    )

    self:setDoorLocked(
        room.exitDoor,
        false
    )
end

function DungeonEncounters:lockRoom(room)
    if not room then
        return
    end

    self:setDoorLocked(
        room.entryDoor,
        true
    )

    self:setDoorLocked(
        room.exitDoor,
        true
    )
end

function DungeonEncounters:collectTargets(
    room,
    enemies
)
    room.targets = {}

    for _, enemy in ipairs(
        enemies or {}
    ) do
        if
            enemyIsAlive(enemy) and
            enemy.z >= room.startZ and
            enemy.z <= room.endZ
        then
            room.targets[
                #room.targets + 1
            ] = enemy
        end
    end
end

function DungeonEncounters:hasLivingTargets(
    room
)
    for _, enemy in ipairs(
        room.targets
    ) do
        if enemyIsAlive(enemy) then
            return true
        end
    end

    return false
end

function DungeonEncounters:beginRoom(
    room,
    enemies
)
    room.triggered = true

    self:collectTargets(
        room,
        enemies
    )

    if #room.targets == 0 then
        room.cleared = true
        self:unlockRoom(room)
        return
    end

    self.activeRoom = room
    self:lockRoom(room)
end

function DungeonEncounters:completeRoom(room)
    room.cleared = true

    self:unlockRoom(room)

    if self.activeRoom == room then
        self.activeRoom = nil
    end
end

-- Сбрасывает активный бой при смерти игрока.
function DungeonEncounters:cancelActiveRoom()
    local room =
        self.activeRoom

    if not room then
        return
    end

    self:unlockRoom(room)

    room.triggered = false
    room.targets = {}

    self.activeRoom = nil
end

function DungeonEncounters:update(
    dt,
    player,
    enemies
)
    if not self.enabled then
        return
    end

    if
        player.gameOver or
        player.state == "dying" or
        player.state == "dead" or
        player.state == "respawning"
    then
        self:cancelActiveRoom()
        return
    end

    if self.activeRoom then
        if not self:hasLivingTargets(
            self.activeRoom
        ) then
            self:completeRoom(
                self.activeRoom
            )
        end

        return
    end

    for _, room in ipairs(
        self.rooms
    ) do
        if
            not room.triggered and
            not room.cleared and
            player.z >=
            room.startZ +
            self.triggerDistance and
            player.z <= room.endZ
        then
            self:beginRoom(
                room,
                enemies
            )

            return
        end
    end
end

-- Проверяет столкновение с закрытой дверью.
function DungeonEncounters:isDoorBlocked(
    door,
    x,
    z,
    radius
)
    if
        not door or
        not door.locked
    then
        return false
    end

    radius = radius or 0

    return
        math.abs(x - door.x) <=
        door.width / 2 + radius and

        math.abs(z - door.z) <=
        door.depth / 2 + radius
end

-- Проверяет, завершён ли последний зал.
function DungeonEncounters:isFinalRoomCleared()
    if not self.enabled then
        return true
    end

    local finalRoom =
        self.rooms[#self.rooms]

    return
        not finalRoom or
        finalRoom.cleared
end

return DungeonEncounters