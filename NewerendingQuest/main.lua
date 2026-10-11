local Game = require("src.core.Game")

local game

-- Загружает игру и создаёт основные системы.
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    game = Game.new()
end

-- Обновляет состояние игры.
function love.update(dt)
    game:update(dt)
end

-- Рисует текущий кадр.
function love.draw()
    game:draw()
end

-- Передаёт нажатие сенсорного экрана системе управления.
function love.touchpressed(id, x, y, dx, dy, pressure)
    game:touchpressed(id, x, y, pressure)
end

-- Обрабатывает системные клавиши.
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

-- Ставит игру на паузу при потере фокуса.
function love.focus(focused)
    game:setPaused(not focused)
end

-- Обновляет масштаб при изменении окна.
function love.resize(width, height)
    game:resize(width, height)
end