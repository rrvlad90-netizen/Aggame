local Assets = require("src.assets")
local Config = require("src.config")
local Registry = require("src.registry")
local UI = require("src.ui")
local Input = require("src.input")

local PlayerSelect = {}
PlayerSelect.__index = PlayerSelect

-- Создаёт экран выбора игрока.
function PlayerSelect:new(config)
    config = config or {}

    local select = setmetatable({}, PlayerSelect)

    select.id = config.id or "player_select"

    select.background = config.background
    select.musicPath = config.music
    select.music = Assets.getMusic(select.musicPath)

    select.characters = config.characters or {}
    select.selectedIndex = 1

    select.finished = false
    select.selectedPlayerId = nil

    return select
end

-- Запускает экран выбора.
function PlayerSelect:start()
    self.finished = false
    self.selectedPlayerId = nil
    self.selectedIndex = 1

    if self.music then
        self.music:stop()
        self.music:play()
    end
end

-- Останавливает экран выбора.
function PlayerSelect:stop()
    if self.music then
        self.music:stop()
    end
end

-- Возвращает id текущего выбранного персонажа.
function PlayerSelect:getCurrentPlayerId()
    return self.characters[self.selectedIndex]
end

-- Возвращает definition текущего игрока.
function PlayerSelect:getCurrentPlayerDefinition()
    local playerId = self:getCurrentPlayerId()

    if not playerId then
        return nil
    end

    return Registry.loadPlayer(playerId)
end

-- Переключает выбранного персонажа.
function PlayerSelect:moveSelection(direction)
    if #self.characters == 0 then
        return
    end

    self.selectedIndex = self.selectedIndex + direction

    if self.selectedIndex < 1 then
        self.selectedIndex = #self.characters
    elseif self.selectedIndex > #self.characters then
        self.selectedIndex = 1
    end
end

-- Подтверждает выбор персонажа.
function PlayerSelect:confirm()
    self.selectedPlayerId = self:getCurrentPlayerId()
    self.finished = true
end

-- Обновляет экран выбора.
function PlayerSelect:update(dt)
    if Input.wasPressed("left") then
        self:moveSelection(-1)
    end

    if Input.wasPressed("right") then
        self:moveSelection(1)
    end

    if Input.wasPressed("jump")
        or Input.wasPressed("shoot")
        or Input.wasPressed("melee")
    then
        self:confirm()
    end
end

-- Рисует фон экрана выбора.
function PlayerSelect:drawBackground()
    if self.background then
        local image = Assets.getImage(self.background)

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            image,
            0,
            0,
            0,
            Config.screen.width / image:getWidth(),
            Config.screen.height / image:getHeight()
        )

        return
    end

    love.graphics.clear(0.04, 0.04, 0.06)
end

-- Рисует портрет выбранного игрока.
function PlayerSelect:drawPortrait(playerDefinition)
    local portrait = playerDefinition and playerDefinition.portrait

    local boxW = 220
    local boxH = 260
    local boxX = Config.screen.width / 2 - boxW / 2
    local boxY = 160

    love.graphics.setColor(0.08, 0.08, 0.1, 0.9)
    love.graphics.rectangle("fill", boxX, boxY, boxW, boxH, 12, 12)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", boxX, boxY, boxW, boxH, 12, 12)

    if portrait then
        local image = Assets.getImage(portrait)

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            image,
            boxX + boxW / 2,
            boxY + boxH / 2,
            0,
            1,
            1,
            image:getWidth() / 2,
            image:getHeight() / 2
        )
    else
        love.graphics.setColor(0.2, 0.45, 0.9)
        love.graphics.rectangle("fill", boxX + 40, boxY + 40, boxW - 80, boxH - 80)

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(
            "NO PORTRAIT",
            boxX,
            boxY + boxH / 2 - 8,
            boxW,
            "center"
        )
    end
end

-- Рисует экран выбора игрока.
function PlayerSelect:draw()
    self:drawBackground()

    local playerDefinition = self:getCurrentPlayerDefinition()
    local playerName = playerDefinition and (playerDefinition.name or playerDefinition.id) or "Unknown"

    love.graphics.setFont(UI.bigFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        "SELECT PLAYER",
        0,
        70,
        Config.screen.width,
        "center"
    )

    self:drawPortrait(playerDefinition)

    love.graphics.setFont(UI.font)
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(
        "<    " .. tostring(playerName) .. "    >",
        0,
        440,
        Config.screen.width,
        "center"
    )

    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.printf(
        "Left/Right - change    Jump/Shoot/Melee - select",
        0,
        510,
        Config.screen.width,
        "center"
    )

    love.graphics.setColor(1, 1, 1)
end

-- Возвращает true, если выбор завершён.
function PlayerSelect:isFinished()
    return self.finished
end

return PlayerSelect