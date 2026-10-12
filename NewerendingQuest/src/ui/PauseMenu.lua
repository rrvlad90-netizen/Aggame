local PauseMenu = {}
PauseMenu.__index = PauseMenu

local function contains(element, x, y)
    return
        x >= element.x and
        x <= element.x + element.width and
        y >= element.y and
        y <= element.y + element.height
end

function PauseMenu.new(app)
    local self = setmetatable({}, PauseMenu)

    self.app = app
    self.focusIndex = 1
    self.fadeProgress = 0
    self.confirmation = nil

    self.fonts = {
        title = love.graphics.newFont(42),
        button = love.graphics.newFont(22),
        dialog = love.graphics.newFont(20)
    }

    self.buttons = {
        {
            text = "Resume",

            action = function()
                self.app:resumeGame()
            end
        },
        {
            text = "Main Menu",

            action = function()
                self:showConfirmation(
                    "Return to the main menu?\nCurrent progress will be lost.",

                    function()
                        self.app:returnToMenu()
                    end
                )
            end
        },
        {
            text = "Exit",

            action = function()
                self:showConfirmation(
                    "Exit the game?\nCurrent progress will be lost.",

                    function()
                        love.event.quit()
                    end
                )
            end
        }
    }

    self.confirmButtons = {
        {
            text = "Yes"
        },
        {
            text = "No"
        }
    }

    self:layout(love.graphics.getDimensions())

    return self
end

function PauseMenu:enter()
    self.focusIndex = 1
    self.fadeProgress = 0
    self.confirmation = nil

    self:layout(love.graphics.getDimensions())
end

function PauseMenu:layout(width, height)
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
        (height - totalHeight) / 2 + 45

    for index, button in ipairs(self.buttons) do
        button.x = x
        button.y =
            startY +
            (index - 1) *
            (buttonHeight + spacing)

        button.width = buttonWidth
        button.height = buttonHeight
    end

    self.dialogWidth =
        math.min(520, width - 40)

    self.dialogHeight = 230
    self.dialogX =
        (width - self.dialogWidth) / 2

    self.dialogY =
        (height - self.dialogHeight) / 2

    local confirmWidth =
        (self.dialogWidth - 70) / 2

    for index, button in ipairs(
        self.confirmButtons
    ) do
        button.x =
            self.dialogX + 25 +
            (index - 1) *
            (confirmWidth + 20)

        button.y =
            self.dialogY +
            self.dialogHeight - 75

        button.width = confirmWidth
        button.height = 50
    end
end

function PauseMenu:showConfirmation(
    message,
    action
)
    self.confirmation = {
        message = message,
        action = action,

        -- "No" is selected by default.
        focusIndex = 2
    }
end

function PauseMenu:cancelConfirmation()
    self.confirmation = nil
end

function PauseMenu:confirmSelection()
    if not self.confirmation then
        return
    end

    local selected =
        self.confirmation.focusIndex

    if selected == 1 then
        local action =
            self.confirmation.action

        self.confirmation = nil

        if action then
            action()
        end
    else
        self:cancelConfirmation()
    end
end

function PauseMenu:update(dt)
    self.fadeProgress =
        math.min(
            1,
            self.fadeProgress + dt / 0.2
        )
end

function PauseMenu:moveFocus(direction)
    self.focusIndex =
        self.focusIndex + direction

    if self.focusIndex < 1 then
        self.focusIndex = #self.buttons
    elseif self.focusIndex > #self.buttons then
        self.focusIndex = 1
    end
end

function PauseMenu:activateFocused()
    local button =
        self.buttons[self.focusIndex]

    if button and button.action then
        button.action()
    end
end

function PauseMenu:drawButton(
    button,
    focused
)
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

function PauseMenu:drawConfirmation()
    if not self.confirmation then
        return
    end

    local width, height =
        love.graphics.getDimensions()

    love.graphics.setColor(
        0,
        0,
        0,
        0.68
    )

    love.graphics.rectangle(
        "fill",
        0,
        0,
        width,
        height
    )

    love.graphics.setColor(
        0.055,
        0.07,
        0.08,
        1
    )

    love.graphics.rectangle(
        "fill",
        self.dialogX,
        self.dialogY,
        self.dialogWidth,
        self.dialogHeight,
        10,
        10
    )

    love.graphics.setColor(
        0.9,
        0.72,
        0.35,
        1
    )

    love.graphics.rectangle(
        "line",
        self.dialogX,
        self.dialogY,
        self.dialogWidth,
        self.dialogHeight,
        10,
        10
    )

    love.graphics.setFont(self.fonts.dialog)
    love.graphics.setColor(
        0.92,
        0.92,
        0.88,
        1
    )

    love.graphics.printf(
        self.confirmation.message,
        self.dialogX + 30,
        self.dialogY + 42,
        self.dialogWidth - 60,
        "center"
    )

    for index, button in ipairs(
        self.confirmButtons
    ) do
        self:drawButton(
            button,
            index ==
            self.confirmation.focusIndex
        )
    end
end

function PauseMenu:draw()
    local width, height =
        love.graphics.getDimensions()

    love.graphics.setColor(
        0,
        0,
        0,
        0.72 * self.fadeProgress
    )

    love.graphics.rectangle(
        "fill",
        0,
        0,
        width,
        height
    )

    love.graphics.setFont(self.fonts.title)
    love.graphics.setColor(
        0.9,
        0.84,
        0.62,
        self.fadeProgress
    )

    love.graphics.printf(
        "PAUSED",
        0,
        height * 0.2,
        width,
        "center"
    )

    for index, button in ipairs(
        self.buttons
    ) do
        self:drawButton(
            button,
            index == self.focusIndex
        )
    end

    self:drawConfirmation()

    love.graphics.setColor(1, 1, 1, 1)
end

function PauseMenu:mousemoved(x, y)
    if self.confirmation then
        for index, button in ipairs(
            self.confirmButtons
        ) do
            if contains(button, x, y) then
                self.confirmation.focusIndex =
                    index

                return
            end
        end

        return
    end

    for index, button in ipairs(
        self.buttons
    ) do
        if contains(button, x, y) then
            self.focusIndex = index
            return
        end
    end
end

function PauseMenu:mousepressed(
    x,
    y,
    mouseButton
)
    if mouseButton ~= 1 then
        return
    end

    if self.confirmation then
        for index, button in ipairs(
            self.confirmButtons
        ) do
            if contains(button, x, y) then
                self.confirmation.focusIndex =
                    index

                self:confirmSelection()
                return
            end
        end

        return
    end

    for index, button in ipairs(
        self.buttons
    ) do
        if contains(button, x, y) then
            self.focusIndex = index

            if button.action then
                button.action()
            end

            return
        end
    end
end

function PauseMenu:keypressed(key)
    if self.confirmation then
        if
            key == "left" or
            key == "right" or
            key == "a" or
            key == "d"
        then
            self.confirmation.focusIndex =
                self.confirmation.focusIndex ==
                1 and 2 or 1

        elseif
            key == "return" or
            key == "kpenter" or
            key == "space"
        then
            self:confirmSelection()

        elseif key == "escape" then
            self:cancelConfirmation()
        end

        return
    end

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
        self.app:resumeGame()
    end
end

function PauseMenu:resize(width, height)
    self:layout(width, height)
end

return PauseMenu