local Button =
  require('src.ui.button')

local CampaignJournalScreen =
  require(
    'src.screens.campaign_journal_screen'
  )

local CampaignScreen = {}
CampaignScreen.__index =
  CampaignScreen


function CampaignScreen.new(app)
  local self =
    setmetatable(
      {},
      CampaignScreen
    )

  self.app = app
  self.ui = app.ui
  self.theme = app.theme

  self.session =
    assert(
      app.campaignSession,
      'CampaignScreen has no session'
    )

  self.state =
    self.session.state

  self.mapX = 20
  self.mapY = 105
  self.mapWidth = 880
  self.mapHeight = 495

  self.panelX = 920
  self.panelY = 20
  self.panelWidth = 340
  self.panelHeight = 680

  self.selectedCityId =
    self.session:
      getPlayer().capital

  self.selectedArmyId = nil

  self.buttons = {}
  self.recruitButtons = {}

  self:createButtons()
  self:layout()
  self:refreshButtons()

  return self
end


function CampaignScreen:
  createButton(settings)
  settings.theme = self.theme
  settings.ui = self.ui

  local button =
    Button.new(settings)

  self.buttons[
    #self.buttons + 1
  ] = button

  return button
end


function CampaignScreen:createButtons()
  self.menuButton =
    self:createButton({
      text = 'MENU',

      onClick = function()
        self.app:showMenu()
      end
    })

  self.journalButton =
    self:createButton({
      text = 'JOURNAL',

      onClick = function()
        self.app.screens:push(
          CampaignJournalScreen.new(
            self.app
          )
        )
      end
    })

  self.previousArmyButton =
    self:createButton({
      text = '<',

      onClick = function()
        self:cycleArmy(-1)
      end
    })

  self.nextArmyButton =
    self:createButton({
      text = '>',

      onClick = function()
        self:cycleArmy(1)
      end
    })

  self.newArmyButton =
    self:createButton({
      text = 'NEW ARMY',
      fontSize = 20,

      onClick = function()
        self.selectedArmyId = nil
        self:refreshButtons()
      end
    })

  self.previousCityButton =
    self:createButton({
      text = '<',

      onClick = function()
        self:cycleCity(-1)
      end
    })

  self.nextCityButton =
    self:createButton({
      text = '>',

      onClick = function()
        self:cycleCity(1)
      end
    })

  self.upgradeButton =
    self:createButton({
      text = 'UPGRADE',
      fontSize = 19,

      onClick = function()
        if
          self.session:
            queueUpgrade(
              self.selectedCityId
            )
        then
          self:refreshButtons()
        end
      end
    })

  self.sendButton =
    self:createButton({
      text = 'SEND ARMY',
      fontSize = 17,

      onClick = function()
        if
          self.selectedArmyId
          and self.selectedCityId
        then
          self.session:sendArmy(
            self.selectedArmyId,
            self.selectedCityId
          )

          self:refreshButtons()
        end
      end
    })

  self.cancelJourneyButton =
    self:createButton({
      text = 'CANCEL MARCH',
      fontSize = 15,

      onClick = function()
        if self.selectedArmyId then
          self.session:
            cancelJourney(
              self.selectedArmyId
            )

          self:refreshButtons()
        end
      end
    })

  self.endTurnButton =
    self:createButton({
      text = 'END TURN',
      fontSize = 21,

      onClick = function()
        local result =
          self.session:endTurn()

        self.app:
          handleCampaignTurnResult(
            result
          )
      end
    })

  local profile =
    self.state.definition
      .recruitment.profiles
      .standard

  for _, option in ipairs(profile) do
    local recruitmentOption = option

    local button =
      self:createButton({
        text =
          recruitmentOption.label,

        fontSize = 16,

        onClick = function()
          self:queueRecruit(
            recruitmentOption
          )
        end
      })

    self.recruitButtons[
      #self.recruitButtons + 1
    ] = {
      button = button,
      option = recruitmentOption
    }
  end
end


function CampaignScreen:layout()
  self.menuButton:setBounds(
    20,
    22,
    150,
    52
  )

  self.journalButton:setBounds(
    740,
    22,
    160,
    52
  )

  self.previousArmyButton:
    setBounds(
      940,
      235,
      55,
      48
    )

  self.nextArmyButton:setBounds(
    1185,
    235,
    55,
    48
  )

  self.newArmyButton:setBounds(
    1005,
    235,
    170,
    48
  )

  self.previousCityButton:
    setBounds(
      940,
      294,
      55,
      48
    )

  self.upgradeButton:setBounds(
    1005,
    294,
    170,
    48
  )

  self.nextCityButton:setBounds(
    1185,
    294,
    55,
    48
  )

  local recruitY = 375

  for index, entry in ipairs(
    self.recruitButtons
  ) do
    entry.button:setBounds(
      940,
      recruitY +
      (index - 1) * 38,
      300,
      34
    )
  end

  self.sendButton:setBounds(
    940,
    610,
    145,
    42
  )

  self.cancelJourneyButton:
    setBounds(
      1095,
      610,
      145,
      42
    )

  self.endTurnButton:setBounds(
    940,
    660,
    300,
    42
  )
end


function CampaignScreen:
  getPlayerArmies()
  return
    self.session:
      getPlayerArmies()
end


function CampaignScreen:
  getSelectedArmy()
  if not self.selectedArmyId then
    return nil
  end

  return
    self.state.armiesById[
      self.selectedArmyId
    ]
end


function CampaignScreen:
  cycleArmy(direction)
  local armies =
    self:getPlayerArmies()

  if #armies == 0 then
    self.selectedArmyId = nil
    self:refreshButtons()
    return
  end

  local index = 0

  for candidateIndex,
    army
  in ipairs(armies) do
    if
      army.id ==
      self.selectedArmyId
    then
      index = candidateIndex
      break
    end
  end

  if index == 0 then
    index =
      direction > 0
      and 1
      or #armies
  else
    index =
      (
        index - 1 +
        direction
      ) % #armies + 1
  end

  self.selectedArmyId =
    armies[index].id

  self:refreshButtons()
end


-- Возвращает города игрока.
function CampaignScreen:
  getOwnedCityDefinitions()
  local result = {}

  local player =
    self.session:getPlayer()

  for _, definition in ipairs(
    self.state.definition.cities
  ) do
    local city =
      self.state:getCity(
        definition.id
      )

    if city.owner == player.id then
      result[#result + 1] =
        definition
    end
  end

  return result
end

-- Переключает только города игрока.
function CampaignScreen:
  cycleCity(direction)
  local cities =
    self:getOwnedCityDefinitions()

  if #cities == 0 then
    return
  end

  local index = 0

  for candidateIndex,
    city
  in ipairs(cities) do
    if
      city.id ==
      self.selectedCityId
    then
      index = candidateIndex
      break
    end
  end

  if index == 0 then
    index =
      direction > 0
      and 1
      or #cities
  else
    index =
      (
        index - 1 +
        direction
      ) % #cities + 1
  end

  self.selectedCityId =
    cities[index].id

  self:refreshButtons()
end


function CampaignScreen:
  queueRecruit(option)
  local city =
    self.state:getCity(
      self.selectedCityId
    )

  local army =
    self:getSelectedArmy()

  if
    army
    and army.cityId ~= city.id
  then
    return false
  end

  local armyId =
    army and army.id or nil

  if
    self.session:queueRecruit(
      city.id,
      option.slot,
      armyId
    )
  then
    self:refreshButtons()
    return true
  end

  return false
end


function CampaignScreen:
  getParticipantColor(
    participantId
  )
  if not participantId then
    local neutral =
      self.app.sideRegistry:get(
        self.state.definition
          .neutralSide
      )

    return
      neutral.campaignColor
      or {
        .55,
        .55,
        .55,
        1
      }
  end

  local participant =
    self.state:
      getParticipant(
        participantId
      )

  local side =
    self.app.sideRegistry:get(
      participant.side
    )

  return
    side.campaignColor
    or {
      .62,
      .62,
      .62,
      1
    }
end


function CampaignScreen:
  cityToScreen(cityDefinition)
  local worldMap =
    self.state.definition.worldMap

  return
    self.mapX +
    cityDefinition.x /
    worldMap.width *
    self.mapWidth,

    self.mapY +
    cityDefinition.y /
    worldMap.height *
    self.mapHeight
end


function CampaignScreen:
  findCityAt(x, y)
  local selected = nil
  local selectedDistance = nil

  for _, definition in ipairs(
    self.state.definition.cities
  ) do
    local cityX, cityY =
      self:cityToScreen(
        definition
      )

    local dx = cityX - x
    local dy = cityY - y

    local distance =
      dx * dx + dy * dy

    local radius =
      definition.markerRadius
      or 28

    if
      distance <= radius * radius
      and (
        not selectedDistance
        or distance <
          selectedDistance
      )
    then
      selected = definition
      selectedDistance = distance
    end
  end

  return selected
end


function CampaignScreen:
  selectCity(cityId)
  self.selectedCityId = cityId
  self:refreshButtons()
end


function CampaignScreen:
  refreshButtons()
  local canAct =
    self.session:
      canPerformActions()

  local city =
    self.state.citiesById[
      self.selectedCityId
    ]

  local definition =
    city
    and self.state:
      getCityDefinition(city.id)

  local player =
    self.session:getPlayer()

  local army =
    self:getSelectedArmy()

  self.upgradeButton.enabled =
    canAct
    and city ~= nil
    and city.owner == player.id
    and definition
      .nativeParticipant ==
      player.id
    and city.level <
      #definition.levels

  local alliedCity =
    city
    and self.state:isAllied(
      player.id,
      city.owner
    )

  local validArmyTarget =
    not army
    or (
      army.cityId ~= nil
      and army.cityId == city.id
    )

  for _, entry in ipairs(
    self.recruitButtons
  ) do
    local option = entry.option

    local supported =
      self.app.sideRegistry:
        resolveUnit(
          player.side,
          option.slot
        ) ~= nil

    entry.button.enabled =
      canAct
      and alliedCity
      and validArmyTarget
      and supported
      and city.level >=
        (
          option.minimumCityLevel
          or 1
        )

    entry.button.text =
      option.label ..
      '  ' ..
      option.cost ..
      'G/' ..
      option.turns ..
      'D'
  end

  self.sendButton.enabled =
    canAct
    and army ~= nil
    and army.cityId ~= nil
    and city ~= nil
    and army.cityId ~= city.id

  self.cancelJourneyButton.enabled =
    canAct
    and army ~= nil
    and army.journeyId ~= nil

  self.previousArmyButton.enabled =
    #self:getPlayerArmies() > 0

  self.nextArmyButton.enabled =
    self.previousArmyButton.enabled

	self.previousCityButton.enabled =
		#self:getOwnedCityDefinitions() > 1

  self.nextCityButton.enabled =
    self.previousCityButton.enabled

  self.newArmyButton.enabled =
    canAct

  self.endTurnButton.enabled =
    canAct
end


function CampaignScreen:enter()
  self:refreshButtons()
end


function CampaignScreen:revealed()
  self:refreshButtons()
end


function CampaignScreen:update(dt)
end

--Рисует города на карте
function CampaignScreen:
  drawCityMarkers(pass)
  for _, definition in ipairs(
    self.state.definition.cities
  ) do
    local city =
      self.state:getCity(
        definition.id
      )

    local x, y =
      self:cityToScreen(
        definition
      )

    local color =
      self:getParticipantColor(
        city.owner
      )

    local baseSize =
      definition.capital
      and 24
      or 14

    local selected =
      self.selectedCityId ==
      city.id

    local size =
      selected
      and baseSize + 8
      or baseSize

    self.ui:drawRectangle(
      pass,
      x - size / 2,
      y - size / 2,
      size,
      size,
      color,
      -3.72
    )

    -- Название выводится над городом.
    self.ui:drawText(
      pass,
      definition.name,
      x - 105,
      y - 39,
      210,
      28,

      definition.capital
      and 16
      or 14,

      self.theme:getColor(
        'text'
      ),

      -3.70
    )
  end
end


function CampaignScreen:
  drawMap(pass)
  self.theme:drawPanel(
    pass,
    self.ui,
    self.mapX - 10,
    self.mapY - 10,
    self.mapWidth + 20,
    self.mapHeight + 20,
    1
  )

  local drawn =
    self.ui:drawImage(
      pass,

      self.state.definition
        .worldMap.image,

      self.mapX,
      self.mapY,
      self.mapWidth,
      self.mapHeight,

      {
        fit = 'contain'
      }
    )

  if not drawn then
    self.ui:drawRectangle(
      pass,
      self.mapX,
      self.mapY,
      self.mapWidth,
      self.mapHeight,
      {
        .07,
        .12,
        .09,
        1
      },
      -3.74
    )
  end

  self:drawCityMarkers(pass)
end


function CampaignScreen:
  drawSelectedCity(pass)
  local city =
    self.state:getCity(
      self.selectedCityId
    )

  local definition =
    self.state:
      getCityDefinition(
        city.id
      )

  local ownerName = 'Neutral'

  if city.owner then
    ownerName =
      self.state:
        getParticipant(
          city.owner
        ).side
  end

  self.ui:drawText(
    pass,
    definition.name,
    940,
    55,
    300,
    42,
    27,

    self.theme:getColor('text'),
    -3.75
  )

  self.ui:drawText(
    pass,

    'OWNER: ' ..
    string.upper(ownerName) ..
    '\nLEVEL: ' ..
    city.level ..
    '\nQUEUE: ' ..
    #city.productionQueue,

    940,
    100,
    300,
    82,
    17,

    self.theme:getColor(
      'mutedText'
    ),

    -3.75
  )
end


function CampaignScreen:
  drawSelectedArmy(pass)
  local army =
    self:getSelectedArmy()

  local text

  if not army then
    text =
      'NEW ARMY - SELECT A UNIT BELOW'
  else
    local location

    if army.cityId then
      location = army.cityId
    else
      local remaining =
        self.session
          .journeySystem:
          getRemainingDays(
            army.id
          )

      location =
        'TRAVELLING ' ..
        tostring(remaining or 0) ..
        'D'
    end

    text =
      army.name ..
      ' | ' ..
      location ..
      ' | ' ..
      #army.squads ..
      '/10'
  end

  self.ui:drawText(
    pass,
    text,
    940,
    195,
    300,
    34,
    14,

    self.theme:getColor(
      'text'
    ),

    -3.75
  )
end


function CampaignScreen:
  drawLog(pass)
  local log =
    self.state.eventLog

  local lines = {}

  local first =
    math.max(
      1,
      #log - 3
    )

  for index = first, #log do
    local entry = log[index]

    lines[#lines + 1] =
      'D' ..
      entry.day ..
      ': ' ..
      entry.message
  end

  self.ui:drawText(
    pass,
    table.concat(lines, '\n'),
    30,
    620,
    860,
    75,
    14,

    self.theme:getColor(
      'mutedText'
    ),

    -3.75
  )
end


function CampaignScreen:draw(pass)
  self.ui:begin(pass)

  self.theme:drawBackground(
    pass,
    self.ui
  )

  self.theme:drawPanel(
    pass,
    self.ui,
    self.panelX,
    self.panelY,
    self.panelWidth,
    self.panelHeight,
    1
  )

  self.ui:drawText(
    pass,

    'DAY ' ..
    self.state.day ..
    '    GOLD ' ..
    self.state.gold,

    190,
    25,
    520,
    55,
    30,

    self.theme:getColor(
      'text'
    ),

    -3.75
  )

  self:drawMap(pass)
  self:drawSelectedCity(pass)
  self:drawSelectedArmy(pass)
  self:drawLog(pass)

  for _, button in ipairs(
    self.buttons
  ) do
    button:draw(pass)
  end

  pass:setColor(1, 1, 1, 1)
end


function CampaignScreen:
  mousemoved(x, y)
  for _, button in ipairs(
    self.buttons
  ) do
    button:mousemoved(x, y)
  end
end


function CampaignScreen:
  mousepressed(
    x,
    y,
    mouseButton
  )
  for _, button in ipairs(
    self.buttons
  ) do
    if button:mousepressed(
      x,
      y,
      mouseButton
    ) then
      return
    end
  end

  if mouseButton ~= 1 then
    return
  end

  local city =
    self:findCityAt(x, y)

  if city then
    self:selectCity(city.id)
  end
end


function CampaignScreen:
  mousereleased(
    x,
    y,
    mouseButton
  )
  for _, button in ipairs(
    self.buttons
  ) do
    if button:mousereleased(
      x,
      y,
      mouseButton
    ) then
      return
    end
  end
end


function CampaignScreen:keypressed(key)
  if key == 'left' then
    self:cycleArmy(-1)

  elseif key == 'right' then
    self:cycleArmy(1)

  elseif key == 'q' then
    self:cycleCity(-1)

  elseif key == 'e' then
    self:cycleCity(1)

  elseif key == 'return' then
    local result =
      self.session:endTurn()

    self.app:
      handleCampaignTurnResult(
        result
      )

  elseif key == 'escape' then
    self.app:showMenu()
  end
end


return CampaignScreen