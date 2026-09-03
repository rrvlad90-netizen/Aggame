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

local BuildingCatalog =
  require(
    'src.buildings.building_catalog'
  )

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
  local self =
    setmetatable({}, Game)

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
  self.selectedBuilding = nil

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


-- Снимает выделение объектов боя.
function Game:clearSelection()
  self.selectedSquad = nil
  self.selectedBuilding = nil
end


-- Показывает главное меню.
function Game:showMenu()
  self.state = 'menu'
  self.paused = false

  self:clearSelection()
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


-- Добавляет уникальную модель в список.
function Game:addBattleModelId(
  ids,
  known,
  modelId
)
  if
    not modelId
    or known[modelId]
  then
    return
  end

  known[modelId] = true

  ids[#ids + 1] =
    modelId
end


-- Добавляет модели доступных войск здания.
function Game:addRecruitModelIds(
  ids,
  known,
  sideId,
  buildingDefinition
)
  local options =
    buildingDefinition
      .recruitOptions
    or {}

  for _, option in ipairs(options) do
    local unit =
      self.sideRegistry:resolveUnit(
        sideId,
        option.slot
      )

    if unit then
      self:addBattleModelId(
        ids,
        known,
        unit.model
      )
    end
  end
end


-- Собирает уникальные модели боя.
function Game:getBattleModelIds(
  playerUnit,
  enemyUnit,
  map,
  playerSide,
  enemySide
)
  local ids = {}
  local known = {}

  self:addBattleModelId(
    ids,
    known,
    playerUnit.model
  )

  self:addBattleModelId(
    ids,
    known,
    enemyUnit.model
  )

  for _, building in ipairs(
    map.buildings or {}
  ) do
    local sideId =
      building.side == 'player'
      and playerSide
      or enemySide

    self:addBattleModelId(
      ids,
      known,

      BuildingCatalog.getModel(
        sideId,
        building.type
      )
    )

    self:addRecruitModelIds(
      ids,
      known,
      sideId,

      BuildingCatalog.get(
        building.type
      )
    )
  end

  return ids
end


-- Подготавливает ресурсы нового боя.
function Game:prepareBattleResources(
  modelIds
)
  self:clearSelection()

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
      enemyUnit,
      map,
      battleSettings.playerSide,
      battleSettings.enemySide
    )

  self:prepareBattleResources(
    modelIds
  )

  self.pendingBattle = {
    map = map,

    playerUnitDefinition =
      playerUnit,

    enemyUnitDefinition =
      enemyUnit,

    playerSide =
      battleSettings.playerSide,

    enemySide =
      battleSettings.enemySide,

    sideRegistry =
      self.sideRegistry
  }

  self.loadingQueue =
    self.modelRegistry:
      createPreloadQueue(
        modelIds
      )

  self.state = 'loading'
  self.paused = false
  self.accumulator = 0

  self:clearSelection()

  if self.loadingQueue.finished then
    self:finishBattleLoading()
  end
end


-- Создаёт загруженное сражение.
function Game:finishBattleLoading()
  local options =
    self.pendingBattle

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

  -- После уничтожения алтаря полностью
  -- останавливает симуляцию и сценарий.
  if
    self.battle
    and self.battle.winner
  then
    self.accumulator = 0
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

    if self.battle.winner then
      self.accumulator = 0
      break
    end
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
    math.tan(
      math.rad(67) / 2
    )

  local yaw = self.camera.yaw
  local pitch = self.camera.pitch

  local sineYaw = math.sin(yaw)
  local cosineYaw = math.cos(yaw)

  local sinePitch =
    math.sin(pitch)

  local cosinePitch =
    math.cos(pitch)

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

  local length =
    math.sqrt(
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

-- Назначает выбранному отряду маршрут.
function Game:tryAssignSelectedRoute(
  worldX,
  worldZ
)
  local squad = self.selectedSquad

  if
    not squad
    or squad:isDefeated()
  then
    return false
  end

  local routes =
    self.battle.map.routes.player
    or {}

  for _, route in ipairs(routes) do
    local dx =
      route.endpoint.x - worldX

    local dz =
      route.endpoint.z - worldZ

    if dx * dx + dz * dz <= 9 then
      squad:assignRoute(
        route,
        true
      )

      return true
    end
  end

  return false
end


-- Ищет союзный отряд под точкой.
function Game:findSquadAt(
  worldX,
  worldZ
)
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

  return nearest
end


-- Обрабатывает выбор объекта мира.
function Game:selectWorldAt(
  worldX,
  worldZ
)
  if self:tryAssignSelectedRoute(
    worldX,
    worldZ
  ) then
    return
  end

  local buildingSystem =
    self.battle.buildingSystem

  if buildingSystem then
    local building =
      buildingSystem:findAt(
        worldX,
        worldZ
      )

    if building then
      self.selectedSquad = nil

      if building.team == 'allies' then
        self.selectedBuilding =
          building

        if building:isPlatform() then
          buildingSystem:
            startPlayerConstruction(
              building
            )
        end
      else
        self.selectedBuilding = nil
      end

      return
    end
  end

  local squad =
    self:findSquadAt(
      worldX,
      worldZ
    )

  if squad then
    self.selectedBuilding = nil
    self.selectedSquad = squad
    return
  end

  self:clearSelection()
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
    return
      squad.startX,
      squad.startZ
  end

  return
    x / count,
    z / count
end


-- Выбирает следующий союзный отряд.
function Game:selectNextSquad()
  local allies = {}

  self.selectedBuilding = nil

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

  for index, squad in ipairs(
    allies
  ) do
    if squad == self.selectedSquad then
      self.selectedSquad =
        allies[
          index % #allies + 1
        ]

      return
    end
  end

  self.selectedSquad = allies[1]
end


-- Возвращает границы кнопки найма.
function Game:getRecruitButtonBounds(
  index
)
  return
    30 + (index - 1) * 78,
    628,
    64,
    64
end


-- Проверяет попадание в прямоугольник.
function Game:isPointInside(
  x,
  y,
  left,
  top,
  width,
  height
)
  return
    x >= left
    and x <= left + width
    and y >= top
    and y <= top + height
end


-- Обрабатывает нажатие панели найма.
function Game:handleRecruitmentClick(
  x,
  y
)
  local building =
    self.selectedBuilding

  if
    not building
    or not building:isReady()
  then
    return false
  end

  local options =
    building.definition
      .recruitOptions
    or {}

  for index = 1, #options do
    local left,
      top,
      width,
      height =
      self:getRecruitButtonBounds(
        index
      )

    if self:isPointInside(
      x,
      y,
      left,
      top,
      width,
      height
    ) then
      self.battle.buildingSystem:
        recruitPlayerSquad(
          building,
          index
        )

      return true
    end
  end

  return false
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
    self.paused =
      not self.paused

  elseif key == 'tab' then
    self:selectNextSquad()

  elseif key == 'p' then
    self.battle:
      fireDebugProjectile(
        'fireball'
      )

  elseif key == 'o' then
    self.battle:
      fireDebugProjectile(
        'arrow'
      )

  elseif key == 'b' then
    self.battle:
      fireDebugProjectile(
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
function Game:mousepressed(
  x,
  y,
  button
)
  if self.state == 'menu' then
    local virtualX,
      virtualY =
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

  if button ~= 1 then
    return
  end

  local virtualX,
    virtualY =
    self.ui:toVirtual(x, y)

  if self:handleRecruitmentClick(
    virtualX,
    virtualY
  ) then
    return
  end

  local worldX,
    worldZ =
    self:getGroundPoint(x, y)

  if worldX then
    self:selectWorldAt(
      worldX,
      worldZ
    )
  else
    self:clearSelection()
  end
end


-- Обрабатывает отпускание мыши.
function Game:mousereleased(
  x,
  y,
  button
)
  if self.state == 'menu' then
    local virtualX,
      virtualY =
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
function Game:mousemoved(
  x,
  y,
  dx,
  dy
)
  if self.state == 'menu' then
    local virtualX,
      virtualY =
      self.ui:toVirtual(x, y)

    self.screens:dispatch(
      'mousemoved',
      virtualX,
      virtualY
    )

    return
  end

  if self.state == 'playing' then
    self.camera:mousemoved(
      dx,
      dy
    )
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
    math.floor(
      progress * 100
    ) ..
    '%',

    0,
    300,
    self.ui.virtualWidth,
    80,
    36,

    self.theme:getColor(
      'text'
    ),

    -3.8
  )
end


-- Рисует выделение и доступные маршруты.
function Game:drawSelection(pass)
  local squad =
    self.selectedSquad

  if
    not squad
    or squad:isDefeated()
  then
    return
  end

  local routes =
    self.battle.map.routes.player
    or {}

  for _, route in ipairs(routes) do
    local selected =
      squad.currentRoute == route

    if selected then
      pass:setColor(
        .2,
        1,
        .35,
        .8
      )
    else
      pass:setColor(
        1,
        .75,
        .15,
        .8
      )
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
      0,
      1,
      0
    )
  end

  local x, z =
    self:getSquadCenter(
      squad
    )

  pass:setColor(
    .2,
    .65,
    1,
    .3
  )

  pass:box(
    x,
    .025,
    z,
    4,
    .05,
    4
  )
end


-- Рисует текущее количество золота.
function Game:drawGold(pass)
  if not self.battle.economy then
    return
  end

  self.theme:drawPanel(
    pass,
    self.ui,
    20,
    20,
    200,
    58,
    1
  )

  self.ui:drawText(
    pass,

    'GOLD ' ..
    self.battle.economy:
      getGold(),

    30,
    25,
    180,
    48,
    26,

    self.theme:getColor(
      'text'
    ),

    -3.8
  )
end


-- Рисует панель найма.
function Game:drawRecruitmentPanel(
  pass
)
  local building =
    self.selectedBuilding

  if
    not building
    or not building:isReady()
  then
    return
  end

  local options =
    building.definition
      .recruitOptions
    or {}

  if #options == 0 then
    return
  end

  self.theme:drawPanel(
    pass,
    self.ui,
    20,
    618,
    #options * 78 + 20,
    84,
    1
  )

  for index, option in ipairs(
    options
  ) do
    local x,
      y,
      width,
      height =
      self:getRecruitButtonBounds(
        index
      )

    local affordable =
      self.battle.economy:
        canAfford(option.cost)

    local state =
      affordable
      and 'normal'
      or 'disabled'

    self.theme:
      drawButtonBackground(
        pass,
        self.ui,
        state,
        x,
        y,
        width,
        height
      )

    self.ui:drawText(
      pass,
      option.mockup or index,
      x,
      y,
      width,
      height,
      32,

      affordable
      and self.theme:
        getColor('text')
      or self.theme:
        getColor('mutedText'),

      -3.8
    )
  end
end


-- Рисует результат боя на экране.
function Game:drawResult(pass)
  if not self.battle.winner then
    return
  end

  local text =
    self.battle.winner ==
      'allies'
    and 'VICTORY'
    or 'DEFEAT'

  self.theme:drawPanel(
    pass,
    self.ui,
    440,
    270,
    400,
    150,
    1
  )

  self.ui:drawText(
    pass,
    text,
    440,
    285,
    400,
    80,
    44,

    self.battle.winner ==
      'allies'
    and {
      .95,
      .82,
      .25,
      1
    }
    or {
      1,
      .35,
      .25,
      1
    },

    -3.8
  )

  self.ui:drawText(
    pass,
    'PRESS ENTER',
    440,
    360,
    400,
    36,
    20,

    self.theme:getColor(
      'mutedText'
    ),

    -3.8
  )
end


-- Рисует интерфейс боя перед камерой.
function Game:drawBattleHud(pass)
  -- Возвращает экранную камеру, чтобы HUD
  -- не оставался в центре игровой карты.
  pass:setViewPose(
    1,
    lovr.math.newMat4()
  )

  self.ui:begin(pass)

  self:drawGold(pass)
  self:drawRecruitmentPanel(pass)
  self:drawResult(pass)

  pass:setColor(1, 1, 1, 1)
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

  self.battle:draw(
    pass,
    self.camera
  )

  self:drawSelection(pass)

  if self.paused then
    pass:setColor(
      1,
      .9,
      .3
    )

    pass:text(
      'PAUSED',
      0,
      10,
      0,
      .7,
      self.camera.yaw,
      0,
      1,
      0
    )
  end

  pass:setColor(1, 1, 1, 1)

  self:drawBattleHud(pass)
end


return Game