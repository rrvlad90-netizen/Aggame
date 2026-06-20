local Config = require("src.config")

local Viewport = {}

function Viewport.getWindowSize()
    return love.graphics.getWidth(), love.graphics.getHeight()
end

function Viewport.getScale()
    local windowW, windowH = Viewport.getWindowSize()

    return windowW / Config.screen.width,
        windowH / Config.screen.height
end

-- Переводит реальные координаты окна в игровые 800x600.
function Viewport.toVirtual(x, y)
    local scaleX, scaleY = Viewport.getScale()

    return x / scaleX, y / scaleY
end

-- Начинает рисование в виртуальных координатах.
function Viewport.begin()
    local scaleX, scaleY = Viewport.getScale()

    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)
end

-- Заканчивает рисование в виртуальных координатах.
function Viewport.finish()
    love.graphics.pop()
end

return Viewport