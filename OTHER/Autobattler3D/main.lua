local Game = require('src.game')

local game


-- Создаёт игру.
function lovr.load()
  math.randomseed(os.time())
  game = Game.new()
end


-- Обновляет игру.
function lovr.update(dt)
  game:update(dt)
end


-- Передаёт движение мыши.
function lovr.mousemoved(x, y, dx, dy)
  game:mousemoved(x, y, dx, dy)
end


-- Передаёт нажатие мыши.
function lovr.mousepressed(x, y, button)
  game:mousepressed(x, y, button)
end


-- Передаёт отпускание мыши.
function lovr.mousereleased(x, y, button)
  game:mousereleased(x, y, button)
end


-- Передаёт нажатие клавиши.
function lovr.keypressed(key, scancode, isRepeat)
  game:keypressed(key, isRepeat)
end


-- Передаёт изменение фокуса.
function lovr.focus(focused)
  game:focus(focused)
end


-- Рисует игру.
function lovr.draw(pass)
  game:draw(pass)
end