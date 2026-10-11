local Animator = {}
Animator.__index = Animator

-- Создаёт аниматор из описания сущности.
function Animator.new(
    assets,
    animations,
    initialState
)
    local self = setmetatable({}, Animator)

    self.assets = assets
    self.animations = animations

    self.state = nil
    self.animation = nil
    self.framePosition = 1
    self.frameTime = 0
    self.finished = false
    self.pendingEvents = {}

    self:play(initialState)

    return self
end

-- Запускает указанную анимацию.
function Animator:play(state, restart)
    if self.state == state and not restart then
        return
    end

    local animation = self.animations[state]

    assert(
        animation,
        "Unknown animation: " .. tostring(state)
    )

    self.state = state
    self.animation = animation
    self.framePosition = 1
    self.frameTime = 0
    self.finished = false
    self.pendingEvents = {}

    if animation.fireFirstFrameEvents then
        self:addFrameEvents(
            self.pendingEvents,
            1
        )
    end
end

-- Возвращает путь к текущему PNG.
function Animator:getCurrentFrame()
    return
        self.animation.frames[
            self.framePosition
        ]
end

-- Возвращает изображение текущего кадра.
function Animator:getCurrentImage()
    return self.assets:getAnimationImage(
        self:getCurrentFrame()
    )
end

-- Возвращает длительность текущего кадра.
function Animator:getCurrentFrameDuration()
    local overrides =
        self.animation.frameDurations

    if
        overrides and
        overrides[self.framePosition]
    then
        return overrides[self.framePosition]
    end

    return
        self.animation.frameDuration or
        0.1
end

-- Добавляет события указанного кадра.
function Animator:addFrameEvents(
    destination,
    framePosition
)
    for _, event in ipairs(
        self.animation.events or {}
    ) do
        if event.frame == framePosition then
            destination[#destination + 1] = event
        end
    end
end

-- Переходит к следующему кадру.
function Animator:advanceFrame(events)
    local frameCount =
        #self.animation.frames

    if self.framePosition < frameCount then
        self.framePosition =
            self.framePosition + 1
    elseif self.animation.loop then
        self.framePosition = 1
    else
        self.finished = true
        return
    end

    self:addFrameEvents(
        events,
        self.framePosition
    )
end

-- Обновляет анимацию и возвращает события.
function Animator:update(dt)
    local events = self.pendingEvents
    self.pendingEvents = {}

    if self.finished then
        return events
    end

    self.frameTime =
        self.frameTime +
        dt

    while not self.finished do
        local duration =
            self:getCurrentFrameDuration()

        if self.frameTime < duration then
            break
        end

        self.frameTime =
            self.frameTime -
            duration

        self:advanceFrame(events)
    end

    return events
end

-- Проверяет завершение незакольцованной анимации.
function Animator:isFinished()
    return self.finished
end

-- Рисует текущий кадр с опорой снизу по центру.
function Animator:draw(x, y, scale, alpha)
    local image = self:getCurrentImage()

    if not image then
        return
    end

    love.graphics.setColor(
        1,
        1,
        1,
        alpha or 1
    )

    love.graphics.draw(
        image,
        x,
        y,
        0,
        scale,
        scale,
        image:getWidth() / 2,
        image:getHeight()
    )

    love.graphics.setColor(1, 1, 1)
end

return Animator