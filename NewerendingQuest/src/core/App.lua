local Game = require("src.core.Game")
local Settings = require("src.core.Settings")
local MainMenu = require("src.ui.MainMenu")
local PauseMenu = require("src.ui.PauseMenu")
local ResultMenu = require("src.ui.ResultMenu")
local SoundCache = require("src.audio.SoundCache")

local App = {}
App.__index = App

function App.new()
    local self = setmetatable({}, App)

    self.state = "menu"
    self.game = nil
    self.settings = Settings.load()

    self:applyAudioSettings()

    self.menu = MainMenu.new(self)
    self.pauseMenu = PauseMenu.new(self)
    self.resultMenu = ResultMenu.new(self)

    self.menu:enter()

    return self
end

function App:startNewGame()
    self.game = Game.new()
    self.state = "playing"
    self.game:setPaused(false)
end

function App:pauseGame()
    if
        self.state ~= "playing" or
        not self.game
    then
        return
    end

    -- App stops updating the game while paused.
    self.state = "paused"
    self.pauseMenu:enter()
end

function App:resumeGame()
    if not self.game then
        return
    end

    self.game:setPaused(false)
    self.state = "playing"
end

function App:returnToMenu()
    self.game = nil
    self.state = "menu"
    self.menu:enter()
end

function App:showResult(resultType)
    if self.state ~= "playing" then
        return
    end

    self.state = "result"
    self.resultMenu:configure(resultType)
end

function App:checkGameResult()
    if not self.game then
        return
    end

    if self.game.player.gameOver then
        self:showResult("game_over")
        return
    end

    if self.game.world:isCompleted() then
        self:showResult("victory")
    end
end

function App:applyAudioSettings()
    SoundCache:setVolume(
        self.settings.effectsVolume
    )

    if self.musicSource then
        self.musicSource:setVolume(
            self.settings.musicVolume
        )
    end
end

function App:saveSettings()
    Settings.save(self.settings)
end

function App:update(dt)
    if self.state == "playing" and self.game then
        self.game:update(dt)
        self:checkGameResult()

    elseif self.state == "paused" then
        self.pauseMenu:update(dt)

    elseif self.state == "result" then
        self.resultMenu:update(dt)

    else
        self.menu:update(dt)
    end
end

function App:draw()
    if self.state == "playing" and self.game then
        self.game:draw()

    elseif self.state == "paused" and self.game then
        self.game:draw()
        self.pauseMenu:draw()

    elseif self.state == "result" and self.game then
        self.game:draw()
        self.resultMenu:draw()

    else
        self.menu:draw()
    end
end

function App:keypressed(key)
    if self.state == "playing" then
        if key == "escape" then
            self:pauseGame()
        end

    elseif self.state == "paused" then
        self.pauseMenu:keypressed(key)

    elseif self.state == "result" then
        self.resultMenu:keypressed(key)

    else
        self.menu:keypressed(key)
    end
end

function App:mousemoved(x, y)
    if self.state == "paused" then
        self.pauseMenu:mousemoved(x, y)

    elseif self.state == "result" then
        self.resultMenu:mousemoved(x, y)

    elseif self.state == "menu" then
        self.menu:mousemoved(x, y)
    end
end

function App:mousepressed(x, y, button)
    if self.state == "paused" then
        self.pauseMenu:mousepressed(
            x,
            y,
            button
        )

    elseif self.state == "result" then
        self.resultMenu:mousepressed(
            x,
            y,
            button
        )

    elseif self.state == "menu" then
        self.menu:mousepressed(
            x,
            y,
            button
        )
    end
end

function App:touchpressed(id, x, y, pressure)
    if self.state == "playing" and self.game then
        self.game:touchpressed(
            id,
            x,
            y,
            pressure
        )

    elseif self.state == "paused" then
        self.pauseMenu:mousepressed(
            x,
            y,
            1
        )

    elseif self.state == "result" then
        self.resultMenu:mousepressed(
            x,
            y,
            1
        )

    else
        self.menu:mousepressed(
            x,
            y,
            1
        )
    end
end

function App:focus(focused)
    if
        not focused and
        self.state == "playing"
    then
        self:pauseGame()
    end
end

function App:resize(width, height)
    self.menu:resize(width, height)
    self.pauseMenu:resize(width, height)
    self.resultMenu:resize(width, height)

    if self.game then
        self.game:resize(width, height)
    end
end

return App