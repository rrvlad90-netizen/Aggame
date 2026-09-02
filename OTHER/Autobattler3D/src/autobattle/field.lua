local Decor =
  require('src.decors.decor')
  
local ModelLighting =
  require(
    'src.graphics.model_lighting'
  )  

local Field = {}
Field.__index = Field


-- Загружает текстурный материал.
local function createMaterial(path)
  if not path then
    return nil
  end

  local texture =
    lovr.graphics.newTexture(path)

  return lovr.graphics.newMaterial({
    texture = texture
  })
end


-- Создаёт поле боя и декорации.
function Field.new(
  config,
  decorDefinitions,
  modelRegistry,
  lighting
)
  local self =
    setmetatable({}, Field)

  self.config = config
  self.decors = {}
  
  self.lighting =
    lighting or {}

  self.decorLightingShader =
    ModelLighting.new()

  self.groundMaterial =
    config.ground
    and createMaterial(
      config.ground.texture
    )

  self.skyMaterial =
    config.sky
    and createMaterial(
      config.sky.texture
    )

  for index, definition in ipairs(
    decorDefinitions or {}
  ) do
    self.decors[#self.decors + 1] =
      Decor.new(
        definition,
        modelRegistry,
        index
      )
  end

  return self
end


-- Поле не ограничивает бойцов.
function Field:keepUnitInside(unit)
end


-- Разрешает столкновения с декорами.
function Field:resolveUnitCollisions(unit)
  for _, decor in ipairs(
    self.decors
  ) do
    decor:resolveUnitCollision(
      unit
    )
  end
end


-- Рисует сферическое небо.
function Field:drawSky(pass)
  local sky =
    self.config.sky

  if
    not sky
    or not self.skyMaterial
  then
    return
  end

  pass:setDepthWrite(false)
  pass:setCullMode('none')

  pass:setMaterial(
    self.skyMaterial
  )

  pass:setColor(
    1,
    1,
    1,
    sky.alpha or 1
  )

  pass:sphere(
    sky.x or 0,
    sky.y or 0,
    sky.z or 0,
    sky.radius or 300
  )

  pass:setDepthWrite(true)
  pass:setColor(1, 1, 1, 1)
end


-- Рисует текстурированную землю.
function Field:drawFloor(pass)
  local ground =
    self.config.ground
    or {}

  local visualWidth =
    ground.visualWidth
    or self.config.width

  local visualLength =
    ground.visualLength
    or self.config.length

  local tileSize =
    ground.tileSize
    or 24

  local halfWidth =
    visualWidth / 2

  local halfLength =
    visualLength / 2

  if self.groundMaterial then
    pass:setMaterial(
      self.groundMaterial
    )
  end

  pass:setColor(1, 1, 1, 1)

  local x = -halfWidth

  while x < halfWidth do
    local tileWidth =
      math.min(
        tileSize,
        halfWidth - x
      )

    local z = -halfLength

    while z < halfLength do
      local tileLength =
        math.min(
          tileSize,
          halfLength - z
        )

      pass:box(
        x + tileWidth / 2,

        self.config.floorY -
          self.config.floorThickness / 2,

        z + tileLength / 2,

        tileWidth,
        self.config.floorThickness,
        tileLength
      )

      z = z + tileSize
    end

    x = x + tileSize
  end
end


-- Рисует временные границы армий.
function Field:drawEdgeMarkers(pass)
  if self.config.alliedEdgeZ then
    pass:setMaterial()
    pass:setColor(.18, .32, .75)

    pass:box(
      0,
      .02,
      self.config.alliedEdgeZ,
      self.config.width,
      .04,
      .25
    )
  end

  if self.config.enemyEdgeZ then
    pass:setMaterial()
    pass:setColor(.75, .20, .16)

    pass:box(
      0,
      .02,
      self.config.enemyEdgeZ,
      self.config.width,
      .04,
      .25
    )
  end
end


-- Рисует декорации с направленным светом.
function Field:drawDecors(pass)
  local lighting =
    self.lighting

  local enabled =
    lighting.enabled ~= false

  if enabled then
    pass:setShader(
      self.decorLightingShader
    )

    pass:send(
      'sunDirection',
      lighting.sunDirection
      or {
        -.45,
        .8,
        .3
      }
    )

    pass:send(
      'ambientLight',
      lighting.ambientLight
      or .42
    )

    pass:send(
      'sunStrength',
      lighting.sunStrength
      or .75
    )
  end

  for _, decor in ipairs(
    self.decors
  ) do
    decor:draw(pass)
  end

  pass:setShader()
end


-- Рисует поле боя.
function Field:draw(pass)
  self:drawSky(pass)
  self:drawFloor(pass)
  self:drawEdgeMarkers(pass)
  self:drawDecors(pass)

  pass:setMaterial()
  pass:setColor(1, 1, 1, 1)
end


return Field