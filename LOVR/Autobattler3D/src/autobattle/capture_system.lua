local CaptureSystem = {}
CaptureSystem.__index = CaptureSystem


-- Создаёт список зданий одной области.
local function createBuildingMembers(
  buildingSystem,
  definition
)
  local members = {}

  local configured =
    definition.buildings

  -- Сохраняет совместимость со старым
  -- форматом с одной платформой.
  if not configured then
    configured = {
      {
        id = definition.building,
        owners = definition.owners
      }
    }
  end

  for _, settings in ipairs(configured) do
    if type(settings) == 'string' then
      settings = {
        id = settings
      }
    end

    local buildingId =
      settings.id
      or settings.building

    local building =
      assert(
        buildingSystem:
          getBuilding(buildingId),

        'Capture point has no building: ' ..
        tostring(buildingId)
      )

    members[#members + 1] = {
      building = building,

      owners =
        settings.owners
        or definition.owners
    }
  end

  assert(
    #members > 0,
    'Capture point has no buildings: ' ..
    tostring(definition.id)
  )

  return members
end


-- Создаёт систему захватываемых областей.
function CaptureSystem.new(settings)
  local self =
    setmetatable({}, CaptureSystem)

  self.battle =
    assert(
      settings.battle,
      'CaptureSystem has no battle'
    )

  self.map =
    assert(
      settings.map,
      'CaptureSystem has no map'
    )

  self.buildingSystem =
    assert(
      settings.buildingSystem,
      'CaptureSystem has no building system'
    )

  self.points = {}
  self.pointsById = {}

  local monsterGroups =
    self.map.squads.monsters
    and self.map.squads.monsters.groups
    or {}

  for _, definition in ipairs(
    self.map.capturePoints or {}
  ) do
    local members =
      createBuildingMembers(
        self.buildingSystem,
        definition
      )

    local guardSettings = nil

    for _, group in ipairs(
      monsterGroups
    ) do
      if
        group.guardPoint ==
        definition.id
      then
        guardSettings = group
        break
      end
    end

    local firstBuilding =
      members[1].building

    local point = {
      id =
        assert(
          definition.id,
          'Capture point has no id'
        ),

      definition = definition,
      buildings = members,

      -- Оставлено для совместимости
      -- с кодом одной платформы.
      building = firstBuilding,

      x = definition.x
        or firstBuilding.x,

      z = definition.z
        or firstBuilding.z,

      floorY =
        firstBuilding.floorY,

      radius =
        definition.radius
        or firstBuilding.radius
        or 8,

      captureDuration =
        definition.captureTime
        or 5,

      cooldownDuration =
        definition.cooldown
        or 8,

      guardRespawnDelay =
        definition.guardRespawnDelay
        or 15,

      guardLeash =
        definition.guardLeash
        or 24,

      guardHomeRadius =
        definition.guardHomeRadius
        or 5,

      guardSettings =
        guardSettings,

      ownerTeam =
        firstBuilding.team,

      capturingTeam = nil,
      captureProgress = 0,

      -- Отдельный кулдаун для
      -- каждой разрушенной платформы.
      cooldowns = {},

      guardRespawnTime = 0,
      pendingAction = nil
    }

    for _, member in ipairs(members) do
      member.building.capturePointId =
        point.id
    end

    self.points[
      #self.points + 1
    ] = point

    self.pointsById[
      point.id
    ] = point
  end

  return self
end


-- Возвращает область захвата.
function CaptureSystem:getPoint(id)
  return self.pointsById[id]
end


-- Проверяет владельца области.
function CaptureSystem:isOwnedBy(
  pointId,
  team
)
  local point =
    self:getPoint(pointId)

  return
    point ~= nil
    and point.ownerTeam == team
end


-- Сбрасывает незавершённый захват.
function CaptureSystem:resetCapture(point)
  point.capturingTeam = nil
  point.captureProgress = 0
end


-- Считает основные войска в области.
function CaptureSystem:getPresence(point)
  local allies = 0
  local enemies = 0

  local radiusSquared =
    point.radius * point.radius

  for _, unit in ipairs(
    self.battle.units
  ) do
    if
      unit:isTargetable()
      and (
        unit.team == 'allies'
        or unit.team == 'enemies'
      )
    then
      local dx = unit.x - point.x
      local dz = unit.z - point.z

      if
        dx * dx + dz * dz <=
        radiusSquared
      then
        if unit.team == 'allies' then
          allies = allies + 1
        else
          enemies = enemies + 1
        end
      end
    end
  end

  return allies, enemies
end


-- Проверяет живую охрану области.
function CaptureSystem:hasLivingGuards(
  point
)
  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'monsters'
      and squad.guardPoint == point.id
      and not squad:isDefeated()
    then
      return true
    end
  end

  return false
end


-- Проверяет готовность всех платформ
-- к нейтрализации или захвату.
function CaptureSystem:
  areBuildingsCapturable(point)
  for _, member in ipairs(
    point.buildings
  ) do
    local building =
      member.building

    if
      building:isReady()
      or building:isConstructing()
      or point.cooldowns[
        building.id
      ]
    then
      return false
    end
  end

  return true
end


-- Делает всю область нейтральной.
function CaptureSystem:clearOwner(point)
  point.ownerTeam = nil
  point.pendingAction = nil
  point.guardRespawnTime = 0

  self:resetCapture(point)

  for _, member in ipairs(
    point.buildings
  ) do
    local building =
      member.building

    building.team = nil
    building.sideId = nil
    building.modelId = nil

    building.routeId = nil
    building.spawnX = nil
    building.spawnZ = nil
  end
end


-- Передаёт все платформы новой стороне.
function CaptureSystem:setOwner(
  point,
  team
)
  if not team then
    self:clearOwner(point)
    return
  end

  point.ownerTeam = team
  point.guardRespawnTime = 0

  self:resetCapture(point)

  for _, member in ipairs(
    point.buildings
  ) do
    self.buildingSystem:
      setBuildingOwner(
        member.building,
        team,
        member.owners
      )
  end

  local actions =
    point.definition.onCaptured

  local action =
    actions
    and actions[team]

  if action then
    point.pendingAction = {
      ownerTeam = team,
      definition = action,

      remaining =
        action.delay or 0
    }
  else
    point.pendingAction = nil
  end
end


-- Возвращает участника области по ID здания.
function CaptureSystem:getBuildingMember(
  point,
  buildingId
)
  for _, member in ipairs(
    point.buildings
  ) do
    if member.building.id == buildingId then
      return member
    end
  end

  return nil
end


-- Запускает строительство всех платформ.
function CaptureSystem:buildAllForEnemy(
  point
)
  local completed = true

  for _, member in ipairs(
    point.buildings
  ) do
    local building =
      member.building

    if building.state == 'platform' then
      if
        not self.buildingSystem:
          startEnemyConstruction(
            building
          )
      then
        completed = false
      end

    elseif
      not building:isConstructing()
      and not building:isReady()
    then
      completed = false
    end
  end

  return completed
end


-- Выполняет действие после захвата.
function CaptureSystem:updatePendingAction(
  point,
  dt
)
  local pending =
    point.pendingAction

  if not pending then
    return
  end

  if
    point.ownerTeam ~=
    pending.ownerTeam
  then
    point.pendingAction = nil
    return
  end

  pending.remaining =
    math.max(
      0,
      pending.remaining - dt
    )

  if pending.remaining > 0 then
    return
  end

  local action =
    pending.definition

  if point.ownerTeam ~= 'enemies' then
    point.pendingAction = nil
    return
  end

  if action.action == 'build_all' then
    if self:buildAllForEnemy(point) then
      point.pendingAction = nil
    end

    return
  end

  if action.action == 'build' then
    local member =
      action.building
      and self:getBuildingMember(
        point,
        action.building
      )
      or point.buildings[1]

    if
      member
      and self.buildingSystem:
        startEnemyConstruction(
          member.building
        )
    then
      point.pendingAction = nil
    end

    return
  end

  point.pendingAction = nil
end

-- Возрождает отряд охраны.
function CaptureSystem:respawnGuards(
  point
)
  local group =
    point.guardSettings

  if not group or not group.slot then
    return false
  end

  local monsterSide =
    self.battle.monsterSide
    or 'monsters'

  local definition =
    self.battle.sideRegistry:
      resolveUnit(
        monsterSide,
        group.slot
      )

  if not definition then
    return false
  end

  self.battle:addSquad(
    'monsters',
    group,
    definition,
    'monsters'
  )

  point.guardRespawnTime = 0

  return true
end


-- Обновляет возрождение охраны.
function CaptureSystem:updateGuardRespawn(
  point,
  dt,
  allies,
  enemies
)
  if
    not point.guardSettings
    or point.ownerTeam
    or self:hasLivingGuards(point)
    or allies > 0
    or enemies > 0
  then
    point.guardRespawnTime = 0
    return
  end

  point.guardRespawnTime =
    point.guardRespawnTime + dt

  if
    point.guardRespawnTime >=
    point.guardRespawnDelay
  then
    self:respawnGuards(point)
  end
end


-- Возвращает оставшийся максимальный
-- кулдаун платформ области.
function CaptureSystem:getMaximumCooldown(
  point
)
  local maximum = 0

  for _, remaining in pairs(
    point.cooldowns
  ) do
    maximum =
      math.max(
        maximum,
        remaining
      )
  end

  return maximum
end


-- Обновляет кулдауны разрушенных зданий.
function CaptureSystem:updateCooldowns(
  point,
  dt
)
  for buildingId, remaining in pairs(
    point.cooldowns
  ) do
    remaining =
      math.max(
        0,
        remaining - dt
      )

    if remaining <= 0 then
      point.cooldowns[buildingId] = nil

      local member =
        self:getBuildingMember(
          point,
          buildingId
        )

      if
        member
        and member.building.state ==
          'cooldown'
      then
        member.building.state =
          'platform'
      end
    else
      point.cooldowns[buildingId] =
        remaining
    end
  end
end


-- Проверяет возможность захвата области.
function CaptureSystem:canCapture(point)
  return
    self:areBuildingsCapturable(point)
    and not self:
      hasLivingGuards(point)
end


-- Обновляет одну область.
function CaptureSystem:updatePoint(
  point,
  dt
)
  self:updateCooldowns(
    point,
    dt
  )

  self:updatePendingAction(
    point,
    dt
  )

  local allies, enemies =
    self:getPresence(point)

  self:updateGuardRespawn(
    point,
    dt,
    allies,
    enemies
  )

  if not self:canCapture(point) then
    self:resetCapture(point)
    return
  end

  -- Пустая или оспариваемая область
  -- не меняет владельца.
  if
    (
      allies == 0
      and enemies == 0
    )
    or (
      allies > 0
      and enemies > 0
    )
  then
    self:resetCapture(point)
    return
  end

  local team =
    allies > 0
    and 'allies'
    or 'enemies'

  if point.ownerTeam == team then
    self:resetCapture(point)
    return
  end

  if point.capturingTeam ~= team then
    point.capturingTeam = team
    point.captureProgress = 0
  end

  point.captureProgress =
    point.captureProgress + dt

  if
    point.captureProgress <
    point.captureDuration
  then
    return
  end

  -- Вражеская территория сначала
  -- становится нейтральной.
  if
    point.ownerTeam
    and point.ownerTeam ~= team
  then
    self:clearOwner(point)
    return
  end

  self:setOwner(
    point,
    team
  )
end


-- Обрабатывает разрушение одного здания.
function CaptureSystem:onBuildingDestroyed(
  building
)
  local pointId =
    building.capturePointId

  local point =
    pointId
    and self:getPoint(pointId)

  if not point then
    return
  end

  point.cooldowns[building.id] =
    point.cooldownDuration

  building.state = 'cooldown'
end


-- Выполняет фиксированный шаг.
function CaptureSystem:update(dt)
  for _, point in ipairs(
    self.points
  ) do
    self:updatePoint(
      point,
      dt
    )
  end
end


-- Возвращает цвет области.
function CaptureSystem:getPointColor(point)
  -- Цвет захватывающей стороны имеет
  -- приоритет над текущим владельцем.
  if point.capturingTeam == 'allies' then
    return .2, .55, 1, .22
  end

  if point.capturingTeam == 'enemies' then
    return 1, .22, .18, .22
  end

  if point.ownerTeam == 'allies' then
    return .2, .55, 1, .14
  end

  if point.ownerTeam == 'enemies' then
    return 1, .22, .18, .14
  end

  -- Нейтральная область не получает
  -- жёлтую подсветку.
  return .38, .4, .42, 0
end

-- Рисует только прогресс активного захвата.
function CaptureSystem:draw(
  pass,
  camera
)
  pass:setShader()
  pass:setMaterial()

  for _, point in ipairs(
    self.points
  ) do
    if
      point.capturingTeam
      and point.captureProgress > 0
    then
      local progress =
        math.min(
          1,
          point.captureProgress /
            point.captureDuration
        )

      local width =
        point.radius * 1.2

      local filled =
        width * progress

      local y =
        point.floorY + .55

      pass:setColor(
        .08,
        .08,
        .08,
        .85
      )

      pass:box(
        point.x,
        y,
        point.z,
        width,
        .18,
        .45
      )

      if
        point.capturingTeam ==
        'allies'
      then
        pass:setColor(
          .2,
          .55,
          1,
          1
        )
      else
        pass:setColor(
          1,
          .22,
          .18,
          1
        )
      end

      pass:box(
        point.x -
          width / 2 +
          filled / 2,

        y + .01,
        point.z,

        filled,
        .2,
        .48
      )

      pass:setColor(1, 1, 1, .9)

      pass:text(
        'CAPTURING ' ..
        math.floor(
          progress * 100
        ) ..
        '%',

        point.x,
        point.floorY + 1.2,
        point.z,
        .22,
        camera and camera.yaw or 0,
        0,
        1,
        0
      )
    end
  end

  pass:setColor(1, 1, 1, 1)
end

return CaptureSystem