local Projectile = {}
Projectile.__index = Projectile


-- Создаёт летящий снаряд.
function Projectile.new(
  system,
  definition,
  settings
)
  local self =
    setmetatable({}, Projectile)

  self.system = system
  self.definition = definition

  self.team = settings.team
  self.source = settings.source
  self.target = settings.target

  self.startX = settings.x
  self.startY = settings.y
  self.startZ = settings.z

  self.endX = settings.targetX
  self.endY = settings.targetY
  self.endZ = settings.targetZ

  self.state = 'flight'
  self.progress = 0
  self.animationTime = 0
  self.removed = false

  local dx = self.endX - self.startX
  local dy = self.endY - self.startY
  local dz = self.endZ - self.startZ

  self.distance = math.sqrt(
    dx * dx + dy * dy + dz * dz
  )

  self.duration =
    self.distance /
    math.max(definition.speed, .001)

  self.duration =
    math.max(self.duration, .001)

  self.x = self.startX
  self.y = self.startY
  self.z = self.startZ

  return self
end


-- Возвращает длительность анимации.
function Projectile:getAnimationDuration(
  animationName
)
  local animation =
    self.definition.animations[
      animationName
    ]

  local frameCount =
    #animation.frames

  if frameCount == 0 then
    return 0
  end

  return
    frameCount /
    math.max(animation.fps or 1, .001)
end


-- Возвращает позицию траектории.
function Projectile:getPositionAt(progress)
  progress = math.max(
    0,
    math.min(1, progress)
  )

  local x =
    self.startX +
    (self.endX - self.startX) *
    progress

  local y =
    self.startY +
    (self.endY - self.startY) *
    progress

  local z =
    self.startZ +
    (self.endZ - self.startZ) *
    progress

  if
    self.definition.trajectory == 'arc'
  then
    y = y +
      4 *
      (self.definition.arcHeight or 0) *
      progress *
      (1 - progress)
  end

  return x, y, z
end


-- Обновляет текущую позицию.
function Projectile:updatePosition()
  self.x, self.y, self.z =
    self:getPositionAt(self.progress)
end


-- Возвращает текущую анимацию.
function Projectile:getAnimation()
  return
    self.definition.animations[
      self.state
    ]
end


-- Возвращает текущий кадр.
function Projectile:getFramePath()
  local animation =
    self:getAnimation()

  if
    not animation
    or #animation.frames == 0
  then
    return nil
  end

  local frameOffset =
    math.floor(
      self.animationTime *
      (animation.fps or 1)
    )

  local frameIndex

  if animation.loop then
    frameIndex =
      frameOffset %
      #animation.frames + 1
  else
    frameIndex =
      math.min(
        frameOffset + 1,
        #animation.frames
      )
  end

  return animation.frames[frameIndex]
end


-- Начинает анимацию попадания.
function Projectile:beginImpact()
  if self.state == 'impact' then
    return
  end

  self.progress = 1
  self:updatePosition()

  -- Урон применяется перед визуальной
  -- анимацией попадания.
  self.system:applyImpact(self)

  self.state = 'impact'
  self.animationTime = 0

  local duration =
    self:getAnimationDuration(
      'impact'
    )

  if
    self.definition.visible == false
    or duration <= 0
  then
    self.removed = true
  end
end


-- Обновляет снаряд.
function Projectile:update(dt)
  if self.removed then
    return
  end

  self.animationTime =
    self.animationTime + dt

  if self.state == 'flight' then
    self.progress =
      self.progress +
      dt / self.duration

    if self.progress >= 1 then
      self:beginImpact()
    else
      self:updatePosition()
    end

    return
  end

  local duration =
    self:getAnimationDuration(
      'impact'
    )

  if self.animationTime >= duration then
    self.removed = true
  end
end


-- Создаёт трансформацию спрайта.
function Projectile:createTransform(
  camera,
  x,
  y,
  z,
  scale,
  progress
)
  local transform =
    lovr.math.newMat4()

  transform:translate(x, y, z)

  if
    self.definition.spriteMode ==
    'billboard'
  then
    transform:rotate(
      camera.yaw,
      0, 1, 0
    )

    transform:rotate(
      -camera.pitch,
      1, 0, 0
    )
  else
    local sampleDistance = .01

    local previousProgress =
      math.max(
        0,
        progress - sampleDistance
      )

    local previousX,
      previousY,
      previousZ =
      self:getPositionAt(
        previousProgress
      )

    local directionX = x - previousX
    local directionY = y - previousY
    local directionZ = z - previousZ

    local horizontalLength =
      math.sqrt(
        directionX * directionX +
        directionZ * directionZ
      )

    local yaw =
      math.atan2(
        -directionX,
        -directionZ
      )

    local pitch =
      math.atan2(
        directionY,
        math.max(
          horizontalLength,
          .0001
        )
      )

    transform:rotate(
      yaw,
      0, 1, 0
    )

    transform:rotate(
      -pitch,
      1, 0, 0
    )
  end

  transform:scale(
    scale,
    scale,
    scale
  )

  return transform
end


-- Рисует один кадр спрайта.
function Projectile:drawFrame(
  pass,
  camera,
  framePath,
  x,
  y,
  z,
  scale,
  alpha,
  progress
)
  if not framePath then
    return
  end

  local material =
    self.system:getMaterial(
      framePath
    )

  pass:setMaterial(material)

local tint =
  self.definition.tint
  or {
    1, 1, 1, 1
  }

pass:setColor(
  tint[1],
  tint[2],
  tint[3],
  alpha * (tint[4] or 1)
)

  local transform =
    self:createTransform(
      camera,
      x,
      y,
      z,
      scale,
      progress
    )

  pass:plane(transform)
end


-- Рисует полупрозрачный трейл.
function Projectile:drawTrail(
  pass,
  camera,
  framePath
)
  local trail =
    self.definition.trail

  if
    self.state ~= 'flight'
    or not trail
    or not trail.enabled
  then
    return
  end

  local count = trail.count or 0
  local spacing = trail.spacing or .05

  for index = count, 1, -1 do
    local progress =
      math.max(
        0,
        self.progress -
        index * spacing
      )

    local x, y, z =
      self:getPositionAt(progress)

    local strength =
      1 - index / (count + 1)

    self:drawFrame(
      pass,
      camera,
      framePath,
      x,
      y,
      z,

      self.definition.scale *
      (trail.scale or 1) *
      strength,

      self.definition.alpha *
      (trail.alpha or .25) *
      strength,

      progress
    )
  end
end


-- Рисует объёмную модель снаряда.
function Projectile:drawModel(pass)
  local description =
    self.definition.model

  if not description then
    return
  end

  local asset =
    self.system:getModelAsset(
      description
    )

  local color =
    description.color
    or {
      1, 1, 1, 1
    }

  local transform =
    lovr.math.newMat4()

  transform:translate(
    self.x,
    self.y,
    self.z
  )

-- Поворачивает модель по горизонтальному
-- направлению полёта.
if description.pitchCurve then
  local directionX =
    self.endX - self.startX

  local directionZ =
    self.endZ - self.startZ

  local yaw =
    math.atan2(
      -directionX,
      -directionZ
    )

  transform:rotate(
    yaw,
    0, 1, 0
  )

  local curve =
    description.pitchCurve

  local pitch
  local interpolation

  if self.progress < .5 then
    interpolation =
      self.progress * 2

    interpolation =
      interpolation *
      interpolation *
      (3 - 2 * interpolation)

    pitch =
      curve.start +
      (
        curve.middle -
        curve.start
      ) * interpolation
  else
    interpolation =
      (self.progress - .5) * 2

    interpolation =
      interpolation *
      interpolation *
      (3 - 2 * interpolation)

    pitch =
      curve.middle +
      (
        curve.finish -
        curve.middle
      ) * interpolation
  end

  transform:rotate(
    -math.rad(pitch),
    1, 0, 0
  )
end

  -- Исправляет исходное направление OBJ.
  if description.yawOffset then
    transform:rotate(
      description.yawOffset,
      0, 1, 0
    )
  end

  if description.pitchOffset then
    transform:rotate(
      description.pitchOffset,
      1, 0, 0
    )
  end

  if description.rollOffset then
    transform:rotate(
      description.rollOffset,
      0, 0, 1
    )
  end

  -- Дополнительное вращение камней.
  local rotationSpeed =
    description.rotationSpeed
    or 0

  if rotationSpeed ~= 0 then
    local axis =
      description.rotationAxis
      or {
        1, 0, 0
      }

    transform:rotate(
      self.animationTime *
      rotationSpeed,

      axis[1],
      axis[2],
      axis[3]
    )
  end

  local scale =
    description.scale or 1

  transform:scale(
    scale,
    scale,
    scale
  )

  pass:setMaterial(
    asset.material
  )

  pass:setColor(
    color[1],
    color[2],
    color[3],
    (color[4] or 1) *
    self.definition.alpha
  )

  pass:draw(
    asset.model,
    transform
  )
end

-- Рисует снаряд.
function Projectile:draw(pass, camera)
  if
    self.removed
    or self.definition.visible == false
  then
    return
  end

  local framePath =
    self:getFramePath()

  if self.state == 'flight' then
    self:drawTrail(
      pass,
      camera,
      framePath
    )

    if self.definition.model then
      self:drawModel(pass)
    else
      self:drawFrame(
        pass,
        camera,
        framePath,
        self.x,
        self.y,
        self.z,
        self.definition.scale,
        self.definition.alpha,
        self.progress
      )
    end
  else
    self:drawFrame(
      pass,
      camera,
      framePath,
      self.x,
      self.y,
      self.z,
      self.definition.scale,
      self.definition.alpha,
      self.progress
    )
  end

  pass:setColor(1, 1, 1, 1)
end


return Projectile