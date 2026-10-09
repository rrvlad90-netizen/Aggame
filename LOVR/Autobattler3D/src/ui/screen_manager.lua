local ScreenManager = {}
ScreenManager.__index = ScreenManager


-- Вызывает метод экрана.
local function callScreenMethod(
  screen,
  methodName,
  ...
)
  if
    screen
    and type(screen[methodName])
      == 'function'
  then
    return screen[methodName](
      screen,
      ...
    )
  end
end


-- Создаёт менеджер экранов.
function ScreenManager.new()
  local self =
    setmetatable({}, ScreenManager)

  self.stack = {}

  return self
end


-- Возвращает число экранов.
function ScreenManager:count()
  return #self.stack
end


-- Возвращает верхний экран.
function ScreenManager:top()
  return self.stack[#self.stack]
end


-- Добавляет экран поверх текущего.
function ScreenManager:push(screen)
  assert(
    screen,
    'ScreenManager requires a screen'
  )

  local previous = self:top()

  callScreenMethod(
    previous,
    'covered',
    screen
  )

  self.stack[#self.stack + 1] =
    screen

  callScreenMethod(
    screen,
    'enter',
    previous
  )
end


-- Закрывает верхний экран.
function ScreenManager:pop()
  if #self.stack <= 1 then
    return nil
  end

  local removed =
    table.remove(self.stack)

  local current = self:top()

  callScreenMethod(
    removed,
    'leave',
    current
  )

  callScreenMethod(
    removed,
    'destroy'
  )

  callScreenMethod(
    current,
    'revealed',
    removed
  )

  return removed
end


-- Заменяет все экраны.
function ScreenManager:replace(screen)
  assert(
    screen,
    'ScreenManager requires a screen'
  )

  local previous = self:top()

  for index =
    #self.stack,
    1,
    -1
  do
    local removed =
      table.remove(
        self.stack,
        index
      )

    callScreenMethod(
      removed,
      'leave',
      screen
    )

    callScreenMethod(
      removed,
      'destroy'
    )
  end

  self.stack[1] = screen

  callScreenMethod(
    screen,
    'enter',
    previous
  )
end


-- Обновляет активные экраны.
function ScreenManager:update(dt)
  if #self.stack == 0 then
    return
  end

  local firstIndex = #self.stack

  while
    firstIndex > 1
    and self.stack[firstIndex]
      .updateBelow
  do
    firstIndex = firstIndex - 1
  end

  for index =
    firstIndex,
    #self.stack
  do
    callScreenMethod(
      self.stack[index],
      'update',
      dt
    )
  end
end


-- Рисует видимые экраны.
function ScreenManager:draw(pass)
  if #self.stack == 0 then
    return
  end

  local firstIndex = #self.stack

  while
    firstIndex > 1
    and self.stack[firstIndex]
      .transparent
  do
    firstIndex = firstIndex - 1
  end

  for index =
    firstIndex,
    #self.stack
  do
    callScreenMethod(
      self.stack[index],
      'draw',
      pass
    )
  end
end


-- Передаёт событие верхнему экрану.
function ScreenManager:dispatch(
  methodName,
  ...
)
  return callScreenMethod(
    self:top(),
    methodName,
    ...
  )
end


-- Передаёт событие всем экранам.
function ScreenManager:dispatchAll(
  methodName,
  ...
)
  for _, screen in ipairs(
    self.stack
  ) do
    callScreenMethod(
      screen,
      methodName,
      ...
    )
  end
end


return ScreenManager