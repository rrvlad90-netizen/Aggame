local Button =
  require('src.ui.button')

local CampaignSave =
  require(
    'src.campaign.campaign_save'
  )

local CampaignSelectScreen = {}
CampaignSelectScreen.__index =
  CampaignSelectScreen


function CampaignSelectScreen.new(app)
  local self =
    setmetatable(
      {},
      CampaignSelectScreen
    )

  self.app = app
  self.ui = app.ui
  self.theme = app.theme

  self.transparent = true
  self.updateBelow = false

  self.campaigns =
    app.campaignRegistry:getAll()

  self.selectedIndex = 1
  self.buttons = {}

  self:createButtons()
  self:layout()
  self:refreshButtons()

  return self
end


function CampaignSelectScreen:
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


function CampaignSelectScreen:
  getSelected()
  return
    self.campaigns[
      self.selectedIndex
    ]
end


function CampaignSelectScreen:
  cycle(direction)
  if #self.campaigns == 0 then
    return
  end

  self.selectedIndex =
    (
      self.selectedIndex -
      1 +
      direction
    ) % #self.campaigns + 1

  self:refreshButtons()
end


function CampaignSelectScreen:
  createButtons()
  self.previousButton =
    self:createButton({
      text = '<',

      onClick = function()
        self:cycle(-1)
      end
    })

  self.nextButton =
    self:createButton({
      text = '>',

      onClick = function()
        self:cycle(1)
      end
    })

  self.continueButton =
    self:createButton({
      text = 'CONTINUE',

      onClick = function()
        local campaign =
          self:getSelected()

        if campaign then
          self.app:startCampaign(
            campaign.id,
            true
          )
        end
      end
    })

  self.newButton =
    self:createButton({
      text = 'NEW CAMPAIGN',

      onClick = function()
        local campaign =
          self:getSelected()

        if campaign then
          local save =
            CampaignSave.new(
              campaign
            )

          save:delete()

          self.app:startCampaign(
            campaign.id,
            false
          )
        end
      end
    })

  self.cancelButton =
    self:createButton({
      text = 'CANCEL',

      onClick = function()
        self.app.screens:pop()
      end
    })
end


function CampaignSelectScreen:layout()
  self.panelX = 130
  self.panelY = 55
  self.panelWidth = 1020
  self.panelHeight = 610

  self.listX = 180
  self.listY = 170
  self.listWidth = 420
  self.listHeight = 310

  self.previewX = 640
  self.previewY = 170
  self.previewWidth = 460
  self.previewHeight = 310

  self.previousButton:setBounds(
    self.listX,
    500,
    70,
    52
  )

  self.nextButton:setBounds(
    self.listX +
    self.listWidth - 70,
    500,
    70,
    52
  )

  self.continueButton:setBounds(
    170,
    585,
    270,
    52
  )

  self.newButton:setBounds(
    505,
    585,
    270,
    52
  )

  self.cancelButton:setBounds(
    840,
    585,
    270,
    52
  )
end


function CampaignSelectScreen:
  refreshButtons()
  local campaign =
    self:getSelected()

  local hasCampaign =
    campaign ~= nil

  self.previousButton.enabled =
    #self.campaigns > 1

  self.nextButton.enabled =
    #self.campaigns > 1

  self.newButton.enabled =
    hasCampaign

  self.continueButton.enabled =
    hasCampaign
    and CampaignSave.new(
      campaign
    ):exists()
end


function CampaignSelectScreen:update(dt)
end


function CampaignSelectScreen:
  drawCampaignInfo(pass)
  local campaign =
    self:getSelected()

  self.theme:drawPanel(
    pass,
    self.ui,
    self.listX,
    self.listY,
    self.listWidth,
    self.listHeight,
    1
  )

  self.theme:drawPanel(
    pass,
    self.ui,
    self.previewX,
    self.previewY,
    self.previewWidth,
    self.previewHeight,
    1
  )

  if not campaign then
    self.ui:drawText(
      pass,
      'NO CAMPAIGNS',
      self.listX,
      self.listY + 100,
      self.listWidth,
      80,
      28,

      self.theme:getColor(
        'mutedText'
      ),

      -3.72
    )

    return
  end

  self.ui:drawText(
    pass,
    campaign.name,
    self.listX + 25,
    self.listY + 35,
    self.listWidth - 50,
    55,
    32,

    self.theme:getColor(
      'text'
    ),

    -3.72
  )

  self.ui:drawText(
    pass,
    campaign.description or '',
    self.listX + 35,
    self.listY + 110,
    self.listWidth - 70,
    100,
    18,

    self.theme:getColor(
      'mutedText'
    ),

    -3.72
  )

  self.ui:drawText(
    pass,

    'FACTIONS: ' ..
    #campaign.participants ..
    '\nCITIES: ' ..
    #campaign.cities,

    self.listX + 35,
    self.listY + 225,
    self.listWidth - 70,
    60,
    17,

    self.theme:getColor(
      'mutedText'
    ),

    -3.72
  )

  local previewDrawn =
    self.ui:drawImage(
      pass,

      campaign.worldMap.image,

      self.previewX + 15,
      self.previewY + 15,
      self.previewWidth - 30,
      self.previewHeight - 30,

      {
        fit = 'contain'
      }
    )

  if not previewDrawn then
    self.ui:drawText(
      pass,
      'NO PREVIEW',
      self.previewX,
      self.previewY + 110,
      self.previewWidth,
      60,
      24,

      self.theme:getColor(
        'mutedText'
      ),

      -3.72
    )
  end
end


function CampaignSelectScreen:draw(pass)
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
    'CHOOSE CAMPAIGN',
    self.panelX,
    self.panelY + 25,
    self.panelWidth,
    70,
    43,

    self.theme:getColor(
      'text'
    ),

    -3.72
  )

  self:drawCampaignInfo(pass)

  for _, button in ipairs(
    self.buttons
  ) do
    button:draw(pass)
  end
end


function CampaignSelectScreen:
  mousemoved(x, y)
  for _, button in ipairs(
    self.buttons
  ) do
    button:mousemoved(x, y)
  end
end


function CampaignSelectScreen:
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


function CampaignSelectScreen:
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


function CampaignSelectScreen:keypressed(key)
  if
    key == 'left'
    or key == 'a'
  then
    self:cycle(-1)

  elseif
    key == 'right'
    or key == 'd'
  then
    self:cycle(1)

  elseif key == 'return' then
    if self.continueButton.enabled then
      self.continueButton:activate()
    elseif self.newButton.enabled then
      self.newButton:activate()
    end

  elseif key == 'escape' then
    self.app.screens:pop()
  end
end


return CampaignSelectScreen