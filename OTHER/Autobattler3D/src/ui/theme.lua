local Theme = {}
Theme.__index = Theme


-- Создаёт стандартную тему интерфейса.
function Theme.new()
  local self =
    setmetatable({}, Theme)

  self.colors = {
    background = {
      .035, .055, .045, 1
    },

    overlay = {
      .01, .02, .015, .78
    },

    panel = {
      .09, .14, .11, .98
    },

    panelBorder = {
      .48, .38, .20, 1
    },

    text = {
      .94, .92, .82, 1
    },

    mutedText = {
      .66, .68, .61, 1
    },

    warningText = {
      1, .45, .30, 1
    },

    button = {
      .18, .38, .24, 1
    },

    buttonHover = {
      .25, .52, .32, 1
    },

    buttonPressed = {
      .12, .29, .18, 1
    },

    buttonDisabled = {
      .20, .22, .20, 1
    }
  }

  self.dimensions = {
    buttonWidth = 340,
    buttonHeight = 62,
    buttonSpacing = 16,
    panelPadding = 32
  }

  self.transitions = {
    screenFadeDuration = .25,
    dialogFadeDuration = .20
  }

  return self
end


-- Возвращает цвет темы.
function Theme:getColor(name)
  return
    self.colors[name]
    or { 1, 1, 1, 1 }
end


-- Возвращает размер UI.
function Theme:getDimension(name)
  return self.dimensions[name]
end


-- Возвращает длительность перехода.
function Theme:getTransition(name)
  return
    self.transitions[name]
    or 0
end


-- Рисует фон интерфейса.
function Theme:drawBackground(pass, ui)
  ui:drawRectangle(
    pass,
    0,
    0,
    ui.virtualWidth,
    ui.virtualHeight,
    self:getColor('background'),
    -4.2
  )
end


-- Рисует затемнение.
function Theme:drawOverlay(
  pass,
  ui,
  alpha
)
  local source =
    self:getColor('overlay')

  local color = {
    source[1],
    source[2],
    source[3],
    (source[4] or 1) *
      (alpha or 1)
  }

  ui:drawRectangle(
    pass,
    0,
    0,
    ui.virtualWidth,
    ui.virtualHeight,
    color,
    -4.05
  )
end


-- Рисует панель с границей.
function Theme:drawPanel(
  pass,
  ui,
  x,
  y,
  width,
  height,
  alpha
)
  local border =
    self:getColor('panelBorder')

  local panel =
    self:getColor('panel')

  ui:drawRectangle(
    pass,
    x - 3,
    y - 3,
    width + 6,
    height + 6,
    {
      border[1],
      border[2],
      border[3],
      (border[4] or 1) *
        (alpha or 1)
    },
    -3.99
  )

  ui:drawRectangle(
    pass,
    x,
    y,
    width,
    height,
    {
      panel[1],
      panel[2],
      panel[3],
      (panel[4] or 1) *
        (alpha or 1)
    },
    -3.96
  )
end


-- Рисует фон кнопки.
function Theme:drawButtonBackground(
  pass,
  ui,
  state,
  x,
  y,
  width,
  height
)
  local colorNames = {
    normal = 'button',
    hover = 'buttonHover',
    pressed = 'buttonPressed',
    disabled = 'buttonDisabled'
  }

  ui:drawRectangle(
    pass,
    x,
    y,
    width,
    height,
    self:getColor(
      colorNames[state]
      or 'button'
    ),
    -3.88
  )
end


return Theme