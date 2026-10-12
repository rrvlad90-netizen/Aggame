local MainMenu = {}
MainMenu.__index = MainMenu

local function clamp(value)
    return math.max(0, math.min(1, value))
end

local function formatPercent(value)
    return tostring(
        math.floor(value * 100 + 0.5)
    ) .. "%"
end

local function contains(item, x, y)
    return
        x >= item.x and
        x <= item.x + item.width and
        y >= item.y and
        y <= item.y + item.height
end

function MainMenu.new(app)
    local self = setmetatable({}, MainMenu)

    self.app = app
    self.mode = "main"
    self.items = {}
    self.focusIndex = 1
    self.fadeProgress = 0

    self.fonts = {
        title = love.graphics.newFont(48),
        subtitle = love.graphics.newFont(18),
        button = love.graphics.newFont(22),
        small = love.graphics.newFont(16)
    }

    self:createMainItems()
    self:layout(love.graphics.getDimensions())

    return self
end

function MainMenu:createMainItems()
    self.mode = "main"

    self.items = {
        {
            type = "button",
            text = "New Game",
            enabled = true,

            action = function()
                self.app:startNewGame()
            end
        },
        {
            type = "button",
            text = "Continue",
            enabled = false
        },
        {
            type = "button",
            text = "Settings",
            enabled = true,

            action = function()
                self:showSettings()
            end
        },
        {
            type = "button",
            text = "Exit",
            enabled = true,

            action = function()
                love.event.quit()
            end
        }
    }

    self.focusIndex = 1
end

function MainMenu:createSettingsItems()
    self.mode = "settings"

    self.items = {
        {
            type = "slider",
            text = "Music Volume",
            key = "musicVolume",
            enabled = true
        },
        {
            type = "slider",
            text = "Sound Volume",
            key = "effectsVolume",
            enabled = true
        },
        {
            type = "button",
            text = "Back",
            enabled = true,

            action = function()
                self:closeSettings()
            end
        }
    }

    self.focusIndex = 1
end

function MainMenu:showSettings()
    self:createSettingsItems()
    self:layout(love.graphics.getDimensions())
end

function MainMenu:closeSettings()
    self.app:saveSettings()
    self:createMainItems()
    self:layout(love.graphics.getDimensions())
end

function MainMenu:enter()
    self.fadeProgress = 0
    self:createMainItems()
    self:layout(love.graphics.getDimensions())
end

function MainMenu:layout(width, height)
    local itemWidth =
        math.min(440, width - 40)

    local itemHeight = 62
    local spacing = 16

    local totalHeight =
        #self.items * itemHeight +
        (#self.items - 1) * spacing

    local startY =
        math.max(
            height * 0.38,
            height - totalHeight - 55
        )

    local x =
        (width - itemWidth) / 2

    for index, item in ipairs(self.items) do
        item.x = x
        item.y =
            startY +
            (index - 1) *
            (itemHeight + spacing)

        item.width = itemWidth
        item.height = itemHeight
    end
end

function MainMenu:moveFocus(direction)
    local index = self.focusIndex

    for _ = 1, #self.items do
        index = index + direction

        if index < 1 then
            index = #self.items
        elseif index > #self.items then
            index = 1
        end

        if self.items[index].enabled ~= false then
            self.focusIndex = index
            return
        end
    end
end

function MainMenu:activateFocused()
    local item =
        self.items[self.focusIndex]

    if
        not item or
        item.enabled == false
    then
        return
    end

    if item.type == "button" and item.action then
        item.action()
    end
end

function MainMenu:changeSlider(item, direction)
    if not item or item.type ~= "slider" then
        return
    end

    local value =
        self.app.settings[item.key] or 0

    value =
        clamp(
            value + direction * 0.05
        )

    self.app.settings[item.key] = value
    self.app:applyAudioSettings()
end

function MainMenu:setSliderFromMouse(item, x)
    local padding = 24
    local startX = item.x + padding
    local width = item.width - padding * 2

    local value =
        clamp(
            (x - startX) / width
        )

    value =
        math.floor(value * 20 + 0.5) / 20

    self.app.settings[item.key] = value
    self.app:applyAudioSettings()
end

function MainMenu:update(dt)
    self.fadeProgress =
        math.min(
            1,
            self.fadeProgress + dt / 0.35
        )
end

function MainMenu:drawBackground()
    local width, height =
        love.graphics.getDimensions()

    love.graphics.clear(
        0.025,
        0.035,
        0.055,
        1
    )

    love.graphics.setColor(
        0.08,
        0.15,
        0.18,
        1
    )

    love.graphics.circle(
        "fill",
        width * 0.15,
        height * 0.2,
        height * 0.35
    )

    love.graphics.setColor(
        0.09,
        0.08,
        0.16,
        1
    )

    love.graphics.circle(
        "fill",
        width * 0.85,
        height * 0.82,
        height * 0.42
    )
end

function MainMenu:drawTitle()
    local width, height =
        love.graphics.getDimensions()

    love.graphics.setFont(self.fonts.title)
    love.graphics.setColor(
        0.9,
        0.84,
        0.62,
        1
    )

    love.graphics.printf(
        "NEWER ENDING QUEST",
        0,
        height * 0.12,
        width,
        "center"
    )

    love.graphics.setFont(self.fonts.subtitle)
    love.graphics.setColor(
        0.68,
        0.72,
        0.76,
        1
    )

    local subtitle =
        self.mode == "settings" and
        "Settings" or
        "Journey Through Forgotten Lands"

    love.graphics.printf(
        subtitle,
        0,
        height * 0.12 +
        self.fonts.title:getHeight() + 10,
        width,
        "center"
    )
end

function MainMenu:drawButton(item, focused)
    if item.enabled == false then
        love.graphics.setColor(
            0.12,
            0.13,
            0.15,
            0.72
        )
    elseif focused then
        love.graphics.setColor(
            0.25,
            0.34,
            0.30,
            0.96
        )
    else
        love.graphics.setColor(
            0.10,
            0.13,
            0.15,
            0.94
        )
    end

    love.graphics.rectangle(
        "fill",
        item.x,
        item.y,
        item.width,
        item.height,
        8,
        8
    )

    if focused and item.enabled ~= false then
        love.graphics.setColor(
            0.9,
            0.72,
            0.35,
            1
        )
    else
        love.graphics.setColor(
            0.32,
            0.35,
            0.36,
            1
        )
    end

    love.graphics.rectangle(
        "line",
        item.x,
        item.y,
        item.width,
        item.height,
        8,
        8
    )

    love.graphics.setFont(self.fonts.button)

    if item.enabled == false then
        love.graphics.setColor(
            0.43,
            0.45,
            0.46,
            1
        )
    else
        love.graphics.setColor(
            0.9,
            0.9,
            0.86,
            1
        )
    end

    love.graphics.printf(
        item.text,
        item.x,
        item.y +
        (
            item.height -
            self.fonts.button:getHeight()
        ) / 2,
        item.width,
        "center"
    )
end

function MainMenu:drawSlider(item, focused)
    love.graphics.setColor(
        focused and 0.17 or 0.10,
        focused and 0.22 or 0.13,
        focused and 0.20 or 0.15,
        0.96
    )

    love.graphics.rectangle(
        "fill",
        item.x,
        item.y,
        item.width,
        item.height,
        8,
        8
    )

    local value =
        self.app.settings[item.key] or 0

    love.graphics.setFont(self.fonts.small)
    love.graphics.setColor(
        0.9,
        0.9,
        0.86,
        1
    )

    love.graphics.print(
        item.text,
        item.x + 24,
        item.y + 10
    )

    local percent =
        formatPercent(value)

    love.graphics.print(
        percent,
        item.x + item.width -
        self.fonts.small:getWidth(percent) - 24,
        item.y + 10
    )

    local barX = item.x + 24
    local barY = item.y + item.height - 17
    local barWidth = item.width - 48

    love.graphics.setColor(
        0.2,
        0.22,
        0.23,
        1
    )

    love.graphics.rectangle(
        "fill",
        barX,
        barY,
        barWidth,
        6,
        3,
        3
    )

    love.graphics.setColor(
        0.9,
        0.68,
        0.28,
        1
    )

    love.graphics.rectangle(
        "fill",
        barX,
        barY,
        barWidth * value,
        6,
        3,
        3
    )

    love.graphics.circle(
        "fill",
        barX + barWidth * value,
        barY + 3,
        8
    )
end

function MainMenu:draw()
    self:drawBackground()
    self:drawTitle()

    for index, item in ipairs(self.items) do
        local focused =
            index == self.focusIndex

        if item.type == "slider" then
            self:drawSlider(item, focused)
        else
            self:drawButton(item, focused)
        end
    end

    if self.fadeProgress < 1 then
        love.graphics.setColor(
            0,
            0,
            0,
            1 - self.fadeProgress
        )

        love.graphics.rectangle(
            "fill",
            0,
            0,
            love.graphics.getDimensions()
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function MainMenu:mousemoved(x, y)
    for index, item in ipairs(self.items) do
        if
            item.enabled ~= false and
            contains(item, x, y)
        then
            self.focusIndex = index
            return
        end
    end
end

function MainMenu:mousepressed(x, y, button)
    if button ~= 1 then
        return
    end

    for index, item in ipairs(self.items) do
        if
            item.enabled ~= false and
            contains(item, x, y)
        then
            self.focusIndex = index

            if item.type == "slider" then
                self:setSliderFromMouse(item, x)
            elseif item.action then
                item.action()
            end

            return
        end
    end
end

function MainMenu:keypressed(key)
    if key == "up" or key == "w" then
        self:moveFocus(-1)

    elseif key == "down" or key == "s" then
        self:moveFocus(1)

    elseif key == "left" or key == "a" then
        self:changeSlider(
            self.items[self.focusIndex],
            -1
        )

    elseif key == "right" or key == "d" then
        self:changeSlider(
            self.items[self.focusIndex],
            1
        )

    elseif
        key == "return" or
        key == "kpenter" or
        key == "space"
    then
        self:activateFocused()

    elseif key == "escape" then
        if self.mode == "settings" then
            self:closeSettings()
        else
            love.event.quit()
        end
    end
end

function MainMenu:resize(width, height)
    self:layout(width, height)
end

return MainMenu