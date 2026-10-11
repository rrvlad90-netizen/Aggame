local ArrowData =
    require("data.projectiles.player_arrow")

local PlayerData =
    require("data.entities.player")

local Arrow = {}
Arrow.__index = Arrow

-- Создаёт стрелу игрока.
function Arrow.new(assets, player)
    local self = setmetatable({}, Arrow)

    self.assets = assets

    self.x = player.x
    self.z = player.z
    self.height = ArrowData.height

    self.direction = player.facing

    local vector =
        PlayerData.directionVectors[
            self.direction
        ]

    self.velocityX =
        vector.x * ArrowData.speed

    self.velocityZ =
        vector.y * ArrowData.speed

    self.damage = ArrowData.damage

    self.collisionRadius =
        ArrowData.collisionRadius

    self.lifeTime = 0
    self.stateTime = 0

    self.state = "flying"
    self.active = true

    self.image =
        assets:getFileImage(
            ArrowData.images[
                self.direction
            ]
        )

    self.hitImages = {}

    for index, path in ipairs(
        ArrowData.hit.frames
    ) do
        self.hitImages[index] =
            assets:getFileImage(path)
    end

    return self
end

-- Проверяет возможность нанести урон.
function Arrow:canDamage()
    return
        self.active and
        self.state == "flying"
end

-- Запускает анимацию попадания.
function Arrow:hit(x, z)
    if not self:canDamage() then
        return
    end

    self.state = "hit"
    self.stateTime = 0

    self.x = x

    -- Чуть ближе к камере, чтобы эффект был поверх врага.
    self.z = z - 0.1

    self.velocityX = 0
    self.velocityZ = 0
end

-- Обновляет стрелу или эффект попадания.
function Arrow:update(dt)
    if not self.active then
        return
    end

    if self.state == "hit" then
        self.stateTime =
            self.stateTime + dt

        local duration =
            #ArrowData.hit.frames *
            ArrowData.hit.frameDuration

        if self.stateTime >= duration then
            self.active = false
        end

        return
    end

    self.lifeTime =
        self.lifeTime + dt

    if
        self.lifeTime >=
        ArrowData.lifetime
    then
        self.active = false
        return
    end

    self.x =
        self.x +
        self.velocityX * dt

    self.z =
        self.z +
        self.velocityZ * dt
end

-- Возвращает текущий кадр попадания.
function Arrow:getHitImage()
    local index =
        math.floor(
            self.stateTime /
            ArrowData.hit.frameDuration
        ) + 1

    index =
        math.min(
            index,
            #self.hitImages
        )

    return self.hitImages[index]
end

-- Рисует стрелу или попадание.
function Arrow:draw(
    projection,
    cameraX,
    cameraZ
)
    if not self.active then
        return
    end

    if not projection:isDepthVisible(
        self.z,
        cameraZ
    ) then
        return
    end

    local x, y, perspectiveScale =
        projection:project(
            self.x,
            self.z,
            cameraX,
            cameraZ
        )

    y =
        y -
        self.height *
        perspectiveScale

    local alpha =
        projection:getVisibilityAlpha(
            self.z,
            cameraZ
        )

    local image = self.image
    local spriteHeight =
        ArrowData.spriteHeight

    local spriteScaleMultiplier =
        ArrowData.scale

    if self.state == "hit" then
        image = self:getHitImage()

        spriteHeight =
            ArrowData.hit.spriteHeight

        spriteScaleMultiplier =
            ArrowData.hit.scale
    end

    if image then
        local spriteScale =
            perspectiveScale *
            spriteHeight /
            image:getHeight() *
            spriteScaleMultiplier

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
            image:getHeight() / 2
        )
    else
        self:drawPlaceholder(
            x,
            y,
            perspectiveScale,
            alpha
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует временный снаряд или попадание.
function Arrow:drawPlaceholder(
    x,
    y,
    scale,
    alpha
)
    if self.state == "hit" then
        love.graphics.setColor(
            0.9,
            0.78,
            0.38,
            alpha
        )

        love.graphics.circle(
            "line",
            x,
            y,
            18 * scale
        )

        return
    end

    love.graphics.setColor(
        0.76,
        0.63,
        0.34,
        alpha
    )

    love.graphics.line(
        x - 14 * scale,
        y,
        x + 14 * scale,
        y
    )
end

return Arrow