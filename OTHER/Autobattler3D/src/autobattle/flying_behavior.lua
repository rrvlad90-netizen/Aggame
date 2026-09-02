local FlyingBehavior = {}
FlyingBehavior.__index =
  FlyingBehavior


-- Приближает значение к цели.
local function approach(
  value,
  target,
  movement
)
  if value < target then
    return math.min(
      value + movement,
      target
    )
  end

  return math.max(
    value - movement,
    target
  )
end


-- Создаёт воздушное поведение.
function FlyingBehavior.new(unit)
  local settings =
    unit.config.flying

  if
    not settings
    or settings.enabled == false
  then
    return nil
  end

  local self =
    setmetatable(
      {},
      FlyingBehavior
    )

  self.unit = unit
  self.settings = settings

  self.height =
    settings.height or 3

  self.currentHeight =
    self.height

  self.deathEffectSpawned = false

  return self
end


-- Возвращает текущую высоту.
function FlyingBehavior:getHeight()
  return self.currentHeight
end


-- Возвращает требуемую высоту.
function FlyingBehavior:getTargetHeight()
  local unit = self.unit
  local dive = unit.config.meleeDive

  if
    not dive
    or dive.enabled == false
  then
    return self.height
  end

  if
    unit.state == 'attacking'
    and unit.attackKind == 'melee'
    and (
      unit.attackPhase == 'start'
      or unit.attackPhase == 'hit'
    )
  then
    return
      dive.attackHeight or 1
  end

  return self.height
end


-- Создаёт взрыв вместо тела.
function FlyingBehavior:spawnDeathEffect()
  if self.deathEffectSpawned then
    return
  end

  self.deathEffectSpawned = true

  local unit = self.unit
  local effect =
    unit.config.deathEffect

  if not effect or not effect.projectile then
    return
  end

  local worldY =
    unit.y + self.currentHeight

  unit.battle:spawnProjectile(
    effect.projectile,
    {
      team = unit.team,
      source = nil,

      x = unit.x,
      y = worldY,
      z = unit.z,

      target = nil,
      targetX = unit.x,
      targetY = worldY,
      targetZ = unit.z
    }
  )
end


-- Обновляет высоту и смерть.
function FlyingBehavior:update(dt)
  local unit = self.unit

  if unit.removed then
    return
  end

  if not unit.combatAlive then
    if unit.config.deathEffect then
      self:spawnDeathEffect()
      unit.removed = true
    end

    return
  end

  local targetHeight =
    self:getTargetHeight()

  local dive =
    unit.config.meleeDive
    or {}

  local speed

  if targetHeight < self.currentHeight then
    speed =
      dive.descentSpeed
      or self.settings.descentSpeed
      or 5
  else
    speed =
      dive.ascentSpeed
      or self.settings.ascentSpeed
      or 4
  end

  self.currentHeight =
    approach(
      self.currentHeight,
      targetHeight,
      speed * dt
    )
end


return FlyingBehavior