local BattleInterface = {}
BattleInterface.__index =
  BattleInterface

local SQUAD_CARD = {
  x = 20,
  y = 636,
  width = 82,
  height = 64,
  spacing = 6,
  maximum = 14
}

local BUILDING_CARD = {
  x = 240,
  y = 20,
  width = 92,
  height = 62,
  spacing = 6,
  maximum = 10
}

local BUILD_BUTTON = {
  x = 20,
  y = 548,
  width = 140,
  height = 60
}

local EXIT_BUTTON = {
  x = 1190,
  y = 90,
  width = 62,
  height = 46
}

local EXIT_DIALOG = {
  x = 390,
  y = 245,
  width = 500,
  height = 220,

  yes = {
    x = 455,
    y = 375,
    width = 160,
    height = 58
  },

  no = {
    x = 665,
    y = 375,
    width = 160,
    height = 58
  }
}

local CAMERA_BUTTONS = {
  {
    id = 'up',
    text = '^',
    x = 76,
    y = 430
  },

  {
    id = 'left',
    text = '<',
    x = 20,
    y = 486
  },

  {
    id = 'down',
    text = 'v',
    x = 76,
    y = 486
  },

  {
    id = 'right',
    text = '>',
    x = 132,
    y = 486
  },

  {
    id = 'tiltUp',
    text = 'T+',
    x = 198,
    y = 430
  },

  {
    id = 'tiltDown',
    text = 'T-',
    x = 198,
    y = 486
  },

  {
    id = 'zoomIn',
    text = '+',
    x = 1190,
    y = 430
  },

  {
    id = 'zoomOut',
    text = '-',
    x = 1190,
    y = 486
  },
  
  {
  id = 'zoomIn',
  text = 'ZOOM+',
  x = 1175,
  y = 430,
  width = 80
},

{
  id = 'zoomOut',
  text = 'ZOOM-',
  x = 1175,
  y = 486,
  width = 80
}
}


-- Создаёт интерфейс боя.
function BattleInterface.new(app)
  local self =
    setmetatable(
      {},
      BattleInterface
    )

	self.exitDialogOpen = false
	self.exitDialogWasPaused = false

  self.app = app
  self.ui = app.ui
  self.theme = app.theme

  self.pressedCameraControl = nil

  return self
end


-- Открывает подтверждение выхода.
function BattleInterface:openExitDialog()
  if
    self.exitDialogOpen
    or not self.app.battle
    or self.app.battle.winner
  then
    return false
  end

  self.exitDialogOpen = true

  self.exitDialogWasPaused =
    self.app.paused

  self.app.paused = true

  self:releaseCameraControl()

  return true
end


-- Закрывает подтверждение выхода.
function BattleInterface:closeExitDialog()
  if not self.exitDialogOpen then
    return false
  end

  self.exitDialogOpen = false

  self.app.paused =
    self.exitDialogWasPaused

  self.exitDialogWasPaused = false

  return true
end


-- Отпускает активную кнопку камеры.
function BattleInterface:releaseCameraControl()
  self.pressedCameraControl = nil

  self.app.camera:
    clearInterfaceControls()
end


-- Подтверждает выход из боя.
function BattleInterface:confirmExit()
  self.exitDialogOpen = false
  self.exitDialogWasPaused = false

  self.app:showMenu()
end


-- Обрабатывает кнопку ESC.
function BattleInterface:
  handleExitButton(x, y)
  if
    not self.app.settings.interface
      .touchCameraControls
    or not self:isInside(
      x,
      y,
      EXIT_BUTTON
    )
  then
    return false
  end

  self:openExitDialog()

  return true
end


-- Обрабатывает кнопки диалога.
function BattleInterface:
  handleExitDialog(x, y)
  if self:isInside(
    x,
    y,
    EXIT_DIALOG.yes
  ) then
    self:confirmExit()
    return true
  end

  if self:isInside(
    x,
    y,
    EXIT_DIALOG.no
  ) then
    self:closeExitDialog()
    return true
  end

  -- Диалог блокирует нажатия по игре.
  return true
end


-- Обрабатывает Escape с клавиатуры.
function BattleInterface:keypressed(key)
  if self.exitDialogOpen then
    if
      key == 'escape'
      or key == 'n'
    then
      self:closeExitDialog()

    elseif key == 'y' then
      self:confirmExit()
    end

    return true
  end

  if key == 'escape' then
    self:openExitDialog()
    return true
  end

  return false
end

-- Проверяет попадание в прямоугольник.
function BattleInterface:isInside(
  x,
  y,
  bounds
)
  return
    x >= bounds.x
    and x <=
      bounds.x + bounds.width
    and y >= bounds.y
    and y <=
      bounds.y + bounds.height
end


-- Возвращает границы карточки.
function BattleInterface:getCardBounds(
  layout,
  index
)
  return {
    x =
      layout.x +
      (index - 1) *
      (
        layout.width +
        layout.spacing
      ),

    y = layout.y,
    width = layout.width,
    height = layout.height
  }
end


-- Возвращает живые союзные отряды.
function BattleInterface:getSquads()
  local result = {}

  if not self.app.battle then
    return result
  end

  for _, squad in ipairs(
    self.app.battle.squads
  ) do
    if
      squad.team == 'allies'
      and not squad:isDefeated()
    then
      result[#result + 1] =
        squad
    end
  end

  return result
end


-- Возвращает здания игрока.
function BattleInterface:getBuildings()
  local result = {}

  local battle =
    self.app.battle

  local system =
    battle
    and battle.buildingSystem

  if not system then
    return result
  end

  for _, building in ipairs(
    system.buildings
  ) do
    if
      building.team == 'allies'
      and not building.removed
    then
      result[#result + 1] =
        building
    end
  end

  return result
end


-- Возвращает здоровье отряда.
function BattleInterface:getSquadHealth(
  squad
)
  local health = 0
  local maximum = 0
  local living = 0

  for _, unit in ipairs(
    squad.units
  ) do
    if unit:isTargetable() then
      health =
        health + unit.health

      maximum =
        maximum +
        unit.maximumHealth

      living = living + 1
    end
  end

  local ratio = 0

  if maximum > 0 then
    ratio = health / maximum
  end

  return living, ratio
end


-- Выбирает карточку отряда.
function BattleInterface:selectSquadCard(
  squad
)
  local alreadySelected =
    self.app:isSquadSelected(
      squad
    )

  local additive =
    lovr.system.isKeyDown(
      'lshift'
    )
    or lovr.system.isKeyDown(
      'rshift'
    )

  self.app:setSquadSelected(
    squad,
    additive
  )

  if alreadySelected and not additive then
    local x, z =
      self.app:getSquadCenter(
        squad
      )

    self.app.camera:focusOn(
      x,
      z,
      self.app.field
    )
  end
end


-- Выбирает карточку здания.
function BattleInterface:
  selectBuildingCard(building)
  local alreadySelected =
    self.app.selectedBuilding ==
    building

  self.app:selectBuilding(
    building
  )

  if alreadySelected then
    self.app.camera:focusOn(
      building.x,
      building.z,
      self.app.field
    )
  end
end


-- Обрабатывает карточки отрядов.
function BattleInterface:
  handleSquadCards(x, y)
  local squads =
    self:getSquads()

  local count =
    math.min(
      #squads,
      SQUAD_CARD.maximum
    )

  for index = 1, count do
    local bounds =
      self:getCardBounds(
        SQUAD_CARD,
        index
      )

    if self:isInside(
      x,
      y,
      bounds
    ) then
      self:selectSquadCard(
        squads[index]
      )

      return true
    end
  end

  return false
end


-- Обрабатывает карточки зданий.
function BattleInterface:
  handleBuildingCards(x, y)
  local buildings =
    self:getBuildings()

  local count =
    math.min(
      #buildings,
      BUILDING_CARD.maximum
    )

  for index = 1, count do
    local bounds =
      self:getCardBounds(
        BUILDING_CARD,
        index
      )

    if self:isInside(
      x,
      y,
      bounds
    ) then
      self:selectBuildingCard(
        buildings[index]
      )

      return true
    end
  end

  return false
end


-- Проверяет доступность строительства.
function BattleInterface:canBuild()
  local building =
    self.app.selectedBuilding

  if
    not building
    or building.team ~= 'allies'
    or building.state ~= 'platform'
  then
    return false
  end

  local economy =
    self.app.battle.economy

  local cost =
    building.definition.buildCost
    or 0

  return
    economy ~= nil
    and economy:canAfford(cost)
end


-- Обрабатывает кнопку строительства.
function BattleInterface:
  handleBuildButton(x, y)
  local building =
    self.app.selectedBuilding

  if
    not building
    or not building:isPlatform()
    or not self:isInside(
      x,
      y,
      BUILD_BUTTON
    )
  then
    return false
  end

  if self:canBuild() then
    self.app.battle
      .buildingSystem:
      startPlayerConstruction(
        building
      )
  end

  return true
end


-- Возвращает границы кнопки камеры.
function BattleInterface:
  getCameraButtonBounds(button)
  return {
    x = button.x,
    y = button.y,

    width =
      button.width or 52,

    height =
      button.height or 52
  }
end


-- Обрабатывает экранную кнопку камеры.
function BattleInterface:
  handleCameraButton(x, y)
  if
    not self.app.settings.interface
      .touchCameraControls
  then
    return false
  end

  for _, button in ipairs(
    CAMERA_BUTTONS
  ) do
    local bounds =
      self:getCameraButtonBounds(
        button
      )

    if self:isInside(
      x,
      y,
      bounds
    ) then
      if button.id == 'zoomIn' then
        self.app.camera:zoom(1)

      elseif button.id == 'zoomOut' then
        self.app.camera:zoom(-1)

      else
        self.pressedCameraControl =
          button.id

        self.app.camera:
          setInterfaceControl(
            button.id,
            true
          )
      end

      return true
    end
  end

  return false
end


-- Обрабатывает нажатие интерфейса.
function BattleInterface:mousepressed(
  x,
  y,
  button
)
  if button ~= 1 then
    return self.exitDialogOpen
  end

  if self.exitDialogOpen then
    return self:handleExitDialog(
      x,
      y
    )
  end

  if self:handleExitButton(x, y) then
    return true
  end

  if self:handleCameraButton(x, y) then
    return true
  end

  if self:handleBuildButton(x, y) then
    return true
  end

  if self:handleSquadCards(x, y) then
    return true
  end

  if self:handleBuildingCards(x, y) then
    return true
  end

  return false
end

-- Рисует прозрачную кнопку ESC.
function BattleInterface:
  drawExitButton(pass)
  if
    not self.app.settings.interface
      .touchCameraControls
  then
    return
  end

  local color =
    self.theme:getColor('button')

  self.ui:drawRectangle(
    pass,
    EXIT_BUTTON.x,
    EXIT_BUTTON.y,
    EXIT_BUTTON.width,
    EXIT_BUTTON.height,

    {
      color[1],
      color[2],
      color[3],
      .32
    },

    -3.88
  )

  self.ui:drawText(
    pass,
    'ESC',
    EXIT_BUTTON.x,
    EXIT_BUTTON.y,
    EXIT_BUTTON.width,
    EXIT_BUTTON.height,
    18,
    {
      1,
      1,
      1,
      .85
    },
    -3.78
  )
end


-- Рисует подтверждение выхода.
function BattleInterface:
  drawExitDialog(pass)
  if not self.exitDialogOpen then
    return
  end

  self.theme:drawOverlay(
    pass,
    self.ui,
    .75
  )

  self.theme:drawPanel(
    pass,
    self.ui,
    EXIT_DIALOG.x,
    EXIT_DIALOG.y,
    EXIT_DIALOG.width,
    EXIT_DIALOG.height,
    1
  )

  self.ui:drawText(
    pass,
    'EXIT BATTLE?',
    EXIT_DIALOG.x,
    EXIT_DIALOG.y + 28,
    EXIT_DIALOG.width,
    65,
    36,
    self.theme:getColor('text'),
    -3.75
  )

  self.theme:drawButtonBackground(
    pass,
    self.ui,
    'normal',

    EXIT_DIALOG.yes.x,
    EXIT_DIALOG.yes.y,
    EXIT_DIALOG.yes.width,
    EXIT_DIALOG.yes.height
  )

  self.ui:drawText(
    pass,
    'YES',

    EXIT_DIALOG.yes.x,
    EXIT_DIALOG.yes.y,
    EXIT_DIALOG.yes.width,
    EXIT_DIALOG.yes.height,
    24,
    self.theme:getColor('text'),
    -3.75
  )

  self.theme:drawButtonBackground(
    pass,
    self.ui,
    'normal',

    EXIT_DIALOG.no.x,
    EXIT_DIALOG.no.y,
    EXIT_DIALOG.no.width,
    EXIT_DIALOG.no.height
  )

  self.ui:drawText(
    pass,
    'NO',

    EXIT_DIALOG.no.x,
    EXIT_DIALOG.no.y,
    EXIT_DIALOG.no.width,
    EXIT_DIALOG.no.height,
    24,
    self.theme:getColor('text'),
    -3.75
  )
end

-- Обрабатывает отпускание интерфейса.
function BattleInterface:mousereleased(
  x,
  y,
  button
)
  if
    button ~= 1
    or not self.pressedCameraControl
  then
    return false
  end

  self.app.camera:
    setInterfaceControl(
      self.pressedCameraControl,
      false
    )

  self.pressedCameraControl = nil

  return true
end


-- Сбрасывает зажатые кнопки.
function BattleInterface:releaseControls()
  self:releaseCameraControl()
end

-- Рисует полоску здоровья.
function BattleInterface:drawHealthBar(
  pass,
  x,
  y,
  width,
  ratio
)
  ratio =
    math.max(
      0,
      math.min(1, ratio)
    )

  self.ui:drawRectangle(
    pass,
    x,
    y,
    width,
    6,
    {
      .08,
      .08,
      .08,
      .9
    },
    -3.8
  )

  if ratio > 0 then
    self.ui:drawRectangle(
      pass,
      x,
      y,
      width * ratio,
      6,
      {
        .25,
        .8,
        .32,
        1
      },
      -3.79
    )
  end
end


-- Рисует карточки отрядов.
function BattleInterface:
  drawSquadCards(pass)
  local squads =
    self:getSquads()

  local count =
    math.min(
      #squads,
      SQUAD_CARD.maximum
    )

  for index = 1, count do
    local squad =
      squads[index]

    local bounds =
      self:getCardBounds(
        SQUAD_CARD,
        index
      )

    local selected =
      self.app:isSquadSelected(
        squad
      )

    if selected then
      self.ui:drawRectangle(
        pass,
        bounds.x - 3,
        bounds.y - 3,
        bounds.width + 6,
        bounds.height + 6,

        {
          .18,
          .9,
          .3,
          1
        },

        -3.9
      )
    end

    self.theme:
      drawButtonBackground(
        pass,
        self.ui,

        selected
        and 'hover'
        or 'normal',

        bounds.x,
        bounds.y,
        bounds.width,
        bounds.height
      )

    local living, health =
      self:getSquadHealth(
        squad
      )

    local name =
      squad.unitDefinition.name
      or squad.unitDefinition.slot
      or 'SQUAD'

    name =
      string.upper(
        tostring(name)
      )

    if #name > 10 then
      name =
        name:sub(1, 10)
    end

    self.ui:drawText(
      pass,
      name,
      bounds.x + 3,
      bounds.y + 4,
      bounds.width - 6,
      28,
      13,

      self.theme:getColor(
        'text'
      ),

      -3.78
    )

    self.ui:drawText(
      pass,
      tostring(living),
      bounds.x + 3,
      bounds.y + 28,
      bounds.width - 6,
      22,
      18,

      self.theme:getColor(
        'text'
      ),

      -3.78
    )

    self:drawHealthBar(
      pass,
      bounds.x + 6,
      bounds.y +
        bounds.height - 10,
      bounds.width - 12,
      health
    )
  end
end


-- Возвращает состояние здания.
function BattleInterface:
  getBuildingStatus(building)
  if building.state == 'ready' then
    return 'READY'
  end

  if building.state ==
    'constructing'
  then
    return
      math.floor(
        building.buildProgress *
        100
      ) .. '%'
  end

  if building.state == 'cooldown' then
    return 'WAIT'
  end

  return 'BUILD'
end


-- Возвращает здоровье здания.
function BattleInterface:
  getBuildingHealth(building)
  if
    building.maximumHealth <= 0
  then
    return 0
  end

  if building.state == 'ready' then
    return
      building.health /
      building.maximumHealth
  end

  if building.state ==
    'constructing'
  then
    return building.buildProgress
  end

  return 0
end


-- Рисует карточки зданий.
function BattleInterface:
  drawBuildingCards(pass)
  local buildings =
    self:getBuildings()

  local count =
    math.min(
      #buildings,
      BUILDING_CARD.maximum
    )

  for index = 1, count do
    local building =
      buildings[index]

    local bounds =
      self:getCardBounds(
        BUILDING_CARD,
        index
      )

    local selected =
      self.app.selectedBuilding ==
      building

    if selected then
      self.ui:drawRectangle(
        pass,
        bounds.x - 3,
        bounds.y - 3,
        bounds.width + 6,
        bounds.height + 6,

        {
          .2,
          .55,
          1,
          1
        },

        -3.9
      )
    end

    self.theme:
      drawButtonBackground(
        pass,
        self.ui,

        selected
        and 'hover'
        or 'normal',

        bounds.x,
        bounds.y,
        bounds.width,
        bounds.height
      )

    local name =
      string.upper(
        tostring(
          building.buildingType
          or 'BUILDING'
        )
      )

    if #name > 11 then
      name =
        name:sub(1, 11)
    end

    self.ui:drawText(
      pass,
      name,
      bounds.x + 3,
      bounds.y + 3,
      bounds.width - 6,
      26,
      13,

      self.theme:getColor(
        'text'
      ),

      -3.78
    )

    self.ui:drawText(
      pass,
      self:getBuildingStatus(
        building
      ),

      bounds.x + 3,
      bounds.y + 27,
      bounds.width - 6,
      22,
      14,

      self.theme:getColor(
        'mutedText'
      ),

      -3.78
    )

    self:drawHealthBar(
      pass,
      bounds.x + 6,
      bounds.y +
        bounds.height - 9,
      bounds.width - 12,

      self:getBuildingHealth(
        building
      )
    )
  end
end


-- Рисует кнопку строительства.
function BattleInterface:
  drawBuildButton(pass)
  local building =
    self.app.selectedBuilding

  if
    not building
    or not building:isPlatform()
  then
    return
  end

  local enabled =
    self:canBuild()

  self.theme:
    drawButtonBackground(
      pass,
      self.ui,

      enabled
      and 'normal'
      or 'disabled',

      BUILD_BUTTON.x,
      BUILD_BUTTON.y,
      BUILD_BUTTON.width,
      BUILD_BUTTON.height
    )

  local cost =
    building.definition.buildCost
    or 0

  self.ui:drawText(
    pass,

    'BUILD ' ..
    tostring(cost),

    BUILD_BUTTON.x,
    BUILD_BUTTON.y,
    BUILD_BUTTON.width,
    BUILD_BUTTON.height,
    19,

    enabled
    and self.theme:
      getColor('text')
    or self.theme:
      getColor('mutedText'),

    -3.78
  )
end

-- Рисует прозрачные кнопки камеры.
function BattleInterface:
  drawCameraButtons(pass)
  if
    not self.app.settings.interface
      .touchCameraControls
  then
    return
  end

  for _, button in ipairs(
    CAMERA_BUTTONS
  ) do
    local bounds =
      self:getCameraButtonBounds(
        button
      )

    local pressed =
      self.pressedCameraControl ==
      button.id

    local source =
      self.theme:getColor(
        pressed
        and 'buttonPressed'
        or 'button'
      )

    self.ui:drawRectangle(
      pass,
      bounds.x,
      bounds.y,
      bounds.width,
      bounds.height,

      {
        source[1],
        source[2],
        source[3],

        pressed
        and .62
        or .32
      },

      -3.88
    )

    local textSize = 28

    if
      button.id == 'tiltUp'
      or button.id == 'tiltDown'
    then
      textSize = 19

    elseif
      button.id == 'zoomIn'
      or button.id == 'zoomOut'
    then
      textSize = 14
    end

    self.ui:drawText(
      pass,
      button.text,
      bounds.x,
      bounds.y,
      bounds.width,
      bounds.height,

      -- Здесь передаётся размер.
      textSize,

      {
        1,
        1,
        1,
        .82
      },

      -3.78
    )
  end
end

-- Рисует интерфейс боя.
function BattleInterface:drawHud(pass)
  self:drawBuildingCards(pass)
  self:drawSquadCards(pass)
  self:drawBuildButton(pass)
  self:drawCameraButtons(pass)
  self:drawExitButton(pass)

  -- Диалог рисуется последним.
  self:drawExitDialog(pass)
end

-- Рисует овал вокруг бойца.
function BattleInterface:drawUnitOval(
  pass,
  unit,
  color
)
  if not unit:isTargetable() then
    return
  end

  local radiusX =
    math.max(
      .7,
      unit.radius * 1.7
    )

  local radiusZ =
    radiusX * .7

  local segments = 24

  pass:setShader()
  pass:setMaterial()

  pass:setColor(
    color[1],
    color[2],
    color[3],
    color[4] or 1
  )

  for index = 0, segments - 1 do
    local firstAngle =
      index /
      segments *
      math.pi * 2

    local secondAngle =
      (index + 1) /
      segments *
      math.pi * 2

    local firstX =
      unit.x +
      math.cos(firstAngle) *
      radiusX

    local firstZ =
      unit.z +
      math.sin(firstAngle) *
      radiusZ

    local secondX =
      unit.x +
      math.cos(secondAngle) *
      radiusX

    local secondZ =
      unit.z +
      math.sin(secondAngle) *
      radiusZ

    local firstY =
      self.app.field:getHeight(
        firstX,
        firstZ
      ) + .06

    local secondY =
      self.app.field:getHeight(
        secondX,
        secondZ
      ) + .06

    pass:line(
      firstX,
      firstY,
      firstZ,
      secondX,
      secondY,
      secondZ
    )
  end
end


-- Рисует выделение отрядов мира.
function BattleInterface:
  drawWorldSelection(pass)
  for _, squad in ipairs(
    self.app.selectedSquads
    or {}
  ) do
    if not squad:isDefeated() then
      for _, unit in ipairs(
        squad.units
      ) do
        self:drawUnitOval(
          pass,
          unit,
          {
            .15,
            1,
            .25,
            1
          }
        )
      end
    end
  end

  local enemy =
    self.app.selectedEnemySquad

  if
    enemy
    and not enemy:isDefeated()
  then
    for _, unit in ipairs(
      enemy.units
    ) do
      self:drawUnitOval(
        pass,
        unit,
        {
          1,
          .12,
          .1,
          1
        }
      )
    end
  end

  pass:setColor(1, 1, 1, 1)
end


return BattleInterface