local SelectionController = {}
SelectionController.__index =
  SelectionController


local function isInside(
  x,
  y,
  minimumX,
  minimumY,
  maximumX,
  maximumY
)
  return
    x >= minimumX
    and x <= maximumX
    and y >= minimumY
    and y <= maximumY
end


-- Создаёт управление рамкой.
function SelectionController.new(
  game,
  config
)
  assert(
    game,
    'Selection controller has no game'
  )

  local self =
    setmetatable(
      {},
      SelectionController
    )

  self.game = game
  self.config = config or {}

  self.active = false
  self.dragging = false

  self.startX = 0
  self.startY = 0

  self.currentX = 0
  self.currentY = 0

  return self
end


-- Начинает возможное выделение.
function SelectionController:begin(
  x,
  y
)
  self.active = true
  self.dragging = false

  self.startX = x
  self.startY = y

  self.currentX = x
  self.currentY = y
end


-- Обновляет положение мыши.
function SelectionController:update(
  x,
  y
)
  if not self.active then
    return false
  end

  self.currentX = x
  self.currentY = y

  local dx =
    self.currentX - self.startX

  local dy =
    self.currentY - self.startY

  local threshold =
    self.config.dragThreshold or 6

  if
    dx * dx + dy * dy >=
    threshold * threshold
  then
    self.dragging = true
  end

  return self.dragging
end


-- Отменяет текущее выделение.
function SelectionController:cancel()
  self.active = false
  self.dragging = false
end


-- Возвращает границы рамки.
function SelectionController:getBounds()
  return
    math.min(
      self.startX,
      self.currentX
    ),

    math.min(
      self.startY,
      self.currentY
    ),

    math.max(
      self.startX,
      self.currentX
    ),

    math.max(
      self.startY,
      self.currentY
    )
end


-- Проецирует мировую точку на экран.
function SelectionController:
  projectWorldToScreen(
    worldX,
    worldY,
    worldZ
  )
  local camera =
    self.game.camera

  local width, height =
	lovr.system.getWindowDimensions()

  width = math.max(width, 1)
  height = math.max(height, 1)

  local relativeX =
    worldX - camera.x

  local relativeY =
    worldY - camera.y

  local relativeZ =
    worldZ - camera.z

  local sineYaw =
    math.sin(camera.yaw)

  local cosineYaw =
    math.cos(camera.yaw)

  local sinePitch =
    math.sin(camera.pitch)

  local cosinePitch =
    math.cos(camera.pitch)

  local forwardX =
    -sineYaw * cosinePitch

  local forwardY =
    sinePitch

  local forwardZ =
    -cosineYaw * cosinePitch

  local rightX = cosineYaw
  local rightY = 0
  local rightZ = -sineYaw

  local upX =
    sineYaw * sinePitch

  local upY =
    cosinePitch

  local upZ =
    cosineYaw * sinePitch

  local cameraX =
    relativeX * rightX +
    relativeY * rightY +
    relativeZ * rightZ

  local cameraY =
    relativeX * upX +
    relativeY * upY +
    relativeZ * upZ

  local depth =
    relativeX * forwardX +
    relativeY * forwardY +
    relativeZ * forwardZ

  if depth <= .01 then
    return nil, nil, false
  end

  local tangent =
    math.tan(
      math.rad(67) * .5
    )

  local aspect = width / height

  local normalizedX =
    cameraX /
    (
      depth *
      tangent *
      aspect
    )

  local normalizedY =
    cameraY /
    (
      depth *
      tangent
    )

  local screenX =
    (
      normalizedX + 1
    ) * .5 * width

  local screenY =
    (
      1 - normalizedY
    ) * .5 * height

  local visible =
    normalizedX >= -1
    and normalizedX <= 1
    and normalizedY >= -1
    and normalizedY <= 1

  return
    screenX,
    screenY,
    visible
end


-- Возвращает экранную точку бойца.
function SelectionController:
  getUnitScreenPosition(unit)
  local height =
    unit.y +
    (
      unit.config.selectionHeight
      or .8
    )

  if unit.flyingBehavior then
    height =
      height +
      unit.flyingBehavior:
        getHeight()
  end

  return self:
    projectWorldToScreen(
      unit.x,
      height,
      unit.z
    )
end


-- Проверяет попадание отряда в рамку.
function SelectionController:
  isSquadInsideRectangle(
    squad,
    minimumX,
    minimumY,
    maximumX,
    maximumY
  )
  local padding =
    self.config.unitPadding or 3

  for _, unit in ipairs(
    squad.units
  ) do
    if unit:isTargetable() then
      local screenX,
        screenY,
        visible =
        self:
          getUnitScreenPosition(unit)

      if
        visible
        and isInside(
          screenX,
          screenY,
          minimumX - padding,
          minimumY - padding,
          maximumX + padding,
          maximumY + padding
        )
      then
        return true
      end
    end
  end

  return false
end


-- Собирает союзные отряды рамки.
function SelectionController:
  collectSquads()
  local minimumX,
    minimumY,
    maximumX,
    maximumY =
    self:getBounds()

  local result = {}

  for _, squad in ipairs(
    self.game.battle.squads
  ) do
    if
      squad.team == 'allies'
      and not squad:isDefeated()
      and self:
        isSquadInsideRectangle(
          squad,
          minimumX,
          minimumY,
          maximumX,
          maximumY
        )
    then
      result[#result + 1] =
        squad
    end
  end

  return result
end


-- Применяет новое выделение.
function SelectionController:
  applySelection(
    squads,
    additive
  )
  local game = self.game

  game.selectedBuilding = nil
  game.selectedEnemySquad = nil

  if not additive then
    game.selectedSquads = {}

    for _, squad in ipairs(squads) do
      game.selectedSquads[
        #game.selectedSquads + 1
      ] = squad
    end

  else
    local selected = {}

    for _, squad in ipairs(
      game.selectedSquads
    ) do
      selected[squad] = true
    end

    for _, squad in ipairs(squads) do
      if selected[squad] then
        selected[squad] = nil
      else
        selected[squad] = true
      end
    end

    game.selectedSquads = {}

    for _, squad in ipairs(
      game.battle.squads
    ) do
      if selected[squad] then
        game.selectedSquads[
          #game.selectedSquads + 1
        ] = squad
      end
    end
  end

  game.selectedSquad =
    game.selectedSquads[
      #game.selectedSquads
    ]
end


-- Завершает рамочное выделение.
function SelectionController:finish(
  x,
  y,
  additive
)
  if not self.active then
    return false
  end

  self:update(x, y)

  if not self.dragging then
    self:cancel()
    return false
  end

  local squads =
    self:collectSquads()

  self:applySelection(
    squads,
    additive
  )

  self:cancel()

  return true
end


-- Рисует рамку.
function SelectionController:draw(pass)
  if
    not self.active
    or not self.dragging
  then
    return
  end

  local minimumX,
    minimumY,
    maximumX,
    maximumY =
    self:getBounds()

  local ui = self.game.ui

  local virtualMinimumX,
    virtualMinimumY =
    ui:toVirtual(
      minimumX,
      minimumY
    )

  local virtualMaximumX,
    virtualMaximumY =
    ui:toVirtual(
      maximumX,
      maximumY
    )

  local width =
    virtualMaximumX -
    virtualMinimumX

  local height =
    virtualMaximumY -
    virtualMinimumY

  if
    width <
      (self.config.minimumBoxSize or 4)
    or height <
      (self.config.minimumBoxSize or 4)
  then
    return
  end

  ui:begin(pass)

  ui:drawRectangle(
    pass,
    virtualMinimumX,
    virtualMinimumY,
    width,
    height,
    {
      .12,
      .8,
      .25,
      .12
    }
  )

  local border = 2

  local color = {
    .2,
    1,
    .35,
    .9
  }

  ui:drawRectangle(
    pass,
    virtualMinimumX,
    virtualMinimumY,
    width,
    border,
    color
  )

  ui:drawRectangle(
    pass,
    virtualMinimumX,
    virtualMaximumY - border,
    width,
    border,
    color
  )

  ui:drawRectangle(
    pass,
    virtualMinimumX,
    virtualMinimumY,
    border,
    height,
    color
  )

  ui:drawRectangle(
    pass,
    virtualMaximumX - border,
    virtualMinimumY,
    border,
    height,
    color
  )
end


return SelectionController