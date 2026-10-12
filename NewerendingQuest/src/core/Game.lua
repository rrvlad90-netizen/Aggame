local Hud = require("src.ui.Hud")
local Config = require("src.config")

local Assets = require("src.assets.Assets")
local Input = require("src.input.Input")
local Player = require("src.entities.Player")

local Projection =
    require("src.rendering.Projection")

local BiomeManager =
    require("src.world.BiomeManager")

local Game = {}
Game.__index = Game

-- Создаёт игру и загружает лёгкую кампанию.
function Game.new()
    local self = setmetatable({}, Game)

    self.canvas = love.graphics.newCanvas(
        Config.virtualWidth,
        Config.virtualHeight
    )

    self.assets = Assets.new()
    self.assets:load()

    self.input = Input.new()
	self.hud = Hud.new()

    self.projection = Projection.new(
        Config.projection
    )

    self.player = Player.new(
        self.assets
    )

    self.world = BiomeManager.new(
        self.projection,
        self.assets,
        self.player,
        "easy"
    )
	
	self.input:setControlProfile(
		self.world:getControlProfile()
	)

	self.controlHintLevelId =
		self.world:getLevelId()

	self.controlHintTimer = 3

    self.paused = false

    self:resize(
        love.graphics.getDimensions()
    )
	
	self.gameOverFade = 0

    return self
end

-- Обновляет игру и переходы.
function Game:update(dt)
	self.input:setControlProfile(
		self.world:getControlProfile()
	)
	
    self.input:update()

    if self.paused then
        return
    end

    if not self.world:isInputLocked() then
        self.player:update(
            dt,
            self.input,
            self.world
        )
    end

    self.world:update(
        dt,
        self.player
    )
	
	local currentLevelId =
		self.world:getLevelId()

	if
		currentLevelId ~=
		self.controlHintLevelId
	then
		self.controlHintLevelId =
			currentLevelId

		self.controlHintTimer = 3

	elseif
		not self.world:isInputLocked()
	then
		self.controlHintTimer =
			math.max(
				0,
				self.controlHintTimer - dt
			)
	end
	
	if self.player.gameOver then
		self.gameOverFade =
			math.min(
				1,
				self.gameOverFade +
				dt / 0.8
			)
	else
		self.gameOverFade = 0
end	
end

-- Рисует игровой кадр.
function Game:draw()
    love.graphics.setCanvas(
        self.canvas
    )

    love.graphics.clear(
        0.05,
        0.05,
        0.05,
        1
    )

	self.world:drawBackground()

    self.world:draw(
        self.player
    )

    self:drawHud()
	self:drawControlHint()
    self.input:draw()
	-- Переход рисуется поверх мира, HUD и кнопок.
	self.world:drawTransition()

	if
		self.player.gameOver or
		self.gameOverFade > 0
	then
		self:drawGameOverOverlay()
	end

    if self.paused then
        self:drawPauseOverlay()
    end

    love.graphics.setCanvas()
    love.graphics.clear(0, 0, 0, 1)

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(
        self.canvas,
        self.offsetX,
        self.offsetY,
        0,
        self.scale,
        self.scale
    )
end

function Game:drawControlHint()
	if self.world:isInputLocked() then
		return
	end
    if self.controlHintTimer <= 0 then
        return
    end

    local text =
        self.world:getControlHint()

    if not text then
        return
    end

    local alpha =
        math.min(
            1,
            self.controlHintTimer
        )

    local width = 520
    local height = 82

    local x =
        (
            Config.virtualWidth -
            width
        ) / 2

    local y = 150

    love.graphics.setColor(
        0.02,
        0.03,
        0.04,
        0.78 * alpha
    )

    love.graphics.rectangle(
        "fill",
        x,
        y,
        width,
        height,
        8,
        8
    )

    love.graphics.setColor(
        0.9,
        0.84,
        0.62,
        alpha
    )

    love.graphics.rectangle(
        "line",
        x,
        y,
        width,
        height,
        8,
        8
    )

    love.graphics.setColor(
        0.94,
        0.94,
        0.9,
        alpha
    )

    love.graphics.printf(
        text,
        x + 20,
        y + 20,
        width - 40,
        "center"
    )

    love.graphics.setColor(1, 1, 1, 1)
end

-- Затемняет экран и показывает Game Over.
function Game:drawGameOverOverlay()
    local alpha =
        self.gameOverFade

    love.graphics.setColor(
        0,
        0,
        0,
        alpha * 0.82
    )

    love.graphics.rectangle(
        "fill",
        0,
        0,
        Config.virtualWidth,
        Config.virtualHeight
    )

    love.graphics.setColor(
        1,
        1,
        1,
        alpha
    )

    self:drawCenteredText(
        "GAME OVER",
        Config.virtualHeight / 2
    )

    love.graphics.setColor(1, 1, 1, 1)
end

-- Рисует игровой интерфейс.
function Game:drawHud()
    self.hud:draw(
        self.player,
        self.world
    )
end

-- Рисует текст по центру экрана.
function Game:drawCenteredText(text, y)
    local font =
        love.graphics.getFont()

    love.graphics.print(
        text,
        Config.virtualWidth / 2 -
        font:getWidth(text) / 2,
        y
    )
end

-- Пересчитывает виртуальное разрешение.
function Game:resize(width, height)
    local scaleX =
        width /
        Config.virtualWidth

    local scaleY =
        height /
        Config.virtualHeight

    self.scale =
        math.min(scaleX, scaleY)

    self.offsetX =
        (
            width -
            Config.virtualWidth *
            self.scale
        ) / 2

    self.offsetY =
        (
            height -
            Config.virtualHeight *
            self.scale
        ) / 2

    self.input:setViewport(
        self.scale,
        self.offsetX,
        self.offsetY
    )
end

-- Передаёт касание системе управления.
function Game:touchpressed(
    id,
    x,
    y,
    pressure
)
    self.input:touchpressed(
        id,
        x,
        y
    )
end

-- Включает или выключает паузу.
function Game:setPaused(paused)
    self.paused = paused
end

-- Рисует затемнение паузы.
function Game:drawPauseOverlay()
    love.graphics.setColor(
        0,
        0,
        0,
        0.55
    )

    love.graphics.rectangle(
        "fill",
        0,
        0,
        Config.virtualWidth,
        Config.virtualHeight
    )

    love.graphics.setColor(1, 1, 1)

    self:drawCenteredText(
        "PAUSED",
        Config.virtualHeight / 2
    )
end

return Game