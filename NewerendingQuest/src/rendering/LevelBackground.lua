local Config = require("src.config")

local LevelBackground = {}
LevelBackground.__index = LevelBackground

local layerOrder = {
    "sky",
    "mountains",
    "landscape",
    "trees"
}

local function clamp(value, minimum, maximum)
    return math.max(
        minimum,
        math.min(maximum, value)
    )
end

local function lerp(first, second, progress)
    return
        first +
        (second - first) *
        progress
end

local function smoothstep(progress)
    progress = clamp(progress, 0, 1)

    return
        progress *
        progress *
        (3 - 2 * progress)
end

function LevelBackground.new(assets)
    local self =
        setmetatable(
            {},
            LevelBackground
        )

    self.assets = assets

    self.definition = {}
    self.layers = {}

    self.time = 0
    self.levelProgress = 0

    self.approach = {}
    self.destinationMountain = nil

    return self
end

-- Загружает фон нового уровня.
function LevelBackground:configure(definition)
    self.definition = definition or {}
    self.layers = {}

    self.time = 0
    self.levelProgress = 0

    self.approach =
        self.definition.approach or {}

    for _, name in ipairs(
        layerOrder
    ) do
        local source =
            self.definition[name]

        if source then
            local layer = {
                name = name,
                image = nil,

                parallax =
                    source.parallax or 0,

                scale =
                    source.scale or 1,

                approachScale =
                    source.approachScale,

                approachParallax =
                    source.approachParallax,

                alpha =
                    source.alpha or 1,

                offset =
                    source.offset or {
                        x = 0,
                        y = 0
                    },

                align =
                    source.align or "bottom",

                repeatX =
                    source.repeatX ~= false,

                scrollSpeed =
                    source.scrollSpeed or 0
            }

            if source.image then
                layer.image =
                    self.assets:getFileImage(
                        source.image
                    )
            end

            self.layers[name] = layer
        end
    end

    self:configureDestinationMountain()
end

-- Загружает конечную гору.
function LevelBackground:
configureDestinationMountain()
    local definition =
        self.approach.destinationMountain

    if not definition then
        self.destinationMountain = nil
        return
    end

    self.destinationMountain = {
        image = nil,

        enabled =
            definition.enabled ~= false,

        startScale =
            definition.startScale or 0.45,

        endScale =
            definition.endScale or 1.65,

        baseY =
            definition.baseY or 310,

        alpha =
            definition.alpha or 1,

        parallax =
            definition.parallax or 0.04,

        offsetX =
            definition.offsetX or 0,

        mockupWidth =
            definition.mockupWidth or 540,

        mockupHeight =
            definition.mockupHeight or 260,

        mockupColor =
            definition.mockupColor or {
                0.24,
                0.27,
                0.3,
                1
            },

        mockupFarColor =
            definition.mockupFarColor or {
                0.18,
                0.21,
                0.24,
                1
            },

        snowColor =
            definition.snowColor or {
                0.72,
                0.76,
                0.78,
                1
            }
    }

    if definition.image then
        self.destinationMountain.image =
            self.assets:getFileImage(
                definition.image
            )
    end
end

-- Принимает прогресс прохождения уровня.
function LevelBackground:setProgress(progress)
    self.levelProgress =
        clamp(progress or 0, 0, 1)
end

function LevelBackground:update(dt)
    self.time = self.time + dt
end

-- Возвращает прогресс эффекта приближения.
function LevelBackground:getApproachProgress()
    if self.approach.enabled == false then
        return 0
    end

    local startProgress =
        self.approach.startProgress or 0

    local endProgress =
        self.approach.endProgress or 1

    local length =
        endProgress - startProgress

    if length <= 0 then
        return
            self.levelProgress >=
            endProgress and 1 or 0
    end

    local progress =
        (
            self.levelProgress -
            startProgress
        ) / length

    return smoothstep(progress)
end

function LevelBackground:getClearColor()
    local color =
        self.definition.clearColor or {
            0.42,
            0.7,
            0.9,
            1
        }

    return
        color[1] or 0,
        color[2] or 0,
        color[3] or 0,
        color[4] or 1
end

-- Возвращает множитель приближения слоя.
function LevelBackground:getLayerScaleMultiplier(
    layer,
    progress
)
    -- Небо никогда не приближается.
    if layer.name == "sky" then
        return 1
    end

    local multipliers =
        self.approach.layerScales or {}

    local target =
        layer.approachScale or
        multipliers[layer.name] or
        self.approach.scaleMultiplier or
        1

    return lerp(
        1,
        target,
        progress
    )
end

-- Возвращает изменение параллакса слоя.
function LevelBackground:getLayerParallaxMultiplier(
    layer,
    progress
)
    if layer.name == "sky" then
        return 1
    end

    local multipliers =
        self.approach.parallaxMultipliers or {}

    local target =
        layer.approachParallax or
        multipliers[layer.name] or
        self.approach.parallaxMultiplier or
        1

    return lerp(
        1,
        target,
        progress
    )
end

function LevelBackground:getLayerY(
    layer,
    imageHeight
)
    local offsetY =
        layer.offset.y or 0

    if layer.align == "top" then
        return offsetY
    end

    if layer.align == "center" then
        return
            Config.virtualHeight / 2 -
            imageHeight / 2 +
            offsetY
    end

    return
        Config.virtualHeight -
        imageHeight +
        offsetY
end

-- Рисует один слой.
function LevelBackground:drawLayer(
    layer,
    cameraX,
    approachProgress
)
    if not layer.image then
        return
    end

    local image = layer.image

    local scale =
        layer.scale *
        self:getLayerScaleMultiplier(
            layer,
            approachProgress
        )

    local width =
        image:getWidth() *
        scale

    local height =
        image:getHeight() *
        scale

    if width <= 0 or height <= 0 then
        return
    end

    local offsetX =
        layer.offset.x or 0

    local parallax =
        layer.parallax *
        self:getLayerParallaxMultiplier(
            layer,
            approachProgress
        )

    local movement =
        -cameraX * parallax +
        self.time *
        layer.scrollSpeed +
        offsetX

    local y =
        self:getLayerY(
            layer,
            height
        )

    love.graphics.setColor(
        1,
        1,
        1,
        layer.alpha
    )

    if layer.repeatX then
        local startX =
            movement % width -
            width

        for x = startX,
            Config.virtualWidth + width,
            width
        do
            love.graphics.draw(
                image,
                x,
                y,
                0,
                scale,
                scale
            )
        end
    else
        love.graphics.draw(
            image,
            movement,
            y,
            0,
            scale,
            scale
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует PNG конечной горы.
function LevelBackground:drawMountainImage(
    mountain,
    centerX,
    scale
)
    local image = mountain.image

    local width =
        image:getWidth() *
        scale

    local height =
        image:getHeight() *
        scale

    love.graphics.setColor(
        1,
        1,
        1,
        mountain.alpha
    )

    love.graphics.draw(
        image,
        centerX - width / 2,
        mountain.baseY - height,
        0,
        scale,
        scale
    )
end

-- Рисует временный мокап горы.
function LevelBackground:drawMountainMockup(
    mountain,
    centerX,
    scale
)
    local width =
        mountain.mockupWidth *
        scale

    local height =
        mountain.mockupHeight *
        scale

    local baseY =
        mountain.baseY

    local farColor =
        mountain.mockupFarColor

    love.graphics.setColor(
        farColor[1] or 0.18,
        farColor[2] or 0.21,
        farColor[3] or 0.24,
        (farColor[4] or 1) *
        mountain.alpha
    )

    -- Дальние боковые вершины.
    love.graphics.polygon(
        "fill",

        centerX - width * 0.72,
        baseY,

        centerX - width * 0.34,
        baseY - height * 0.64,

        centerX - width * 0.05,
        baseY
    )

    love.graphics.polygon(
        "fill",

        centerX + width * 0.02,
        baseY,

        centerX + width * 0.39,
        baseY - height * 0.58,

        centerX + width * 0.74,
        baseY
    )

    local color =
        mountain.mockupColor

    love.graphics.setColor(
        color[1] or 0.24,
        color[2] or 0.27,
        color[3] or 0.3,
        (color[4] or 1) *
        mountain.alpha
    )

    -- Основная вершина.
    love.graphics.polygon(
        "fill",

        centerX - width / 2,
        baseY,

        centerX,
        baseY - height,

        centerX + width / 2,
        baseY
    )

    local snow =
        mountain.snowColor

    love.graphics.setColor(
        snow[1] or 0.72,
        snow[2] or 0.76,
        snow[3] or 0.78,
        (snow[4] or 1) *
        mountain.alpha
    )

    -- Снежная вершина.
    love.graphics.polygon(
        "fill",

        centerX - width * 0.12,
        baseY - height * 0.76,

        centerX,
        baseY - height,

        centerX + width * 0.13,
        baseY - height * 0.74,

        centerX + width * 0.06,
        baseY - height * 0.78,

        centerX,
        baseY - height * 0.7,

        centerX - width * 0.05,
        baseY - height * 0.79
    )
end

-- Рисует гору у конца уровня.
function LevelBackground:drawDestinationMountain(
    cameraX,
    approachProgress
)
    local mountain =
        self.destinationMountain

    if
        not mountain or
        not mountain.enabled
    then
        return
    end

    local scale =
        lerp(
            mountain.startScale,
            mountain.endScale,
            approachProgress
        )

    local centerX =
        Config.virtualWidth / 2 +
        mountain.offsetX -
        cameraX *
        mountain.parallax *
        lerp(
            1,
            1.6,
            approachProgress
        )

    if mountain.image then
        self:drawMountainImage(
            mountain,
            centerX,
            scale
        )
    else
        self:drawMountainMockup(
            mountain,
            centerX,
            scale
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function LevelBackground:draw(cameraX)
    local red, green, blue, alpha =
        self:getClearColor()

    love.graphics.clear(
        red,
        green,
        blue,
        alpha
    )

    cameraX = cameraX or 0

    local progress =
        self:getApproachProgress()

    for _, name in ipairs(
        layerOrder
    ) do
        local layer =
            self.layers[name]

        if layer then
            self:drawLayer(
                layer,
                cameraX,
                progress
            )
        end

        -- Гора находится между дальними горами
        -- и ближними деревьями.
        if name == "mountains" then
            self:drawDestinationMountain(
                cameraX,
                progress
            )
        end
    end
end

return LevelBackground