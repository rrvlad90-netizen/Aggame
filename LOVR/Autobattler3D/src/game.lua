local Campaign =
  require('campaigns.main')

local SceneRegistry =
  require('src.scenes.scene_registry')

local SceneScreen =
  require('src.screens.scene_screen')

local Config =
  require('src.autobattle.config')

local Camera =
  require('src.autobattle.camera')

local Field =
  require('src.autobattle.field')

local Battle =
  require('src.autobattle.battle')

local SelectionController =
  require(
    'src.autobattle.selection_controller'
  )

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

local BattleInterface =
  require(
    'src.ui.battle_interface'
  )

local ScreenManager =
  require('src.ui.screen_manager')

local MenuScreen =
  require('src.screens.menu_screen')

local SoundPlayer =
  require('src.audio.sound_player')

local CampaignRegistry =
  require(
    'src.campaign.campaign_registry'
  )

local CampaignSession =
  require(
    'src.campaign.campaign_session'
  )

local CampaignScreen =
  require(
    'src.screens.campaign_screen'
  )

local CampaignAdvisorScreen =
  require(
    'src.screens.campaign_advisor_screen'
  )

local CampaignSelectScreen =
  require(
    'src.screens.campaign_select_screen'
  )


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

  self.battleInterface =
    BattleInterface.new(self)

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

  self.campaignRegistry =
    CampaignRegistry.new()

  self.campaignSession = nil
  self.campaignBattlePayload = nil

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
  self.selectedSquads = {}
  self.selectedEnemySquad = nil
  self.selectedBuilding = nil

  self.selectionController =
    SelectionController.new(
      self,
      Config.selection
    )

  self.sceneRegistry =
    SceneRegistry.new()

  self.campaignActive = false
  self.campaignIndex = nil

  lovr.graphics.setBackgroundColor(
    .035,
    .055,
    .045
  )

  lovr.system.setMouseMode('normal')

  self.moveMarkers = {}

  self.music = nil
  self.musicPausedByFocus = false

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


-- Останавливает музыку уровня.
function Game:stopMusic()
  if self.music then
    pcall(
      self.music.stop,
      self.music
    )
  end

  self.music = nil
  self.musicPausedByFocus = false
end


-- Запускает музыку карты.
function Game:startMapMusic(map)
  self:stopMusic()

  local settings =
    map and map.music

  if
    not settings
    or not settings.path
    or settings.path == ''
  then
    return false
  end

  if lovr.filesystem.isFile then
    local success, exists =
      pcall(
        lovr.filesystem.isFile,
        settings.path
      )

    if success and not exists then
      print(
        '[music] file not found: ' ..
        settings.path
      )

      return false
    end
  end

  local success, source =
    pcall(
      function()
        return lovr.audio.newSource(
          settings.path,
          {
            decode = false,
            spatial = false,
            pitchable = false
          }
        )
      end
    )

  if
    not success
    or not source
  then
    print(
      '[music] failed to load: ' ..
      settings.path
    )

    return false
  end

  success =
    pcall(
      function()
        source:setVolume(
          settings.volume or .35
        )

        source:setLooping(
          settings.loop ~= false
        )

        source:play()
      end
    )

  if not success then
    print(
      '[music] failed to play: ' ..
      settings.path
    )

    return false
  end

  self.music = source
  self.musicPausedByFocus = false

  return true
end


-- Сохраняет настройки.
function Game:saveSettings()
  Settings.save(self.settings)
end


-- Снимает выделение объектов боя.
function Game:clearSelection()
  self.selectedSquad = nil
  self.selectedSquads = {}
  self.selectedEnemySquad = nil
  self.selectedBuilding = nil

  if self.selectionController then
    self.selectionController:cancel()
  end
end


-- Проверяет выделение союзного отряда.
function Game:isSquadSelected(squad)
  for _, selected in ipairs(
    self.selectedSquads
  ) do
    if selected == squad then
      return true
    end
  end

  return false
end


-- Изменяет выделение союзного отряда.
function Game:setSquadSelected(
  squad,
  additive
)
  if
    not squad
    or squad.team ~= 'allies'
    or squad:isDefeated()
  then
    return false
  end

  self.selectedBuilding = nil
  self.selectedEnemySquad = nil

  if not additive then
    self.selectedSquads = {
      squad
    }

    self.selectedSquad = squad
    return true
  end

  for index, selected in ipairs(
    self.selectedSquads
  ) do
    if selected == squad then
      table.remove(
        self.selectedSquads,
        index
      )

      self.selectedSquad =
        self.selectedSquads[
          #self.selectedSquads
        ]

      return true
    end
  end

  self.selectedSquads[
    #self.selectedSquads + 1
  ] = squad

  self.selectedSquad = squad

  return true
end


-- Выбирает вражеский отряд.
function Game:selectEnemySquad(squad)
  self.selectedSquad = nil
  self.selectedSquads = {}
  self.selectedBuilding = nil

  self.selectedEnemySquad = squad
end


-- Выбирает здание.
function Game:selectBuilding(building)
  self.selectedSquad = nil
  self.selectedSquads = {}
  self.selectedEnemySquad = nil

  self.selectedBuilding = building
end


-- Показывает главное меню.
function Game:showMenu()
  self:stopMusic()

  self.campaignActive = false
  self.campaignIndex = nil

  self.campaignSession = nil
  self.campaignBattlePayload = nil

  self.state = 'menu'
  self.paused = false

  self:clearSelection()

  self.battleInterface:
    releaseControls()

  self.camera:endRotation()

  self.screens:replace(
    MenuScreen.new(self)
  )
end

-- Показывает список кампаний.
function Game:showCampaignSelection()
  self.screens:push(
    CampaignSelectScreen.new(self)
  )
end


-- Запускает новую или сохранённую кампанию.
function Game:startCampaign(
  campaignId,
  loadSave
)
  self:stopMusic()

  local definition

  if campaignId then
    definition =
      self.campaignRegistry:get(
        campaignId
      )
  else
    definition =
      self.campaignRegistry:
        getDefault()
  end

  self.campaignSession =
    CampaignSession.new({
      definition = definition,

      sideRegistry =
        self.sideRegistry,

      mapRegistry =
        self.mapRegistry,

      loadSave =
        loadSave == true
    })

  self.campaignActive = true
  self.campaignIndex = nil
  self.campaignBattlePayload = nil

  self.state = 'campaign'
  self.paused = false
  self.accumulator = 0

  self.battle = nil
  self.field = nil
  self.loadingQueue = nil
  self.pendingBattle = nil

  self:clearSelection()

  self.screens:replace(
    CampaignScreen.new(self)
  )
end


-- Показывает следующее событие кампании.
function Game:handleCampaignTurnResult(
  result
)
  if not result then
    return
  end

  if
    result.status == 'idle'
    or result.status ==
      'turn_complete'
  then
    local screen =
      self.screens:top()

    if
      screen
      and screen.refreshButtons
    then
      screen:refreshButtons()
    end

    return
  end

  self.screens:push(
    CampaignAdvisorScreen.new(
      self,
      result
    )
  )
end


-- Запускает ручной бой кампании.
function Game:startCampaignManualBattle(
  payload
)
  if
    not payload
    or not payload.options
  then
    return false
  end

  self.campaignBattlePayload =
    payload

  self:startConfiguredBattle(
    payload.options
  )

  return true
end


-- Запускает текущую запись кампании.
function Game:startCampaignEntry()
  local entry =
    Campaign[self.campaignIndex]

  if not entry then
    self:showMenu()
    return
  end

  if entry.scene then
    self:showCampaignScene(
      entry.scene
    )
  else
    self:startCampaignBattle()
  end
end


-- Показывает сюжетную сцену.
function Game:showCampaignScene(sceneId)
  local definition =
    self.sceneRegistry:get(
      sceneId
    )

  self:stopMusic()

  self.state = 'scene'
  self.paused = false

  self.screens:replace(
    SceneScreen.new(
      self,
      definition,

      function()
        self:startCampaignBattle()
      end
    )
  )
end


-- Запускает бой кампании.
function Game:startCampaignBattle()
  local entry =
    assert(
      Campaign[self.campaignIndex],
      'Campaign entry not found'
    )

  self:startConfiguredBattle(entry)
end


-- Возвращается из ручного боя
-- на глобальную карту.
function Game:finishCampaignBattle()
  if
    not self.campaignSession
    or not self.campaignBattlePayload
    or not self.battle
    or not self.battle.winner
  then
    return
  end

  local outcome =
    self.campaignSession:
      finishManualBattle(
        self.battle
      )

  self:stopMusic()
  self:clearSelection()

  self.battleInterface:
    releaseControls()

  self.camera:endRotation()

  self.battle = nil
  self.field = nil
  self.loadingQueue = nil
  self.pendingBattle = nil

  self.campaignBattlePayload = nil

  self.state = 'campaign'
  self.paused = false
  self.accumulator = 0

  self.screens:replace(
    CampaignScreen.new(self)
  )

  if outcome then
    self:handleCampaignTurnResult(
      outcome.turn
    )
  end
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


-- Показывает настройки.
function Game:showSettings()
  local SettingsScreen =
    require(
      'src.screens.settings_screen'
    )

  self.screens:push(
    SettingsScreen.new(self)
  )
end


-- Добавляет уникальную модель.
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
  ids[#ids + 1] = modelId
end


-- Добавляет модели войск здания.
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

  local function addGroupModels(
    groups,
    sideId
  )
    for _, group in ipairs(
      groups or {}
    ) do
      if group.slot then
        local unit =
          self.sideRegistry:
            resolveUnit(
              sideId,
              group.slot
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
  end

  addGroupModels(
    map.squads.player.groups,
    playerSide
  )

  addGroupModels(
    map.squads.enemy.groups,
    enemySide
  )

  local monsters =
    map.squads.monsters

  if monsters then
    local monsterSide =
      monsters.side
      or 'monsters'

    for _, group in ipairs(
      monsters.groups or {}
    ) do
      local unit =
        self.sideRegistry:
          resolveUnit(
            monsterSide,
            group.slot
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

  local function addBuildingSide(
    sideId,
    building
  )
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

  for _, building in ipairs(
    map.buildings or {}
  ) do
    if building.side == 'player' then
      addBuildingSide(
        playerSide,
        building
      )

    elseif building.side == 'enemy' then
      addBuildingSide(
        enemySide,
        building
      )

    else
      addBuildingSide(
        playerSide,
        building
      )

      addBuildingSide(
        enemySide,
        building
      )
    end
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
function Game:startConfiguredBattle(
  battleOptions
)
  battleOptions =
    battleOptions or {}

  local battleSettings =
    self.settings.battle

  local requestedMap =
    battleOptions.map
    or battleSettings.map

  local map

  if type(requestedMap) == 'table' then
    map = requestedMap
  else
    map =
      self.mapRegistry:get(
        requestedMap
      )
  end

  local playerSide =
    battleOptions.playerSide
    or battleSettings.playerSide

  local enemySide =
    battleOptions.enemySide
    or battleSettings.enemySide

  local monsterSide =
    battleOptions.monsterSide
    or (
      map.squads.monsters
      and map.squads.monsters.side
    )
    or 'monsters'

  local playerUnit =
    self.sideRegistry:resolveUnit(
      playerSide,
      map.squads.player.slot
    )

  local enemyUnit =
    self.sideRegistry:resolveUnit(
      enemySide,
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
      playerSide,
      enemySide
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

    playerSide = playerSide,
    enemySide = enemySide,
    monsterSide = monsterSide,

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

  self:startMapMusic(
    options.map
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
  self:updateMoveMarkers(dt)

  if
    self.state == 'menu'
    or self.state == 'scene'
    or self.state == 'campaign'
  then
    self.screens:update(dt)
    return
  end

  if self.state == 'loading' then
    self:updateLoading()
    return
  end

  dt =
    math.min(
      dt,
      Config.maximumFrameDelta
    )

  self.camera:update(dt)

  local listenerX,
    listenerY,
    listenerZ =
    self.camera:getFocusPoint(
      self.field
    )

  SoundPlayer.setListenerPosition(
    listenerX,
    listenerY,
    listenerZ
  )

  lovr.audio.setPose(
    listenerX,
    listenerY,
    listenerZ,
    self.camera.yaw,
    0,
    1,
    0
  )

  lovr.audio.update(dt)

  if self.paused then
    return
  end

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
      math.rad(67) * .5
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

  return
    self.field:raycastGround(
      originX,
      originY,
      originZ,
      directionX,
      directionY,
      directionZ
    )
end


-- Добавляет отметку приказа.
function Game:addCommandMarker(
  x,
  z,
  kind
)
  self.moveMarkers[
    #self.moveMarkers + 1
  ] = {
    x = x,
    z = z,
    kind = kind or 'move',
    age = 0,
    duration = .5,
    size = 4
  }
end


-- Совместимость со старым вызовом.
function Game:addMoveMarker(x, z)
  self:addCommandMarker(
    x,
    z,
    'move'
  )
end


-- Обновляет отметки приказов.
function Game:updateMoveMarkers(dt)
  for index = #self.moveMarkers,
    1,
    -1
  do
    local marker =
      self.moveMarkers[index]

    marker.age =
      marker.age + dt

    if
      marker.age >=
      marker.duration
    then
      table.remove(
        self.moveMarkers,
        index
      )
    end
  end
end


-- Рисует отметки приказов.
function Game:drawMoveMarkers(pass)
  pass:setShader()
  pass:setMaterial()

  for _, marker in ipairs(
    self.moveMarkers
  ) do
    local remaining =
      math.max(
        0,
        1 -
        marker.age /
        marker.duration
      )

    local smooth =
      remaining *
      remaining *
      (3 - 2 * remaining)

    local size =
      marker.size * smooth

    local thickness =
      math.max(
        .08,
        .42 * smooth
      )

    local y =
      self.field:getHeight(
        marker.x,
        marker.z
      ) + .09

    if marker.kind == 'attack' then
      pass:setColor(
        1,
        .18,
        .1,
        remaining
      )
    else
      pass:setColor(
        .15,
        1,
        .28,
        remaining
      )
    end

    pass:box(
      marker.x,
      y,
      marker.z,
      size,
      .08,
      thickness,
      math.pi * .25,
      0,
      1,
      0
    )

    pass:box(
      marker.x,
      y,
      marker.z,
      thickness,
      .08,
      size,
      math.pi * .25,
      0,
      1,
      0
    )
  end

  pass:setColor(1, 1, 1, 1)
end


-- Возвращает смещение группового приказа.
function Game:getGroupOrderOffset(
  index,
  count
)
  if count <= 1 then
    return 0, 0
  end

  local spacing =
    Config.squad.groupOrderSpacing
    or 8

  local columns =
    math.ceil(
      math.sqrt(count)
    )

  local rows =
    math.ceil(
      count / columns
    )

  local zeroIndex = index - 1

  local column =
    zeroIndex % columns

  local row =
    math.floor(
      zeroIndex / columns
    )

  return
    (
      column -
      (columns - 1) * .5
    ) * spacing,

    (
      row -
      (rows - 1) * .5
    ) * spacing
end


-- Отдаёт приказ движения.
function Game:issueSelectedMoveCommand(
  worldX,
  worldZ
)
  if #self.selectedSquads == 0 then
    return false
  end

  local issued = false
  local count = #self.selectedSquads

  for index, squad in ipairs(
    self.selectedSquads
  ) do
    if
      squad.team == 'allies'
      and not squad:isDefeated()
    then
      local offsetX, offsetZ =
        self:getGroupOrderOffset(
          index,
          count
        )

      local accepted =
        squad:issueMove(
          worldX + offsetX,
          worldZ + offsetZ,
          'player'
        )

      if accepted then
        issued = true
      end
    end
  end

  if issued then
    self:addCommandMarker(
      worldX,
      worldZ,
      'move'
    )
  end

  return issued
end


-- Отдаёт приказ атаки отряда.
function Game:
  issueSelectedAttackSquad(
    target
  )
  if
    not target
    or target:isDefeated()
    or #self.selectedSquads == 0
  then
    return false
  end

  local issued = false

  for _, squad in ipairs(
    self.selectedSquads
  ) do
    local accepted =
      squad:issueAttackSquad(
        target,
        'player'
      )

    if accepted then
      issued = true
    end
  end

  if issued then
    local x, z =
      target:getCenter()

    self:addCommandMarker(
      x,
      z,
      'attack'
    )
  end

  return issued
end


-- Отдаёт приказ атаки здания.
function Game:
  issueSelectedAttackBuilding(
    building
  )
  if
    not building
    or not building:isTargetable()
    or #self.selectedSquads == 0
  then
    return false
  end

  local issued = false

  for _, squad in ipairs(
    self.selectedSquads
  ) do
    local accepted =
      squad:issueAttackBuilding(
        building,
        'player'
      )

    if accepted then
      issued = true
    end
  end

  if issued then
    self:addCommandMarker(
      building.x,
      building.z,
      'attack'
    )
  end

  return issued
end


-- Ищет отряд под мировой точкой.
function Game:findSquadAt(
  worldX,
  worldZ
)
  local nearest = nil

  local nearestDistanceSquared =
    3 * 3

  for _, squad in ipairs(
    self.battle.squads
  ) do
    if not squad:isDefeated() then
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


-- Ищет здание под мировой точкой.
function Game:findBuildingAt(
  worldX,
  worldZ
)
  if not self.battle.buildingSystem then
    return nil
  end

  return
    self.battle.buildingSystem:
      findAt(
        worldX,
        worldZ
      )
end


-- Выполняет контекстный приказ.
function Game:issueContextCommand(
  worldX,
  worldZ
)
  if #self.selectedSquads == 0 then
    return false
  end

  local building =
    self:findBuildingAt(
      worldX,
      worldZ
    )

  if
    building
    and building.team ~= 'allies'
    and building:isTargetable()
  then
    return
      self:
        issueSelectedAttackBuilding(
          building
        )
  end

  local squad =
    self:findSquadAt(
      worldX,
      worldZ
    )

  if
    squad
    and squad.team ~= 'allies'
  then
    return
      self:
        issueSelectedAttackSquad(
          squad
        )
  end

  return
    self:issueSelectedMoveCommand(
      worldX,
      worldZ
    )
end


-- Обрабатывает выбор объекта мира.
function Game:selectWorldAt(
  worldX,
  worldZ
)
  local building =
    self:findBuildingAt(
      worldX,
      worldZ
    )

  if building then
    if building.team == 'allies' then
      self:selectBuilding(
        building
      )
    else
      self:clearSelection()
    end

    return
  end

  local squad =
    self:findSquadAt(
      worldX,
      worldZ
    )

  if squad then
    if squad.team == 'allies' then
      local additive =
        lovr.system.isKeyDown(
          'lshift'
        )
        or lovr.system.isKeyDown(
          'rshift'
        )

      self:setSquadSelected(
        squad,
        additive
      )
    else
      self:selectEnemySquad(
        squad
      )
    end

    return
  end

  self:clearSelection()
end


-- Возвращает центр отряда.
function Game:getSquadCenter(squad)
  return squad:getCenter()
end


-- Выбирает следующий союзный отряд.
function Game:selectNextSquad()
  local allies =
    self.battleInterface:
      getSquads()

  if #allies == 0 then
    self:clearSelection()
    return
  end

  if
    not self.selectedSquad
    or not self:isSquadSelected(
      self.selectedSquad
    )
  then
    self:setSquadSelected(
      allies[1],
      false
    )

    return
  end

  for index, squad in ipairs(
    allies
  ) do
    if squad == self.selectedSquad then
      self:setSquadSelected(
        allies[
          index % #allies + 1
        ],

        false
      )

      return
    end
  end

  self:setSquadSelected(
    allies[1],
    false
  )
end

-- Возвращает границы кнопки найма.
function Game:getRecruitButtonBounds(
  index
)
  return
    180 + (index - 1) * 78,
    558,
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


-- Обрабатывает панель найма.
function Game:handleRecruitmentClick(
  x,
  y
)
  local building =
    self.selectedBuilding

  if
    not building
    or building.team ~= 'allies'
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

    if
      self:isPointInside(
        x,
        y,
        left,
        top,
        width,
        height
      )
    then
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

  if
    self.state == 'menu'
    or self.state == 'scene'
    or self.state == 'campaign'
  then
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

  if
    self.battleInterface:
      keypressed(key)
  then
    return
  end

  if key == 'space' then
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
    and self.battle
    and self.battle.winner
  then
    if self.campaignActive then
      self:finishCampaignBattle()
    else
      self:startConfiguredBattle()
    end
  end
end


-- Обрабатывает нажатие мыши.
function Game:mousepressed(
  x,
  y,
  button
)
  if
    self.state == 'menu'
    or self.state == 'scene'
    or self.state == 'campaign'
  then
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

  local virtualX,
    virtualY =
    self.ui:toVirtual(x, y)

  if
    self.battleInterface:
      mousepressed(
        virtualX,
        virtualY,
        button
      )
  then
    return
  end

  -- ПКМ выбирает движение или атаку.
  if button == 2 then
    local worldX, worldZ =
      self:getGroundPoint(x, y)

    if worldX then
      self:issueContextCommand(
        worldX,
        worldZ
      )
    end

    return
  end

  if button ~= 1 then
    return
  end

  if
    self:handleRecruitmentClick(
      virtualX,
      virtualY
    )
  then
    return
  end

  local worldX, worldZ =
    self:getGroundPoint(x, y)

  if not worldX then
    self:clearSelection()
    return
  end

  -- Сенсорное управление остаётся
  -- без рамочного выделения.
  if
    self.settings.interface
      .touchCameraControls
  then
    local squad =
      self:findSquadAt(
        worldX,
        worldZ
      )

    local building =
      self:findBuildingAt(
        worldX,
        worldZ
      )

    if squad or building then
      self:selectWorldAt(
        worldX,
        worldZ
      )

      return
    end

    if #self.selectedSquads > 0 then
      self:issueContextCommand(
        worldX,
        worldZ
      )

      return
    end

    self:clearSelection()
    return
  end

  -- Обычный клик будет обработан при
  -- отпускании, если рамка не появилась.
  self.selectionController:begin(
    x,
    y
  )
end


-- Обрабатывает отпускание мыши.
function Game:mousereleased(
  x,
  y,
  button
)
  if
    self.state == 'menu'
    or self.state == 'scene'
    or self.state == 'campaign'
  then
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

  local virtualX,
    virtualY =
    self.ui:toVirtual(x, y)

  self.battleInterface:
    mousereleased(
      virtualX,
      virtualY,
      button
    )

  if
    self.state ~= 'playing'
    or button ~= 1
    or self.settings.interface
      .touchCameraControls
  then
    return
  end

  local controller =
    self.selectionController

  -- Нажатие мог перехватить интерфейс.
  if not controller.active then
    return
  end

  local additive =
    lovr.system.isKeyDown(
      'lshift'
    )
    or lovr.system.isKeyDown(
      'rshift'
    )

  local usedRectangle =
    controller:finish(
      x,
      y,
      additive
    )

  if usedRectangle then
    return
  end

  local worldX, worldZ =
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


-- Обрабатывает движение мыши.
function Game:mousemoved(
  x,
  y,
  dx,
  dy
)
  if
    self.state == 'menu'
    or self.state == 'scene'
    or self.state == 'campaign'
  then
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
    self.selectionController:update(
      x,
      y
    )
  end
end

-- Обрабатывает колесо мыши.
function Game:wheelmoved(
  deltaX,
  deltaY
)
  if self.state ~= 'playing' then
    return
  end

  self.camera:zoom(deltaY)
end


-- Обрабатывает изменение фокуса окна.
function Game:focus(focused)
  if not focused then
    self.selectionController:cancel()

    self.battleInterface:
      releaseControls()

    if self.music then
      local success, playing =
        pcall(
          self.music.isPlaying,
          self.music
        )

      if success and playing then
        pcall(
          self.music.pause,
          self.music
        )

        self.musicPausedByFocus =
          true
      end
    end

    return
  end

  pcall(
    lovr.audio.start,
    'playback'
  )

  self:applyAudioSettings()

  if
    self.music
    and self.musicPausedByFocus
  then
    pcall(
      self.music.play,
      self.music
    )
  end

  self.musicPausedByFocus = false

  if lovr.audio.update then
    pcall(
      lovr.audio.update,
      0
    )
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
    or building.team ~= 'allies'
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
    170,
    548,
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


-- Рисует результат боя.
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


-- Рисует интерфейс боя.
function Game:drawBattleHud(pass)
  pass:setViewPose(
    1,
    lovr.math.newMat4()
  )

  self.ui:begin(pass)

  self:drawGold(pass)
  self:drawRecruitmentPanel(pass)

  self.battleInterface:
    drawHud(pass)

  self.selectionController:draw(pass)
  self:drawResult(pass)

  pass:setColor(1, 1, 1, 1)
end


-- Рисует приложение.
function Game:draw(pass)
  self.ui:updateWindowSize()

  if
    self.state == 'menu'
    or self.state == 'scene'
    or self.state == 'campaign'
  then
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
  self:drawMoveMarkers(pass)

  self.battle:draw(
    pass,
    self.camera
  )

  self.battleInterface:
    drawWorldSelection(pass)

  if self.battle.captureSystem then
    self.battle.captureSystem:draw(
      pass,
      self.camera
    )
  end

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