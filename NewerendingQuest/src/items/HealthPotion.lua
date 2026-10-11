local Config =
    require("src.config")

local PotionData =
    require("data.items.health_potion")

local HealthPotion = {}
HealthPotion.__index = HealthPotion

-- Создаёт лечебный пузырёк.
function HealthPotion.new(
    assets,
    x,
    z,
    variantId,
    options
)
    local self =
        setmetatable(
            {},
            HealthPotion
        )

    options = options or {}

    self.type = "health_potion"

    self.x = x
    self.z = z

    self.variantId =
        variantId or "small"

    self.variant =
        PotionData.variants[
            self.variantId
        ] or
        PotionData.variants.small

    self.amount =
        self.variant.amount

    self.pickupRadius =
        PotionData.pickupRadius *
        Config.worldUnitsPerMeter

    self.revealRadius =
        PotionData.revealRadius *
        Config.worldUnitsPerMeter

    self.visible =
        options.visible ~= false

    self.isMonsterDrop =
        options.isMonsterDrop == true

    self.active = true
    self.collected = false

    self.image =
        assets:getFileImage(
            self.variant.image
        )

    return self
end

-- Обновляет видимость и подбор.
function HealthPotion:update(
    dt,
    player,
    cameraZ
)
    if
        not self.active or
        self.collected
    then
        return
    end

    if
        self.isMonsterDrop and
        cameraZ and
        self.z <
        cameraZ -
        Config.projection.visibleBehindDepth
    then
        self.active = false
        return
    end

    local dx =
        player.x - self.x

    local dz =
        player.z - self.z

    local distanceSquared =
        dx * dx + dz * dz

    if
        not self.visible and
        distanceSquared <=
        self.revealRadius *
        self.revealRadius
    then
        self.visible = true
    end

    if not self.visible then
        return
    end

    if
        player.health >=
        player.maxHealth
    then
        return
    end

    local radius =
        self.pickupRadius +
        player.collisionRadius

    if
        distanceSquared <=
        radius * radius
    then
        local added =
            player:addHealth(
                self.amount
            )

        if added > 0 then
            self.collected = true
            self.active = false
        end
    end
end

-- Рисует пузырёк.
function HealthPotion:draw(
    projection,
    cameraX,
    cameraZ
)
    if
        not self.active or
        self.collected or
        not self.visible
    then
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
        PotionData.alpha

    if self.image then
        local spriteScale =
            perspectiveScale *
            PotionData.spriteHeight /
            self.image:getHeight() *
            PotionData.scale

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
        love.graphics.setColor(
            0.8,
            0.12,
            0.18,
            alpha
        )

        love.graphics.circle(
            "fill",
            x,
            y - 12 * perspectiveScale,
            10 * perspectiveScale
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return HealthPotion