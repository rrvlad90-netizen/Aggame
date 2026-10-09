local SoundRegistry =
  require(
    'src.audio.sound_registry'
  )
  
local EntityLod =
  require('src.world.entity_lod')  

local Entity = {}
Entity.__index = Entity


-- Создаёт сущность уровня.
function Entity.new(
  data,
  modelRegistry
)
  local self =
    setmetatable({}, Entity)

  self.id =
    assert(
      data.id,
      'Entity has no id'
    )

  self.modelId =
    assert(
      data.model,
      'Entity "' ..
      self.id ..
      '" has no model id'
    )

  self.animationLoopIndex = 0

  self.modelRegistry =
    modelRegistry

  self.asset =
    modelRegistry:get(
      self.modelId
    )

  self.definition =
    self.asset.definition

  self.lodRenderer =
    EntityLod.new(
      self.definition.lod
    )

  local position =
    data.position
    or {
      0, 0, 0
    }

  self.x = position[1] or 0
  self.y = position[2] or 0
  self.z = position[3] or 0

  self.yaw =
    data.yaw or 0

  if data.scale ~= nil then
    self.scale = data.scale
  else
    self.scale =
      self.definition.scale or 1
  end

  if data.rotationOffset ~= nil then
    self.rotationOffset =
      data.rotationOffset
  else
    self.rotationOffset =
      self.definition.rotationOffset
      or 0
  end

  if data.rotationSpeed ~= nil then
    self.rotationSpeed =
      data.rotationSpeed
  else
    self.rotationSpeed =
      self.definition.rotationSpeed
      or 0
  end

  if data.solid ~= nil then
    self.solid = data.solid
  else
    self.solid =
      self.definition.solid == true
  end

  if data.visible ~= nil then
    self.visible = data.visible
  else
    self.visible = true
  end

  if data.alpha ~= nil then
    self.alpha = data.alpha
  else
    self.alpha = 1
  end

  self.tint =
    data.tint
    or self.definition.tint
    or {
      1, 1, 1, 1
    }

  self.collider =
    data.collider
    or self.definition.collider

  self.yOffset =
    data.yOffset
    or self.definition.yOffset
    or 0

  self.animationName =
    data.animation
    or self.definition
      .defaultAnimation

  self.animationTime =
    data.animationOffset
    or math.random() * .5

  -- Небольшое индивидуальное
  -- отклонение скорости анимации.
  self.animationSpeed =
    .94 + math.random() * .12

  self.currentSourceFrame = nil
  self.md3Instance = nil

  if self.asset.kind == 'md3' then
    self.md3Instance =
      self.asset:createInstance()
  end

  if
    self.asset.kind == 'md3'
    and self.animationName
  then
    self:updateAnimation(0)
  end

  return self
end


-- Проигрывает звук анимации.
function Entity:playAnimationSound(
  animation
)
  if not animation then
    return
  end

  local soundPath =
    animation.playSound
    or animation.playsound

  if soundPath then
    SoundRegistry.play(
      soundPath
    )
  end
end


-- Возвращает радиус коллизии.
function Entity:getCollisionRadius()
  if not self.collider then
    return 0
  end

  if self.collider.type ~= 'circle' then
    return 0
  end

  return
    self.collider.radius or 0
end


-- Выталкивает круглый объект.
function Entity:resolveCircleCollision(
  object,
  objectRadius
)
  if not self.solid then
    return
  end

  local entityRadius =
    self:getCollisionRadius()

  if entityRadius <= 0 then
    return
  end

  local dx =
    object.x - self.x

  local dz =
    object.z - self.z

  local minimumDistance =
    entityRadius +
    objectRadius

  local distanceSquared =
    dx * dx +
    dz * dz

  if
    distanceSquared >=
    minimumDistance *
    minimumDistance
  then
    return
  end

  local distance
  local normalX
  local normalZ

  if distanceSquared < .0001 then
    local angle =
      math.random() *
      math.pi * 2

    normalX =
      math.cos(angle)

    normalZ =
      math.sin(angle)

    distance = 0
  else
    distance =
      math.sqrt(
        distanceSquared
      )

    normalX =
      dx / distance

    normalZ =
      dz / distance
  end

  local correction =
    minimumDistance -
    distance

  object.x =
    object.x +
    normalX * correction

  object.z =
    object.z +
    normalZ * correction
end


-- Переключает анимацию сущности.
function Entity:setAnimation(
  animationName,
  restart
)
  local animation =
    assert(
      self.definition.animations
      and self.definition.animations[
        animationName
      ],
      'Unknown animation: ' ..
      tostring(animationName)
    )

  if
    self.animationName ==
    animationName
    and not restart
  then
    return
  end

  self.animationName =
    animationName

  self.animationTime = 0
  self.animationLoopIndex = 0
  self.currentSourceFrame = nil

  self:playAnimationSound(
    animation
  )

  self:updateAnimation(0)
end


-- Вычисляет текущий кадр.
function Entity:updateAnimation(dt)
  if self.asset.kind ~= 'md3' then
    return
  end

  local animations =
    self.definition.animations

  if not animations then
    return
  end

  local animation =
    animations[
      self.animationName
    ]

  if not animation then
    return
  end

  self.animationTime =
    self.animationTime +
    dt * self.animationSpeed

  local firstFrame =
    animation.firstFrame

  local lastFrame =
    animation.lastFrame

  local frameCount =
    lastFrame -
    firstFrame + 1

  local absoluteFrameOffset =
    math.floor(
      self.animationTime *
      animation.fps
    )

  local frameOffset =
    absoluteFrameOffset

  if animation.loop then
    if
      animation.pingPong
      and frameCount > 1
    then
      local cycleFrameCount =
        frameCount * 2 - 2

      local loopIndex =
        math.floor(
          absoluteFrameOffset /
          cycleFrameCount
        )

      if
        loopIndex >
        self.animationLoopIndex
      then
        self.animationLoopIndex =
          loopIndex

        self:playAnimationSound(
          animation
        )
      end

      local cycleOffset =
        absoluteFrameOffset %
        cycleFrameCount

      if cycleOffset < frameCount then
        frameOffset =
          cycleOffset
      else
        frameOffset =
          cycleFrameCount -
          cycleOffset
      end
    else
      local loopIndex =
        math.floor(
          absoluteFrameOffset /
          frameCount
        )

      if
        loopIndex >
        self.animationLoopIndex
      then
        self.animationLoopIndex =
          loopIndex

        self:playAnimationSound(
          animation
        )
      end

      frameOffset =
        absoluteFrameOffset %
        frameCount
    end
  else
    frameOffset =
      math.min(
        absoluteFrameOffset,
        frameCount - 1
      )
  end

  local sourceFrame =
    firstFrame +
    frameOffset

  if
    sourceFrame ==
    self.currentSourceFrame
  then
    return
  end

  self.currentSourceFrame =
    sourceFrame

  self.md3Instance:setFrame(
    self.animationName,
    sourceFrame
  )
end


-- Проверяет завершение анимации.
function Entity:isAnimationFinished()
  if not self.animationName then
    return true
  end

  local animations =
    self.definition.animations

  if not animations then
    return true
  end

  local animation =
    animations[
      self.animationName
    ]

  if not animation then
    return true
  end

  if animation.loop then
    return false
  end

  local frameCount =
    animation.lastFrame -
    animation.firstFrame + 1

  local duration =
    frameCount /
    animation.fps

  return
    self.animationTime >=
    duration
end


-- Обновляет вращение сущности.
function Entity:updateRotation(dt)
  if self.rotationSpeed == 0 then
    return
  end

  self.yaw =
    (
      self.yaw +
      self.rotationSpeed * dt
    ) %
    (
      math.pi * 2
    )
end


-- Обновляет состояние сущности.
function Entity:update(dt)
  self:updateRotation(dt)
  self:updateAnimation(dt)
end


-- Рисует MD3-сущность.
function Entity:drawMd3(pass)
  if not self.md3Instance then
    return
  end

  self.md3Instance:draw(
    pass,
    self.x,
    self.y + self.yOffset,
    self.z,
    self.scale,
    self.yaw +
      self.rotationOffset,
    self.modelRegistry
      .defaultMaterial,
    self.alpha,
    self.tint
  )
end


-- Рисует OBJ с несколькими geoset.
function Entity:drawGroupedObj(pass)
  pass:setColor(
    self.tint[1],
    self.tint[2],
    self.tint[3],
    (self.tint[4] or 1) *
      self.alpha
  )

  local function drawPart(part)
    pass:setMaterial(
      part.material
    )

    pass:draw(
      part.mesh,

      self.x,
      self.y + self.yOffset,
      self.z,

      self.scale,

      self.yaw +
        self.rotationOffset,
      0, 1, 0
    )
  end

  -- Сначала ствол и другие
  -- непрозрачные части.
  for _, part in ipairs(
    self.asset.parts
  ) do
    if not part.transparent then
      drawPart(part)
    end
  end

  -- Прозрачная листва не должна
  -- перекрывать глубину ствола.
  pass:setDepthWrite(false)

  for _, part in ipairs(
    self.asset.parts
  ) do
    if part.transparent then
      drawPart(part)
    end
  end

  pass:setDepthWrite(true)
  pass:setColor(1, 1, 1, 1)

  pass:setMaterial(
    self.modelRegistry
      .defaultMaterial
  )
end


-- Рисует обычную OBJ-модель.
function Entity:drawObj(pass)
  if self.asset.material then
    pass:setMaterial(
      self.asset.material
    )
  else
    pass:setMaterial()
  end

  pass:setColor(
    self.tint[1],
    self.tint[2],
    self.tint[3],
    (self.tint[4] or 1) *
      self.alpha
  )

  pass:draw(
    self.asset.model,

    self.x,
    self.y + self.yOffset,
    self.z,

    self.scale,

    self.yaw +
      self.rotationOffset,
    0, 1, 0
  )

  pass:setColor(1, 1, 1, 1)

  pass:setMaterial(
    self.modelRegistry
      .defaultMaterial
  )
end


-- Рисует сущность.
function Entity:draw(
  pass,
  camera,
  allowLod
)
  if not self.visible then
    return
  end

  if
    self.lodRenderer:shouldDraw(
      self,
      camera,
      allowLod
    )
  then
    self.lodRenderer:draw(
      pass,
      self,
      camera
    )

    return
  end

  if self.asset.kind == 'md3' then
    self:drawMd3(pass)
    return
  end

  if
    self.asset.kind ==
    'grouped_obj'
  then
    self:drawGroupedObj(pass)
    return
  end

  self:drawObj(pass)
end


return Entity