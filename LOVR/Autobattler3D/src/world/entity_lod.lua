local EntityLod = {}
EntityLod.__index = EntityLod

local materialCache = {}


-- Загружает материал дальнего спрайта.
local function getMaterial(
  path,
  alphaCutoff
)
  local key =
    path ..
    ':' ..
    tostring(alphaCutoff)

  if materialCache[key] then
    return materialCache[key]
  end

  local texture =
    lovr.graphics.newTexture(path)

  local material =
    lovr.graphics.newMaterial({
      texture = texture,
      alphaCutoff = alphaCutoff
    })

  materialCache[key] = material

  return material
end


-- Создаёт контроллер дальнего LOD.
function EntityLod.new(config)
  local self =
    setmetatable({}, EntityLod)

  self.config = config
  self.active = false
  self.material = nil

  if
    config
    and config.enabled ~= false
    and config.sprite
  then
    self.material =
      getMaterial(
        config.sprite,
        config.alphaCutoff or .1
      )
  end

  return self
end


-- Проверяет наличие дальнего спрайта.
function EntityLod:isAvailable()
  return
    self.config ~= nil
    and self.config.enabled
      ~= false
    and self.material ~= nil
end


-- Выбирает модель или дальний спрайт.
function EntityLod:shouldDraw(
  entity,
  camera,
  allowed
)
  if
    not allowed
    or not camera
    or not self:isAvailable()
  then
    self.active = false
    return false
  end

  local dx =
    entity.x - camera.x

  local dy =
    entity.y +
    entity.yOffset -
    camera.y

  local dz =
    entity.z - camera.z

  local distanceSquared =
    dx * dx +
    dy * dy +
    dz * dz

  local distance =
    self.config.distance or 55

  local hysteresis =
    self.config.hysteresis or 5

  local threshold

  if self.active then
    threshold =
      math.max(
        0,
        distance - hysteresis
      )
  else
    threshold =
      distance + hysteresis
  end

  self.active =
    distanceSquared >=
    threshold * threshold

  return self.active
end


-- Рисует обращённый к камере спрайт.
function EntityLod:draw(
  pass,
  entity,
  camera
)
  local config = self.config

  local scale =
    config.scale or 2

  local canvas =
    config.canvas
    or {
      width = 1,
      height = 1
    }

  local aspect =
    (canvas.width or 1) /
    math.max(
      canvas.height or 1,
      1
    )

  local width =
    config.width
    or scale * aspect

  local height =
    config.height
    or scale

  local centerY =
    entity.y +
    entity.yOffset +
    (config.yOffset or 0)

  local transform =
    lovr.math.newMat4()

  transform:translate(
    entity.x +
      (config.xOffset or 0),

    centerY,

    entity.z +
      (config.zOffset or 0)
  )

  -- Цилиндрический billboard:
  -- юнит остаётся вертикальным.
  transform:rotate(
    camera.yaw,
    0, 1, 0
  )

  transform:scale(
    width,
    height,
    1
  )

  pass:setShader()

  pass:setMaterial(
    self.material
  )

  local tint =
    config.tint
    or entity.tint

  pass:setColor(
    tint[1] or 1,
    tint[2] or 1,
    tint[3] or 1,

    (tint[4] or 1) *
    entity.alpha *
    (config.alpha or 1)
  )

  pass:plane(transform)

  pass:setColor(1, 1, 1, 1)
  pass:setMaterial()
end


return EntityLod