local Config =
    require("src.config")

local ShieldData =
    require("data.items.shield")

local ShieldPickup = {}
ShieldPickup.__index = ShieldPickup

-- Создаёт подбираемый щит.
function ShieldPickup.new(
    assets,
    x,
    z
)
    local self =
        setmetatable(
            {},
            ShieldPickup
        )

    self.type = "shield_pickup"

    self.x = x
    self.z = z

    self.collected = false

    self.pickupRadius =
        ShieldData.pickupRadius *
        Config.worldUnitsPerMeter

    self.image =
        assets:getImage(
            ShieldData.imageKey
        )

    return self
end

-- Проверяет подбор щита.
function ShieldPickup:update(
    dt,
    player
)
    if self.collected then
        return
    end

    if not player:canPickupShield() then
        return
    end

    local dx =
        player.x - self.x

    local dz =
        player.z - self.z

    local radius =
        self.pickupRadius +
        player.collisionRadius

    if
        dx * dx + dz * dz <=
        radius * radius
    then
        player:equipShield()
        self.collected = true
    end
end

-- Рисует предмет щита.
function ShieldPickup:draw(
    projection,
    cameraX,
    cameraZ
)
    if self.collected then
        return
    end

    local x, y, perspectiveScale =
        projection:project(
            self.x,
            self.z,
            cameraX,
            cameraZ
        )

    local alpha =
        projection:
        getVisibilityAlpha(
            self.z,
            cameraZ
        ) *
        ShieldData.alpha

    if self.image then
        local spriteScale =
            perspectiveScale *
            ShieldData.spriteHeight /
            self.image:getHeight() *
            ShieldData.scale

        love.graphics.setColor(
            1,
            1,
            1,
            alpha
        )

        love.graphics.draw(
            self.image,
            x,
            y,
            0,
            spriteScale,
            spriteScale,
            self.image:getWidth() / 2,
            self.image:getHeight()
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

-- Рисует временный щит.
function ShieldPickup:drawPlaceholder(
    x,
    y,
    scale,
    alpha
)
    love.graphics.setColor(
        0.62,
        0.66,
        0.72,
        alpha
    )

    love.graphics.circle(
        "fill",
        x,
        y - 24 * scale,
        22 * scale
    )

    love.graphics.setColor(
        0.24,
        0.28,
        0.34,
        alpha
    )

    love.graphics.circle(
        "line",
        x,
        y - 24 * scale,
        22 * scale
    )
end

return ShieldPickup