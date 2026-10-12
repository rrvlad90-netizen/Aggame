local Config = require("src.config")

local EnemyShadow = {}

function EnemyShadow.draw(
    x,
    y,
    perspectiveScale,
    horizontalScale,
    visibilityAlpha,
    definition
)
    if
        type(definition) ~= "table" or
        definition.enabled == false
    then
        return
    end

    local radius =
        (definition.radius or 1) *
        Config.worldUnitsPerMeter

    local radiusX =
        radius *
        (
            horizontalScale or
            perspectiveScale or
            1
        )

    local radiusY =
        radiusX *
        (definition.aspect or 0.34)

    radiusX = math.max(radiusX, 2)
    radiusY = math.max(radiusY, 1)

    local color =
        definition.color or {
            0,
            0,
            0
        }

    local alpha =
        (definition.alpha or 0.3) *
        (visibilityAlpha or 1)

    love.graphics.setColor(
        color[1] or 0,
        color[2] or 0,
        color[3] or 0,
        alpha
    )

    love.graphics.ellipse(
        "fill",
        x,
        y - (definition.offsetY or 2),
        radiusX,
        radiusY
    )

    love.graphics.setColor(1, 1, 1, 1)
end

return EnemyShadow