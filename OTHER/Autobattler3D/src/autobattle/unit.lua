local Entity =
  require('src.world.entity')

local Unit = {}
Unit.__index = Unit


-- Возвращает случайное число диапазона.
local function randomRange(
  minimum,
  maximum
)
  minimum = minimum or 0
  maximum = maximum or minimum

  return
    minimum +
    math.random() *
    (maximum - minimum)
end


-- Создаёт независимого бойца.
function Unit.new(settings)
  local self =
    setmetatable({}, Unit)

  self.id = settings.id
  self.squad = settings.squad
  self.team = self.squad.team
  self.config = settings.config
  self.battle = settings.battle

  self.x = settings.x
  self.y = 0
  self.z = settings.z

  self.previousX = self.x
  self.previousZ = self.z

  self.radius = self.config.radius
  self.health = self.config.health
  self.maximumHealth = self.health

  self.damageMinimum =
    self.config.damageMinimum

  self.damageMaximum =
    self.config.damageMaximum

  self.damageType =
    self.config.damageType
    or 'normal'

  self.attackDistance =
    self.config.attackDistance
    or 0

  self.rangedAttack =
    self.config.rangedAttack

  self.sightDistance =
    self.config.sightDistance
    or self.attackDistance

  if self.rangedAttack then
    self.sightDistance =
      math.max(
        self.sightDistance,
        self.rangedAttack
          .maximumDistance
        or 0
      )
  end

  self.lastAttackIndex = nil
  self.rangedCooldown = 0

  self.state = 'idle'
  self.attackKind = nil
  self.attackPhase = nil
  self.attackDefinition = nil
  self.target = nil

  self.route = nil
  self.routePointIndex = nil
  self.routeEntryPointIndex = nil
  self.routeOffset = 0
  self.routeFinished = true

  self.blockedTime = 0

  self.avoidanceSide =
    math.random() < .5
    and -1
    or 1

  self.removed = false
  self.combatAlive = true
  self.countedAsRemoved = false

  self.corpseDefinition =
    self.config.corpse
    or {
      mode = 'never',
      stayChance = 0
    }

  self.corpseResolved = false

	self.fallDefinition =
	  self.config.fallDeath
	  or {
		enabled = true,

		distanceMinimum = 2.5,
		distanceMaximum = 3.4,

		heightMinimum = 1.3,
		heightMaximum = 1.9,

		durationMinimum = .7,
		durationMaximum = .95
	  }

  self.fallPhase = nil
  self.fallTime = 0
  self.fallDuration = 0

	self.flyingBehavior =
	  require(
		'src.autobattle.flying_behavior'
	  ).new(self)

  self.entity = Entity.new({
    id =
      'battle_unit_' ..
      self.id,

    model = self.config.model,
    tint = self.config.tint,

    position = {
      self.x,
      self.y,
      self.z
    },

    animation = 'idle',
    solid = false
  }, settings.modelRegistry)

  return self
end


-- Запоминает позицию перед шагом.
function Unit:beginSimulationStep()
  self.previousX = self.x
  self.previousZ = self.z
end


-- Проверяет участие в столкновениях.
function Unit:isSpatiallyActive()
  return
    self.combatAlive
    and not self.removed
end


-- Проверяет доступность для атаки.
function Unit:isTargetable()
  return
    self.combatAlive
    and not self.removed
end


-- Синхронизирует сущность.
function Unit:syncEntity()
  self.entity.x = self.x
--  self.entity.y = self.y
--для летающих юнитов опциональное поведение
local visualHeight = 0

if self.flyingBehavior then
  visualHeight =
    self.flyingBehavior:getHeight()
end

self.entity.y =
  self.y + visualHeight
  
  self.entity.z = self.z
end


-- Устанавливает анимацию.
function Unit:setAnimation(name)
  if not name then
    return
  end

  -- Преобразует смысловое имя idle
  -- в анимацию конкретной модели.
  if name == 'idle' then
    local battleAnimations =
      self.entity.definition
        .battleAnimations

    name =
      battleAnimations
      and battleAnimations.idle
      or 'idle'
  end

  if
    self.entity.animationName ==
    name
  then
    return
  end

  self.entity:setAnimation(
    name,
    true
  )
end


-- Поворачивает бойца.
function Unit:faceDirection(dx, dz)
  if
    dx * dx + dz * dz <
    .0001
  then
    return
  end

  self.entity.yaw =
    math.atan2(-dx, -dz)
end


-- Возвращает расстояние до цели.
function Unit:getDistanceTo(target)
  local dx = target.x - self.x
  local dz = target.z - self.z

  return math.sqrt(
    dx * dx + dz * dz
  )
end


-- Возвращает случайную смерть.
function Unit:getDeathAnimation()
  local deaths =
    self.entity.definition
      .battleAnimations.deaths

  return deaths[
    math.random(1, #deaths)
  ]
end


-- Возвращает отдельные анимации падения.
function Unit:getFallAnimations()
  local battleAnimations =
    self.entity.definition
      .battleAnimations

  local fall =
    battleAnimations
    and battleAnimations.fall

  if not fall then
    return nil
  end

  local animations =
    self.entity.definition
      .animations

  if
    not animations
    or not animations[fall.start]
    or not animations[fall.airborne]
    or not animations[fall.land]
  then
    return nil
  end

  return fall
end


-- Проверяет наличие ближней атаки.
function Unit:hasMeleeAttack()
  local battleAnimations =
    self.entity.definition
      .battleAnimations

  local attacks =
    battleAnimations
    and battleAnimations.attacks

  return
    attacks ~= nil
    and #attacks > 0
end


-- Проверяет наличие дальней атаки.
function Unit:hasRangedAttack()
  if not self.rangedAttack then
    return false
  end

  local battleAnimations =
    self.entity.definition
      .battleAnimations

  return
    battleAnimations ~= nil
    and battleAnimations.ranged
      ~= nil
    and self.rangedAttack.projectile
      ~= nil
end


-- Возвращает перезарядку выстрела.
function Unit:getRangedCooldown()
  local settings =
    self.rangedAttack

  local minimum =
    settings.cooldownMinimum
    or settings.cooldown
    or 1

  local maximum =
    settings.cooldownMaximum
    or settings.cooldown
    or minimum

  if maximum < minimum then
    maximum = minimum
  end

  return randomRange(
    minimum,
    maximum
  )
end


-- Проверяет дистанцию выстрела.
function Unit:isInsideRangedDistance(
  distance
)
  if not self:hasRangedAttack() then
    return false
  end

  local minimum =
    self.rangedAttack
      .minimumDistance
    or 0

  local maximum =
    self.rangedAttack
      .maximumDistance
    or self.sightDistance

  return
    distance >= minimum
    and distance <= maximum
end


-- Назначает маршрут.
function Unit:setRoute(
  route,
  routeOffset,
  pointIndex
)
  self.route = route

  self.routePointIndex =
    math.max(
      1,
      math.min(
        pointIndex or 1,
        #route.points
      )
    )

  self.routeEntryPointIndex =
    self.routePointIndex

  self.routeFinished = false
  self.routeStartX = self.x
  self.routeStartZ = self.z

  if routeOffset ~= nil then
    self.routeOffset = routeOffset
  else
    local width =
      route.width
      or self.battle.config
        .navigation
        .defaultCorridorWidth

    self.routeOffset =
      (math.random() - .5) *
      width
  end

  self.blockedTime = 0
end


-- Возвращает начало сегмента.
function Unit:getPreviousRoutePoint()
  if
    self.routePointIndex ==
    self.routeEntryPointIndex
  then
    return
      self.routeStartX,
      self.routeStartZ
  end

  local previous =
    self.route.points[
      self.routePointIndex - 1
    ]

  if not previous then
    return
      self.routeStartX,
      self.routeStartZ
  end

  return previous.x, previous.z
end


-- Возвращает смещённую точку.
function Unit:getRoutePoint()
  if
    not self.route
    or self.routeFinished
  then
    return nil
  end

  local point =
    self.route.points[
      self.routePointIndex
    ]

  if not point then
    self.routeFinished = true
    return nil
  end

  local previousX,
    previousZ =
    self:getPreviousRoutePoint()

  local segmentX =
    point.x - previousX

  local segmentZ =
    point.z - previousZ

  local length = math.sqrt(
    segmentX * segmentX +
    segmentZ * segmentZ
  )

  if length <= .0001 then
    return point.x, point.z
  end

  local perpendicularX =
    -segmentZ / length

  local perpendicularZ =
    segmentX / length

  if
    perpendicularX < 0
    or (
      math.abs(perpendicularX) <
      .0001
      and perpendicularZ < 0
    )
  then
    perpendicularX =
      -perpendicularX

    perpendicularZ =
      -perpendicularZ
  end

  return
    point.x +
    perpendicularX *
    self.routeOffset,

    point.z +
    perpendicularZ *
    self.routeOffset
end


-- Проверяет прохождение точки.
function Unit:hasPassedRoutePoint(
  targetX,
  targetZ
)
  local point =
    self.route.points[
      self.routePointIndex
    ]

  local previousX,
    previousZ =
    self:getPreviousRoutePoint()

  local segmentX =
    point.x - previousX

  local segmentZ =
    point.z - previousZ

  local beyondX =
    self.x - targetX

  local beyondZ =
    self.z - targetZ

  return
    beyondX * segmentX +
    beyondZ * segmentZ > 0
end


-- Возвращает направление маршрута.
function Unit:getRouteDirection()
  while true do
    local targetX, targetZ =
      self:getRoutePoint()

    if not targetX then
      return nil
    end

    local dx = targetX - self.x
    local dz = targetZ - self.z

    local distance =
      math.sqrt(
        dx * dx + dz * dz
      )

    local reached =
      distance <=
      self.battle.config
        .navigation
        .waypointRadius

    local passed =
      self:hasPassedRoutePoint(
        targetX,
        targetZ
      )

    if not reached and not passed then
      return
        dx / distance,
        dz / distance
    end

    local reachedPoint =
      self.routePointIndex

    self.routePointIndex =
      self.routePointIndex + 1

    self.squad:
      onUnitReachedRoutePoint(
        self,
        reachedPoint
      )
  end
end


-- Удаляет бойца за картой.
function Unit:checkMapExit()
  local map =
    self.battle.map.field

  local outside =
    math.abs(self.x) >
      map.width / 2
    or math.abs(self.z) >
      map.length / 2

  if not outside then
    return false
  end

  self.combatAlive = false
  self.removed = true
  self.target = nil

  self.squad:onUnitRemoved(
    self,
    'exited'
  )

  return true
end


-- Выполняет суперудар на ходу.
function Unit:tryChargeHit(
  target,
  dt
)
  if
    not self.route
    or self.routeFinished
  then
    return false
  end

  local charge =
    self.squad:claimChargeHit(
      self
    )

  if not charge then
    return false
  end

  local minimum =
    charge.damageMinimum

  local maximum =
    charge.damageMaximum

  if not minimum then
    minimum =
      self.damageMinimum *
      (charge.damageMultiplier or 1)
  end

  if not maximum then
    maximum =
      self.damageMaximum *
      (charge.damageMultiplier or 1)
  end

  local damage =
    randomRange(
      minimum,
      maximum
    )

  self:faceDirection(
    target.x - self.x,
    target.z - self.z
  )

  self.state = 'moving'

  self:setAnimation(
    self.entity.definition
      .battleAnimations.forward
  )

  target:takeDamage(
    damage,
    self.damageType,
    {
      source = self,
      x = self.x,
      z = self.z,

      radiusAttack = false,

      launchOnKill =
        charge.launchOnKill
          == true,

      chargeAttack = true
    }
  )

  self.entity:update(dt)

  return true
end


-- Начинает ближнюю атаку.
function Unit:startMeleeAttack(target)
  local attacks =
    self.entity.definition
      .battleAnimations.attacks

  local attackIndex =
    math.random(1, #attacks)

  if
    #attacks > 1
    and attackIndex ==
      self.lastAttackIndex
  then
    attackIndex =
      attackIndex % #attacks + 1
  end

  self.lastAttackIndex =
    attackIndex

  self.attackDefinition =
    attacks[attackIndex]

  self.target = target
  self.attackKind = 'melee'
  self.attackPhase = 'start'
  self.state = 'attacking'

  self.entity:setAnimation(
    self.attackDefinition.start,
    true
  )
end


-- Начинает дальнюю атаку.
function Unit:startRangedAttack(target)
  self.target = target
  self.attackKind = 'ranged'
  self.attackPhase = 'start'
  self.state = 'attacking'

  self.attackDefinition =
    self.entity.definition
      .battleAnimations.ranged

  self.entity:setAnimation(
    self.attackDefinition.start,
    true
  )
end


-- Завершает атаку.
function Unit:finishAttack()
  self.target = nil
  self.attackKind = nil
  self.attackPhase = nil
  self.attackDefinition = nil
  self.state = 'idle'
end


-- Выпускает снаряд.
function Unit:fireProjectile()
  local settings =
    self.rangedAttack

  local target =
    self.battle:findNearestEnemy(
      self,
      settings.maximumDistance
        or self.sightDistance
    )

  if not target then
    return false
  end

  local distance =
    self:getDistanceTo(target)

  if
    not self:isInsideRangedDistance(
      distance
    )
  then
    return false
  end

  self.target = target

  self:faceDirection(
    target.x - self.x,
    target.z - self.z
  )

  local dx = target.x - self.x
  local dz = target.z - self.z

  local horizontalLength =
    math.sqrt(
      dx * dx + dz * dz
    )

  local directionX = 0
  local directionZ = 0

  if horizontalLength > .0001 then
    directionX =
      dx / horizontalLength

    directionZ =
      dz / horizontalLength
  end

  local spawnForward =
    settings.spawnForward or 0

  local spawnHeight =
    settings.spawnHeight or 1.2

  local targetHeight =
    settings.targetHeight or .8

  self.battle:spawnProjectile(
    settings.projectile,
    {
      team = self.team,
      source = self,

      x =
        self.x +
        directionX *
        spawnForward,

      y =
        self.y +
        spawnHeight,

      z =
        self.z +
        directionZ *
        spawnForward,

      target = target,
      targetX = target.x,
      targetY =
        target.y + targetHeight,
      targetZ = target.z
    }
  )

  self.rangedCooldown =
    self:getRangedCooldown()

  return true
end


-- Обновляет ближнюю атаку.
function Unit:updateMeleeAttack(dt)
  local victim =
    self.battle:findNearestEnemy(
      self,
      self.attackDistance
    )

  self.target = victim

  if victim then
    self:faceDirection(
      victim.x - self.x,
      victim.z - self.z
    )
  end

  self.entity:update(dt)

  if
    not self.entity:
      isAnimationFinished()
  then
    return
  end

  if self.attackPhase == 'start' then
    self.attackPhase = 'hit'

    self.entity:setAnimation(
      self.attackDefinition.hit,
      true
    )

    victim =
      self.battle:findNearestEnemy(
        self,
        self.attackDistance
      )

    self.target = victim

    if victim then
      local area =
        self.config.meleeArea

      if area and area.enabled then
        self.battle:damageRadius(
          self.x,
          self.z,
          area.radius,
          {
            damageMinimum =
              area.damageMinimum
              or self.damageMinimum,

            damageMaximum =
              area.damageMaximum
              or self.damageMaximum,

            damageType =
              area.damageType
              or self.damageType,

            friendlyFire =
              area.friendlyFire == true,

            damageFalloff =
              area.damageFalloff
              or 'uniform',

            launchOnKill =
              area.launchOnKill
              ~= false
          },
          self.team,
          self
        )
      else
        local damage =
          math.random(
            self.damageMinimum,
            self.damageMaximum
          )

        victim:takeDamage(
          damage,
          self.damageType,
          {
            source = self,
            x = self.x,
            z = self.z,
            radiusAttack = false
          }
        )
      end
    end

    return
  end

  if self.attackPhase == 'hit' then
    self.attackPhase = 'finish'

    self.entity:setAnimation(
      self.attackDefinition.finish,
      true
    )

    return
  end

  self:finishAttack()
end


-- Обновляет дальнюю атаку.
function Unit:updateRangedAttack(dt)
  if
    self.target
    and self.target:isTargetable()
  then
    self:faceDirection(
      self.target.x - self.x,
      self.target.z - self.z
    )
  end

  self.entity:update(dt)

  if
    not self.entity:
      isAnimationFinished()
  then
    return
  end

  if self.attackPhase == 'start' then
    self.attackPhase = 'fire'

    self.entity:setAnimation(
      self.attackDefinition.fire,
      true
    )

    self:fireProjectile()

    return
  end

  if self.attackPhase == 'fire' then
    self.attackPhase = 'finish'

    self.entity:setAnimation(
      self.attackDefinition.finish,
      true
    )

    return
  end

  self:finishAttack()
end


-- Обновляет текущую атаку.
function Unit:updateAttack(dt)
  if self.attackKind == 'ranged' then
    self:updateRangedAttack(dt)
  else
    self:updateMeleeAttack(dt)
  end
end


-- Ожидает освобождения пути.
function Unit:waitForPath(dt)
  self.blockedTime =
    self.blockedTime + dt

  if self.blockedTime >= .5 then
    self.blockedTime = 0
    self.avoidanceSide =
      -self.avoidanceSide
  end

  self.state = 'idle'
  self:setAnimation('idle')
  self.entity:update(dt)
end


-- Ожидает перезарядки.
function Unit:waitForRangedAttack(
  dt,
  target
)
  self.state = 'idle'
  self.blockedTime = 0

  if target then
    self:faceDirection(
      target.x - self.x,
      target.z - self.z
    )
  end

  self:setAnimation('idle')
  self.entity:update(dt)
end


-- Двигает бойца.
function Unit:moveInDirection(
  dt,
  desiredX,
  desiredZ
)
  local movementX, movementZ =
    self.battle:
      chooseMovementDirection(
        self,
        desiredX,
        desiredZ
      )

  if not movementX then
    self:waitForPath(dt)
    return false
  end

  self.blockedTime = 0

  local movement =
    self.config.moveSpeed * dt

  self.x =
    self.x +
    movementX * movement

  self.z =
    self.z +
    movementZ * movement

  self:faceDirection(
    movementX,
    movementZ
  )

  self.state = 'moving'

  self:setAnimation(
    self.entity.definition
      .battleAnimations.forward
  )

  self.entity:update(dt)
  self:checkMapExit()

  return true
end


-- Двигается к противнику.
function Unit:updateCombatMovement(
  dt,
  target
)
  local dx = target.x - self.x
  local dz = target.z - self.z

  local distance =
    math.sqrt(
      dx * dx + dz * dz
    )

  if distance <= .0001 then
    self:waitForPath(dt)
    return
  end

  self:moveInDirection(
    dt,
    dx / distance,
    dz / distance
  )
end


-- Двигается по маршруту.
function Unit:updateRouteMovement(dt)
  local directionX, directionZ =
    self:getRouteDirection()

  if not directionX then
    self.state = 'idle'
    self:setAnimation('idle')
    self.entity:update(dt)
    return
  end

  self:moveInDirection(
    dt,
    directionX,
    directionZ
  )
end


-- Завершает отображение тела.
function Unit:resolveCorpse()
  if self.corpseResolved then
    return
  end

  self.corpseResolved = true

  local corpse =
    self.corpseDefinition

  local shouldStay =
    corpse.mode == 'always'

  if corpse.mode == 'random' then
    shouldStay =
      math.random() <
      (corpse.stayChance or 0)
  end

  if shouldStay then
    self.state = 'corpse'
  else
    self.removed = true
  end
end


-- Запускает обычную смерть.
function Unit:startNormalDeath()
  self.state = 'dying'

  self.entity:setAnimation(
    self:getDeathAnimation(),
    true
  )
end


-- Запускает отлёт от удара.
function Unit:startFallDeath(context)
  local settings =
    self.fallDefinition

  local sourceX =
    context.x
    or (
      context.source
      and context.source.x
    )
    or self.x

  local sourceZ =
    context.z
    or (
      context.source
      and context.source.z
    )
    or self.z

  local directionX =
    self.x - sourceX

  local directionZ =
    self.z - sourceZ

  local length =
    math.sqrt(
      directionX * directionX +
      directionZ * directionZ
    )

  if length <= .0001 then
    local angle =
      math.random() *
      math.pi * 2

    directionX = math.cos(angle)
    directionZ = math.sin(angle)
  else
    directionX =
      directionX / length

    directionZ =
      directionZ / length
  end

  self.state = 'falling'
  self.fallPhase = 'flight'
  self.fallTime = 0

  self.fallDuration =
    randomRange(
      settings.durationMinimum
        or settings.duration
        or .8,

      settings.durationMaximum
        or settings.duration
        or .8
    )

  self.fallHeight =
    randomRange(
      settings.heightMinimum
        or settings.height
        or 1.5,

      settings.heightMaximum
        or settings.height
        or 1.5
    )

  self.fallDistance =
    randomRange(
      settings.distanceMinimum
        or settings.distance
        or 2.5,

      settings.distanceMaximum
        or settings.distance
        or 2.5
    )

  self.fallStartX = self.x
  self.fallStartY = self.y
  self.fallStartZ = self.z

  self.fallEndX =
    self.x +
    directionX *
    self.fallDistance

  self.fallEndZ =
    self.z +
    directionZ *
    self.fallDistance

  self.fallAnimations =
    self:getFallAnimations()

  if self.fallAnimations then
    self.entity:setAnimation(
      self.fallAnimations.start,
      true
    )
  else
    self.entity:setAnimation(
      self:getDeathAnimation(),
      true
    )
  end
end


-- Запускает смерть бойца.
function Unit:startDeath(context)
  self.combatAlive = false
  self.target = nil
  self.attackKind = nil
  self.attackPhase = nil
  self.attackDefinition = nil

  self.squad:onUnitRemoved(
    self,
    'killed'
  )

  local shouldFall =
    context
    and context.launchOnKill
    and self.fallDefinition
    and self.fallDefinition.enabled
      ~= false

  if shouldFall then
    self:startFallDeath(context)
  else
    self:startNormalDeath()
  end
end


-- Наносит бойцу урон.
function Unit:takeDamage(
  amount,
  damageType,
  context
)
  if not self.combatAlive then
    return
  end

  local multiplier = 1

  if damageType == 'spear' then
    multiplier =
      self.config
        .spearDamageMultiplier
      or 1
  elseif damageType == 'magic' then
    multiplier =
      self.config
        .magicDamageMultiplier
      or 1
  end

  self.health =
    self.health -
    amount * multiplier

  if self.health <= 0 then
    self.health = 0
    self:startDeath(context)
  end
end


-- Обновляет обычную смерть.
function Unit:updateDeath(dt)
  self.entity:update(dt)

  if
    self.entity:
      isAnimationFinished()
  then
    self:resolveCorpse()
  end
end


-- Обновляет отлёт погибшего бойца.
function Unit:updateFallDeath(dt)
  if self.fallPhase == 'flight' then
    self.fallTime =
      self.fallTime + dt

    local progress =
      math.min(
        1,
        self.fallTime /
        self.fallDuration
      )

    self.x =
      self.fallStartX +
      (
        self.fallEndX -
        self.fallStartX
      ) * progress

    self.z =
      self.fallStartZ +
      (
        self.fallEndZ -
        self.fallStartZ
      ) * progress

    self.y =
      self.fallStartY +
      4 *
      self.fallHeight *
      progress *
      (1 - progress)

    self.entity:update(dt)

    if
      self.fallAnimations
      and self.entity:
        isAnimationFinished()
      and self.entity.animationName ==
        self.fallAnimations.start
    then
      self.entity:setAnimation(
        self.fallAnimations.airborne,
        true
      )
    end

    if progress < 1 then
      return
    end

    self.x = self.fallEndX
    self.y = self.fallStartY
    self.z = self.fallEndZ

    self.fallPhase = 'landing'

    if self.fallAnimations then
      self.entity:setAnimation(
        self.fallAnimations.land,
        true
      )
    end

    return
  end

  self.entity:update(dt)

  if
    self.entity:
      isAnimationFinished()
  then
    self:resolveCorpse()
  end
end


-- Обновляет перезарядку.
function Unit:updateCooldowns(dt)
  self.rangedCooldown =
    math.max(
      0,
      self.rangedCooldown - dt
    )
end


-- Выбирает боевое действие.
function Unit:updateCombat(
  dt,
  enemy
)
  local distance =
    self:getDistanceTo(enemy)

  if
    distance <= self.attackDistance
    and self:hasMeleeAttack()
  then
    if self:tryChargeHit(
      enemy,
      dt
    ) then
      return
    end

    self:startMeleeAttack(enemy)
    return
  end

  if self:hasRangedAttack() then
    local minimumDistance =
      self.rangedAttack
        .minimumDistance
      or 0

    -- Артиллерия без ближней атаки
    -- ничего не делает рядом с врагом.
    if
      distance < minimumDistance
      and not self:hasMeleeAttack()
    then
      self:waitForRangedAttack(
        dt,
        enemy
      )

      return
    end
  end

  if
    self:isInsideRangedDistance(
      distance
    )
  then
    if self.rangedCooldown <= 0 then
      self:startRangedAttack(enemy)
    else
      self:waitForRangedAttack(
        dt,
        enemy
      )
    end

    return
  end

  self:updateCombatMovement(
    dt,
    enemy
  )
end


-- Обновляет бойца.
function Unit:update(dt)
	if self.flyingBehavior then
	  self.flyingBehavior:update(dt)
	end

  if self.removed then
    return
  end

  if self.state == 'dying' then
    self:updateDeath(dt)
    self:syncEntity()
    return
  end

  if self.state == 'falling' then
    self:updateFallDeath(dt)
    self:syncEntity()
    return
  end

  if self.state == 'corpse' then
    self:syncEntity()
    return
  end

  self:updateCooldowns(dt)

  if self.state == 'attacking' then
    self:updateAttack(dt)
    self:syncEntity()
    return
  end

  local enemy =
    self.battle:findNearestEnemy(
      self,
      self.sightDistance
    )

  if enemy then
    self:updateCombat(
      dt,
      enemy
    )
  else
    self:updateRouteMovement(dt)
  end

  self:syncEntity()
end


-- Рисует бойца.
function Unit:draw(pass, camera)
  if self.removed then
    return
  end

  self:syncEntity()

  local allowLod =
    self.combatAlive
    and self.state ~= 'falling'

  self.entity:draw(
    pass,
    camera,
    allowLod
  )
end


return Unit