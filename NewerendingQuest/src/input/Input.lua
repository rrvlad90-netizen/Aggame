local Config = require("src.config")

local Input = {}
Input.__index = Input

-- Создаёт систему клавиатурного и сенсорного управления.
function Input.new()
    local self = setmetatable({}, Input)

	self.lastHorizontalDirection = 0
	self.lastHorizontalTime = -math.huge

    self.scale = 1
    self.offsetX = 0
    self.offsetY = 0
    self.lastTouchTime = love.timer.getTime()

    self.currentActions = {}
    self.previousActions = {}

	self.doubleTapWindow = 0.28

	self.lastDirectionPress = {
		left = -math.huge,
		right = -math.huge,
		up = -math.huge,
		down = -math.huge
	}

	self.runningAction = nil

    self.buttons = {
        left =    { x = 60,   y = 610, radius = 42, label = "A" },
        right =   { x = 190,  y = 610, radius = 42, label = "D" },
        up =      { x = 125,  y = 545, radius = 42, label = "W" },
        down =    { x = 125,  y = 675, radius = 42, label = "S" },
        shield =  { x = 275,  y = 625, radius = 44, label = "BLK" },

        jumpNear = {
            x = 910,
            y = 640,
            radius = 40,
            label = "N"
        },

        jumpMedium = {
            x = 995,
            y = 575,
            radius = 40,
            label = "M"
        },

        jumpFar = {
            x = 1080,
            y = 510,
            radius = 40,
            label = "F"
        },

		ranged = {
			x = 1180,
			y = 525,
			radius = 44,
			label = "BOW"
		},

        melee = {
            x = 1180,
            y = 635,
            radius = 48,
            label = "ATK"
        }
    }

	self.controlProfile = nil

	self:setControlProfile({
		movement = "free",

		jumps = {
			"medium"
		},

		melee = true,
		ranged = true,
		shield = true
	})

    return self
end

function Input:setControlProfile(profile)
    if not profile then
        return
    end

    if self.controlProfile == profile then
        return
    end

    self.controlProfile = profile
    self:applyControlLayout()
end

function Input:hasJump(jumpType)
    local profile =
        self.controlProfile

    if not profile then
        return true
    end

    for _, configuredType in ipairs(
        profile.jumps or {}
    ) do
        if configuredType == jumpType then
            return true
        end
    end

    return false
end

function Input:isActionEnabled(action)
    local profile =
        self.controlProfile

    if not profile then
        return true
    end

    if action == "left" or action == "right" then
        return
            profile.movement == "free" or
            profile.movement == "direction_only"
    end

    if action == "up" or action == "down" then
        return profile.movement == "free"
    end

    if action == "jumpNear" then
        return self:hasJump("near")
    end

    if action == "jumpMedium" then
        return self:hasJump("medium")
    end

    if action == "jumpFar" then
        return self:hasJump("far")
    end

    if action == "melee" then
        return profile.melee == true
    end

    if action == "ranged" then
        return profile.ranged == true
    end

    if action == "shield" then
        return profile.shield == true
    end

    return true
end

function Input:applyControlLayout()
    local profile =
        self.controlProfile

    if
        profile and
        profile.movement ==
        "direction_only"
    then
        self.buttons.left.x = 90
        self.buttons.left.y = 625
        self.buttons.left.label = "LEFT"

        self.buttons.right.x = 210
        self.buttons.right.y = 625
        self.buttons.right.label = "RIGHT"

        self.buttons.jumpNear.x = 920
        self.buttons.jumpNear.y = 625
        self.buttons.jumpNear.label = "NEAR"

        self.buttons.jumpMedium.x = 1040
        self.buttons.jumpMedium.y = 625
        self.buttons.jumpMedium.label = "MID"

        self.buttons.jumpFar.x = 1160
        self.buttons.jumpFar.y = 625
        self.buttons.jumpFar.label = "FAR"

        return
    end

    self.buttons.left.x = 60
    self.buttons.left.y = 610
    self.buttons.left.label = "A"

    self.buttons.right.x = 190
    self.buttons.right.y = 610
    self.buttons.right.label = "D"

    self.buttons.up.x = 125
    self.buttons.up.y = 545
    self.buttons.up.label = "W"

    self.buttons.down.x = 125
    self.buttons.down.y = 675
    self.buttons.down.label = "S"

    self.buttons.shield.x = 275
    self.buttons.shield.y = 625
    self.buttons.shield.label = "BLK"

    self.buttons.jumpMedium.x = 970
    self.buttons.jumpMedium.y = 625
    self.buttons.jumpMedium.label = "JUMP"

    self.buttons.ranged.x = 1080
    self.buttons.ranged.y = 540
    self.buttons.ranged.label = "BOW"

    self.buttons.melee.x = 1180
    self.buttons.melee.y = 625
    self.buttons.melee.label = "ATK"
end

-- Обновляет преобразование координат экрана.
function Input:setViewport(scale, offsetX, offsetY)
    self.scale = scale
    self.offsetX = offsetX
    self.offsetY = offsetY
end

-- Преобразует координаты окна в виртуальные.
function Input:toVirtual(x, y)
    return
        (x - self.offsetX) / self.scale,
        (y - self.offsetY) / self.scale
end

-- Проверяет попадание точки в круглую кнопку.
function Input:isInsideButton(x, y, button)
    local dx = x - button.x
    local dy = y - button.y

    return dx * dx + dy * dy <= button.radius * button.radius
end

-- Запоминает сенсорную активность.
function Input:touchpressed(id, x, y)
    self.lastTouchTime = love.timer.getTime()
end

-- Устанавливает действие как активное.
function Input:setAction(action, active)
    if
        active and
        self:isActionEnabled(action)
    then
        self.currentActions[action] = true
    end
end

-- Собирает состояние клавиатуры.
function Input:readKeyboard()
    self:setAction("left", love.keyboard.isDown("a", "left"))
    self:setAction("right", love.keyboard.isDown("d", "right"))
    self:setAction("up", love.keyboard.isDown("w", "up"))
    self:setAction("down", love.keyboard.isDown("s", "down"))

	self:setAction( "jumpMedium",love.keyboard.isDown("x", "space"))

    self:setAction("jumpNear", love.keyboard.isDown("z"))
    self:setAction("jumpMedium", love.keyboard.isDown("x"))
    self:setAction("jumpFar", love.keyboard.isDown("c"))

    self:setAction("melee", love.keyboard.isDown("lctrl") or
    love.mouse.isDown(1))
    self:setAction("ranged", love.keyboard.isDown("lalt") or
    love.mouse.isDown(2))

    self:setAction(
        "shield",
        love.keyboard.isDown("lshift", "rshift")
    )
end

-- Собирает действия всех активных касаний.
function Input:readTouches()
    local touches = love.touch.getTouches()

    for _, id in ipairs(touches) do
        local physicalX, physicalY =
            love.touch.getPosition(id)

        local x, y = self:toVirtual(
            physicalX,
            physicalY
        )

        self.lastTouchTime = love.timer.getTime()

        for action, button in pairs(self.buttons) do
            if self:isInsideButton(x, y, button) then
                self:setAction(action, true)
            end
        end
    end
end

-- Обновляет состояния действий.
function Input:update()
    self.previousActions = self.currentActions
    self.currentActions = {}

    self:readKeyboard()
    self:readTouches()

    if self:keyboardIsActive() then
        self.lastTouchTime = -math.huge
    end
	
	self:updateHorizontalBuffer()
	self:updateRunning()	
end

-- Обновляет двойное нажатие направления.
function Input:updateRunning()
    local currentTime =
        love.timer.getTime()

    local directions = {
        "left",
        "right",
        "up",
        "down"
    }

    -- Отпускание второй кнопки прекращает бег.
    if
        self.runningAction and
        not self:isDown(
            self.runningAction
        )
    then
        self.runningAction = nil
    end

    for _, action in ipairs(
        directions
    ) do
        if self:wasPressed(action) then
            local previousTime =
                self.lastDirectionPress[
                    action
                ]

            local interval =
                currentTime -
                previousTime

            if
                interval <=
                self.doubleTapWindow
            then
                self.runningAction =
                    action

                -- Для следующего бега снова нужны два нажатия.
                self.lastDirectionPress[
                    action
                ] = -math.huge
            else
                self.lastDirectionPress[
                    action
                ] = currentTime
            end
        end
    end
end

-- Проверяет активный бег.
function Input:isRunning()
    if not self.runningAction then
        return false
    end

    if not self:isDown(
        self.runningAction
    ) then
        return false
    end

    local horizontal, vertical =
        self:getMovement()

    return
        horizontal ~= 0 or
        vertical ~= 0
end

-- Запоминает последнее боковое направление.
function Input:updateHorizontalBuffer()
    local left = self:isDown("left")
    local right = self:isDown("right")

    if left and not right then
        self.lastHorizontalDirection = -1
        self.lastHorizontalTime =
            love.timer.getTime()
    elseif right and not left then
        self.lastHorizontalDirection = 1
        self.lastHorizontalTime =
            love.timer.getTime()
    end
end

-- Возвращает недавно нажатое направление.
function Input:getBufferedHorizontalDirection(
    window
)
    local age =
        love.timer.getTime() -
        self.lastHorizontalTime

    if age <= (window or 0.15) then
        return self.lastHorizontalDirection
    end

    return 0
end

-- Проверяет, удерживается ли действие.
function Input:isDown(action)
    return self.currentActions[action] == true
end

-- Проверяет начало нажатия действия.
function Input:wasPressed(action)
    return
        self.currentActions[action] == true and
        self.previousActions[action] ~= true
end

-- Возвращает выбранный тип прыжка.
function Input:getPressedJump()
    if self:wasPressed("jumpNear") then
        return "near"
    end

    if self:wasPressed("jumpMedium") then
        return "medium"
    end

    if self:wasPressed("jumpFar") then
        return "far"
    end

    return nil
end

-- Проверяет начало дальней атаки.
function Input:getPressedRangedAttack()
    return self:wasPressed(
        "ranged"
    )
end

-- Проверяет начало ближней атаки.
function Input:getPressedMeleeAttack()
    return self:wasPressed(
        "melee"
    )
end

-- Возвращает направление движения.
function Input:getMovement()
    local horizontal = 0
    local vertical = 0

    if self:isDown("left") then
        horizontal = horizontal - 1
    end

    if self:isDown("right") then
        horizontal = horizontal + 1
    end

    if self:isDown("up") then
        vertical = vertical + 1
    end

    if self:isDown("down") then
        vertical = vertical - 1
    end

    if horizontal ~= 0 and vertical ~= 0 then
        local factor = 1 / math.sqrt(2)
        horizontal = horizontal * factor
        vertical = vertical * factor
    end

    return horizontal, vertical
end

-- Проверяет использование клавиатуры.
function Input:keyboardIsActive()
    return
        love.keyboard.isDown(
            "w", "a", "s", "d",
            "up", "down", "left", "right",
            "z", "x", "c",
            "lctrl", "lalt",
            "lshift", "rshift"
        )
end

-- Проверяет видимость сенсорных кнопок.
function Input:touchControlsAreVisible()
    return
        love.timer.getTime() -
        self.lastTouchTime <=
        Config.touch.hideDelay
end

-- Рисует сенсорные кнопки.
function Input:draw()
    if not self:touchControlsAreVisible() then
        return
    end

    for action, button in pairs(
        self.buttons
    ) do
        if self:isActionEnabled(action) then
            if self:isDown(action) then
                love.graphics.setColor(
                    0.3,
                    0.55,
                    0.8,
                    0.65
                )
            else
                love.graphics.setColor(
                    0.05,
                    0.05,
                    0.05,
                    0.42
                )
            end

            love.graphics.circle(
                "fill",
                button.x,
                button.y,
                button.radius
            )

            love.graphics.setColor(
                1,
                1,
                1,
                0.82
            )

            love.graphics.circle(
                "line",
                button.x,
                button.y,
                button.radius
            )

            local font =
                love.graphics.getFont()

            local textWidth =
                font:getWidth(button.label)

            local textHeight =
                font:getHeight()

            love.graphics.print(
                button.label,
                button.x - textWidth / 2,
                button.y - textHeight / 2
            )
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return Input