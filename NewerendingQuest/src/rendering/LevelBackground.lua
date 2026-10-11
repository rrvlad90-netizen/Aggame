local Config = require("src.config")

local LevelBackground = {}
LevelBackground.__index = LevelBackground

local layerOrder = {
    "sky",
    "mountains",
    "landscape",
    "trees"
}

-- Создаёт отрисовщик фона текущего уровня.
function LevelBackground.new(assets)
    local self = setmetatable({}, LevelBackground)

    self.assets = assets

    self.definition = {}
    self.layers = {}
    self.time = 0

    return self
end

-- Загружает описание фона нового уровня.
function LevelBackground:configure(definition)
    self.definition = definition or {}
    self.layers = {}
    self.time = 0

    for _, name in ipairs(layerOrder) do
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
end

-- Обновляет самостоятельное движение слоёв.
function LevelBackground:update(dt)
    self.time = self.time + dt
end

-- Возвращает цвет очистки экрана.
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

-- Рассчитывает вертикальное положение слоя.
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

-- Рисует один повторяющийся слой.
function LevelBackground:drawLayer(
    layer,
    cameraX
)
    if not layer.image then
        return
    end

    local image = layer.image

    local scale =
        layer.scale

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

    local movement =
        -cameraX *
        layer.parallax +
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

    love.graphics.setColor(1, 1, 1)
end

-- Рисует фон текущего уровня.
function LevelBackground:draw(cameraX)
    local red, green, blue, alpha =
        self:getClearColor()

    love.graphics.clear(
        red,
        green,
        blue,
        alpha
    )

    for _, name in ipairs(layerOrder) do
        local layer =
            self.layers[name]

        if layer then
            self:drawLayer(
                layer,
                cameraX or 0
            )
        end
    end
end

return LevelBackground