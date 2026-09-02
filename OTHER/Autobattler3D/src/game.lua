local Config =
  require('src.autobattle.config')

local Camera =
  require('src.autobattle.camera')

local Field =
  require('src.autobattle.field')

local Battle =
  require('src.autobattle.battle')

local ModelRegistry =
  require('src.assets.model_registry')

local UnitRegistry =
  require('src.units.unit_registry')

local SideRegistry =
  require('src.sides.side_registry')

local MapRegistry =
  require('src.maps.map_registry')

local Settings =
  require('src.core.settings')

local UiContext =
  require('src.ui.ui_context')

local Theme =
  require('src.ui.theme')

local ScreenManager =
  require('src.ui.screen_manager')

local MenuScreen =
  require('src.screens.menu_screen')

local Game = {}
Game.__index = Game


-- Создаёт приложение.
function Game.new()
  local self = setmetatable({}, Game)

  self.settings = Settings.load()

  self.ui = UiContext.new()
  self.theme = Theme.new()
  self.screens = ScreenManager.new()

  self.modelRegistry =
    ModelRegistry.new()
	
  self.loadedBattleModelKey = nil
  
  self.unitRegistry =
    UnitRegistry.new()

  self.sideRegistry =
    SideRegistry.new(
      self.unitRegistry
    )

  self.mapRegistry =
    MapRegistry.new()

  self.camera =
    Camera.new(Config.camera)

  self.state = 'menu'
  self.paused = false
  self.accumulator = 0

  self.loadingQueue = nil
  self.pendingBattle = nil

  self.field = nil
  self.battle = nil
  self.selectedSquad = nil

  lovr.graphics.setBackgroundColor(
    .035,
    .055,
    .045
  )

  lovr.system.setMouseMode('normal')

  self:applyAudioSettings()
  self:showMenu()

  return self
end


-- Применяет общую громкость.
function Game:applyAudioSettings()
  if lovr.audio.setVolume then
    lovr.audio.setVolume(
      self.settings.audio.master
    )
  end
end


-- Сохраняет настройки.
function Game:saveSettings()
  Settings.save(self.settings)
end


-- Показывает главное меню.
function Game:showMenu()
  self.state = 'menu'
  self.paused = false
  self.selectedSquad = nil

  self.camera:endRotation()

  self.screens:replace(
    MenuScreen.new(self)
  )
end


-- Показывает настройку боя.
function Game:showBattleSetup()
  local BattleSetupScreen =
    require(
      'src.screens.battle_setup_screen'
    )

  self.screens:push(
    BattleSetupScreen.new(self)
  )
end


-- Показывает настройки громкости.
function Game:showSettings()
  local SettingsScreen =
    require(
      'src.screens.settings_screen'
    )

  self.screens:push(
    SettingsScreen.new(self)
  )
end


-- Собирает уникальные модели боя.
function Game:getBattleModelIds(
  playerUnit,
  enemyUnit
)
  local ids = {}
  local known = {}

  for _, definition in ipairs({
    playerUnit,
    enemyUnit
  }) do
    if not known[definition.model] then
      known[definition.model] = true
      ids[#ids + 1] =
        definition.model
    end
  end

  return ids
end

-- Подготавливает ресурсы нового боя.
function Game:prepareBattleResources(
  modelIds
)
  -- Освобождает ссылки на предыдущий бой.
  self.selectedSquad = nil
  self.battle = nil
  self.field = nil
  self.loadingQueue = nil
  self.pendingBattle = nil

  local sortedIds = {}

  for _, modelId in ipairs(
    modelIds
  ) do
    sortedIds[#sortedIds + 1] =
      modelId
  end

  table.sort(sortedIds)

  local modelKey =
    table.concat(
      sortedIds,
      ':'
    )

  -- При тех же моделях сохраняет кэш,
  -- чтобы повторный бой загрузился быстрее.
  if
    modelKey ==
    self.loadedBattleModelKey
  then
    collectgarbage('collect')
    return
  end

  -- Старый реестр становится недоступен,
  -- и его модели освобождаются сборщиком.
  self.modelRegistry =
    ModelRegistry.new()

  self.loadedBattleModelKey =
    modelKey

  collectgarbage('collect')
end

-- Начинает загрузку настроенного боя.
function Game:startConfiguredBattle()
  local battleSettings =
    self.settings.battle

  local map =
    self.mapRegistry:get(
      battleSettings.map
    )

  local playerUnit =
    self.sideRegistry:resolveUnit(
      battleSettings.playerSide,
      map.squads.player.slot
    )

  local enemyUnit =
    self.sideRegistry:resolveUnit(
      battleSettings.enemySide,
      map.squads.enemy.slot
    )

  assert(
    playerUnit,
    'Player side has empty unit slot: ' ..
    map.squads.player.slot
  )

  assert(
    enemyUnit,
    'Enemy side has empty unit slot: ' ..
    map.squads.enemy.slot
  )

local modelIds =
  self:getBattleModelIds(
    playerUnit,
    enemyUnit
  )

self:prepareBattleResources(
  modelIds
)

  self.pendingBattle = {
    map = map,
    playerUnitDefinition =
      playerUnit,
    enemyUnitDefinition =
      enemyUnit
  }

self.loadingQueue =
  self.modelRegistry:
    createPreloadQueue(
      modelIds
    )

  self.state = 'loading'
  self.paused = false
  self.accumulator = 0
  self.selectedSquad = nil

  if self.loadingQueue.finished then
    self:finishBattleLoading()
  end
end


-- Создаёт загруженное сражение.
function Game:finishBattleLoading()
  local options = self.pendingBattle

self.field =
    Field.new(
      options.map.field,
      options.map.decors,
      self.modelRegistry,
      Config.lighting
    )
	
  self.battle = Battle.new(
    Config,
    self.modelRegistry,
    self.field,
    options
  )

  self.camera:reset()

  self.loadingQueue = nil
  self.pendingBattle = nil
  self.accumulator = 0
  self.state = 'playing'
end


-- Обновляет загрузку моделей.
function Game:updateLoading()
  local finished =
    self.modelRegistry:
      updatePreloadQueue(
        self.loadingQueue,
        2
      )

  if finished then
    self:finishBattleLoading()
  end
end


-- Обновляет приложение.
function Game:update(dt)
  self.ui:updateWindowSize()

  if self.state == 'menu' then
    self.screens:update(dt)
    return
  end

  if self.state == 'loading' then
    self:updateLoading()
    return
  end

  dt = math.min(
    dt,
    Config.maximumFrameDelta
  )

  self.camera:update(dt)

  if self.paused then
    return
  end

  self.accumulator =
    self.accumulator + dt

  while
    self.accumulator >=
    Config.simulationStep
  do
    self.battle:update(
      Config.simulationStep
    )

    self.accumulator =
      self.accumulator -
      Config.simulationStep
  end
end


-- Строит луч камеры через экран.
function Game:getScreenRay(x, y)
  local width, height =
    lovr.system.getWindowDimensions()

  local normalizedX =
    x / width * 2 - 1

  local normalizedY =
    1 - y / height * 2

  local aspect = width / height
  local tangent =
    math.tan(math.rad(67) / 2)

  local yaw = self.camera.yaw
  local pitch = self.camera.pitch

  local sineYaw = math.sin(yaw)
  local cosineYaw = math.cos(yaw)
  local sinePitch = math.sin(pitch)
  local cosinePitch = math.cos(pitch)

  local forwardX =
    -sineYaw * cosinePitch

  local forwardY = sinePitch

  local forwardZ =
    -cosineYaw * cosinePitch

  local rightX = cosineYaw
  local rightZ = -sineYaw

  local upX =
    sineYaw * sinePitch

  local upY = cosinePitch

  local upZ =
    cosineYaw * sinePitch

  local rayX =
    forwardX +
    rightX *
    normalizedX *
    tangent *
    aspect +
    upX *
    normalizedY *
    tangent

  local rayY =
    forwardY +
    upY *
    normalizedY *
    tangent

  local rayZ =
    forwardZ +
    rightZ *
    normalizedX *
    tangent *
    aspect +
    upZ *
    normalizedY *
    tangent

  local length = math.sqrt(
    rayX * rayX +
    rayY * rayY +
    rayZ * rayZ
  )

  return
    self.camera.x,
    self.camera.y,
    self.camera.z,
    rayX / length,
    rayY / length,
    rayZ / length
end


-- Возвращает точку на земле.
function Game:getGroundPoint(x, y)
  local originX,
    originY,
    originZ,
    directionX,
    directionY,
    directionZ =
    self:getScreenRay(x, y)

  if directionY >= -.0001 then
    return nil
  end

  local distance =
    (
      self.field.config.floorY -
      originY
    ) / directionY

  if distance < 0 then
    return nil
  end

  return
    originX +
    directionX * distance,

    originZ +
    directionZ * distance
end


-- Выбирает отряд или назначает
-- выбранному отряду новый маршрут.
function Game:selectSquadAt(
  worldX,
  worldZ
)
  if
    self.selectedSquad
    and not self.selectedSquad:
      isDefeated()
  then
    local routes =
      self.battle.map.routes.player
      or {}

    for _, route in ipairs(routes) do
      local dx =
        route.endpoint.x - worldX

      local dz =
        route.endpoint.z - worldZ

      if dx * dx + dz * dz <= 9 then
        self.selectedSquad:assignRoute(
          route,
          true
        )

        return
      end
    end
  end

  local nearest = nil
  local nearestDistanceSquared =
    2.5 * 2.5

  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'allies'
      and not squad:isDefeated()
    then
      for _, unit in ipairs(
        squad.units
      ) do
        if unit:isTargetable() then
          local dx =
            unit.x - worldX

          local dz =
            unit.z - worldZ

          local distanceSquared =
            dx * dx + dz * dz

          if
            distanceSquared <=
            nearestDistanceSquared
          then
            nearest = squad

            nearestDistanceSquared =
              distanceSquared
          end
        end
      end
    end
  end

  self.selectedSquad = nearest
end

-- Возвращает центр отряда.
function Game:getSquadCenter(squad)
  local x = 0
  local z = 0
  local count = 0

  for _, unit in ipairs(
    squad.units
  ) do
    if not unit.removed then
      x = x + unit.x
      z = z + unit.z
      count = count + 1
    end
  end

  if count == 0 then
    return squad.startX, squad.startZ
  end

  return x / count, z / count
end


-- Выбирает следующий союзный отряд.
function Game:selectNextSquad()
  local allies = {}

  for _, squad in ipairs(
    self.battle.squads
  ) do
    if
      squad.team == 'allies'
      and not squad:isDefeated()
    then
      allies[#allies + 1] =
        squad
    end
  end

  if #allies == 0 then
    self.selectedSquad = nil
    return
  end

  if not self.selectedSquad then
    self.selectedSquad = allies[1]
    return
  end

  for index, squad in ipairs(allies) do
    if squad == self.selectedSquad then
      self.selectedSquad =
        allies[index % #allies + 1]

      return
    end
  end

  self.selectedSquad = allies[1]
end


-- Обрабатывает клавиатуру.
function Game:keypressed(key, isRepeat)
  if isRepeat then
    return
  end

  if self.state == 'menu' then
    self.screens:dispatch(
      'keypressed',
      key
    )

    return
  end

  if self.state == 'loading' then
    if key == 'escape' then
      self:showMenu()
    end

    return
  end

  if key == 'escape' then
    self:showMenu()
  elseif key == 'space' then
    self.paused = not self.paused
  elseif key == 'tab' then
    self:selectNextSquad()
  elseif key == 'p' then
  self.battle:fireDebugProjectile(
    'fireball'
  )
elseif key == 'o' then
  self.battle:fireDebugProjectile(
    'arrow'
  )
elseif key == 'b' then
  self.battle:fireDebugProjectile(
    'bullet'
  )
  elseif
    key == 'return'
    and self.battle.winner
  then
    self:startConfiguredBattle()
  end
end


-- Обрабатывает нажатие мыши.
function Game:mousepressed(x, y, button)
  if self.state == 'menu' then
    local virtualX, virtualY =
      self.ui:toVirtual(x, y)

    self.screens:dispatch(
      'mousepressed',
      virtualX,
      virtualY,
      button
    )

    return
  end

  if self.state ~= 'playing' then
    return
  end

  if button == 2 then
    self.camera:beginRotation()
    return
  end

  if button == 1 then
    local worldX, worldZ =
      self:getGroundPoint(x, y)

    if worldX then
      self:selectSquadAt(
        worldX,
        worldZ
      )
    end
  end
end


-- Обрабатывает отпускание мыши.
function Game:mousereleased(x, y, button)
  if self.state == 'menu' then
    local virtualX, virtualY =
      self.ui:toVirtual(x, y)

    self.screens:dispatch(
      'mousereleased',
      virtualX,
      virtualY,
      button
    )

    return
  end

  if button == 2 then
    self.camera:endRotation()
  end
end


-- Обрабатывает движение мыши.
function Game:mousemoved(x, y, dx, dy)
  if self.state == 'menu' then
    local virtualX, virtualY =
      self.ui:toVirtual(x, y)

    self.screens:dispatch(
      'mousemoved',
      virtualX,
      virtualY
    )

    return
  end

  if self.state == 'playing' then
    self.camera:mousemoved(dx, dy)
  end
end


-- Обрабатывает изменение фокуса.
function Game:focus(focused)
  if not focused then
    self.camera:endRotation()
  end
end


-- Рисует загрузку.
function Game:drawLoading(pass)
  self.ui:begin(pass)

  self.theme:drawBackground(
    pass,
    self.ui
  )

  local progress =
    self.modelRegistry:
      getPreloadProgress(
        self.loadingQueue
      )

  self.ui:drawText(
    pass,
    'LOADING ' ..
    math.floor(progress * 100) ..
    '%',

    0,
    300,
    self.ui.virtualWidth,
    80,
    36,
    self.theme:getColor('text'),
    -3.8
  )
end


-- Рисует выделение и доступные маршруты.
function Game:drawSelection(pass)
  local squad = self.selectedSquad

  if not squad or squad:isDefeated() then
    return
  end

  local routes =
    self.battle.map.routes.player
    or {}

  for _, route in ipairs(routes) do
    local selected =
      squad.currentRoute == route

    if selected then
      pass:setColor(.2, 1, .35, .8)
    else
      pass:setColor(1, .75, .15, .8)
    end

    pass:box(
      route.endpoint.x,
      .08,
      route.endpoint.z,
      3,
      .16,
      3
    )

    pass:text(
      route.name or route.id,
      route.endpoint.x,
      1,
      route.endpoint.z,
      .25,
      self.camera.yaw,
      0, 1, 0
    )
  end

  local x, z =
    self:getSquadCenter(squad)

  pass:setColor(.2, .65, 1, .3)

  pass:box(
    x,
    .025,
    z,
    4,
    .05,
    4
  )
end


-- Рисует результат боя.
function Game:drawResult(pass)
  if not self.battle.winner then
    return
  end

  local text =
    self.battle.winner == 'allies'
    and 'VICTORY'
    or 'DEFEAT'

  pass:setColor(1, .8, .25)

  pass:text(
    text,
    0, 8, 0,
    .85,
    self.camera.yaw,
    0, 1, 0
  )
end


-- Рисует приложение.
function Game:draw(pass)
  self.ui:updateWindowSize()

  if self.state == 'menu' then
    self.screens:draw(pass)
    return
  end

  if self.state == 'loading' then
    self:drawLoading(pass)
    return
  end

  self.camera:apply(pass)
  pass:setCullMode('none')

  self.field:draw(pass)
  self:drawSelection(pass)
self.battle:draw(
  pass,
  self.camera
)
  self:drawResult(pass)

  if self.paused then
    pass:setColor(1, .9, .3)

    pass:text(
      'PAUSED',
      0, 10, 0,
      .7,
      self.camera.yaw,
      0, 1, 0
    )
  end

  pass:setColor(1, 1, 1, 1)
end


return Game