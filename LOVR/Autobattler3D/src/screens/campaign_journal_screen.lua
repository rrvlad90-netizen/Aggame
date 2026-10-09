local Button =
  require('src.ui.button')

local CampaignJournalScreen = {}
CampaignJournalScreen.__index =
  CampaignJournalScreen


function CampaignJournalScreen.new(app)
  local self =
    setmetatable(
      {},
      CampaignJournalScreen
    )

  self.app = app
  self.ui = app.ui
  self.theme = app.theme

  self.transparent = true
  self.updateBelow = false

  self.log =
    app.campaignSession
      .state.eventLog

  self.pageSize = 12

  self.page =
    math.max(
      1,
      math.ceil(
        #self.log /
        self.pageSize
      )
    )

  self.buttons = {}

  self:createButtons()
  self:layout()
  self:refreshButtons()

  return self
end


function CampaignJournalScreen:
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


function CampaignJournalScreen:
  createButtons()
  self.previousButton =
    self:createButton({
      text = '<',

      onClick = function()
        self.page =
          math.max(
            1,
            self.page - 1
          )

        self:refreshButtons()
      end
    })

  self.nextButton =
    self:createButton({
      text = '>',

      onClick = function()
        self.page =
          math.min(
            self:getPageCount(),
            self.page + 1
          )

        self:refreshButtons()
      end
    })

  self.closeButton =
    self:createButton({
      text = 'CLOSE',

      onClick = function()
        self.app.screens:pop()
      end
    })
end


function CampaignJournalScreen:layout()
  self.panelX = 180
  self.panelY = 55
  self.panelWidth = 920
  self.panelHeight = 610

  self.previousButton:setBounds(
    380,
    585,
    80,
    52
  )

  self.nextButton:setBounds(
    820,
    585,
    80,
    52
  )

  self.closeButton:setBounds(
    520,
    585,
    240,
    52
  )
end


function CampaignJournalScreen:
  getPageCount()
  return
    math.max(
      1,

      math.ceil(
        #self.log /
        self.pageSize
      )
    )
end


function CampaignJournalScreen:
  refreshButtons()
  self.previousButton.enabled =
    self.page > 1

  self.nextButton.enabled =
    self.page <
    self:getPageCount()
end


function CampaignJournalScreen:
  getPageText()
  if #self.log == 0 then
    return 'No events recorded.'
  end

  local first =
    (self.page - 1) *
    self.pageSize + 1

  local last =
    math.min(
      #self.log,
      first + self.pageSize - 1
    )

  local lines = {}

  for index = first, last do
    local entry =
      self.log[index]

    lines[#lines + 1] =
      string.format(
        'DAY %d   %s',
        entry.day,
        entry.message
      )
  end

  return table.concat(
    lines,
    '\n\n'
  )
end


function CampaignJournalScreen:update(dt)
end


function CampaignJournalScreen:draw(pass)
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
    'CAMPAIGN JOURNAL',
    self.panelX + 30,
    self.panelY + 24,
    self.panelWidth - 60,
    58,
    36,

    self.theme:getColor(
      'text'
    ),

    -3.72
  )

  self.ui:drawText(
    pass,
    self:getPageText(),
    self.panelX + 55,
    self.panelY + 100,
    self.panelWidth - 110,
    420,
    18,

    self.theme:getColor(
      'mutedText'
    ),

    -3.72
  )

  self.ui:drawText(
    pass,

    self.page ..
    ' / ' ..
    self:getPageCount(),

    460,
    592,
    360,
    35,
    18,

    self.theme:getColor(
      'mutedText'
    ),

    -3.70
  )

  for _, button in ipairs(
    self.buttons
  ) do
    button:draw(pass)
  end
end


function CampaignJournalScreen:
  mousemoved(x, y)
  for _, button in ipairs(
    self.buttons
  ) do
    button:mousemoved(x, y)
  end
end


function CampaignJournalScreen:
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


function CampaignJournalScreen:
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


function CampaignJournalScreen:
  keypressed(key)
  if
    key == 'left'
    or key == 'a'
  then
    if self.previousButton.enabled then
      self.previousButton:activate()
    end

  elseif
    key == 'right'
    or key == 'd'
  then
    if self.nextButton.enabled then
      self.nextButton:activate()
    end

  elseif
    key == 'escape'
    or key == 'return'
  then
    self.app.screens:pop()
  end
end


return CampaignJournalScreen