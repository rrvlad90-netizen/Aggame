local FireballData =
    require("data.projectiles.wyvern_fireball")

local WyvernFireball = {}
WyvernFireball.__index = WyvernFireball

-- Создаёт снаряд виверны.
function WyvernFireball.new(
    assets,
    definition
)
    local self =
        setmetatable(
            {},
            WyvernFireball
        )

    self.type = "enemy_projectile"

    self.x = definition.x
    self.z = definition.z

    self.sourceX =
        definition.x

    self.sourceZ =
        definition.z

    self.height =
        FireballData.height

    local dx =
        definition.targetX -
        definition.x

    local dz =
        definition.targetZ -
        definition.z

    local distance =
        math.sqrt(
            dx * dx + dz * dz
        )

    if distance < 0.001 then
        dx = 0
        dz = 1
        distance = 1
    end

    self.velocityX =
        dx / distance *
        FireballData.speed

    self.velocityZ =
        dz / distance *
        FireballData.speed

    self.damage =
        FireballData.damage

    self.collisionRadius =
        FireballData.collisionRadius

    self.state = "flying"
    self.stateTime = 0
    self.lifeTime = 0

    self.active = true

    self.image =
        assets:getFileImage(
            FireballData.image
        )

    self.hitImages = {}

    for index, path in ipairs(
        FireballData.hit.frames
    ) do
        self.hitImages[index] =
            assets:getFileImage(path)
    end

    return self
end

-- Проверяет возможность нанести урон.
function WyvernFireball:canDamage()
    return
        self.active and
        self.state == "flying"
end

-- Проверяет столкновение с игроком.
function WyvernFireball:isHitPlayer(player)
    if not self:canDamage() then
        return false
    end

    local dx =
        player.x - self.x

    local dz =
        player.z - self.z

    local radius =
        player.collisionRadius +
        self.collisionRadius

    return
        dx * dx + dz * dz <=
        radius * radius
end

-- Запускает эффект попадания.
function WyvernFireball:hit(
    x,
    z
)
    if not self.active then
        return
    end

    self.state = "hit"
    self.stateTime = 0

    self.x = x
    self.z = z - 0.1

    self.velocityX = 0
    self.velocityZ = 0
end

-- Обновляет снаряд.
function WyvernFireball:update(dt)
    if not self.active then
        return
    end

    if self.state == "hit" then
        self.stateTime =
            self.stateTime + dt

        local duration =
            #FireballData.hit.frames *
            FireballData.hit.frameDuration

        if self.stateTime >= duration then
            self.active = false
        end

        return
    end

    self.lifeTime =
        self.lifeTime + dt

    if
        self.lifeTime >=
        FireballData.lifetime
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

-- Возвращает кадр попадания.
function WyvernFireball:getHitImage()
    local index =
        math.floor(
            self.stateTime /
            FireballData.hit.frameDuration
        ) + 1

    index =
        math.min(
            index,
            #self.hitImages
        )

    return self.hitImages[index]
end

-- Рисует снаряд.
function WyvernFireball:draw(
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
        FireballData.spriteHeight

    local spriteScaleMultiplier =
        FireballData.scale

    if self.state == "hit" then
        image =
            self:getHitImage()

        spriteHeight =
            FireballData.hit.spriteHeight

        spriteScaleMultiplier =
            FireballData.hit.scale
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
        love.graphics.setColor(
            0.9,
            0.24,
            0.08,
            alpha
        )

        love.graphics.circle(
            "fill",
            x,
            y,
            10 * perspectiveScale
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return WyvernFireball