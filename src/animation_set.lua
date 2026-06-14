local Animation = require("src.animation")
local Utils = require("src.utils")

local AnimationSet = {}
AnimationSet.__index = AnimationSet

-- Создаёт набор анимаций entity.
-- Entity может иметь idle, walk, attack, death и любые другие состояния.
function AnimationSet:new(config)
    config = config or {}

    local set = setmetatable({}, AnimationSet)

    set.animations = {}
    set.currentName = nil
    set.defaultName = config.default or config.defaultState or "idle"
    set.pendingEvents = {}

    for name, animationConfig in pairs(config.animations or {}) do
        local preparedConfig = Utils.copyTable(animationConfig)

        preparedConfig.name = name

        set.animations[name] = Animation:new(preparedConfig)
    end

    if not set.animations[set.defaultName] then
        for name, _ in pairs(set.animations) do
            set.defaultName = name
            break
        end
    end

    if not set.defaultName then
        set.defaultName = "idle"
        set.animations.idle = Animation:new({
            name = "idle",
            frames = {},
            loop = true
        })
    end

    set:set(set.defaultName, true)

    return set
end

-- Добавляет события в общую очередь набора анимаций.
function AnimationSet:addPendingEvents(events)
    for _, event in ipairs(events or {}) do
        table.insert(self.pendingEvents, event)
    end
end

-- Возвращает и очищает очередь событий.
function AnimationSet:consumeEvents()
    local events = self.pendingEvents

    self.pendingEvents = {}

    return events
end

-- Проверяет, существует ли animation с таким именем.
function AnimationSet:has(name)
    return self.animations[name] ~= nil
end

-- Возвращает имя fallback-анимации.
-- Если нужной анимации нет, берём defaultName.
function AnimationSet:getFallbackName(name)
    if self.animations[name] then
        return name
    end

    if self.animations[self.defaultName] then
        return self.defaultName
    end

    for existingName, _ in pairs(self.animations) do
        return existingName
    end

    return nil
end

-- Переключает текущую анимацию.
-- force = true перезапускает даже ту же самую анимацию.
function AnimationSet:set(name, force)
    local nextName = self:getFallbackName(name)

    if not nextName then
        return
    end

    if self.currentName == nextName and not force then
        return
    end

    self.currentName = nextName

    local animation = self:getCurrent()

    animation:reset()
    self:addPendingEvents(animation:consumeEvents())
end

-- Возвращает текущую animation.
function AnimationSet:getCurrent()
    return self.animations[self.currentName]
end

-- Возвращает имя текущей animation.
function AnimationSet:getCurrentName()
    return self.currentName
end

-- Возвращает true, если текущая animation закончилась.
function AnimationSet:isCurrentFinished()
    local animation = self:getCurrent()

    if not animation then
        return true
    end

    return animation:isFinished()
end

-- Возвращает true, если текущая animation блокирует ввод.
function AnimationSet:isInputLocked()
    local animation = self:getCurrent()

    if not animation then
        return false
    end

    return animation:isInputLocked()
end

-- Обновляет текущую animation и возвращает events.
function AnimationSet:update(dt)
    local animation = self:getCurrent()

    if not animation then
        return {}
    end

    self:addPendingEvents(animation:update(dt))

    return self:consumeEvents()
end

-- Рисует текущую animation.
function AnimationSet:draw(x, y, rotation, scaleX, scaleY, offsetX, offsetY, alpha)
    local animation = self:getCurrent()

    if not animation then
        return
    end

    animation:draw(
        x,
        y,
        rotation,
        scaleX,
        scaleY,
        offsetX,
        offsetY,
        alpha
    )
end

return AnimationSet