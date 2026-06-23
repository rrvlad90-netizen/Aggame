local Config = require("src.config")
local Collision = require("src.collision")

local Input = {}

Input.down = {}
Input.pressed = {}
Input.released = {}

Input.touchButtons = {}
Input.touchVisibleTimer = 0
Input.touchAlpha = Config.input.touchButtonAlpha

Input.defaultKeyBindings = {
    left = {"left", "a"},
    right = {"right", "d"},
    up = {"up", "w"},
    down = {"down", "s"},

    jump = {"space", "z"},
    shoot = {"x", "lctrl", "rctrl"},
    melee = {"c"},

    block = {"v"},
    strafe = {"lshift", "rshift"},

    pause = {"escape"},
    confirm = {"return"}
}

Input.keyBindings = {}

local function copyBindings(bindings)
    local result = {}

    for action, keys in pairs(bindings or {}) do
        result[action] = {}

        for _, key in ipairs(keys or {}) do
            table.insert(result[action], key)
        end
    end

    return result
end

-- Инициализирует input-состояние.
function Input.init()
    Input.down = {}
    Input.pressed = {}
    Input.released = {}

    Input.keyBindings = copyBindings(Input.defaultKeyBindings)

    Input.touchButtons = Input.createDefaultTouchButtons()
    Input.touchVisibleTimer = 0
end

-- Загружает клавиатурные бинды из save.
function Input.setKeyBindings(bindings)
    Input.keyBindings = copyBindings(Input.defaultKeyBindings)

    for action, keys in pairs(bindings or {}) do
        if type(keys) == "table" then
            Input.keyBindings[action] = copyBindings({value = keys}).value
        elseif type(keys) == "string" then
            Input.keyBindings[action] = {keys}
        end
    end
end

-- Возвращает текущие клавиатурные бинды.
function Input.getKeyBindings()
    return copyBindings(Input.keyBindings)
end

-- Сбрасывает бинды клавиатуры.
function Input.resetKeyBindings()
    Input.keyBindings = copyBindings(Input.defaultKeyBindings)
end

-- Назначает одну клавишу на action.
function Input.setKeyBinding(action, key)
    if not action or not key then
        return
    end

    -- Убираем эту клавишу из других action, чтобы не было конфликтов.
    for bindingAction, keys in pairs(Input.keyBindings) do
        for index = #keys, 1, -1 do
            if keys[index] == key then
                table.remove(keys, index)
            end
        end

        if #keys == 0 and bindingAction ~= action then
            Input.keyBindings[bindingAction] = {}
        end
    end

    Input.keyBindings[action] = {key}
end

-- Возвращает первую клавишу action для отображения в Options.
function Input.getPrimaryKey(action)
    local keys = Input.keyBindings[action]

    if not keys or #keys == 0 then
        return "-"
    end

    return keys[1]
end

-- Создаёт стандартные touch-кнопки.
function Input.createDefaultTouchButtons()
    local scale = Config.input.touchButtonScale
    local size = 50 * scale
    local gap = 10 * scale
    local margin = 16 * scale

    local screenW = Config.screen.width
    local screenH = Config.screen.height

    local topY = margin

    local bottomY = screenH - margin - size
    local upperY = bottomY - size - gap

    local leftX = margin
    local leftMidX = leftX + size + gap
    local leftRightX = leftX + (size + gap) * 2
    local leftExtraX = leftX + (size + gap) * 3

    local rightX = screenW - margin - size
    local rightMidX = rightX - size - gap
    local rightLeftX = rightX - (size + gap) * 2

    return {
        -- Левая часть экрана.
        {
            action = "up",
            x = leftMidX,
            y = upperY,
            w = size,
            h = size
        },
        {
            action = "left",
            x = leftX,
            y = bottomY,
            w = size,
            h = size
        },
        {
            action = "down",
            x = leftMidX,
            y = bottomY,
            w = size,
            h = size
        },
        {
            action = "right",
            x = leftRightX,
            y = bottomY,
            w = size,
            h = size
        },

        -- Правая часть экрана.
        {
            action = "block",
            x = rightX,
            y = upperY,
            w = size,
            h = size
        },
        {
            action = "strafe",
            x = rightMidX,
            y = upperY,
            w = size,
            h = size
        },
        {
            action = "jump",
            x = rightX,
            y = bottomY,
            w = size,
            h = size
        },
        {
            action = "shoot",
            x = rightMidX,
            y = bottomY,
            w = size,
            h = size
        },
        {
            action = "melee",
            x = rightLeftX,
            y = bottomY,
            w = size,
            h = size
        },

        -- Верхние кнопки справа.
        {
            action = "pause",
            x = rightX,
            y = topY,
            w = size,
            h = size
        },
        {
            action = "confirm",
            x = rightMidX,
            y = topY,
            w = size,
            h = size
        }
    }
end

-- Очищает Точпад
function Input.clear()
    Input.down = {}
    Input.pressed = {}
    Input.released = {}
end

-- Очищает события pressed/released.
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

-- Показывает touch-кнопки.
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

function Input.isDown(action)
    return Input.down[action] == true
end

function Input.wasPressed(action)
    return Input.pressed[action] == true
end

function Input.wasReleased(action)
    return Input.released[action] == true
end

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

function Input.getAimY()
    if Input.isDown("up") then
        return -1
    end

    if Input.isDown("down") then
        return 1
    end

    return 0
end

-- Возвращает action для клавиши.
function Input.keyToAction(key)
    for action, keys in pairs(Input.keyBindings or {}) do
        for _, bindingKey in ipairs(keys or {}) do
            if bindingKey == key then
                return action
            end
        end
    end

    return nil
end

function Input.keypressed(key)
    local action = Input.keyToAction(key)

    Input.press(action)
end

function Input.keyreleased(key)
    local action = Input.keyToAction(key)

    Input.release(action)
end

function Input.getTouchButtonAt(x, y)
    for _, button in ipairs(Input.touchButtons) do
        if Collision.pointInRect(x, y, button) then
            return button
        end
    end

    return nil
end

function Input.pointerPressed(x, y)
    Input.showTouchButtons()

    local button = Input.getTouchButtonAt(x, y)

    if button then
        Input.press(button.action)
        return true
    end

    return false
end

function Input.pointerReleased(x, y)
    local button = Input.getTouchButtonAt(x, y)

    if button then
        Input.release(button.action)
        return true
    end

    for _, touchButton in ipairs(Input.touchButtons) do
        Input.release(touchButton.action)
    end

    return false
end

function Input.mousepressed(x, y, button)
    if button == 1 then
        return Input.pointerPressed(x, y)
    end

    return false
end

function Input.mousereleased(x, y, button)
    if button == 1 then
        return Input.pointerReleased(x, y)
    end

    return false
end

function Input.touchpressed(id, x, y)
    return Input.pointerPressed(
        x * Config.screen.width,
        y * Config.screen.height
    )
end

function Input.touchreleased(id, x, y)
    return Input.pointerReleased(
        x * Config.screen.width,
        y * Config.screen.height
    )
end

return Input