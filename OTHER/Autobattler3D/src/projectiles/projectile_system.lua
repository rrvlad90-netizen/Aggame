local Projectile =
  require('src.projectiles.projectile')

local ProjectileSystem = {}
ProjectileSystem.__index =
  ProjectileSystem

-- Создаёт систему снарядов.
function ProjectileSystem.new(
  registry,
  battle
)
  local self =
    setmetatable(
      {},
      ProjectileSystem
    )

  self.registry = registry
  self.battle = battle

  self.projectiles = {}
  self.smokeParticles = {}

  -- Материалы спрайтов.
  self.materialCache = {}

  -- Объёмные модели снарядов.
  self.modelCache = {}

  self.defaultModelMaterial =
    lovr.graphics.newMaterial({})

  return self
end


-- Загружает и кэширует материал кадра.
function ProjectileSystem:getMaterial(path)
  if self.materialCache[path] then
    return self.materialCache[path]
  end

  local texture =
    lovr.graphics.newTexture(path)

  local material =
    lovr.graphics.newMaterial({
      texture = texture
    })

  self.materialCache[path] = material

  return material
end


-- Загружает и кэширует OBJ снаряда.
function ProjectileSystem:getModelAsset(
  description
)
  local key =
    description.path ..
    ':' ..
    tostring(description.texture)

  if self.modelCache[key] then
    return self.modelCache[key]
  end

  local asset = {
    model =
      lovr.graphics.newModel(
        description.path
      ),

    material =
      self.defaultModelMaterial
  }

  if description.texture then
    local texture =
      lovr.graphics.newTexture(
        description.texture
      )

    asset.material =
      lovr.graphics.newMaterial({
        texture = texture
      })
  end

  self.modelCache[key] = asset

  return asset
end

-- Создаёт одну частицу дыма.
function ProjectileSystem:createSmokeParticle(
  settings,
  x,
  y,
  z
)
  local angle =
    math.random() * math.pi * 2

  local speed =
    settings.speedMinimum +
    math.random() *
    (
      settings.speedMaximum -
      settings.speedMinimum
    )

  local lifetime =
    settings.lifetimeMinimum +
    math.random() *
    (
      settings.lifetimeMaximum -
      settings.lifetimeMinimum
    )

  local scale =
    settings.scaleMinimum +
    math.random() *
    (
      settings.scaleMaximum -
      settings.scaleMinimum
    )

  local growth =
    settings.growthMinimum +
    math.random() *
    (
      settings.growthMaximum -
      settings.growthMinimum
    )

  self.smokeParticles[
    #self.smokeParticles + 1
  ] = {
    x = x,
    y = y,
    z = z,

    velocityX =
      math.cos(angle) * speed,

    velocityY =
      .25 + math.random() * .6,

    velocityZ =
      math.sin(angle) * speed,

    lifetime = lifetime,
    age = 0,
    scale = scale,
    growth = growth,
    color = settings.color
  }
end


-- Создаёт облако дыма выстрела.
function ProjectileSystem:createMuzzleSmoke(
  definition,
  x,
  y,
  z
)
  local settings =
    definition.muzzleSmoke

  if
    not settings
    or not settings.enabled
  then
    return
  end

  for index = 1,
    settings.count or 0
  do
    self:createSmokeParticle(
      settings,
      x,
      y,
      z
    )
  end
end


-- Создаёт снаряд.
function ProjectileSystem:spawn(
  projectileId,
  settings
)
  local definition =
    self.registry:get(projectileId)

  local targetX =
    settings.targetX

  local targetY =
    settings.targetY
    or (
      settings.target
      and settings.target.y + 1
    )

  local targetZ =
    settings.targetZ

  if
    definition.hitMode == 'target'
    and settings.target
  then
    targetX = settings.target.x

    targetY =
      settings.target.y + 1

    targetZ = settings.target.z
  end

  assert(
    targetX and targetY and targetZ,
    'Projectile has no destination'
  )

  local projectile = Projectile.new(
    self,
    definition,
    {
      team = settings.team,
      source = settings.source,
      target = settings.target,

      x = settings.x,
      y = settings.y,
      z = settings.z,

      targetX = targetX,
      targetY = targetY,
      targetZ = targetZ
    }
  )

  self.projectiles[
    #self.projectiles + 1
  ] = projectile

  self:createMuzzleSmoke(
    definition,
    settings.x,
    settings.y,
    settings.z
  )

  return projectile
end


-- Наносит урон при попадании.
function ProjectileSystem:applyImpact(
  projectile
)
  local definition =
    projectile.definition
	
	
	if definition.visualOnly then
	  return
	end
  if definition.hitMode == 'target' then
    local target = projectile.target

    if target and target:isTargetable() then
      local damage = math.random(
        definition.damageMinimum,
        definition.damageMaximum
      )

      target:takeDamage(
        damage,
        definition.damageType,
        {
          source = projectile.source,
          x = projectile.x,
          z = projectile.z,
          radiusAttack = false
        }
      )
    end

    return
  end

  self.battle:damageRadius(
    projectile.x,
    projectile.z,
    definition.radius,
    definition,
    projectile.team,
    projectile.source
  )
end


-- Обновляет дым.
function ProjectileSystem:updateSmoke(dt)
  for index =
    #self.smokeParticles,
    1,
    -1
  do
    local particle =
      self.smokeParticles[index]

    particle.age =
      particle.age + dt

    if
      particle.age >=
      particle.lifetime
    then
      table.remove(
        self.smokeParticles,
        index
      )
    else
      particle.x =
        particle.x +
        particle.velocityX * dt

      particle.y =
        particle.y +
        particle.velocityY * dt

      particle.z =
        particle.z +
        particle.velocityZ * dt

      particle.scale =
        particle.scale +
        particle.growth * dt

      particle.velocityY =
        particle.velocityY +
        .15 * dt
    end
  end
end


-- Обновляет все снаряды.
function ProjectileSystem:update(dt)
  for index =
    #self.projectiles,
    1,
    -1
  do
    local projectile =
      self.projectiles[index]

    projectile:update(dt)

    if projectile.removed then
      table.remove(
        self.projectiles,
        index
      )
    end
  end

  self:updateSmoke(dt)
end

-- Рисует прозрачный дым без записи глубины.
function ProjectileSystem:drawSmoke(pass)
  -- Дым не должен наследовать текстуру
  -- последнего спрайтового снаряда.
  pass:setShader()
  pass:setMaterial()
  pass:setDepthWrite(false)

  for _, particle in ipairs(
    self.smokeParticles
  ) do
    local progress =
      particle.age /
      particle.lifetime

    local color = particle.color

    pass:setColor(
      color[1],
      color[2],
      color[3],

      (color[4] or 1) *
      (1 - progress)
    )

    pass:sphere(
      particle.x,
      particle.y,
      particle.z,
      particle.scale
    )
  end

  pass:setDepthWrite(true)
  pass:setColor(1, 1, 1, 1)
  pass:setMaterial()
end

-- Рисует снаряды и дым.
function ProjectileSystem:draw(
  pass,
  camera
)
  pass:setCullMode('none')

  for _, projectile in ipairs(
    self.projectiles
  ) do
    projectile:draw(
      pass,
      camera
    )
  end

  self:drawSmoke(pass)

  -- Не передаёт материал снаряда
  -- следующим объектам сцены.
  pass:setShader()
  pass:setMaterial()
  pass:setColor(1, 1, 1, 1)
end


return ProjectileSystem