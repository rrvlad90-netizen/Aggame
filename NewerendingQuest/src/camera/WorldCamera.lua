local Config = require("src.config")
local CameraData = require("data.camera")

local WorldCamera = {}
WorldCamera.__index = WorldCamera

-- Создаёт единую камеру всей игры.
function WorldCamera.new()
    local self = setmetatable({}, WorldCamera)

    self.x = 0
    self.z = 0

    self.minimumX = 0
    self.maximumX = 0

    self.deadZone =
        CameraData.deadZone

    self.screenMargin =
        CameraData.screenMargin

    self.followSpeed =
        CameraData.followSpeed

    return self
end

-- Настраивает допустимое движение по границам мира.
function WorldCamera:configure(worldBounds)
    local horizontalScale =
        Config.projection.horizontalNearScale or
        1

    local visibleHalfWidth =
        (
            Config.virtualWidth / 2 -
            self.screenMargin
        ) /
        horizontalScale

    local worldWidth =
        worldBounds.maxX -
        worldBounds.minX

    -- Узкий мир автоматически закрепляет камеру по центру.
    if worldWidth <= visibleHalfWidth * 2 then
        local center =
            (
                worldBounds.minX +
                worldBounds.maxX
            ) / 2

        self.minimumX = center
        self.maximumX = center
        return
    end

    self.minimumX =
        worldBounds.minX +
        visibleHalfWidth

    self.maximumX =
        worldBounds.maxX -
        visibleHalfWidth
end

-- Ограничивает положение камеры.
function WorldCamera:clampX(x)
    return math.max(
        self.minimumX,
        math.min(
            self.maximumX,
            x
        )
    )
end

-- Сбрасывает камеру в начале уровня.
function WorldCamera:reset(player)
    self.x =
        self:clampX(player.x)

    self.z = player.z
end

-- Плавно следует за игроком.
function WorldCamera:update(dt, player)
    self.z = player.z

    local relativeX =
        player.x -
        self.x

    local targetX =
        self.x

    if relativeX > self.deadZone then
        targetX =
            player.x -
            self.deadZone
    elseif relativeX < -self.deadZone then
        targetX =
            player.x +
            self.deadZone
    end

    targetX =
        self:clampX(targetX)

    local interpolation =
        math.min(
            1,
            dt *
            self.followSpeed
        )

    self.x =
        self.x +
        (
            targetX -
            self.x
        ) *
        interpolation
end

-- Возвращает горизонтальную координату.
function WorldCamera:getX()
    return self.x
end

-- Возвращает координату глубины.
function WorldCamera:getZ()
    return self.z
end

return WorldCamera