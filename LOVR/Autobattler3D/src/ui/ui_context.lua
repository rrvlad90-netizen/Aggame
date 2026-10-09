local UiContext = {}
UiContext.__index = UiContext


-- Создаёт виртуальную область интерфейса.
function UiContext.new()
  local self =
    setmetatable({}, UiContext)

  self.virtualWidth = 1280
  self.virtualHeight = 720

  self.depth = 4
  self.imageCache = {}

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

  pass:setShader()
  pass:setMaterial()

  pass:setColor(
    color[1],
    color[2],
    color[3],
    color[4] or 1
  )

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


-- Безопасно загружает UI-изображение.
function UiContext:getImage(path)
  if
    type(path) ~= 'string'
    or path == ''
  then
    return nil
  end

  if self.imageCache[path] ~= nil then
    return
      self.imageCache[path]
      or nil
  end

  if lovr.filesystem.isFile then
    local success, exists =
      pcall(
        lovr.filesystem.isFile,
        path
      )

    if success and not exists then
      print(
        '[ui] image not found: ' ..
        path
      )

      self.imageCache[path] = false
      return nil
    end
  end

  local success, texture =
    pcall(
      lovr.graphics.newTexture,
      path
    )

  if not success or not texture then
    print(
      '[ui] failed to load image: ' ..
      path
    )

    self.imageCache[path] = false
    return nil
  end

  self.imageCache[path] = texture

  return texture
end


-- Рисует изображение с сохранением пропорций.
function UiContext:drawImage(
  pass,
  path,
  x,
  y,
  width,
  height,
  options
)
  options = options or {}

  local texture =
    self:getImage(path)

  if not texture then
    return false
  end

  local imageWidth,
    imageHeight =
    texture:getDimensions()

  local drawWidth = width
  local drawHeight = height

  local imageAspect =
    imageWidth / imageHeight

  local targetAspect =
    width / height

  if options.fit == 'contain' then
    if imageAspect > targetAspect then
      drawHeight =
        width / imageAspect
    else
      drawWidth =
        height * imageAspect
    end

  elseif options.fit == 'cover' then
    if imageAspect > targetAspect then
      drawWidth =
        height * imageAspect
    else
      drawHeight =
        width / imageAspect
    end
  end

  local drawX =
    x + (width - drawWidth) / 2

  local drawY =
    y + (height - drawHeight) / 2

  local worldX,
    worldY,
    worldWidth,
    worldHeight =
    self:toWorldRect(
      drawX,
      drawY,
      drawWidth,
      drawHeight
    )

  local transform =
    lovr.math.newMat4()

  transform:translate(
    worldX,
    worldY,
    -self.depth
  )

  transform:scale(
    worldWidth,
    worldHeight,
    1
  )

  pass:setShader()
  pass:setMaterial(texture)

  pass:setColor(
    1,
    1,
    1,
    options.alpha or 1
  )

  pass:plane(transform)

  pass:setMaterial()
  pass:setColor(1, 1, 1, 1)

  return true
end


return UiContext