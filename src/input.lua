local Config = require("src.config")
local Collision = require("src.collision")

local Input = {}

Input.down = {}
Input.pressed = {}
Input.released = {}

Input.touchButtons = {}
Input.touchVisibleTimer = 0
Input.touchAlpha = Config.input.touchButtonAlpha

-- Инициализирует input-состояние.
function Input.init()
    Input.down = {}
    Input.pressed = {}
    Input.released = {}

    Input.touchButtons = Input.createDefaultTouchButtons()
    Input.touchVisibleTimer = 0
end

-- Создаёт стандартные touch-кнопки.
-- Картинки потом можно будет добавить через UI.
function Input.createDefaultTouchButtons()
    local scale = Config.input.touchButtonScale
    local size = 58 * scale
    local margin = 18 * scale

    local screenW = Config.screen.width
    local screenH = Config.screen.height

    return {
        {
            action = "left",
            x = margin,
            y = screenH - size - margin,
            w = size,
            h = size
        },
        {
            action = "right",
            x = margin + size + 12 * scale,
            y = screenH - size - margin,
            w = size,
            h = size
        },
        {
            action = "crouch",
            x = margin + (size + 12 * scale) * 2,
            y = screenH - size - margin,
            w = size,
            h = size
        },
        {
            action = "jump",
            x = screenW - margin - size,
            y = screenH - size - margin,
            w = size,
            h = size
        },
        {
            action = "shoot",
            x = screenW - margin - size * 2 - 12 * scale,
            y = screenH - size - margin,
            w = size,
            h = size
        },
        {
            action = "melee",
            x = screenW - margin - size * 3 - 24 * scale,
            y = screenH - size - margin,
            w = size,
            h = size
        },
        {
            action = "strafe",
            x = screenW - margin - size,
            y = screenH - size * 2 - margin - 12 * scale,
            w = size,
            h = size
        },
        {
            action = "pause",
            x = screenW - margin - size,
            y = margin,
            w = size,
            h = size
        }
    }
end

-- Очищает события pressed/released.
-- Вызывается в конце каждого кадра.
function Input.endFrame()
    Input.pressed = {}
    Input.released = {}
end

-- Обновляет таймер видимости touch-кнопок.
function Input.update(dt)
    if Input.touchVisibleTimer > 0 then
        Input.touchVisibleTimer = math.max(0, Input.touchVisibleTimer - dt)
    end
end

-- Показывает touch-кнопки на Config.input.touchHideDelay секунд.
function Input.showTouchButtons()
    Input.touchVisibleTimer = Config.input.touchHideDelay
end

-- Возвращает true, если touch-кнопки сейчас видимы.
function Input.areTouchButtonsVisible()
    return Input.touchVisibleTimer > 0
end

-- Помечает action как нажатый.
function Input.press(action)
    if not action then
        return
    end

    if not Input.down[action] then
        Input.pressed[action] = true
    end

    Input.down[action] = true
end

-- Помечает action как отпущенный.
function Input.release(action)
    if not action then
        return
    end

    if Input.down[action] then
        Input.released[action] = true
    end

    Input.down[action] = false
end

-- Возвращает true, если action удерживается.
function Input.isDown(action)
    return Input.down[action] == true
end

-- Возвращает true только в кадр нажатия action.
function Input.wasPressed(action)
    return Input.pressed[action] == true
end

-- Возвращает true только в кадр отпускания action.
function Input.wasReleased(action)
    return Input.released[action] == true
end

-- Возвращает горизонтальное направление движения.
function Input.getMoveDirection()
    local direction = 0

    if Input.isDown("left") then
        direction = direction - 1
    end

    if Input.isDown("right") then
        direction = direction + 1
    end

    return direction
end

-- Возвращает вертикальное направление для атак.
function Input.getAimY()
    if Input.isDown("up") then
        return -1
    end

    if Input.isDown("down") or Input.isDown("crouch") then
        return 1
    end

    return 0
end

-- Возвращает action для клавиши.
function Input.keyToAction(key)
    local map = {
        left = "left",
        a = "left",

        right = "right",
        d = "right",

        up = "up",
        w = "up",

        down = "down",
        s = "down",

        space = "jump",
        z = "jump",

        x = "shoot",
        lctrl = "shoot",
        rctrl = "shoot",

        c = "melee",
        lshift = "strafe",
        rshift = "strafe",

        escape = "pause"
    }

    return map[key]
end

-- Обрабатывает love.keypressed.
function Input.keypressed(key)
    local action = Input.keyToAction(key)

    Input.press(action)
end

-- Обрабатывает love.keyreleased.
function Input.keyreleased(key)
    local action = Input.keyToAction(key)

    Input.release(action)
end

-- Возвращает touch-кнопку под координатами x/y.
function Input.getTouchButtonAt(x, y)
    for _, button in ipairs(Input.touchButtons) do
        if Collision.pointInRect(x, y, button) then
            return button
        end
    end

    return nil
end

-- Обрабатывает нажатие мыши или touch.
function Input.pointerPressed(x, y)
    Input.showTouchButtons()

    local button = Input.getTouchButtonAt(x, y)

    if button then
        Input.press(button.action)
        return true
    end

    return false
end

-- Обрабатывает отпускание мыши или touch.
function Input.pointerReleased(x, y)
    local button = Input.getTouchButtonAt(x, y)

    if button then
        Input.release(button.action)
        return true
    end

    -- Если отпустили вне кнопки, отпускаем все touch actions.
    for _, touchButton in ipairs(Input.touchButtons) do
        Input.release(touchButton.action)
    end

    return false
end

-- Обрабатывает love.mousepressed.
function Input.mousepressed(x, y, button)
    if button == 1 then
        return Input.pointerPressed(x, y)
    end

    return false
end

-- Обрабатывает love.mousereleased.
function Input.mousereleased(x, y, button)
    if button == 1 then
        return Input.pointerReleased(x, y)
    end

    return false
end

-- Обрабатывает love.touchpressed.
function Input.touchpressed(id, x, y)
    return Input.pointerPressed(
        x * Config.screen.width,
        y * Config.screen.height
    )
end

-- Обрабатывает love.touchreleased.
function Input.touchreleased(id, x, y)
    return Input.pointerReleased(
        x * Config.screen.width,
        y * Config.screen.height
    )
end

return Input