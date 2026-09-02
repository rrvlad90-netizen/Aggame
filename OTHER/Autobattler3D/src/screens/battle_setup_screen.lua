local Button = require('src.ui.button')

local BattleSetupScreen = {}
BattleSetupScreen.__index =
  BattleSetupScreen

local ROWS = {
  {
    id = 'playerSide',
    label = 'PLAYER SIDE',
    source = 'side'
  },

  {
    id = 'enemySide',
    label = 'ENEMY SIDE',
    source = 'side'
  },

  {
    id = 'map',
    label = 'CHOOSE MAP',
    source = 'map'
  }
}


-- Создаёт экран настройки боя.
function BattleSetupScreen.new(app)
  local self =
    setmetatable(
      {},
      BattleSetupScreen
    )

  self.app = app
  self.theme = app.theme
  self.ui = app.ui

  self.transparent = true
  self.updateBelow = false

  self.pending = {
    playerSide =
      app.settings.battle.playerSide,

    enemySide =
      app.settings.battle.enemySide,

    map =
      app.settings.battle.map
  }

  self.indices = {}
  self.arrowButtons = {}
  self.rowFocus = 1
  self.fadeProgress = 0

  self:refreshIndices()
  self:createButtons()
  self:layout()

  return self
end


-- Возвращает список строки.
function BattleSetupScreen:getList(row)
  if row.source == 'side' then
    return self.app.sideRegistry:getAll()
  end

  return self.app.mapRegistry:getAll()
end


-- Ищет индекс элемента по ID.
function BattleSetupScreen:findIndex(
  list,
  selectedId
)
  for index, item in ipairs(list) do
    if item.id == selectedId then
      return index
    end
  end

  return #list > 0 and 1 or 0
end


-- Обновляет индексы выбранных элементов.
function BattleSetupScreen:refreshIndices()
  for _, row in ipairs(ROWS) do
    local list = self:getList(row)

    self.indices[row.id] =
      self:findIndex(
        list,
        self.pending[row.id]
      )

    local selected =
      list[self.indices[row.id]]

    if selected then
      self.pending[row.id] =
        selected.id
    end
  end
end


-- Создаёт кнопки экрана.
function BattleSetupScreen:createButtons()
  for _, row in ipairs(ROWS) do
    self.arrowButtons[row.id] = {
      left = Button.new({
        text = '<',
        theme = self.theme,
        ui = self.ui,

        onClick = function()
          self:cycle(row.id, -1)
        end
      }),

      right = Button.new({
        text = '>',
        theme = self.theme,
        ui = self.ui,

        onClick = function()
          self:cycle(row.id, 1)
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
function BattleSetupScreen:layout()
  self.panelX = 100
  self.panelY = 45
  self.panelWidth = 1080
  self.panelHeight = 630

  self.rowsX = 155
  self.rowsY = 150
  self.rowsWidth = 520
  self.rowHeight = 105

  self.previewX = 720
  self.previewY = 150
  self.previewWidth = 405
  self.previewHeight = 365

  for index, row in ipairs(ROWS) do
    local y =
      self.rowsY +
      (index - 1) *
      self.rowHeight

    local arrows =
      self.arrowButtons[row.id]

    arrows.left:setBounds(
      self.rowsX,
      y + 37,
      58,
      52
    )

    arrows.right:setBounds(
      self.rowsX +
      self.rowsWidth - 58,
      y + 37,
      58,
      52
    )
  end

  self.applyButton:setBounds(
    385,
    575,
    240,
    58
  )

  self.cancelButton:setBounds(
    655,
    575,
    240,
    58
  )
end


-- Возвращает описание строки.
function BattleSetupScreen:getRow(rowId)
  for _, row in ipairs(ROWS) do
    if row.id == rowId then
      return row
    end
  end

  return nil
end


-- Возвращает выбранный объект строки.
function BattleSetupScreen:getSelected(row)
  local list = self:getList(row)

  return list[
    self.indices[row.id]
  ]
end


-- Переключает выбранный элемент.
function BattleSetupScreen:cycle(
  rowId,
  direction
)
  local row = self:getRow(rowId)

  if not row then
    return
  end

  local list = self:getList(row)

  if #list == 0 then
    return
  end

  local index =
    (
      self.indices[rowId] -
      1 +
      direction
    ) % #list + 1

  self.indices[rowId] = index
  self.pending[rowId] =
    list[index].id

  for rowIndex, candidate in ipairs(
    ROWS
  ) do
    if candidate.id == rowId then
      self.rowFocus = rowIndex
      break
    end
  end
end


-- Сохраняет выбор и запускает бой.
function BattleSetupScreen:apply()
  self.app.settings.battle.playerSide =
    self.pending.playerSide

  self.app.settings.battle.enemySide =
    self.pending.enemySide

  self.app.settings.battle.map =
    self.pending.map

  self.app:saveSettings()
  self.app:startConfiguredBattle()
end


-- Запускает появление окна.
function BattleSetupScreen:enter()
  self.fadeProgress = 0
end


-- Обновляет появление окна.
function BattleSetupScreen:update(dt)
  local duration =
    self.theme:getTransition(
      'dialogFadeDuration'
    )

  self.fadeProgress =
    math.min(
      self.fadeProgress +
      dt / math.max(duration, .001),
      1
    )
end


-- Рисует строку выбора.
function BattleSetupScreen:drawRow(
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
      self.theme:getColor('button')

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

  local selected =
    self:getSelected(row)

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
    selected
      and selected.name
      or 'NOT AVAILABLE',
    self.rowsX + 65,
    y + 37,
    self.rowsWidth - 130,
    52,
    25,
    self.theme:getColor('text'),
    -3.79
  )

  local arrows =
    self.arrowButtons[row.id]

  arrows.left:draw(pass)
  arrows.right:draw(pass)
end


-- Рисует предпросмотр выбранной строки.
function BattleSetupScreen:drawPreview(pass)
  local row = ROWS[self.rowFocus]
  local selected =
    self:getSelected(row)

  self.theme:drawPanel(
    pass,
    self.ui,
    self.previewX,
    self.previewY,
    self.previewWidth,
    self.previewHeight,
    1
  )

  if not selected then
    return
  end

  self.ui:drawText(
    pass,
    'NO PREVIEW',
    self.previewX + 25,
    self.previewY + 25,
    self.previewWidth - 50,
    165,
    24,
    self.theme:getColor(
      'mutedText'
    ),
    -3.76
  )

  self.ui:drawText(
    pass,
    selected.name,
    self.previewX + 20,
    self.previewY + 205,
    self.previewWidth - 40,
    45,
    29,
    self.theme:getColor('text'),
    -3.76
  )

  self.ui:drawText(
    pass,
    selected.description or '',
    self.previewX + 20,
    self.previewY + 260,
    self.previewWidth - 40,
    60,
    17,
    self.theme:getColor(
      'mutedText'
    ),
    -3.76
  )
end


-- Рисует экран настройки боя.
function BattleSetupScreen:draw(pass)
  self.ui:begin(pass)

  self.theme:drawOverlay(
    pass,
    self.ui,
    self.fadeProgress
  )

  self.theme:drawPanel(
    pass,
    self.ui,
    self.panelX,
    self.panelY,
    self.panelWidth,
    self.panelHeight,
    self.fadeProgress
  )

  self.ui:drawText(
    pass,
    'BATTLE',
    self.panelX,
    self.panelY + 20,
    self.panelWidth,
    70,
    45,
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

  self:drawPreview(pass)
  self.applyButton:draw(pass)
  self.cancelButton:draw(pass)
end


-- Обрабатывает движение мыши.
function BattleSetupScreen:mousemoved(x, y)
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
function BattleSetupScreen:mousepressed(
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
        x, y, button
      )
      or arrows.right:mousepressed(
        x, y, button
      )
    then
      return
    end
  end

  if self.applyButton:mousepressed(
    x, y, button
  ) then
    return
  end

  self.cancelButton:mousepressed(
    x, y, button
  )
end


-- Обрабатывает отпускание мыши.
function BattleSetupScreen:mousereleased(
  x,
  y,
  button
)
  for _, row in ipairs(ROWS) do
    local arrows =
      self.arrowButtons[row.id]

    if
      arrows.left:mousereleased(
        x, y, button
      )
      or arrows.right:mousereleased(
        x, y, button
      )
    then
      return
    end
  end

  if self.applyButton:mousereleased(
    x, y, button
  ) then
    return
  end

  self.cancelButton:mousereleased(
    x, y, button
  )
end


-- Обрабатывает клавиатуру.
function BattleSetupScreen:keypressed(key)
  if key == 'up' or key == 'w' then
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
    self:cycle(
      ROWS[self.rowFocus].id,
      -1
    )
  elseif
    key == 'right'
    or key == 'd'
  then
    self:cycle(
      ROWS[self.rowFocus].id,
      1
    )
  elseif
    key == 'return'
    or key == 'space'
  then
    self:apply()
  elseif key == 'escape' then
    self.app.screens:pop()
  end
end


return BattleSetupScreen