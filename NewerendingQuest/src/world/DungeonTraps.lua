local Config = require("src.config")

local DungeonTraps = {}
DungeonTraps.__index = DungeonTraps

function DungeonTraps.new(
    assets,
    level,
    layout,
    minX,
    maxX,
    minZ,
    maxZ,
    seed
)
    local self =
        setmetatable({}, DungeonTraps)

    self.assets = assets
    self.layout = layout

    self.minX = minX
    self.maxX = maxX
    self.minZ = minZ
    self.maxZ = maxZ

    self.settings =
        level.traps or {}

    self.enabled =
        self.settings.enabled ~= false

    self.traps = {}

    local units =
        Config.worldUnitsPerMeter

    self.countPerRoom =
        self.settings.countPerRoom or 2

    self.triggerRadius =
        (
            self.settings.triggerRadius or
            1.35
        ) * units

    self.minimumDistance =
        (
            self.settings.minimumDistance or
            5
        ) * units

    self.roomMargin =
        (
            self.settings.roomMargin or
            5
        ) * units

    self.passageClearance =
        (
            self.settings.passageClearance or
            3
        ) * units

    self.warningDuration =
        self.settings.warningDuration or 0.65

    self.activeDuration =
        self.settings.activeDuration or 0.55

    self.cooldownDuration =
        self.settings.cooldownDuration or 2.2

    self.damage =
        self.settings.damage or 1

    self.safeJumpHeight =
        (
            self.settings.safeJumpHeight or
            0.7
        ) * units

    local visual =
        self.settings.visual or {}

    self.visualRadius =
        visual.radius or 34

    self.spikeHeight =
        visual.spikeHeight or 38

    self.idleColor =
        visual.idleColor or {
            0.22,
            0.21,
            0.2,
            1
        }

    self.warningColor =
        visual.warningColor or {
            0.78,
            0.46,
            0.12,
            1
        }

    self.activeColor =
        visual.activeColor or {
            0.72,
            0.72,
            0.68,
            1
        }

    self.darkColor =
        visual.darkColor or {
            0.12,
            0.11,
            0.1,
            1
        }

    self.idleImage = nil
    self.warningImage = nil
    self.activeImage = nil

    if visual.idleImage then
        self.idleImage =
            assets:getFileImage(
                visual.idleImage
            )
    end

    if visual.warningImage then
        self.warningImage =
            assets:getFileImage(
                visual.warningImage
            )
    end

    if visual.activeImage then
        self.activeImage =
            assets:getFileImage(
                visual.activeImage
            )
    end

    if self.enabled then
        self:generate(seed or 1)
    end

    return self
end

function DungeonTraps:isTooCloseToTrap(x, z)
    local minimumSquared =
        self.minimumDistance *
        self.minimumDistance

    for _, trap in ipairs(
        self.traps
    ) do
        local dx = x - trap.x
        local dz = z - trap.z

        if
            dx * dx + dz * dz <
            minimumSquared
        then
            return true
        end
    end

    return false
end

function DungeonTraps:addTrap(x, z)
    self.traps[#self.traps + 1] = {
        type = "dungeon_spikes",

        x = x,
        z = z,

        active = true,
        collidable = false,
        collisionRadius = 0,

        state = "idle",
        stateTime = 0,
        hitDone = false,

        triggerRadius =
            self.triggerRadius,

        safeJumpHeight =
            self.safeJumpHeight,

        damage =
            self.damage,

        warningDuration =
            self.warningDuration,

        activeDuration =
            self.activeDuration,

        cooldownDuration =
            self.cooldownDuration,

        visualRadius =
            self.visualRadius,

        spikeHeight =
            self.spikeHeight,

        idleColor =
            self.idleColor,

        warningColor =
            self.warningColor,

        activeColor =
            self.activeColor,

        darkColor =
            self.darkColor,

        idleImage =
            self.idleImage,

        warningImage =
            self.warningImage,

        activeImage =
            self.activeImage
    }
end

function DungeonTraps:generate(seed)
    local random =
        love.math.newRandomGenerator(
            seed + 56171
        )

    local roomCount =
        self.layout.roomCount

    local roomLength =
        (
            self.maxZ -
            self.minZ
        ) / roomCount

    -- Первый зал остаётся безопасным.
    for roomIndex = 2, roomCount do
        local roomStart =
            self.minZ +
            roomLength *
            (roomIndex - 1)

        local roomEnd =
            self.minZ +
            roomLength *
            roomIndex

        for _ = 1,
            self.countPerRoom
        do
            for _ = 1, 60 do
                local x =
                    self.minX +
                    self.roomMargin +
                    random:random() *
                    (
                        self.maxX -
                        self.minX -
                        self.roomMargin * 2
                    )

                local z =
                    roomStart +
                    self.roomMargin +
                    random:random() *
                    math.max(
                        1,
                        roomEnd -
                        roomStart -
                        self.roomMargin * 2
                    )

                local reserved =
                    self.layout:isReserved(
                        x,
                        z,
                        self.passageClearance
                    )

                if
                    not reserved and
                    not self:isTooCloseToTrap(
                        x,
                        z
                    )
                then
                    self:addTrap(x, z)
                    break
                end
            end
        end
    end
end

function DungeonTraps:getTraps()
    return self.traps
end

function DungeonTraps:isReserved(
    x,
    z,
    radius
)
    radius = radius or 0

    for _, trap in ipairs(
        self.traps
    ) do
        local dx = x - trap.x
        local dz = z - trap.z

        local minimum =
            trap.triggerRadius +
            radius

        if
            dx * dx + dz * dz <
            minimum * minimum
        then
            return true
        end
    end

    return false
end

function DungeonTraps:playerTouchesTrap(
    trap,
    player
)
    if
        player.height >
        trap.safeJumpHeight
    then
        return false
    end

    if
        player.state == "dying" or
        player.state == "dead" or
        player.state == "respawning"
    then
        return false
    end

    local dx = player.x - trap.x
    local dz = player.z - trap.z

    local radius =
        trap.triggerRadius +
        player.collisionRadius

    return
        dx * dx + dz * dz <=
        radius * radius
end

function DungeonTraps:updateTrap(
    trap,
    dt,
    player
)
    if trap.state == "idle" then
        if self:playerTouchesTrap(
            trap,
            player
        ) then
            trap.state = "warning"
            trap.stateTime = 0
            trap.hitDone = false
        end

        return
    end

    trap.stateTime =
        trap.stateTime + dt

    if trap.state == "warning" then
        if
            trap.stateTime >=
            trap.warningDuration
        then
            trap.state = "active"
            trap.stateTime = 0
            trap.hitDone = false
        end

        return
    end

    if trap.state == "active" then
        if
            not trap.hitDone and
            self:playerTouchesTrap(
                trap,
                player
            )
        then
            trap.hitDone = true

            player:takeDamage(
                trap.damage,
                trap.x,
                trap.z
            )
        end

        if
            trap.stateTime >=
            trap.activeDuration
        then
            trap.state = "cooldown"
            trap.stateTime = 0
        end

        return
    end

    if
        trap.state == "cooldown" and
        trap.stateTime >=
        trap.cooldownDuration
    then
        trap.state = "idle"
        trap.stateTime = 0
        trap.hitDone = false
    end
end

function DungeonTraps:update(dt, player)
    if not self.enabled then
        return
    end

    for _, trap in ipairs(
        self.traps
    ) do
        self:updateTrap(
            trap,
            dt,
            player
        )
    end
end

return DungeonTraps