local Entity =
  require('src.world.entity')

local Building = {}
Building.__index = Building


-- Создаёт здание или строительную платформу.
function Building.new(settings)
  local self =
    setmetatable({}, Building)

  self.id = settings.id
  self.team = settings.team
  self.sideId = settings.sideId

  self.buildingType =
    settings.buildingType

  self.definition =
    settings.definition

  self.modelId = settings.modelId

  self.modelRegistry =
    settings.modelRegistry

  self.system = settings.system

  self.x = settings.x

  self.floorY =
    settings.floorY or 0

  self.y = self.floorY
  self.z = settings.z
  self.yaw = settings.yaw or 0

  self.routeId = settings.routeId
  self.spawnX = settings.spawnX
  self.spawnZ = settings.spawnZ

  self.radius =
    self.definition.colliderRadius
    or 3

  self.maximumHealth =
    self.definition.health

  self.health = 0
  self.entity = nil

  self.buildTime = 0
  self.buildProgress = 0
  self.attackCooldown = 0

  self.deathTime = 0

  self.deathDuration =
    self.definition.deathDuration
    or .4

  self.deathContext = nil

  self.isBuilding = true
  self.removed = false

  if settings.built then
    self.state = 'ready'
    self.health = self.maximumHealth
    self:createEntity()
  else
    self.state = 'platform'
  end

  return self
end


-- Создаёт визуальную сущность здания.
function Building:createEntity()
  self.entity = Entity.new({
    id = 'building_' .. self.id,
    model = self.modelId,

    position = {
      self.x,
      self.y,
      self.z
    },

    yaw = self.yaw,
    animation = 'idle',
    solid = true
  }, self.modelRegistry)
end


-- Проверяет состояние платформы.
function Building:isPlatform()
  return self.state == 'platform'
end


-- Проверяет процесс строительства.
function Building:isConstructing()
  return self.state == 'constructing'
end


-- Проверяет готовность здания.
function Building:isReady()
  return self.state == 'ready'
end


-- Проверяет анимацию уничтожения.
function Building:isDying()
  return self.state == 'dying'
end


-- Проверяет доступность здания как цели.
function Building:isTargetable()
  return
    self.state == 'ready'
    and self.health > 0
    and not self.removed
end


-- Проверяет участие здания в столкновениях.
function Building:isSpatiallyActive()
  return self:isTargetable()
end


-- Возвращает радиус здания.
function Building:getCollisionRadius()
  return self.radius
end


-- Проверяет попадание в основание здания.
function Building:containsPoint(x, z)
  local dx = x - self.x
  local dz = z - self.z

  return
    dx * dx + dz * dz <=
    self.radius * self.radius
end


-- Начинает строительство.
function Building:startConstruction()
  if not self:isPlatform() then
    return false
  end

  self.state = 'constructing'
  self.health = 0
  self.buildTime = 0
  self.buildProgress = 0
  self.attackCooldown = 0
  self.deathTime = 0
  self.deathContext = nil

  self.y =
    self.floorY -
    (
      self.definition.buildDepth
      or 0
    )

  self:createEntity()

  return true
end


-- Немедленно завершает строительство.
function Building:finishConstruction()
  if not self:isConstructing() then
    return
  end

  self.state = 'ready'
  self.buildProgress = 1
  self.health = self.maximumHealth
  self.y = self.floorY
  self.attackCooldown = 0

  self.entity.y = self.y
end


-- Возвращает здание на платформу.
function Building:returnToPlatform()
  self.state = 'platform'
  self.health = 0
  self.entity = nil

  self.buildTime = 0
  self.buildProgress = 0
  self.attackCooldown = 0

  self.deathTime = 0
  self.deathContext = nil

  self.y = self.floorY
end


-- Создаёт спрайтовый взрыв здания.
function Building:spawnDeathEffect()
  local effectY =
    self.floorY +
    math.max(
      2,
      self.radius * .5
    )

  self.system.battle:spawnProjectile(
    'building_explosion',
    {
      team = self.team,
      source = nil,

      x = self.x,
      y = effectY,
      z = self.z,

      target = nil,
      targetX = self.x,
      targetY = effectY,
      targetZ = self.z
    }
  )
end


-- Уничтожает здание и создаёт взрыв.
function Building:destroy(context)
  if not self:isTargetable() then
    return
  end

  self.health = 0

  self:spawnDeathEffect()

  -- Модель исчезает сразу, чтобы
  -- спрайт взрыва был хорошо виден.
  self.entity = nil

  if self.buildingType == 'altar' then
    self.state = 'destroyed'
    self.removed = true
  else
    -- На месте обычного здания сразу
    -- возвращается его платформа.
    self:returnToPlatform()
  end

  self.system:onBuildingDestroyed(
    self,
    context
  )
end


-- Завершает уничтожение здания.
function Building:finishDeath()
  if not self:isDying() then
    return
  end

  print(
    'BUILDING DEATH FINISH:',
    self.id,
    self.buildingType
  )

  local context =
    self.deathContext

  self.entity = nil

  if self.buildingType == 'altar' then
    self.state = 'destroyed'
    self.removed = true
    self.deathContext = nil
  else
    self:returnToPlatform()
  end

  self.system:onBuildingDestroyed(
    self,
    context
  )
end


-- Наносит урон зданию.
function Building:takeDamage(
  amount,
  damageType,
  context
)
  if not self:isTargetable() then
    return
  end

  self.health =
    math.max(
      0,
      self.health - amount
    )

  if self.health <= 0 then
    self:destroy(context)
  end
end


-- Обновляет строительство.
function Building:updateConstruction(dt)
  self.buildTime =
    self.buildTime + dt

  local duration =
    math.max(
      self.definition.buildTime,
      .001
    )

  self.buildProgress =
    math.min(
      1,
      self.buildTime / duration
    )

  local depth =
    self.definition.buildDepth
    or 0

  self.y =
    self.floorY -
    depth +
    depth * self.buildProgress

  self.entity.y = self.y

  if self.buildProgress >= 1 then
    self:finishConstruction()
  end
end


-- Обновляет анимацию уничтожения.
function Building:updateDeath(dt)
  self.deathTime =
    self.deathTime + dt

  if
    self.deathTime >=
    self.deathDuration
  then
    self:finishDeath()
  end
end


-- Обновляет здание.
function Building:update(dt)
  if self:isConstructing() then
    self:updateConstruction(dt)

  elseif self:isDying() then
    self:updateDeath(dt)
  end

  if self.entity then
    self.entity:update(dt)
  end
end


-- Рисует пустую платформу.
function Building:drawPlatform(pass)
  pass:setShader()
  pass:setMaterial()

  pass:setColor(
    .38,
    .4,
    .42,
    1
  )

  pass:box(
    self.x,
    self.floorY + .04,
    self.z,
    self.radius * 2,
    .08,
    self.radius * 2
  )

  pass:setColor(1, 1, 1, 1)
end


-- Рисует здание или платформу.
function Building:draw(
  pass,
  camera,
  applyLighting
)
  if self:isPlatform() then
    self:drawPlatform(pass)
    return
  end

  if not self.entity then
    return
  end

  applyLighting()

  self.entity:draw(
    pass,
    camera,
    false
  )
end


return Building