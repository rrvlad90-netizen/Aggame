local Config =
    require("src.config")

local PortalData =
    require("data.entities.portal")

local Animator =
    require("src.animation.Animator")

local Portal = {}
Portal.__index = Portal

-- Создаёт портал.
function Portal.new(
    assets,
    x,
    z,
    definition
)
    local self =
        setmetatable({}, Portal)

    definition = definition or {}

    self.type = "portal"

    self.x = x
    self.z = z

    self.destination =
        definition.destination or {
            type = "next"
        }

    self.activationRadius =
        (
            definition.activationRadius or
            PortalData.activationRadius
        ) *
        Config.worldUnitsPerMeter

    self.scale =
        definition.scale or
        PortalData.scale

    self.alpha =
        definition.alpha or
        PortalData.alpha

    self.activated = false

    self.animator =
        Animator.new(
            assets,
            PortalData.animations,
            "idle"
        )

    return self
end

-- Обновляет анимацию и проверяет игрока.
function Portal:update(dt, player)
    self.animator:update(dt)

    if self.activated then
        return
    end

    if player.state ~= "grounded" then
        return
    end

    local dx =
        player.x - self.x

    local dz =
        player.z - self.z

    local radius =
        self.activationRadius +
        player.collisionRadius

    if
        dx * dx +
        dz * dz <=
        radius * radius
    then
        self.activated = true
    end
end

-- Проверяет активацию портала.
function Portal:isActivated()
    return self.activated
end

-- Возвращает назначение портала.
function Portal:getDestination()
    return self.destination
end

-- Рисует портал.
function Portal:draw(
    projection,
    cameraX,
    cameraZ
)
    local x, y, perspectiveScale =
        projection:project(
            self.x,
            self.z,
            cameraX,
            cameraZ
        )

    local alpha =
        projection:getVisibilityAlpha(
            self.z,
            cameraZ
        ) *
        self.alpha

    local image =
        self.animator:
        getCurrentImage()

    if image then
        local spriteScale =
            perspectiveScale *
            PortalData.spriteHeight /
            image:getHeight() *
            self.scale

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
        self:drawPlaceholder(
            x,
            y,
            perspectiveScale,
            alpha
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует портал без PNG.
function Portal:drawPlaceholder(
    x,
    y,
    scale,
    alpha
)
    love.graphics.setColor(
        0.28,
        0.14,
        0.72,
        alpha * 0.55
    )

    love.graphics.ellipse(
        "fill",
        x,
        y - 58 * scale,
        38 * scale,
        62 * scale
    )

    love.graphics.setColor(
        0.72,
        0.48,
        1,
        alpha
    )

    love.graphics.ellipse(
        "line",
        x,
        y - 58 * scale,
        38 * scale,
        62 * scale
    )
end

return Portal