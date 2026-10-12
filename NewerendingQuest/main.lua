local App = require("src.core.App")

local app

function love.load()
    love.graphics.setDefaultFilter(
        "nearest",
        "nearest"
    )

    app = App.new()
end

function love.update(dt)
    app:update(dt)
end

function love.draw()
    app:draw()
end

function love.keypressed(key)
    app:keypressed(key)
end

function love.mousemoved(x, y)
    app:mousemoved(x, y)
end

function love.mousepressed(x, y, button)
    app:mousepressed(x, y, button)
end

function love.touchpressed(
    id,
    x,
    y,
    dx,
    dy,
    pressure
)
    app:touchpressed(
        id,
        x,
        y,
        pressure
    )
end

function love.focus(focused)
    app:focus(focused)
end

function love.resize(width, height)
    app:resize(width, height)
end