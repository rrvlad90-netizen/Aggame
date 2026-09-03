local UiContext = {}
UiContext.__index = UiContext


-- Создаёт виртуальную область интерфейса.
function UiContext.new()
  local self =
    setmetatable({}, UiContext)

  self.virtualWidth = 1280
  self.virtualHeight = 720

  -- Весь интерфейс рисуется на одной
  -- плоскости без перспективного сдвига.
  self.depth = 4

  -- Соответствует стандартному углу,
  -- используемому экранной камерой.
  self.verticalFov =
    math.rad(67)

  self:updateWindowSize()

  return self
end


-- Обновляет размеры окна и UI-плоскости.
function UiContext:updateWindowSize()
  local width, height =
    lovr.system.getWindowDimensions()

  self.windowWidth =
    math.max(width, 1)

  self.windowHeight =
    math.max(height, 1)

  -- Вычисляет видимую высоту пространства
  -- на глубине расположения интерфейса.
  self.worldHeight =
    2 *
    self.depth *
    math.tan(
      self.verticalFov / 2
    )

  self.worldWidth =
    self.worldHeight *
    self.windowWidth /
    self.windowHeight
end


-- Переводит координаты мыши
-- в виртуальные координаты UI.
function UiContext:toVirtual(x, y)
  return
    x / self.windowWidth *
    self.virtualWidth,

    y / self.windowHeight *
    self.virtualHeight
end


-- Переводит прямоугольник UI
-- в координаты пространства LÖVR.
function UiContext:toWorldRect(
  x,
  y,
  width,
  height
)
  local centerX =
    x + width / 2

  local centerY =
    y + height / 2

  local worldX =
    centerX /
    self.virtualWidth *
    self.worldWidth -
    self.worldWidth / 2

  local worldY =
    self.worldHeight / 2 -
    centerY /
    self.virtualHeight *
    self.worldHeight

  local worldWidth =
    width /
    self.virtualWidth *
    self.worldWidth

  local worldHeight =
    height /
    self.virtualHeight *
    self.worldHeight

  return
    worldX,
    worldY,
    worldWidth,
    worldHeight
end


-- Подготавливает проход к рисованию UI.
function UiContext:begin(pass)
  -- Убирает материал последней модели
  -- или спрайтового снаряда.
  pass:setShader()
  pass:setMaterial()
  pass:setColor(1, 1, 1, 1)

  pass:setDepthTest()
  pass:setDepthWrite(false)
  pass:setCullMode('none')
end


-- Рисует цветной прямоугольник.
function UiContext:drawRectangle(
  pass,
  x,
  y,
  width,
  height,
  color,
  z
)
  local worldX,
    worldY,
    worldWidth,
    worldHeight =
    self:toWorldRect(
      x,
      y,
      width,
      height
    )

  -- Каждый прямоугольник HUD должен
  -- использовать однотонный материал.
  pass:setShader()
  pass:setMaterial()

  pass:setColor(
    color[1],
    color[2],
    color[3],
    color[4] or 1
  )

  -- Параметр z сохранён в интерфейсе
  -- функции для совместимости, но все
  -- элементы рисуются на одной глубине.
  pass:box(
    worldX,
    worldY,
    -self.depth,
    worldWidth,
    worldHeight,
    .001
  )
end


-- Рисует текст по центру прямоугольника.
function UiContext:drawText(
  pass,
  text,
  x,
  y,
  width,
  height,
  size,
  color,
  z
)
  local worldX,
    worldY =
    self:toWorldRect(
      x,
      y,
      width,
      height
    )

  local scale =
    size /
    self.virtualHeight *
    self.worldHeight

  pass:setShader()
  pass:setMaterial()

  pass:setColor(
    color[1],
    color[2],
    color[3],
    color[4] or 1
  )

  pass:text(
    tostring(text or ''),
    worldX,
    worldY,
    -self.depth,
    scale
  )
end


return UiContext