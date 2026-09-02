local Button = {}
Button.__index = Button


-- Создаёт кнопку интерфейса.
function Button.new(options)
  options = options or {}

  local self =
    setmetatable({}, Button)

  self.id = options.id
  self.text = options.text or ''
  self.theme = options.theme
  self.ui = options.ui
  self.onClick = options.onClick

  self.x = options.x or 0
  self.y = options.y or 0

  self.width =
    options.width
    or self.theme:getDimension(
      'buttonWidth'
    )

  self.height =
    options.height
    or self.theme:getDimension(
      'buttonHeight'
    )

  self.visible =
    options.visible ~= false

  self.enabled =
    options.enabled ~= false

  self.hovered = false
  self.pressed = false
  self.focused = false

  return self
end


-- Изменяет границы кнопки.
function Button:setBounds(
  x,
  y,
  width,
  height
)
  self.x = x
  self.y = y
  self.width = width or self.width
  self.height = height or self.height
end


-- Проверяет попадание точки.
function Button:contains(x, y)
  return
    self.visible
    and x >= self.x
    and x <= self.x + self.width
    and y >= self.y
    and y <= self.y + self.height
end


-- Изменяет состояние наведения.
function Button:setHovered(hovered)
  self.hovered =
    hovered == true
    and self.enabled
end


-- Изменяет клавиатурный фокус.
function Button:setFocused(focused)
  self.focused =
    focused == true
end


-- Включает или отключает кнопку.
function Button:setEnabled(enabled)
  self.enabled =
    enabled == true

  if not self.enabled then
    self.hovered = false
    self.pressed = false
  end
end


-- Изменяет текст кнопки.
function Button:setText(text)
  self.text = tostring(text or '')
end


-- Выполняет действие кнопки.
function Button:activate()
  if
    not self.visible
    or not self.enabled
  then
    return false
  end

  if self.onClick then
    self.onClick(self)
  end

  return true
end


-- Обрабатывает движение мыши.
function Button:mousemoved(x, y)
  if self.focused then
    return
  end

  self:setHovered(
    self:contains(x, y)
  )
end


-- Обрабатывает нажатие мыши.
function Button:mousepressed(
  x,
  y,
  mouseButton
)
  if
    mouseButton ~= 1
    or not self.enabled
    or not self:contains(x, y)
  then
    return false
  end

  self.pressed = true
  return true
end


-- Обрабатывает отпускание мыши.
function Button:mousereleased(
  x,
  y,
  mouseButton
)
  if
    mouseButton ~= 1
    or not self.pressed
  then
    return false
  end

  self.pressed = false

  if self:contains(x, y) then
    return self:activate()
  end

  return false
end


-- Возвращает визуальное состояние.
function Button:getState()
  if not self.enabled then
    return 'disabled'
  end

  if self.pressed then
    return 'pressed'
  end

  if self.hovered or self.focused then
    return 'hover'
  end

  return 'normal'
end


-- Рисует кнопку.
function Button:draw(pass)
  if not self.visible then
    return
  end

  self.theme:drawButtonBackground(
    pass,
    self.ui,
    self:getState(),
    self.x,
    self.y,
    self.width,
    self.height
  )

  local color =
    self.enabled
    and self.theme:getColor('text')
    or self.theme:getColor(
      'mutedText'
    )

  self.ui:drawText(
    pass,
    self.text,
    self.x,
    self.y,
    self.width,
    self.height,
    25,
    color,
    -3.82
  )
end


return Button