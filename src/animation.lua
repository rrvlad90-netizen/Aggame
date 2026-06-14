local Assets = require("src.assets")

local Animation = {}
Animation.__index = Animation

-- Группирует events по номеру кадра.
-- Так быстрее забирать события при переходе на новый кадр.
local function buildEventsByFrame(events)
    local result = {}

    for _, event in ipairs(events or {}) do
        local frame = event.frame or 1

        result[frame] = result[frame] or {}
        table.insert(result[frame], event)
    end

    return result
end

-- Нормализует описание кадра.
-- Кадр может быть строкой:
-- "assets/player/run_1.png"
--
-- Или таблицей:
-- {
--     image = "assets/player/run_1.png",
--     duration = 0.1
-- }
local function normalizeFrame(frameConfig, defaultDuration)
    if type(frameConfig) == "string" then
        return {
            image = frameConfig,
            duration = defaultDuration
        }
    end

    if type(frameConfig) == "table" then
        return {
            image = frameConfig.image or frameConfig.path or frameConfig[1],
            duration = frameConfig.duration
                or frameConfig.delay
                or defaultDuration,
            events = frameConfig.events
        }
    end

    return {
        image = nil,
        duration = defaultDuration
    }
end

-- Создаёт новую runtime-анимацию.
function Animation:new(config)
    config = config or {}

    local animation = setmetatable({}, Animation)

    animation.name = config.name or "animation"

    animation.loop = config.loop == true
    animation.lockInput = config.lockInput == true
    animation.holdLastFrame = config.holdLastFrame == true

    animation.frameDuration = config.frameDuration
        or config.duration
        or config.delay
        or 0.1

    animation.frames = {}

    for _, frameConfig in ipairs(config.frames or {}) do
        table.insert(
            animation.frames,
            normalizeFrame(frameConfig, animation.frameDuration)
        )
    end

    if #animation.frames == 0 then
        table.insert(animation.frames, {
            image = nil,
            duration = animation.frameDuration
        })
    end

    animation.eventsByFrame = buildEventsByFrame(config.events)

    -- Events можно писать как в общем списке animation.events,
    -- так и прямо внутри конкретного кадра.
    for index, frame in ipairs(animation.frames) do
        if frame.events then
            animation.eventsByFrame[index] = animation.eventsByFrame[index] or {}

            for _, event in ipairs(frame.events) do
                table.insert(animation.eventsByFrame[index], event)
            end
        end
    end

    animation.frame = 1
    animation.timer = 0
    animation.finished = false
    animation.pendingEvents = {}

    -- Если true, события первого кадра сработают сразу при reset/start.
    animation.fireFirstFrameEvents = config.fireFirstFrameEvents == true

    return animation
end

-- Сбрасывает анимацию на первый кадр.
function Animation:reset()
    self.frame = 1
    self.timer = 0
    self.finished = false
    self.pendingEvents = {}

    if self.fireFirstFrameEvents then
        self:queueFrameEvents(self.frame)
    end
end

-- Добавляет события указанного кадра в pendingEvents.
function Animation:queueFrameEvents(frame)
    local events = self.eventsByFrame[frame]

    if not events then
        return
    end

    for _, event in ipairs(events) do
        table.insert(self.pendingEvents, event)
    end
end

-- Возвращает события, которые накопились после update/reset.
function Animation:consumeEvents()
    local events = self.pendingEvents

    self.pendingEvents = {}

    return events
end

-- Возвращает текущий кадр.
function Animation:getCurrentFrame()
    return self.frames[self.frame]
end

-- Возвращает картинку текущего кадра.
function Animation:getCurrentImage()
    local frame = self:getCurrentFrame()

    return Assets.getImage(frame.image)
end

-- Возвращает длительность текущего кадра.
function Animation:getCurrentFrameDuration()
    local frame = self:getCurrentFrame()

    return frame.duration or self.frameDuration
end

-- Переключает анимацию на следующий кадр.
function Animation:advanceFrame()
    if self.finished then
        return
    end

    self.frame = self.frame + 1

    if self.frame <= #self.frames then
        self:queueFrameEvents(self.frame)
        return
    end

    if self.loop then
        self.frame = 1
        self:queueFrameEvents(self.frame)
        return
    end

    self.finished = true
    self.frame = #self.frames
end

-- Обновляет анимацию.
-- Возвращает события, которые сработали на кадрах.
function Animation:update(dt)
    if self.finished then
        return self:consumeEvents()
    end

    self.timer = self.timer + dt

    while self.timer >= self:getCurrentFrameDuration() do
        self.timer = self.timer - self:getCurrentFrameDuration()

        self:advanceFrame()

        if self.finished then
            break
        end
    end

    return self:consumeEvents()
end

-- Возвращает true, если non-loop анимация закончилась.
function Animation:isFinished()
    return self.finished
end

-- Возвращает true, если анимация блокирует ввод.
function Animation:isInputLocked()
    return self.lockInput and not self.finished
end

-- Рисует текущий кадр.
function Animation:draw(x, y, rotation, scaleX, scaleY, offsetX, offsetY, alpha)
    local image = self:getCurrentImage()

    rotation = rotation or 0
    scaleX = scaleX or 1
    scaleY = scaleY or 1
    offsetX = offsetX or 0
    offsetY = offsetY or 0
    alpha = alpha or 1

    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.draw(
        image,
        x,
        y,
        rotation,
        scaleX,
        scaleY,
        offsetX,
        offsetY
    )
    love.graphics.setColor(1, 1, 1)
end

return Animation