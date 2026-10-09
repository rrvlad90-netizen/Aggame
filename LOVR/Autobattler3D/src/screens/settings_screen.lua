local Button =
  require('src.ui.button')

local SettingsScreen = {}
SettingsScreen.__index =
  SettingsScreen

local ROWS = {
  {
    id = 'master',
    label = 'MASTER VOLUME',
    kind = 'number'
  },

  {
    id = 'music',
    label = 'MUSIC VOLUME',
    kind = 'number'
  },

  {
    id = 'touchCameraControls',
    label = 'TURN ON INTERFACE',
    kind = 'boolean'
  }
}


-- Ограничивает значение диапазоном.
local function clamp(value)
  return math.max(
    0,
    math.min(1, value)
  )
end


-- Возвращает описание настройки.
local function getRow(settingId)
  for _, row in ipairs(ROWS) do
    if row.id == settingId then
      return row
    end
  end

  return nil
end


-- Создаёт экран настроек.
function SettingsScreen.new(app)
  local self =
    setmetatable(
      {},
      SettingsScreen
    )

  self.app = app
  self.theme = app.theme
  self.ui = app.ui

  self.transparent = true
  self.rowFocus = 1

  self.pending = {
    master =
      app.settings.audio.master,

    music =
      app.settings.audio.music,

    touchCameraControls =
      app.settings.interface
        .touchCameraControls
  }

  self.arrowButtons = {}

  self:createButtons()
  self:layout()

  return self
end


-- Создаёт кнопки настроек.
function SettingsScreen:createButtons()
  for _, row in ipairs(ROWS) do
    self.arrowButtons[row.id] = {
      left = Button.new({
        text = '<',
        theme = self.theme,
        ui = self.ui,

        onClick = function()
          self:change(
            row.id,
            -.1
          )
        end
      }),

      right = Button.new({
        text = '>',
        theme = self.theme,
        ui = self.ui,

        onClick = function()
          self:change(
            row.id,
            .1
          )
        end
      })
    }
  end

  self.applyButton = Button.new({
    text = 'APPLY',
    theme = self.theme,
    ui = self.ui,

    onClick = function()
      self:apply()
    end
  })

  self.cancelButton = Button.new({
    text = 'CANCEL',
    theme = self.theme,
    ui = self.ui,

    onClick = function()
      self.app.screens:pop()
    end
  })
end


-- Располагает элементы экрана.
function SettingsScreen:layout()
  self.panelX = 310
  self.panelY = 80
  self.panelWidth = 660
  self.panelHeight = 560

  self.rowsX = 385
  self.rowsY = 165
  self.rowsWidth = 510
  self.rowHeight = 105

  for index, row in ipairs(ROWS) do
    local y =
      self.rowsY +
      (index - 1) *
      self.rowHeight

    local arrows =
      self.arrowButtons[row.id]

    arrows.left:setBounds(
      self.rowsX,
      y + 38,
      58,
      52
    )

    arrows.right:setBounds(
      self.rowsX +
      self.rowsWidth - 58,
      y + 38,
      58,
      52
    )
  end

  self.applyButton:setBounds(
    385,
    535,
    240,
    58
  )

  self.cancelButton:setBounds(
    655,
    535,
    240,
    58
  )
end


-- Изменяет настройку.
function SettingsScreen:change(
  settingId,
  amount
)
  local row =
    getRow(settingId)

  if not row then
    return
  end

  if row.kind == 'boolean' then
    self.pending[settingId] =
      not self.pending[settingId]

    return
  end

  self.pending[settingId] =
    clamp(
      self.pending[settingId] +
      amount
    )
end


-- Сохраняет настройки.
function SettingsScreen:apply()
  self.app.settings.audio.master =
    self.pending.master

  self.app.settings.audio.music =
    self.pending.music

  self.app.settings.interface
    .touchCameraControls =
    self.pending
      .touchCameraControls

  self.app:applyAudioSettings()
  self.app:saveSettings()

  self.app.screens:pop()
end


-- Возвращает текст значения.
function SettingsScreen:getValueText(row)
  local value =
    self.pending[row.id]

  if row.kind == 'boolean' then
    return
      value
      and 'ON'
      or 'OFF'
  end

  return
    math.floor(
      value * 100 + .5
    ) .. '%'
end


-- Рисует строку настройки.
function SettingsScreen:drawRow(
  pass,
  index,
  row
)
  local y =
    self.rowsY +
    (index - 1) *
    self.rowHeight

  if index == self.rowFocus then
    local color =
      self.theme:getColor(
        'button'
      )

    self.ui:drawRectangle(
      pass,
      self.rowsX - 10,
      y,
      self.rowsWidth + 20,
      self.rowHeight - 7,

      {
        color[1],
        color[2],
        color[3],
        .42
      },

      -3.86
    )
  end

  self.ui:drawText(
    pass,
    row.label,
    self.rowsX + 65,
    y + 4,
    self.rowsWidth - 130,
    28,
    18,

    self.theme:getColor(
      'mutedText'
    ),

    -3.79
  )

  self.ui:drawText(
    pass,
    self:getValueText(row),

    self.rowsX + 65,
    y + 37,
    self.rowsWidth - 130,
    52,
    27,

    self.theme:getColor('text'),
    -3.79
  )

  local arrows =
    self.arrowButtons[row.id]

  arrows.left:draw(pass)
  arrows.right:draw(pass)
end


-- Рисует экран настроек.
function SettingsScreen:draw(pass)
  self.ui:begin(pass)

  self.theme:drawOverlay(
    pass,
    self.ui,
    1
  )

  self.theme:drawPanel(
    pass,
    self.ui,
    self.panelX,
    self.panelY,
    self.panelWidth,
    self.panelHeight,
    1
  )

  self.ui:drawText(
    pass,
    'SETTINGS',
    self.panelX,
    self.panelY + 22,
    self.panelWidth,
    65,
    43,

    self.theme:getColor('text'),
    -3.76
  )

  for index, row in ipairs(ROWS) do
    self:drawRow(
      pass,
      index,
      row
    )
  end

  self.applyButton:draw(pass)
  self.cancelButton:draw(pass)
end


-- Обрабатывает движение мыши.
function SettingsScreen:mousemoved(
  x,
  y
)
  for _, row in ipairs(ROWS) do
    local arrows =
      self.arrowButtons[row.id]

    arrows.left:mousemoved(x, y)
    arrows.right:mousemoved(x, y)
  end

  self.applyButton:mousemoved(x, y)
  self.cancelButton:mousemoved(x, y)
end


-- Обрабатывает нажатие мыши.
function SettingsScreen:mousepressed(
  x,
  y,
  button
)
  for index, row in ipairs(ROWS) do
    local rowY =
      self.rowsY +
      (index - 1) *
      self.rowHeight

    if
      y >= rowY
      and y <=
        rowY + self.rowHeight
    then
      self.rowFocus = index
    end

    local arrows =
      self.arrowButtons[row.id]

    if
      arrows.left:mousepressed(
        x,
        y,
        button
      )
      or arrows.right:
        mousepressed(
          x,
          y,
          button
        )
    then
      return
    end
  end

  if
    self.applyButton:
      mousepressed(
        x,
        y,
        button
      )
  then
    return
  end

  self.cancelButton:mousepressed(
    x,
    y,
    button
  )
end


-- Обрабатывает отпускание мыши.
function SettingsScreen:mousereleased(
  x,
  y,
  button
)
  for _, row in ipairs(ROWS) do
    local arrows =
      self.arrowButtons[row.id]

    if
      arrows.left:mousereleased(
        x,
        y,
        button
      )
      or arrows.right:
        mousereleased(
          x,
          y,
          button
        )
    then
      return
    end
  end

  if
    self.applyButton:
      mousereleased(
        x,
        y,
        button
      )
  then
    return
  end

  self.cancelButton:mousereleased(
    x,
    y,
    button
  )
end


-- Обрабатывает клавиатуру.
function SettingsScreen:keypressed(key)
  if
    key == 'up'
    or key == 'w'
  then
    self.rowFocus =
      (self.rowFocus - 2) %
      #ROWS + 1

  elseif
    key == 'down'
    or key == 's'
  then
    self.rowFocus =
      self.rowFocus %
      #ROWS + 1

  elseif
    key == 'left'
    or key == 'a'
  then
    self:change(
      ROWS[self.rowFocus].id,
      -.1
    )

  elseif
    key == 'right'
    or key == 'd'
  then
    self:change(
      ROWS[self.rowFocus].id,
      .1
    )

  elseif
    key == 'return'
    or key == 'space'
  then
    local row =
      ROWS[self.rowFocus]

    if row.kind == 'boolean' then
      self:change(
        row.id,
        0
      )
    else
      self:apply()
    end

  elseif key == 'escape' then
    self.app.screens:pop()
  end
end


return SettingsScreen