local Camera = {}
Camera.__index = Camera


-- Ограничивает значение диапазоном.
local function clamp(value, minimum, maximum)
  return math.max(
    minimum,
    math.min(maximum, value)
  )
end


-- Создаёт камеру поля боя.
function Camera.new(config)
  local self = setmetatable({}, Camera)

  self.config = config
  self.rotating = false

  self:reset()

  return self
end


-- Сбрасывает положение камеры.
function Camera:reset()
  self.x = self.config.x
  self.y = self.config.y
  self.z = self.config.z

  self.yaw = self.config.yaw
  self.pitch = self.config.pitch
end


-- Начинает вращение камеры.
function Camera:beginRotation()
  self.rotating = true
  lovr.system.setMouseMode('relative')
end


-- Завершает вращение камеры.
function Camera:endRotation()
  self.rotating = false
  lovr.system.setMouseMode('normal')
end


-- Обрабатывает движение мыши.
function Camera:mousemoved(dx, dy)
  if not self.rotating then
    return
  end

  self.yaw =
    self.yaw -
    dx * self.config.sensitivity

  self.pitch =
    self.pitch -
    dy * self.config.sensitivity

  self.pitch = clamp(
    self.pitch,
    -math.pi / 2 + .05,
    -.08
  )
end


-- Обновляет клавиатурное движение.
function Camera:update(dt)
  local forward = 0
  local sideways = 0
  local vertical = 0

  if lovr.system.isKeyDown('w') then
    forward = forward + 1
  end

  if lovr.system.isKeyDown('s') then
    forward = forward - 1
  end

  if lovr.system.isKeyDown('a') then
    sideways = sideways - 1
  end

  if lovr.system.isKeyDown('d') then
    sideways = sideways + 1
  end

  if lovr.system.isKeyDown('r') then
    vertical = vertical + 1
  end

  if lovr.system.isKeyDown('f') then
    vertical = vertical - 1
  end

  local forwardX = -math.sin(self.yaw)
  local forwardZ = -math.cos(self.yaw)

  local rightX = math.cos(self.yaw)
  local rightZ = -math.sin(self.yaw)

  local movementX =
    forwardX * forward +
    rightX * sideways

  local movementZ =
    forwardZ * forward +
    rightZ * sideways

  local length =
    math.sqrt(
      movementX * movementX +
      movementZ * movementZ
    )

  if length > 0 then
    movementX = movementX / length
    movementZ = movementZ / length
  end

  local speed = self.config.moveSpeed

  if
    lovr.system.isKeyDown('lshift')
    or lovr.system.isKeyDown('rshift')
  then
    speed =
      speed * self.config.fastMultiplier
  end

  self.x = self.x + movementX * speed * dt
  self.z = self.z + movementZ * speed * dt
  self.y = clamp(
    self.y + vertical * speed * dt,
    self.config.minimumY,
    self.config.maximumY
  )
end


-- Применяет камеру к проходу.
function Camera:apply(pass)
  local pose = lovr.math.newMat4()

  pose:translate(self.x, self.y, self.z)
  pose:rotate(self.yaw, 0, 1, 0)
  pose:rotate(self.pitch, 1, 0, 0)

  pass:setViewPose(1, pose)
end


return Camera