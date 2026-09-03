local Squad =
  require('src.autobattle.squad')

local SpatialGrid =
  require('src.autobattle.spatial_grid')

local Economy =
  require('src.economy.economy')

local BuildingSystem =
  require(
    'src.buildings.building_system'
  )

local ProjectileRegistry =
  require(
    'src.projectiles.projectile_registry'
  )

local ProjectileSystem =
  require(
    'src.projectiles.projectile_system'
  )

local ModelLighting =
  require(
    'src.graphics.model_lighting'
  )

local Battle = {}
Battle.__index = Battle


-- Создаёт настроенное сражение.
function Battle.new(
  config,
  modelRegistry,
  field,
  options
)
  local self =
    setmetatable({}, Battle)

  options = options or {}

  self.config = config
  self.modelRegistry = modelRegistry
  self.field = field

  self.sideRegistry =
    assert(
      options.sideRegistry,
      'Battle has no side registry'
    )

  self.map =
    assert(
      options.map,
      'Battle has no map'
    )

  self.playerUnitDefinition =
    assert(
      options.playerUnitDefinition,
      'Player side has no unit'
    )

  self.enemyUnitDefinition =
    assert(
      options.enemyUnitDefinition,
      'Enemy side has no unit'
    )

  self.nextUnitId = 1
  self.nextSquadId = 1

  self.squads = {}
  self.units = {}
  self.winner = nil

  self.economy = nil
  self.buildingSystem = nil

  self.grid = SpatialGrid.new(
    config.collision.cellSize
  )

  self.projectileRegistry =
    ProjectileRegistry.new()

  self.projectileSystem =
    ProjectileSystem.new(
      self.projectileRegistry,
      self
    )

  self.modelLightingShader =
    ModelLighting.new()

  self:createConfiguredBattle()

  if self.map.buildings then
    self.economy = Economy.new(
      self.map.economy
      or config.economy
    )

    self.buildingSystem =
      BuildingSystem.new({
        battle = self,
        map = self.map,

        modelRegistry =
          self.modelRegistry,

        sideRegistry =
          self.sideRegistry,

        economy = self.economy,

        playerSide =
          options.playerSide,

        enemySide =
          options.enemySide
      })
  end

  return self
end


-- Выделяет уникальный ID бойца.
function Battle:allocateUnitId()
  local id = self.nextUnitId

  self.nextUnitId =
    self.nextUnitId + 1

  return id
end


-- Выделяет уникальный ID отряда.
function Battle:allocateSquadId()
  local id = self.nextSquadId

  self.nextSquadId =
    self.nextSquadId + 1

  return id
end


-- Возвращает маршрут карты.
function Battle:findRoute(
  routeTeam,
  routeId
)
  local routes =
    self.map.routes[routeTeam]
    or {}

  for _, route in ipairs(routes) do
    if route.id == routeId then
      return route
    end
  end

  return nil
end


-- Добавляет группу бойцов.
function Battle:addSquad(
  team,
  squadSettings,
  unitDefinition,
  routeTeam
)
  local route =
    self:findRoute(
      routeTeam,
      squadSettings.defaultRoute
    )

  local squad = Squad.new({
    id = self:allocateSquadId(),
    team = team,

    direction =
      team == 'allies'
      and -1
      or 1,

    startX = squadSettings.x,
    startZ = squadSettings.z,

    count =
      unitDefinition.squadSize
      or squadSettings.count,

    route = route,
    unitDefinition = unitDefinition,

    battle = self,
    config = self.config,

    modelRegistry =
      self.modelRegistry
  })

  self.squads[
    #self.squads + 1
  ] = squad

  for _, unit in ipairs(
    squad.units
  ) do
    self.units[
      #self.units + 1
    ] = unit
  end

  return squad
end


-- Создаёт все начальные отряды карты.
function Battle:createConfiguredBattle()
  local squads = self.map.squads

  for _, group in ipairs(
    squads.player.groups
  ) do
    self:addSquad(
      'allies',
      group,
      self.playerUnitDefinition,
      'player'
    )
  end

  for _, group in ipairs(
    squads.enemy.groups
  ) do
    self:addSquad(
      'enemies',
      group,
      self.enemyUnitDefinition,
      'enemy'
    )
  end
end


-- Ищет ближайшего врага в радиусе.
function Battle:findNearestEnemy(
  unit,
  radius
)
  local enemy =
    self.grid:findNearest(
      unit.x,
      unit.z,
      radius,

      function(candidate)
        return
          candidate.team ~= unit.team
          and candidate:isTargetable()
      end
    )

  -- Войска всегда имеют приоритет
  -- перед вражескими зданиями.
  if enemy then
    return enemy
  end

  if self.buildingSystem then
    return
      self.buildingSystem:
        findNearestEnemyBuilding(
          unit,
          radius
        )
  end

  return nil
end

-- Проверяет разрешение пройти
-- сквозь союзного бойца.
function Battle:canUnitPassThrough(
  movingUnit,
  otherUnit
)
  if
    movingUnit.team ~=
    otherUnit.team
  then
    return false
  end

  local allowedSlots =
    movingUnit.config
      .alliedPassThroughSlots

  if not allowedSlots then
    return false
  end

  return
    allowedSlots[
      otherUnit.config.slot
    ] == true
end

-- Проверяет ближайший участок движения.
function Battle:isDirectionClear(
  unit,
  directionX,
  directionZ
)
  local navigation =
    self.config.navigation

  local clear = true

  self.grid:forEachNearby(
    unit.x,
    unit.z,
    navigation.avoidanceRadius,

    function(candidate)
      if
        not clear
        or candidate == unit
        or candidate.team ~= unit.team
        or not candidate:
          isSpatiallyActive()
      then
        return
      end

      local unitFlying =
        unit.flyingBehavior ~= nil

      local candidateFlying =
        candidate.flyingBehavior ~= nil

      -- Наземные и воздушные юниты
      -- не блокируют движение друг друга.
      if
        unitFlying ~=
        candidateFlying
      then
        return
      end

      -- Разрешённые типы союзников
      -- не требуют поиска обхода.
      if self:canUnitPassThrough(
        unit,
        candidate
      ) then
        return
      end

      local relativeX =
        candidate.x - unit.x

      local relativeZ =
        candidate.z - unit.z

      local forward =
        relativeX * directionX +
        relativeZ * directionZ

      local requiredSpace =
        unit.radius +
        candidate.radius +
        .15

      if
        forward <= 0
        or forward > requiredSpace
      then
        return
      end

      local sideways =
        math.abs(
          relativeX * directionZ -
          relativeZ * directionX
        )

      if sideways < requiredSpace then
        clear = false
      end
    end
  )

  return clear
end


-- Ищет свободное направление обхода.
function Battle:chooseMovementDirection(
  unit,
  desiredX,
  desiredZ
)
  if self:isDirectionClear(
    unit,
    desiredX,
    desiredZ
  ) then
    return desiredX, desiredZ
  end

  local angles = {
    math.rad(35),
    math.rad(60),
    math.rad(85)
  }

  for _, angle in ipairs(angles) do
    local cosine = math.cos(angle)
    local sine = math.sin(angle)

    for attempt = 1, 2 do
      local side =
        attempt == 1
        and unit.avoidanceSide
        or -unit.avoidanceSide

      local signedSine =
        sine * side

      local candidateX =
        desiredX * cosine -
        desiredZ * signedSine

      local candidateZ =
        desiredX * signedSine +
        desiredZ * cosine

      if self:isDirectionClear(
        unit,
        candidateX,
        candidateZ
      ) then
        unit.avoidanceSide = side

        return
          candidateX,
          candidateZ
      end
    end
  end

  return nil
end


-- Наносит радиусный урон бойцам.
function Battle:damageUnitsInRadius(
  x,
  z,
  radius,
  attack,
  sourceTeam,
  source
)
  self.grid:forEachNearby(
    x,
    z,
    radius,

    function(unit)
      -- Атакующий не повреждает себя.
      if unit == source then
        return
      end

      if not unit:isTargetable() then
        return
      end

      if
        not attack.friendlyFire
        and unit.team == sourceTeam
      then
        return
      end

      local dx = unit.x - x
      local dz = unit.z - z

      local distanceSquared =
        dx * dx + dz * dz

      if
        distanceSquared >
        radius * radius
      then
        return
      end

      local damage =
        math.random(
          attack.damageMinimum,
          attack.damageMaximum
        )

      if
        attack.damageFalloff ==
          'linear'
        and radius > 0
      then
        local distance =
          math.sqrt(
            distanceSquared
          )

        damage =
          damage *
          math.max(
            0,
            1 - distance / radius
          )
      end

      unit:takeDamage(
        damage,
        attack.damageType,
        {
          source = source,
          x = x,
          z = z,

          radiusAttack = true,

          launchOnKill =
            attack.launchOnKill
              == true
        }
      )
    end
  )
end


-- Наносит радиусный урон зданиям.
function Battle:damageBuildingsInRadius(
  x,
  z,
  radius,
  attack,
  sourceTeam,
  source
)
  if not self.buildingSystem then
    return
  end

  for _, building in ipairs(
    self.buildingSystem.buildings
  ) do
    if
      building ~= source
      and building:isTargetable()
      and (
        attack.friendlyFire
        or building.team ~= sourceTeam
      )
    then
      local dx = building.x - x
      local dz = building.z - z

      local centerDistance =
        math.sqrt(
          dx * dx + dz * dz
        )

      local distance =
        math.max(
          0,
          centerDistance -
            building.radius
        )

      if distance <= radius then
        local damage =
          math.random(
            attack.damageMinimum,
            attack.damageMaximum
          )

        if
          attack.damageFalloff ==
            'linear'
          and radius > 0
        then
          damage =
            damage *
            math.max(
              0,
              1 - distance / radius
            )
        end

        building:takeDamage(
          damage,
          attack.damageType,
          {
            source = source,
            x = x,
            z = z,
            radiusAttack = true
          }
        )
      end
    end
  end
end


-- Наносит радиусный урон.
function Battle:damageRadius(
  x,
  z,
  radius,
  attack,
  sourceTeam,
  source
)
  self:damageUnitsInRadius(
    x,
    z,
    radius,
    attack,
    sourceTeam,
    source
  )

  self:damageBuildingsInRadius(
    x,
    z,
    radius,
    attack,
    sourceTeam,
    source
  )
end


-- Создаёт снаряд.
function Battle:spawnProjectile(
  projectileId,
  settings
)
  local source =
    settings.source

  if
    source
    and source.flyingBehavior
  then
    settings.y =
      settings.y +
      source.flyingBehavior:
        getHeight()
  end

  local target =
    settings.target

  if
    target
    and target.flyingBehavior
  then
    settings.targetY =
      settings.targetY +
      target.flyingBehavior:
        getHeight()
  end

  return
    self.projectileSystem:spawn(
      projectileId,
      settings
    )
end


-- Ищет первого живого бойца стороны.
function Battle:findFirstLivingUnit(team)
  for _, unit in ipairs(
    self.units
  ) do
    if
      unit.team == team
      and unit:isTargetable()
    then
      return unit
    end
  end

  return nil
end


-- Выпускает тестовый снаряд.
function Battle:fireDebugProjectile(
  projectileId
)
  local source =
    self:findFirstLivingUnit(
      'allies'
    )

  local target =
    self:findFirstLivingUnit(
      'enemies'
    )

  if not source or not target then
    return
  end

  local definition =
    self.projectileRegistry:get(
      projectileId
    )

  local settings = {
    team = source.team,
    source = source,

    x = source.x,
    y = source.y + 1.2,
    z = source.z,

    target = target,
    targetX = target.x,
    targetY = target.y + .7,
    targetZ = target.z
  }

  if definition.hitMode == 'point' then
    settings.target = nil
  end

  self:spawnProjectile(
    projectileId,
    settings
  )
end


-- Отменяет пересекающееся движение.
-- Раздвигает движущихся союзников.
function Battle:separateUnits(
  first,
  second
)
  if
    not first:isSpatiallyActive()
    or not second:
      isSpatiallyActive()
  then
    return
  end

  local firstFlying =
    first.flyingBehavior ~= nil

  local secondFlying =
    second.flyingBehavior ~= nil

  if firstFlying ~= secondFlying then
    return
  end

  local dx = second.x - first.x
  local dz = second.z - first.z

  local minimumDistance =
    first.radius + second.radius

  local distanceSquared =
    dx * dx + dz * dz

  if
    distanceSquared >=
    minimumDistance *
    minimumDistance
  then
    return
  end

  local firstMoved =
    math.abs(
      first.x - first.previousX
    ) > .0001
    or math.abs(
      first.z - first.previousZ
    ) > .0001

  local secondMoved =
    math.abs(
      second.x - second.previousX
    ) > .0001
    or math.abs(
      second.z - second.previousZ
    ) > .0001
	
-- Пропускает столкновение, если именно
  -- двигавшемуся бойцу разрешён проход.
  if first.team == second.team then
    local firstCanPass =
      firstMoved
      and self:canUnitPassThrough(
        first,
        second
      )

    local secondCanPass =
      secondMoved
      and self:canUnitPassThrough(
        second,
        first
      )

    if firstCanPass or secondCanPass then
      return
    end
  end	

  local bothMoving =
    firstMoved
    and secondMoved
    and first.state == 'moving'
    and second.state == 'moving'

  -- Движущиеся союзники мягко
  -- раздвигаются в равных долях.
  if
    bothMoving
    and first.team == second.team
  then
    local distance
    local normalX
    local normalZ

    if distanceSquared < .0001 then
      local angle =
        (
          first.id * 37 +
          second.id * 17
        ) % 360

      angle = math.rad(angle)

      normalX = math.cos(angle)
      normalZ = math.sin(angle)
      distance = 0
    else
      distance =
        math.sqrt(distanceSquared)

      normalX = dx / distance
      normalZ = dz / distance
    end

    local correction =
      (
        minimumDistance -
        distance
      ) / 2

    first.x =
      first.x -
      normalX * correction

    first.z =
      first.z -
      normalZ * correction

    second.x =
      second.x +
      normalX * correction

    second.z =
      second.z +
      normalZ * correction

    return
  end

  -- Стоящих бойцов никто не толкает:
  -- отменяется только движение вошедшего.
  if firstMoved then
    first.x = first.previousX
    first.z = first.previousZ
  end

  if secondMoved then
    second.x = second.previousX
    second.z = second.previousZ
  end
end


-- Выполняет один проход столкновений.
function Battle:resolveCollisionPass()
  for _, first in ipairs(
    self.units
  ) do
    if first:isSpatiallyActive() then
      self.grid:forEachNearby(
        first.x,
        first.z,
        first.radius * 2.2,

        function(second)
          if second.id > first.id then
            self:separateUnits(
              first,
              second
            )
          end
        end
      )
    end
  end
end


-- Удаляет законченные сущности.
function Battle:removeFinishedUnits()
  for index =
    #self.units,
    1,
    -1
  do
    local unit = self.units[index]

    if unit.removed then
      table.remove(
        self.units,
        index
      )

      for squadIndex =
        #unit.squad.units,
        1,
        -1
      do
        if
          unit.squad.units[
            squadIndex
          ] == unit
        then
          table.remove(
            unit.squad.units,
            squadIndex
          )

          break
        end
      end
    end
  end
end


-- Проверяет поражение стороны.
function Battle:isTeamDefeated(team)
  local found = false

  for _, squad in ipairs(
    self.squads
  ) do
    if squad.team == team then
      found = true

      if not squad:isDefeated() then
        return false
      end
    end
  end

  return found
end


-- Проверяет победителя.
function Battle:checkWinner()
  if self.winner then
    return
  end

  -- На карте крепостей победитель
  -- определяется только разрушением алтаря.
  if
    self.map.victoryCondition ==
      'altar'
  then
    return
  end

  if self:isTeamDefeated(
    'enemies'
  ) then
    self.winner = 'allies'
  elseif self:isTeamDefeated(
    'allies'
  ) then
    self.winner = 'enemies'
  end
end


-- Выполняет фиксированный шаг.
function Battle:update(dt)
  -- После уничтожения алтаря обновляет
  -- только оставшиеся визуальные эффекты.
if self.winner then
      return
    end

  if self.economy then
    self.economy:update(dt)
  end

  if self.buildingSystem then
    self.buildingSystem:update(dt)

	if self.winner then
		  return
		end
  end

  for _, squad in ipairs(
    self.squads
  ) do
    squad:update(dt)
  end

  for _, unit in ipairs(
    self.units
  ) do
    unit:beginSimulationStep()
  end

  self.grid:rebuild(
    self.units
  )

  for _, unit in ipairs(
    self.units
  ) do
    unit:update(dt)
  end

-- Неподвижные декорации продолжают
  -- выталкивать наземных бойцов.
  for _, unit in ipairs(
    self.units
  ) do
    if unit:isSpatiallyActive() then
      self.field:
        resolveUnitCollisions(
          unit
        )

      unit:syncEntity()
    end
  end

  for iteration = 1,
    self.config.collision.iterations
  do
    self.grid:rebuild(
      self.units
    )

    self:resolveCollisionPass()
  end

  -- Перестраивает сетку перед
  -- возможным радиусным попаданием.
  self.grid:rebuild(
    self.units
  )

  self.projectileSystem:update(dt)

  for _, unit in ipairs(
    self.units
  ) do
    unit:syncEntity()
  end

  self:removeFinishedUnits()
  self:checkWinner()
end


-- Рисует бойцов, здания и снаряды.
function Battle:draw(pass, camera)
  local lighting =
    self.config.lighting
    or {}

  local lightingEnabled =
    lighting.enabled ~= false

  -- Включает шейдер и повторно
  -- передаёт параметры освещения.
  local function applyLighting()
    if not lightingEnabled then
      pass:setShader()
      return
    end

    pass:setShader(
      self.modelLightingShader
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

  if self.buildingSystem then
    self.buildingSystem:draw(
      pass,
      camera,
      applyLighting
    )
  end

  -- Освещение назначается заново
  -- перед каждым юнитом.
  for _, unit in ipairs(
    self.units
  ) do
    applyLighting()

    unit:draw(
      pass,
      camera
    )
  end

  pass:setShader()

  self.projectileSystem:draw(
    pass,
    camera
  )
end


return Battle