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
	
	self.groundMesh = nil

	if
	  config.terrain
	  and config.terrain.enabled
	then
	  self.groundMesh =
		self:createGroundMesh()
	end	

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


-- Возвращает высоту рельефа в точке.
function Field:getHeight(x, z)
  local height =
    self.config.floorY or 0

  local terrain =
    self.config.terrain

  if
    not terrain
    or not terrain.enabled
  then
    return height
  end

  for _, hill in ipairs(
    terrain.hills or {}
  ) do
    local dx = x - hill.x
    local dz = z - hill.z

    local radius =
      math.max(hill.radius or 1, .001)

    local distance =
      math.sqrt(
        dx * dx + dz * dz
      )

    if distance < radius then
      local progress =
        distance / radius

      -- Плавное закругление без резкого края.
      local influence =
        1 - progress * progress

      influence =
        influence * influence

      height =
        height +
        (hill.height or 0) *
        influence
    end
  end

  return height
end


-- Возвращает нормаль поверхности.
function Field:getNormal(x, z)
  local sample = .25

  local left =
    self:getHeight(x - sample, z)

  local right =
    self:getHeight(x + sample, z)

  local back =
    self:getHeight(x, z - sample)

  local forward =
    self:getHeight(x, z + sample)

  local normalX = left - right
  local normalY = sample * 2
  local normalZ = back - forward

  local length =
    math.sqrt(
      normalX * normalX +
      normalY * normalY +
      normalZ * normalZ
    )

  return
    normalX / length,
    normalY / length,
    normalZ / length
end


-- Добавляет вершину рельефа.
function Field:addGroundVertex(
  vertices,
  x,
  z,
  tileSize
)
  local y =
    self:getHeight(x, z)

  local normalX,
    normalY,
    normalZ =
    self:getNormal(x, z)

  vertices[#vertices + 1] = {
    x,
    y,
    z,

    normalX,
    normalY,
    normalZ,

    x / tileSize,
    z / tileSize
  }
end


-- Создаёт статический mesh поверхности.
function Field:createGroundMesh()
  local ground =
    self.config.ground or {}

  local terrain =
    self.config.terrain or {}

  local width =
    ground.visualWidth
    or self.config.width

  local length =
    ground.visualLength
    or self.config.length

  local cellSize =
    terrain.cellSize or 4

  local tileSize =
    ground.tileSize or 24

  local columns =
    math.max(
      1,
      math.ceil(width / cellSize)
    )

  local rows =
    math.max(
      1,
      math.ceil(length / cellSize)
    )

  local stepX = width / columns
  local stepZ = length / rows

  local startX = -width / 2
  local startZ = -length / 2

  local vertices = {}

  for row = 0, rows - 1 do
    local z1 =
      startZ + row * stepZ

    local z2 = z1 + stepZ

    for column = 0, columns - 1 do
      local x1 =
        startX + column * stepX

      local x2 = x1 + stepX

      -- Первый треугольник.
      self:addGroundVertex(
        vertices, x1, z1, tileSize
      )

      self:addGroundVertex(
        vertices, x2, z1, tileSize
      )

      self:addGroundVertex(
        vertices, x2, z2, tileSize
      )

      -- Второй треугольник.
      self:addGroundVertex(
        vertices, x1, z1, tileSize
      )

      self:addGroundVertex(
        vertices, x2, z2, tileSize
      )

      self:addGroundVertex(
        vertices, x1, z2, tileSize
      )
    end
  end

  local format = {
    {
      'VertexPosition',
      'vec3'
    },
    {
      'VertexNormal',
      'vec3'
    },
    {
      'VertexUV',
      'vec2'
    }
  }

	local mesh =
	  lovr.graphics.newMesh(
		format,
		vertices,
		'cpu',
		'triangles'
	  )

  if self.groundMaterial then
    mesh:setMaterial(
      self.groundMaterial
    )
  end

  return mesh
end


-- Поле не ограничивает бойцов.
function Field:keepUnitInside(unit)
end


-- Разрешает столкновения с декорами.
function Field:resolveUnitCollisions(unit)
  unit.y =
    self:getHeight(
      unit.x,
      unit.z
    )

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

	if self.groundMesh then
	  pass:setMaterial(
		self.groundMaterial
	  )

	  pass:setColor(1, 1, 1, 1)
	  pass:draw(self.groundMesh)

	  return
	end

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

-- Ищет пересечение луча с рельефом.
function Field:raycastGround(
  originX,
  originY,
  originZ,
  directionX,
  directionY,
  directionZ
)
  if directionY >= 0 then
    return nil
  end

  local step = 1
  local maximumDistance = 1000

  local previousDistance = 0

  local previousDifference =
    originY -
    self:getHeight(
      originX,
      originZ
    )

  for distance = step,
    maximumDistance,
    step
  do
    local x =
      originX +
      directionX * distance

    local y =
      originY +
      directionY * distance

    local z =
      originZ +
      directionZ * distance

    local difference =
      y - self:getHeight(x, z)

    if
      previousDifference >= 0
      and difference <= 0
    then
      local minimum =
        previousDistance

      local maximum = distance

      -- Уточняет точку пересечения.
      for _ = 1, 12 do
        local middle =
          (minimum + maximum) / 2

        local middleX =
          originX +
          directionX * middle

        local middleY =
          originY +
          directionY * middle

        local middleZ =
          originZ +
          directionZ * middle

        local terrainY =
          self:getHeight(
            middleX,
            middleZ
          )

        if middleY > terrainY then
          minimum = middle
        else
          maximum = middle
        end
      end

      local hitDistance =
        (minimum + maximum) / 2

      local hitX =
        originX +
        directionX * hitDistance

      local hitZ =
        originZ +
        directionZ * hitDistance

      return
        hitX,
        hitZ,
        self:getHeight(hitX, hitZ)
    end

    previousDistance = distance
    previousDifference = difference
  end

  return nil
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