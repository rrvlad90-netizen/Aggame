local ForestEndMountain = {}
ForestEndMountain.__index = ForestEndMountain

function ForestEndMountain.new(
    assets,
    x,
    z,
    definition
)
    local self =
        setmetatable(
            {},
            ForestEndMountain
        )

    definition = definition or {}

    self.assets = assets
    self.x = x
    self.z = z

    self.active = true

    self.scale =
        definition.scale or 1

    self.spriteHeight =
        definition.spriteHeight or 680

    self.alpha =
        definition.alpha or 1

    self.offsetY =
        definition.offsetY or 0

    self.renderMargin =
        definition.renderMargin or 0

    self.image = nil

    if definition.image then
        self.image =
            assets:getFileImage(
                definition.image
            )
    end

    self.mockupWidth =
        definition.mockupWidth or 900

    self.mockupHeight =
        definition.mockupHeight or
        self.spriteHeight

    self.mockupColor =
        definition.mockupColor or {
            0.24,
            0.27,
            0.3,
            1
        }

    self.mockupDarkColor =
        definition.mockupDarkColor or {
            0.16,
            0.18,
            0.21,
            1
        }

    self.snowColor =
        definition.snowColor or {
            0.75,
            0.78,
            0.8,
            1
        }

    return self
end

-- Рисует PNG горы.
function ForestEndMountain:drawImage(
    image,
    x,
    y,
    perspectiveScale,
    alpha
)
    local scale =
        perspectiveScale *
        self.spriteHeight /
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
        y + self.offsetY * scale,
        0,
        scale,
        scale,
        image:getWidth() / 2,
        image:getHeight()
    )
end

-- Рисует временную гору без PNG.
function ForestEndMountain:drawMockup(
    x,
    y,
    perspectiveScale,
    alpha
)
    local scale =
        perspectiveScale *
        self.scale

    local width =
        self.mockupWidth *
        scale

    local height =
        self.mockupHeight *
        scale

    y =
        y +
        self.offsetY *
        scale

    local dark =
        self.mockupDarkColor

    love.graphics.setColor(
        dark[1] or 0.16,
        dark[2] or 0.18,
        dark[3] or 0.21,
        (dark[4] or 1) * alpha
    )

    -- Левая дальняя вершина.
    love.graphics.polygon(
        "fill",

        x - width * 0.72,
        y,

        x - width * 0.36,
        y - height * 0.62,

        x - width * 0.04,
        y
    )

    -- Правая дальняя вершина.
    love.graphics.polygon(
        "fill",

        x + width * 0.04,
        y,

        x + width * 0.39,
        y - height * 0.56,

        x + width * 0.72,
        y
    )

    local color =
        self.mockupColor

    love.graphics.setColor(
        color[1] or 0.24,
        color[2] or 0.27,
        color[3] or 0.3,
        (color[4] or 1) * alpha
    )

    -- Основная гора.
    love.graphics.polygon(
        "fill",

        x - width / 2,
        y,

        x,
        y - height,

        x + width / 2,
        y
    )

    local snow =
        self.snowColor

    love.graphics.setColor(
        snow[1] or 0.75,
        snow[2] or 0.78,
        snow[3] or 0.8,
        (snow[4] or 1) * alpha
    )

    -- Снежная вершина.
    love.graphics.polygon(
        "fill",

        x - width * 0.12,
        y - height * 0.76,

        x,
        y - height,

        x + width * 0.13,
        y - height * 0.74,

        x + width * 0.06,
        y - height * 0.79,

        x,
        y - height * 0.69,

        x - width * 0.05,
        y - height * 0.79
    )
end

function ForestEndMountain:draw(
    projection,
    cameraX,
    cameraZ
)
    if not self.active then
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
        projection:getVisibilityAlpha(
            self.z,
            cameraZ
        ) *
        self.alpha

    if alpha <= 0 then
        return
    end

    if self.image then
        self:drawImage(
            self.image,
            x,
            y,
            perspectiveScale,
            alpha
        )
    else
        self:drawMockup(
            x,
            y,
            perspectiveScale,
            alpha
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return ForestEndMountain