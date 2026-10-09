local Camera = {}
Camera.__index = Camera


-- Ограничивает значение диапазоном.
local function clamp(
  value,
  minimum,
  maximum
)
  return math.max(
    minimum,
    math.min(maximum, value)
  )
end


-- Создаёт камеру поля боя.
function Camera.new(config)
  local self =
    setmetatable({}, Camera)

  self.config = config

  -- Состояния экранных кнопок.
	self.interfaceControls = {
	  up = false,
	  down = false,
	  left = false,
	  right = false,

	  tiltUp = false,
	  tiltDown = false
	}

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

  self:clearInterfaceControls()
end


-- Оставлено для совместимости
-- со старым кодом.
function Camera:beginRotation()
end


-- Оставлено для совместимости
-- со старым кодом.
function Camera:endRotation()
  lovr.system.setMouseMode('normal')
end


-- Вращение мышью отключено.
function Camera:mousemoved(dx, dy)
end


-- Изменяет состояние экранной кнопки.
function Camera:setInterfaceControl(
  control,
  active
)
  if
    self.interfaceControls[control]
    == nil
  then
    return false
  end

  self.interfaceControls[control] =
    active == true

  return true
end


-- Отпускает все экранные кнопки.
function Camera:clearInterfaceControls()
  for control in pairs(
    self.interfaceControls
  ) do
    self.interfaceControls[control] =
      false
  end
end


-- Приближает или отдаляет камеру.
function Camera:zoom(amount)
  local zoomStep =
    self.config.zoomStep or 4

  -- Положительное значение приближает.
  self.y =
    clamp(
      self.y - amount * zoomStep,
      self.config.minimumY,
      self.config.maximumY
    )
end


-- Центрирует камеру над объектом.
function Camera:focusOn(
  targetX,
  targetZ,
  field
)
  local groundY = 0

  if field and field.getHeight then
    groundY =
      field:getHeight(
        targetX,
        targetZ
      )
  end

  local cosinePitch =
    math.cos(self.pitch)

  local directionX =
    -math.sin(self.yaw) *
    cosinePitch

  local directionY =
    math.sin(self.pitch)

  local directionZ =
    -math.cos(self.yaw) *
    cosinePitch

  if
    math.abs(directionY) <
    .0001
  then
    self.x = targetX
    self.z = targetZ
    return
  end

  local distance =
    (groundY - self.y) /
    directionY

  self.x =
    targetX -
    directionX * distance

  self.z =
    targetZ -
    directionZ * distance
end

-- Обновляет движение и вращение камеры.
function Camera:update(dt)
  local forward = 0
  local sideways = 0
  local yawDirection = 0
  local pitchDirection = 0

  local up =
    lovr.system.isKeyDown('up')
    or self.interfaceControls.up

  local down =
    lovr.system.isKeyDown('down')
    or self.interfaceControls.down

  local left =
    lovr.system.isKeyDown('left')
    or self.interfaceControls.left

  local right =
    lovr.system.isKeyDown('right')
    or self.interfaceControls.right

  if up then
    forward = forward + 1
  end

  if down then
    forward = forward - 1
  end

  if left then
    yawDirection =
      yawDirection + 1
  end

  if right then
    yawDirection =
      yawDirection - 1
  end

  if
    lovr.system.isKeyDown('=')
    or lovr.system.isKeyDown('kp+')
    or self.interfaceControls.tiltUp
  then
    pitchDirection =
      pitchDirection + 1
  end

  if
    lovr.system.isKeyDown('-')
    or lovr.system.isKeyDown('kp-')
    or self.interfaceControls.tiltDown
  then
    pitchDirection =
      pitchDirection - 1
  end

  if lovr.system.isKeyDown('a') then
    sideways = sideways - 1
  end

  if lovr.system.isKeyDown('d') then
    sideways = sideways + 1
  end

  local rotationSpeed =
    self.config.rotationSpeed
    or 1.2

  local pitchSpeed =
    self.config.pitchSpeed
    or .8

  self.yaw =
    self.yaw +
    yawDirection *
    rotationSpeed *
    dt

  self.pitch =
    clamp(
      self.pitch +
      pitchDirection *
      pitchSpeed *
      dt,

      self.config.minimumPitch
      or -1.45,

      self.config.maximumPitch
      or -.2
    )

  local forwardX =
    -math.sin(self.yaw)

  local forwardZ =
    -math.cos(self.yaw)

  local rightX =
    math.cos(self.yaw)

  local rightZ =
    -math.sin(self.yaw)

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

  local speed =
    self.config.moveSpeed

  self.x =
    self.x +
    movementX * speed * dt

  self.z =
    self.z +
    movementZ * speed * dt
end


-- Применяет камеру к проходу.
function Camera:apply(pass)
  local pose =
    lovr.math.newMat4()

  pose:translate(
    self.x,
    self.y,
    self.z
  )

  pose:rotate(
    self.yaw,
    0,
    1,
    0
  )

  pose:rotate(
    self.pitch,
    1,
    0,
    0
  )

  pass:setViewPose(1, pose)
end


-- Возвращает точку земли,
-- находящуюся в центре экрана.
function Camera:getFocusPoint(field)
  local cosinePitch =
    math.cos(self.pitch)

  local directionX =
    -math.sin(self.yaw) *
    cosinePitch

  local directionY =
    math.sin(self.pitch)

  local directionZ =
    -math.cos(self.yaw) *
    cosinePitch

  if directionY >= -.0001 then
    return
      self.x,
      self.y,
      self.z
  end

  local groundY = 0
  local focusX = self.x
  local focusZ = self.z

  for iteration = 1, 2 do
    local distance =
      (groundY - self.y) /
      directionY

    focusX =
      self.x +
      directionX * distance

    focusZ =
      self.z +
      directionZ * distance

    if
      field
      and field.getHeight
    then
      groundY =
        field:getHeight(
          focusX,
          focusZ
        )
    end
  end

  return
    focusX,
    groundY + 1,
    focusZ
end


return Camera