local Button =
  require('src.ui.button')

local CampaignAdvisorScreen = {}
CampaignAdvisorScreen.__index =
  CampaignAdvisorScreen


local FORECAST_TEXT = {
  overwhelming_advantage =
    'The enemy cannot resist.',

  clear_advantage =
    'We have a clear advantage.',

  small_advantage =
    'We have a small advantage.',

  equal_forces =
    'The forces are approximately equal.',

  small_disadvantage =
    'The enemy has a small advantage.',

  clear_disadvantage =
    'The enemy is significantly stronger.',

  overwhelming_disadvantage =
    'Defeat is almost certain.'
}


function CampaignAdvisorScreen.new(
  app,
  result
)
  local self =
    setmetatable(
      {},
      CampaignAdvisorScreen
    )

  self.app = app
  self.ui = app.ui
  self.theme = app.theme

  self.session =
    assert(
      app.campaignSession,
      'Advisor has no campaign session'
    )

  self.result = result

  self.transparent = true
  self.updateBelow = false

  self.panelX = 270
  self.panelY = 150
  self.panelWidth = 740
  self.panelHeight = 420

  self.title = 'ADVISOR'
  self.message = ''

  self.buttons = {}

  self:configure()

  return self
end


function CampaignAdvisorScreen:
  addButton(
    text,
    onClick,
    width
  )
  local button =
    Button.new({
      text = text,
      theme = self.theme,
      ui = self.ui,
      onClick = onClick
    })

  button.requestedWidth =
    width or 190

  self.buttons[
    #self.buttons + 1
  ] = button

  return button
end


function CampaignAdvisorScreen:
  layoutButtons()
  local spacing = 14

  local totalWidth = 0

  for _, button in ipairs(
    self.buttons
  ) do
    totalWidth =
      totalWidth +
      button.requestedWidth
  end

  totalWidth =
    totalWidth +
    math.max(
      0,
      #self.buttons - 1
    ) * spacing

  local x =
    self.panelX +
    (
      self.panelWidth -
      totalWidth
    ) / 2

  local y =
    self.panelY +
    self.panelHeight -
    82

  for _, button in ipairs(
    self.buttons
  ) do
    button:setBounds(
      x,
      y,
      button.requestedWidth,
      52
    )

    x =
      x +
      button.requestedWidth +
      spacing
  end
end


function CampaignAdvisorScreen:
  closeWithResult(result)
  self.app.screens:pop()

  self.app:
    handleCampaignTurnResult(
      result
    )
end


function CampaignAdvisorScreen:
  configureNotification()
  local notification =
    self.result.notification

  self.title = 'ADVISOR'

  self.message =
    notification.message
    or 'The day continues.'

  self:addButton(
    'CONTINUE',

    function()
      local result =
        self.session:
          acknowledgeNotification()

      self:closeWithResult(result)
    end,

    230
  )
end


function CampaignAdvisorScreen:
  configureDefenderSelection(
    scenario
  )
  self.title = 'DEFEND THE CITY'

  self.message =
    'Choose an army to fight first.'

  for _, armyId in ipairs(
    scenario.remainingDefenders
    or {}
  ) do
    local selectedArmyId = armyId

    local army =
      self.session.state
        .armiesById[
          selectedArmyId
        ]

    if army then
      self:addButton(
        army.name,

        function()
          local result =
            self.session:
              selectSiegeDefender(
                selectedArmyId
              )

          self:closeWithResult(
            result
          )
        end,

        150
      )
    end
  end
end


function CampaignAdvisorScreen:
  configureBattleChoice(scenario)
  self.title = 'BATTLE'

  local forecast =
    self.session:
      getBattleForecast()

  self.message =
    FORECAST_TEXT[forecast]
    or 'An enemy army approaches.'

  self:addButton(
    'FIGHT',

    function()
      local payload =
        self.session:
          beginManualBattle()

      if payload then
        self.app:
          startCampaignManualBattle(
            payload
          )
      end
    end,

    180
  )

  self:addButton(
    'AUTO BATTLE',

    function()
      local resolution =
        self.session:
          resolveBattleAutomatically()

      self:closeWithResult(
        resolution
        and resolution.turn
      )
    end,

    200
  )

  if scenario.canRetreat then
    self:addButton(
      'RETREAT',

      function()
        local result =
          self.session:
            retreatFromBattle()

        self:closeWithResult(
          result
        )
      end,

      180
    )
  end
end


function CampaignAdvisorScreen:
  configureBattle()
  local scenario =
    self.result.battle

  if
    scenario.status ==
      'select_defender'
  then
    self:
      configureDefenderSelection(
        scenario
      )
  else
    self:
      configureBattleChoice(
        scenario
      )
  end
end


function CampaignAdvisorScreen:
  configureVictory()
  self.title = 'VICTORY'

  self.message =
    'The campaign objectives have been completed.'

  self:addButton(
    'MAIN MENU',

    function()
      self.session:deleteSave()
      self.app:showMenu()
    end,

    230
  )
end


function CampaignAdvisorScreen:
  configureDefeat()
  self.title = 'DEFEAT'

  self.message =
    'The capital has been lost.'

  self:addButton(
    'MAIN MENU',

    function()
      self.session:deleteSave()
      self.app:showMenu()
    end,

    230
  )
end


function CampaignAdvisorScreen:
  configure()
  if not self.result then
    self.title = 'ADVISOR'
    self.message =
      'Nothing requires attention.'

    self:addButton(
      'CONTINUE',

      function()
        self.app.screens:pop()
      end,

      230
    )

  elseif
    self.result.status ==
    'notification'
  then
    self:configureNotification()

  elseif self.result.status == 'battle' then
    self:configureBattle()

  elseif self.result.status == 'victory' then
    self:configureVictory()

  elseif self.result.status == 'defeat' then
    self:configureDefeat()

  else
    self.title = 'ADVISOR'
    self.message =
      'The next day has begun.'

    self:addButton(
      'CONTINUE',

      function()
        self.app.screens:pop()
      end,

      230
    )
  end

  self:layoutButtons()
end


function CampaignAdvisorScreen:update(dt)
end


function CampaignAdvisorScreen:draw(pass)
  self.ui:begin(pass)

  self.theme:drawOverlay(
    pass,
    self.ui,
    1
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
    self.title,
    self.panelX + 30,
    self.panelY + 35,
    self.panelWidth - 60,
    65,
    38,

    self.theme:getColor(
      'text'
    ),

    -3.72
  )

  self.ui:drawText(
    pass,
    self.message,
    self.panelX + 60,
    self.panelY + 125,
    self.panelWidth - 120,
    130,
    22,

    self.theme:getColor(
      'mutedText'
    ),

    -3.72
  )

  for _, button in ipairs(
    self.buttons
  ) do
    button:draw(pass)
  end
end


function CampaignAdvisorScreen:
  mousemoved(x, y)
  for _, button in ipairs(
    self.buttons
  ) do
    button:mousemoved(x, y)
  end
end


function CampaignAdvisorScreen:
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
end


function CampaignAdvisorScreen:
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


function CampaignAdvisorScreen:keypressed(key)
  if
    (
      key == 'return'
      or key == 'space'
    )
    and #self.buttons == 1
  then
    self.buttons[1]:activate()
  end
end


return CampaignAdvisorScreen