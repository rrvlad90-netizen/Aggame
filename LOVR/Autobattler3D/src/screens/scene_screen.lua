local SceneScreen = {}
SceneScreen.__index = SceneScreen


local function loadTexture(path)
  if not path then
    return nil
  end

  if
    lovr.filesystem.isFile
    and not lovr.filesystem.isFile(path)
  then
    print(
      '[scene] image not found: ' ..
      path
    )

    return nil
  end

  local success, texture =
    pcall(
      lovr.graphics.newTexture,
      path
    )

  if not success then
    print(
      '[scene] failed to load: ' ..
      path
    )

    return nil
  end

  return texture
end


function SceneScreen.new(
  app,
  definition,
  onComplete
)
  local self =
    setmetatable({}, SceneScreen)

  self.app = app
  self.ui = app.ui
  self.theme = app.theme
  self.definition = definition
  self.onComplete = onComplete

  self.frameIndex = 1
  self.timer = 0
  self.finished = false
  self.textures = {}

  for _, frame in ipairs(
    definition.frames or {}
  ) do
    if
      frame.image
      and not self.textures[
        frame.image
      ]
    then
      self.textures[frame.image] =
        loadTexture(frame.image)
    end
  end

  return self
end


function SceneScreen:getFrame()
  return self.definition.frames[
    self.frameIndex
  ]
end


function SceneScreen:finish()
  if self.finished then
    return
  end

  self.finished = true

  local callback =
    self.onComplete

  self.onComplete = nil

  if callback then
    callback()
  end
end


function SceneScreen:nextFrame()
  self.frameIndex =
    self.frameIndex + 1

  self.timer = 0

  if
    self.frameIndex >
    #self.definition.frames
  then
    self:finish()
  end
end


function SceneScreen:update(dt)
  if self.finished then
    return
  end

  local frame =
    self:getFrame()

  if not frame then
    self:finish()
    return
  end

  self.timer =
    self.timer + dt

  if
    self.timer >=
    (frame.duration or 3)
  then
    self:nextFrame()
  end
end


function SceneScreen:drawImage(
  pass,
  texture,
  x,
  y,
  width,
  height
)
  if not texture then
    return
  end

  local worldX,
    worldY,
    worldWidth,
    worldHeight =
    self.ui:toWorldRect(
      x,
      y,
      width,
      height
    )

  local transform =
    lovr.math.newMat4()

  transform:translate(
    worldX,
    worldY,
    -self.ui.depth
  )

  transform:scale(
    worldWidth,
    worldHeight,
    1
  )

  pass:setShader()
  pass:setMaterial(texture)
  pass:setColor(1, 1, 1, 1)
  pass:plane(transform)
  pass:setMaterial()
end


function SceneScreen:draw(pass)
  self.ui:begin(pass)

  self.theme:drawBackground(
    pass,
    self.ui
  )

  local frame =
    self:getFrame()

  if not frame then
    return
  end

  if frame.image then
    self:drawImage(
      pass,
      self.textures[frame.image],
      0,
      0,
      self.ui.virtualWidth,
      560
    )
  end

  self.theme:drawPanel(
    pass,
    self.ui,
    40,
    555,
    1200,
    130,
    1
  )

  if frame.title then
    self.ui:drawText(
      pass,
      frame.title,
      40,
      35,
      1200,
      70,
      42,
      self.theme:getColor('text'),
      -3.8
    )
  end

  self.ui:drawText(
    pass,
    frame.text or '',
    70,
    575,
    1140,
    60,
    26,
    self.theme:getColor('text'),
    -3.8
  )

  if
    self.definition.skipAllowed
      ~= false
  then
    self.ui:drawText(
      pass,
      'ENTER / SPACE / CLICK TO SKIP',
      70,
      640,
      1140,
      28,
      16,
      self.theme:getColor(
        'mutedText'
      ),
      -3.8
    )
  end

  pass:setColor(1, 1, 1, 1)
end


function SceneScreen:skip()
  if
    self.definition.skipAllowed
      ~= false
  then
    self:finish()
  end
end


function SceneScreen:keypressed(key)
  if
    key == 'return'
    or key == 'space'
  then
    self:skip()
  elseif key == 'escape' then
    self.app:showMenu()
  end
end


function SceneScreen:mousepressed(
  x,
  y,
  button
)
  if button == 1 then
    self:skip()
  end
end


return SceneScreen