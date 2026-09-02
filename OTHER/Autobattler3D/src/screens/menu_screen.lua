local Button = require('src.ui.button')

local MenuScreen = {}
MenuScreen.__index = MenuScreen


-- Создаёт главное меню.
function MenuScreen.new(app)
  local self =
    setmetatable({}, MenuScreen)

  self.app = app
  self.theme = app.theme
  self.ui = app.ui

  self.buttons = {}
  self.focusIndex = 1
  self.fadeProgress = 0

  self:createButtons()
  self:layout()

  return self
end


-- Создаёт кнопки главного меню.
function MenuScreen:createButtons()
  self.buttons = {
    Button.new({
      id = 'campaign',
      text = 'CAMPAIGN',
      theme = self.theme,
      ui = self.ui,
      enabled = false
    }),

    Button.new({
      id = 'battle',
      text = 'BATTLE',
      theme = self.theme,
      ui = self.ui,

      onClick = function()
        self.app:showBattleSetup()
      end
    }),

    Button.new({
      id = 'settings',
      text = 'SETTINGS',
      theme = self.theme,
      ui = self.ui,

      onClick = function()
        self.app:showSettings()
      end
    }),

    Button.new({
      id = 'exit',
      text = 'EXIT',
      theme = self.theme,
      ui = self.ui,

      onClick = function()
        lovr.event.quit()
      end
    })
  }

  self:setFocus(2)
end


-- Располагает кнопки меню.
function MenuScreen:layout()
  local width =
    self.theme:getDimension(
      'buttonWidth'
    )

  local height =
    self.theme:getDimension(
      'buttonHeight'
    )

  local spacing =
    self.theme:getDimension(
      'buttonSpacing'
    )

  local totalHeight =
    #self.buttons * height +
    (#self.buttons - 1) * spacing

  local x =
    (
      self.ui.virtualWidth -
      width
    ) / 2

  local startY =
    285 -
    totalHeight / 2

  for index, button in ipairs(
    self.buttons
  ) do
    button:setBounds(
      x,
      startY +
      (index - 1) *
      (height + spacing),
      width,
      height
    )
  end
end


-- Устанавливает фокус кнопки.
function MenuScreen:setFocus(index)
  for _, button in ipairs(
    self.buttons
  ) do
    button:setFocused(false)
  end

  local button =
    self.buttons[index]

  if not button or not button.enabled then
    return
  end

  self.focusIndex = index
  button:setFocused(true)
end


-- Перемещает фокус по активным кнопкам.
function MenuScreen:moveFocus(direction)
  local index = self.focusIndex

  for attempt = 1, #self.buttons do
    index = index + direction

    if index < 1 then
      index = #self.buttons
    elseif index > #self.buttons then
      index = 1
    end

    if self.buttons[index].enabled then
      self:setFocus(index)
      return
    end
  end
end


-- Запускает появление меню.
function MenuScreen:enter()
  self.fadeProgress = 0
end


-- Обновляет появление меню.
function MenuScreen:update(dt)
  local duration =
    self.theme:getTransition(
      'screenFadeDuration'
    )

  if duration <= 0 then
    self.fadeProgress = 1
  else
    self.fadeProgress =
      math.min(
        self.fadeProgress +
        dt / duration,
        1
      )
  end
end


-- Рисует главное меню.
function MenuScreen:draw(pass)
  self.ui:begin(pass)
  self.theme:drawBackground(
    pass,
    self.ui
  )

  self.ui:drawText(
    pass,
    'AUTOBATTLER 3D',
    0,
    72,
    self.ui.virtualWidth,
    80,
    52,
    self.theme:getColor('text'),
    -3.84
  )

  self.ui:drawText(
    pass,
    'HUMANS  •  ORCS',
    0,
    140,
    self.ui.virtualWidth,
    45,
    24,
    self.theme:getColor(
      'mutedText'
    ),
    -3.84
  )

  for _, button in ipairs(
    self.buttons
  ) do
    button:draw(pass)
  end

  self.ui:drawText(
    pass,
    'CAMPAIGN — COMING LATER',
    0,
    640,
    self.ui.virtualWidth,
    35,
    18,
    self.theme:getColor(
      'mutedText'
    ),
    -3.84
  )

  if self.fadeProgress < 1 then
    self.ui:drawRectangle(
      pass,
      0,
      0,
      self.ui.virtualWidth,
      self.ui.virtualHeight,
      {
        0,
        0,
        0,
        1 - self.fadeProgress
      },
      -3.75
    )
  end

  pass:setColor(1, 1, 1, 1)
end


-- Обрабатывает движение мыши.
function MenuScreen:mousemoved(x, y)
  for index, button in ipairs(
    self.buttons
  ) do
    button:mousemoved(x, y)

    if
      button.enabled
      and button:contains(x, y)
    then
      self:setFocus(index)
    end
  end
end


-- Обрабатывает нажатие мыши.
function MenuScreen:mousepressed(
  x,
  y,
  button
)
  for _, menuButton in ipairs(
    self.buttons
  ) do
    if menuButton:mousepressed(
      x,
      y,
      button
    ) then
      return
    end
  end
end


-- Обрабатывает отпускание мыши.
function MenuScreen:mousereleased(
  x,
  y,
  button
)
  for _, menuButton in ipairs(
    self.buttons
  ) do
    if menuButton:mousereleased(
      x,
      y,
      button
    ) then
      return
    end
  end
end


-- Обрабатывает клавиатуру.
function MenuScreen:keypressed(key)
  if key == 'up' or key == 'w' then
    self:moveFocus(-1)
  elseif
    key == 'down'
    or key == 's'
  then
    self:moveFocus(1)
  elseif
    key == 'return'
    or key == 'space'
  then
    self.buttons[
      self.focusIndex
    ]:activate()
  elseif key == 'escape' then
    lovr.event.quit()
  end
end


return MenuScreen