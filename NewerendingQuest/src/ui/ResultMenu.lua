local ResultMenu = {}
ResultMenu.__index = ResultMenu

local function contains(button, x, y)
    return
        x >= button.x and
        x <= button.x + button.width and
        y >= button.y and
        y <= button.y + button.height
end

function ResultMenu.new(app)
    local self = setmetatable({}, ResultMenu)

    self.app = app
    self.resultType = "game_over"
    self.focusIndex = 1
    self.fadeProgress = 0
    self.buttons = {}

    self.fonts = {
        title = love.graphics.newFont(46),
        subtitle = love.graphics.newFont(18),
        button = love.graphics.newFont(22)
    }

    self:configure("game_over")
    self:layout(love.graphics.getDimensions())

    return self
end

function ResultMenu:configure(resultType)
    self.resultType = resultType
    self.focusIndex = 1
    self.fadeProgress = 0

    local firstButtonText =
        resultType == "victory" and
        "New Game" or
        "Retry"

    self.buttons = {
        {
            text = firstButtonText,

            action = function()
                self.app:startNewGame()
            end
        },
        {
            text = "Main Menu",

            action = function()
                self.app:returnToMenu()
            end
        },
        {
            text = "Exit",

            action = function()
                love.event.quit()
            end
        }
    }

    self:layout(love.graphics.getDimensions())
end

function ResultMenu:layout(width, height)
    local buttonWidth =
        math.min(400, width - 40)

    local buttonHeight = 62
    local spacing = 16

    local totalHeight =
        #self.buttons * buttonHeight +
        (#self.buttons - 1) * spacing

    local x =
        (width - buttonWidth) / 2

    local startY =
        (height - totalHeight) / 2 + 65

    for index, button in ipairs(self.buttons) do
        button.x = x
        button.y =
            startY +
            (index - 1) *
            (buttonHeight + spacing)

        button.width = buttonWidth
        button.height = buttonHeight
    end
end

function ResultMenu:update(dt)
    self.fadeProgress =
        math.min(
            1,
            self.fadeProgress + dt / 0.45
        )
end

function ResultMenu:moveFocus(direction)
    self.focusIndex =
        self.focusIndex + direction

    if self.focusIndex < 1 then
        self.focusIndex = #self.buttons
    elseif self.focusIndex > #self.buttons then
        self.focusIndex = 1
    end
end

function ResultMenu:activateFocused()
    local button =
        self.buttons[self.focusIndex]

    if button and button.action then
        button.action()
    end
end

function ResultMenu:drawButton(button, focused)
    if focused then
        love.graphics.setColor(
            0.25,
            0.34,
            0.30,
            0.98
        )
    else
        love.graphics.setColor(
            0.08,
            0.10,
            0.12,
            0.96
        )
    end

    love.graphics.rectangle(
        "fill",
        button.x,
        button.y,
        button.width,
        button.height,
        8,
        8
    )

    love.graphics.setColor(
        focused and 0.9 or 0.35,
        focused and 0.72 or 0.38,
        focused and 0.35 or 0.4,
        1
    )

    love.graphics.rectangle(
        "line",
        button.x,
        button.y,
        button.width,
        button.height,
        8,
        8
    )

    love.graphics.setFont(self.fonts.button)
    love.graphics.setColor(
        0.9,
        0.9,
        0.86,
        1
    )

    love.graphics.printf(
        button.text,
        button.x,
        button.y +
        (
            button.height -
            self.fonts.button:getHeight()
        ) / 2,
        button.width,
        "center"
    )
end

function ResultMenu:draw()
    local width, height =
        love.graphics.getDimensions()

    love.graphics.setColor(
        0,
        0,
        0,
        0.78 * self.fadeProgress
    )

    love.graphics.rectangle(
        "fill",
        0,
        0,
        width,
        height
    )

    local title
    local subtitle

    if self.resultType == "victory" then
        title = "CAMPAIGN COMPLETE"
        subtitle = "The journey is over... for now."

        love.graphics.setColor(
            0.9,
            0.84,
            0.62,
            self.fadeProgress
        )
    else
        title = "GAME OVER"
        subtitle = "Your journey has come to an end."

        love.graphics.setColor(
            0.78,
            0.24,
            0.20,
            self.fadeProgress
        )
    end

    love.graphics.setFont(self.fonts.title)

    love.graphics.printf(
        title,
        0,
        height * 0.17,
        width,
        "center"
    )

    love.graphics.setFont(self.fonts.subtitle)
    love.graphics.setColor(
        0.76,
        0.78,
        0.76,
        self.fadeProgress
    )

    love.graphics.printf(
        subtitle,
        0,
        height * 0.17 +
        self.fonts.title:getHeight() + 10,
        width,
        "center"
    )

    for index, button in ipairs(self.buttons) do
        self:drawButton(
            button,
            index == self.focusIndex
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function ResultMenu:mousemoved(x, y)
    for index, button in ipairs(self.buttons) do
        if contains(button, x, y) then
            self.focusIndex = index
            return
        end
    end
end

function ResultMenu:mousepressed(
    x,
    y,
    mouseButton
)
    if mouseButton ~= 1 then
        return
    end

    for index, button in ipairs(self.buttons) do
        if contains(button, x, y) then
            self.focusIndex = index

            if button.action then
                button.action()
            end

            return
        end
    end
end

function ResultMenu:keypressed(key)
    if key == "up" or key == "w" then
        self:moveFocus(-1)

    elseif key == "down" or key == "s" then
        self:moveFocus(1)

    elseif
        key == "return" or
        key == "kpenter" or
        key == "space"
    then
        self:activateFocused()

    elseif key == "escape" then
        self.app:returnToMenu()
    end
end

function ResultMenu:resize(width, height)
    self:layout(width, height)
end

return ResultMenu