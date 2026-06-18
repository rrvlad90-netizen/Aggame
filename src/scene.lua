local Assets = require("src.assets")
local Config = require("src.config")
local UI = require("src.ui")

local Scene = {}
Scene.__index = Scene

-- Нормализует описание следующего перехода.
-- Поддерживает next = { type = "...", id = "..." }, nextScene, nextLevel и nextMode.
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

    if config.nextMode or config.next_mode then
        return {
            type = "mode",
            id = config.nextMode or config.next_mode
        }
    end

    return nil
end

-- Возвращает true, если точка находится внутри прямоугольника.
local function pointInRect(x, y, rect)
    return x >= rect.x
        and x <= rect.x + rect.w
        and y >= rect.y
        and y <= rect.y + rect.h
end

-- Возвращает список дополнительных картинок текущего кадра.
-- Ограничиваем список шестью элементами, чтобы scene не стала тяжёлым UI-экраном.
local function getFrameImages(frame)
    local result = {}

    for index, imageConfig in ipairs(frame.images or {}) do
        if index > 6 then
            break
        end

        table.insert(result, imageConfig)
    end

    return result
end

-- Возвращает прямоугольник, в котором дополнительная картинка рисуется на экране.
-- Если w/h не заданы, используется натуральный размер PNG.
local function getFrameImageRect(imageConfig)
    if not imageConfig or not imageConfig.image then
        return nil
    end

    local image = Assets.getImage(imageConfig.image)

    if not image then
        return nil
    end

    local width = imageConfig.w
        or imageConfig.width
        or image:getWidth()

    local height = imageConfig.h
        or imageConfig.height
        or image:getHeight()

    return {
        x = imageConfig.x or 0,
        y = imageConfig.y or 0,
        w = width,
        h = height,
        image = image
    }
end

-- Создаёт scene из definition.
-- Scene используется для intro, briefing, victory/game over и интерактивных кадров.
function Scene:new(config)
    config = config or {}

    local scene = setmetatable({}, Scene)

    scene.id = config.id or "scene"

    scene.musicPath = config.music
    scene.music = Assets.getMusic(scene.musicPath)

    scene.frames = config.frames or {}
    scene.skipAllowed = config.skipAllowed ~= false
        and config.skip_allowed ~= false

    -- Если true, клик вне кликабельной картинки не будет скипать scene.
    scene.clickNotSkipScene = config.clickNotSkipScene == true
        or config.click_not_skip_scene == true

    scene.currentFrame = 1
    scene.timer = 0
    scene.finished = false

    -- Цель перехода после завершения scene.
    -- Если nil, игра продолжит старый flow через advanceFlow().
    scene.nextTarget = normalizeNextTarget(config)
	
	scene.livesDelta = config.livesDelta
        or config.lives_delta
        or 0

    -- Цель, выбранная кликом по дополнительной картинке кадра.
    scene.selectedNextTarget = nil
	scene.selectedLivesDelta = nil

    scene.playedSounds = {}

    return scene
end

-- Запускает scene с начала.
function Scene:start()
    self.currentFrame = 1
    self.timer = 0
    self.finished = false
    self.selectedNextTarget = nil
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

-- Пропускает scene, если skip разрешён.
function Scene:skip()
    if self.skipAllowed then
        self.finished = true
    end
end

-- Возвращает кликабельную картинку под указанной точкой.
-- Кликабельной считается только сама PNG-картинка, текст не входит в hitbox.
function Scene:getClickableImageAt(x, y)
    local frame = self:getFrame()

    if not frame then
        return nil
    end

    for _, imageConfig in ipairs(getFrameImages(frame)) do
        if imageConfig.clickable == true then
            local rect = getFrameImageRect(imageConfig)

            if rect and pointInRect(x, y, rect) then
                return imageConfig
            end
        end
    end

    return nil
end

-- Обрабатывает клик/тач по scene.
-- Клик по clickable-картинке выбирает nextScene этой картинки.
-- Клик вне картинки скипает scene только если clickNotSkipScene не включён.
function Scene:click(x, y)
    if self.finished then
        return false
    end

    local imageConfig = self:getClickableImageAt(x, y)

	if imageConfig then
        local nextTarget = normalizeNextTarget(imageConfig)
        local livesDelta = imageConfig.livesDelta
            or imageConfig.lives_delta

        if nextTarget or livesDelta then
            self.selectedNextTarget = nextTarget
            self.selectedLivesDelta = livesDelta
            self.finished = true
            return true
        end
    end

    if self.clickNotSkipScene then
        return false
    end

    self:skip()
    return true
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

-- Рисует основной фон текущего кадра.
function Scene:drawFrameBackground(frame)
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

        return
    end

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

-- Рисует дополнительные картинки текущего кадра поверх основного frame.
function Scene:drawFrameImages(frame)
    for _, imageConfig in ipairs(getFrameImages(frame)) do
        local rect = getFrameImageRect(imageConfig)

        if rect then
            love.graphics.setColor(1, 1, 1)

            love.graphics.draw(
                rect.image,
                rect.x,
                rect.y,
                0,
                rect.w / rect.image:getWidth(),
                rect.h / rect.image:getHeight()
            )
        end
    end
end

-- Рисует текст кадра.
-- Если textX/textY заданы, текст рисуется в указанной зоне.
-- Если не заданы — используется старое поведение с нижней панелью.
function Scene:drawFrameText(frame)
    if not frame.text then
        return
    end

    local textX = frame.textX or frame.text_x
    local textY = frame.textY or frame.text_y

    if textX ~= nil and textY ~= nil then
        local textW = frame.textW
            or frame.text_w
            or (Config.screen.width - textX)

        local textH = frame.textH
            or frame.text_h

        local align = frame.textAlign
            or frame.text_align
            or "left"

        love.graphics.setFont(UI.font)
        love.graphics.setColor(1, 1, 1)

        if textH then
            love.graphics.setScissor(textX, textY, textW, textH)
        end

        love.graphics.printf(
            frame.text,
            textX,
            textY,
            textW,
            align
        )

        if textH then
            love.graphics.setScissor()
        end

        return
    end

    love.graphics.setColor(0.04, 0.04, 0.05, 0.95)
    love.graphics.rectangle("fill", 0, Config.screen.height - 100, Config.screen.width, 100)

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

-- Рисует подсказку skip, если scene можно пропустить.
function Scene:drawSkipHint()
    if not self.skipAllowed then
        return
    end

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

-- Рисует текущий кадр scene.
function Scene:draw()
    love.graphics.clear(0.02, 0.02, 0.03)

    local frame = self:getFrame()

    if not frame then
        return
    end

    self:drawFrameBackground(frame)
    self:drawFrameImages(frame)
    self:drawFrameText(frame)
    self:drawSkipHint()

    love.graphics.setColor(1, 1, 1)
end

-- Возвращает true, если scene завершилась.
function Scene:isFinished()
    return self.finished
end

-- Возвращает изменение жизней после завершения scene.
-- Если игрок выбрал clickable-вариант с livesDelta, он имеет приоритет.
function Scene:getLivesDelta()
    if self.selectedLivesDelta ~= nil then
        return self.selectedLivesDelta
    end

    return self.livesDelta or 0
end

-- Возвращает цель перехода после завершения scene.
-- Если игрок кликнул по clickable-картинке, приоритет получает её nextScene.
function Scene:getNextTarget()
    return self.selectedNextTarget or self.nextTarget
end

return Scene