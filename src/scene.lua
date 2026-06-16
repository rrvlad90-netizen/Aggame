local Assets = require("src.assets")
local Config = require("src.config")
local UI = require("src.ui")

local Scene = {}
Scene.__index = Scene

-- Нормализует описание следующего перехода.
-- Поддерживает next = { type = "...", id = "..." }, nextScene и nextLevel.
local function normalizeNextTarget(config)
    if config.next then
        return config.next
    end

    if config.nextScene or config.next_scene then
        return {
            type = "scene",
            id = config.nextScene or config.next_scene
        }
    end

    if config.nextLevel or config.next_level then
        return {
            type = "level",
            id = config.nextLevel or config.next_level
        }
    end

    return nil
end

-- Создаёт scene из definition.
-- Scene используется для intro, briefing, victory/game over.
function Scene:new(config)
    config = config or {}

    local scene = setmetatable({}, Scene)

    scene.id = config.id or "scene"

    scene.musicPath = config.music
    scene.music = Assets.getMusic(scene.musicPath)

    scene.frames = config.frames or {}
    scene.skipAllowed = config.skipAllowed ~= false
        and config.skip_allowed ~= false

    scene.currentFrame = 1
    scene.timer = 0
    scene.finished = false

-- Цель перехода после завершения scene.
    -- Если nil, игра продолжит старый flow через advanceFlow().
    scene.nextTarget = normalizeNextTarget(config)

    scene.playedSounds = {}

    return scene
end

-- Запускает scene с начала.
function Scene:start()
    self.currentFrame = 1
    self.timer = 0
    self.finished = false
    self.playedSounds = {}

    if self.music then
        self.music:stop()
        self.music:play()
    end

    self:playFrameSound()
end

-- Останавливает scene.
function Scene:stop()
    if self.music then
        self.music:stop()
    end
end

-- Возвращает текущий frame.
function Scene:getFrame()
    return self.frames[self.currentFrame]
end

-- Проигрывает звук текущего кадра, если он есть.
function Scene:playFrameSound()
    local frame = self:getFrame()

    if not frame or not frame.sound then
        return
    end

    local key = tostring(self.currentFrame) .. ":" .. tostring(frame.sound)

    if self.playedSounds[key] then
        return
    end

    self.playedSounds[key] = true

    Assets.playSound(frame.sound)
end

-- Переходит к следующему кадру.
function Scene:nextFrame()
    self.currentFrame = self.currentFrame + 1
    self.timer = 0

    if self.currentFrame > #self.frames then
        self.finished = true
        return
    end

    self:playFrameSound()
end

-- Пропускает scene.
function Scene:skip()
    if self.skipAllowed then
        self.finished = true
    end
end

-- Обновляет scene.
function Scene:update(dt)
    if self.finished then
        return
    end

    local frame = self:getFrame()

    if not frame then
        self.finished = true
        return
    end

    self.timer = self.timer + dt

    local duration = frame.duration or 3

    if self.timer >= duration then
        self:nextFrame()
    end
end

-- Рисует текущий кадр scene.
function Scene:draw()
    love.graphics.clear(0.02, 0.02, 0.03)

    local frame = self:getFrame()

    if not frame then
        return
    end

    if frame.image then
        local image = Assets.getImage(frame.image)

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            image,
            0,
            0,
            0,
            Config.screen.width / image:getWidth(),
            (Config.screen.height - 100) / image:getHeight()
        )
    else
        love.graphics.setColor(0.12, 0.14, 0.18)
        love.graphics.rectangle("fill", 0, 0, Config.screen.width, Config.screen.height - 100)

        love.graphics.setFont(UI.bigFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(
            self.id,
            0,
            Config.screen.height / 2 - 70,
            Config.screen.width,
            "center"
        )
    end

    love.graphics.setColor(0.04, 0.04, 0.05, 0.95)
    love.graphics.rectangle("fill", 0, Config.screen.height - 100, Config.screen.width, 100)

    if frame.text then
        love.graphics.setFont(UI.font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(
            frame.text,
            30,
            Config.screen.height - 76,
            Config.screen.width - 60,
            "center"
        )
    end

    if self.skipAllowed then
        love.graphics.setFont(UI.font)
        love.graphics.setColor(1, 1, 1, 0.6)
        love.graphics.printf(
            "Press Enter / Space / Tap to skip",
            0,
            Config.screen.height - 24,
            Config.screen.width,
            "center"
        )
    end

    love.graphics.setColor(1, 1, 1)
end

-- Возвращает true, если scene завершилась.
function Scene:isFinished()
    return self.finished
end

-- Возвращает цель перехода после завершения scene.
function Scene:getNextTarget()
    return self.nextTarget
end

return Scene