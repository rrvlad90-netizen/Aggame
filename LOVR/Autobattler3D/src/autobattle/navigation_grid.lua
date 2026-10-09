local NavigationGrid = {}
NavigationGrid.__index = NavigationGrid


local function clamp(
  value,
  minimum,
  maximum
)
  return math.max(
    minimum,
    math.min(maximum, value)
  )
end


local function distanceSquared(
  firstX,
  firstZ,
  secondX,
  secondZ
)
  local dx = secondX - firstX
  local dz = secondZ - firstZ

  return dx * dx + dz * dz
end


-- Создаёт навигационную сетку.
function NavigationGrid.new(
  field,
  config
)
  assert(
    field,
    'Navigation grid has no field'
  )

  config = config or {}

  local self =
    setmetatable(
      {},
      NavigationGrid
    )

  self.field = field
  self.config = config

  local fieldConfig =
    field.config or {}

  self.width =
    assert(
      fieldConfig.width,
      'Field has no width'
    )

  self.length =
    assert(
      fieldConfig.length,
      'Field has no length'
    )

  self.cellSize =
    config.cellSize or 2

  self.clearance =
    config.clearance or .75

  -- Максимально допустимый перепад
  -- высоты относительно размера клетки.
  self.maximumSlope =
    config.maximumSlope or .85

  self.originX =
    -self.width * .5

  self.originZ =
    -self.length * .5

  self.columns =
    math.max(
      1,
      math.ceil(
        self.width /
        self.cellSize
      )
    )

  self.rows =
    math.max(
      1,
      math.ceil(
        self.length /
        self.cellSize
      )
    )

  self.staticBlocked = {}
  self.dynamicBlocked = {}

  self.revision = 0

  self:buildStaticGrid()

  return self
end


-- Возвращает индекс клетки.
function NavigationGrid:getKey(
  column,
  row
)
  return
    (row - 1) *
    self.columns +
    column
end


-- Проверяет координаты клетки.
function NavigationGrid:isInside(
  column,
  row
)
  return
    column >= 1
    and column <= self.columns
    and row >= 1
    and row <= self.rows
end


-- Переводит мировую позицию в клетку.
function NavigationGrid:worldToCell(
  worldX,
  worldZ
)
  local column =
    math.floor(
      (
        worldX -
        self.originX
      ) /
      self.cellSize
    ) + 1

  local row =
    math.floor(
      (
        worldZ -
        self.originZ
      ) /
      self.cellSize
    ) + 1

  if not self:isInside(
    column,
    row
  ) then
    return nil, nil
  end

  return column, row
end


-- Возвращает центр клетки.
function NavigationGrid:cellToWorld(
  column,
  row
)
  if not self:isInside(
    column,
    row
  ) then
    return nil, nil
  end

  local worldX =
    self.originX +
    (
      column - .5
    ) * self.cellSize

  local worldZ =
    self.originZ +
    (
      row - .5
    ) * self.cellSize

  return worldX, worldZ
end


-- Безопасно получает высоту поля.
function NavigationGrid:getHeight(
  worldX,
  worldZ
)
  if not self.field.getHeight then
    return 0
  end

  return
    self.field:getHeight(
      worldX,
      worldZ
    ) or 0
end


-- Проверяет проходимость рельефа.
function NavigationGrid:isTerrainWalkable(
  worldX,
  worldZ
)
  local halfStep =
    self.cellSize * .5

  local centerHeight =
    self:getHeight(
      worldX,
      worldZ
    )

  local sampleHeights = {
    self:getHeight(
      worldX - halfStep,
      worldZ
    ),

    self:getHeight(
      worldX + halfStep,
      worldZ
    ),

    self:getHeight(
      worldX,
      worldZ - halfStep
    ),

    self:getHeight(
      worldX,
      worldZ + halfStep
    )
  }

  local maximumDifference = 0

  for _, height in ipairs(
    sampleHeights
  ) do
    maximumDifference =
      math.max(
        maximumDifference,
        math.abs(
          height - centerHeight
        )
      )
  end

  local slope =
    maximumDifference /
    math.max(
      halfStep,
      .001
    )

  return
    slope <= self.maximumSlope
end


-- Строит неизменяемую часть сетки.
function NavigationGrid:buildStaticGrid()
  self.staticBlocked = {}

  for row = 1, self.rows do
    for column = 1,
      self.columns
    do
      local worldX, worldZ =
        self:cellToWorld(
          column,
          row
        )

      if
        not self:isTerrainWalkable(
          worldX,
          worldZ
        )
      then
        local key =
          self:getKey(
            column,
            row
          )

        self.staticBlocked[key] =
          true
      end
    end
  end

  self.revision =
    self.revision + 1
end


-- Помечает круговую область занятой.
function NavigationGrid:blockCircle(
  worldX,
  worldZ,
  radius
)
  radius =
    math.max(
      0,
      radius or 0
    )

  local expandedRadius =
    radius +
    self.clearance +
    self.cellSize * .5

  local minimumColumn =
    math.floor(
      (
        worldX -
        expandedRadius -
        self.originX
      ) /
      self.cellSize
    ) + 1

  local maximumColumn =
    math.floor(
      (
        worldX +
        expandedRadius -
        self.originX
      ) /
      self.cellSize
    ) + 1

  local minimumRow =
    math.floor(
      (
        worldZ -
        expandedRadius -
        self.originZ
      ) /
      self.cellSize
    ) + 1

  local maximumRow =
    math.floor(
      (
        worldZ +
        expandedRadius -
        self.originZ
      ) /
      self.cellSize
    ) + 1

  minimumColumn =
    clamp(
      minimumColumn,
      1,
      self.columns
    )

  maximumColumn =
    clamp(
      maximumColumn,
      1,
      self.columns
    )

  minimumRow =
    clamp(
      minimumRow,
      1,
      self.rows
    )

  maximumRow =
    clamp(
      maximumRow,
      1,
      self.rows
    )

  local radiusSquared =
    expandedRadius *
    expandedRadius

  for row = minimumRow,
    maximumRow
  do
    for column = minimumColumn,
      maximumColumn
    do
      local cellX, cellZ =
        self:cellToWorld(
          column,
          row
        )

      if
        distanceSquared(
          worldX,
          worldZ,
          cellX,
          cellZ
        ) <= radiusSquared
      then
        local key =
          self:getKey(
            column,
            row
          )

        self.dynamicBlocked[key] =
          true
      end
    end
  end
end


-- Перестраивает препятствия зданий.
function NavigationGrid:
  rebuildDynamicObstacles(
    buildings
  )
  self.dynamicBlocked = {}

  for _, building in ipairs(
    buildings or {}
  ) do
    if
      not building.removed
      and building.x
      and building.z
    then
      self:blockCircle(
        building.x,
        building.z,
        building.radius or 0
      )
    end
  end

  self.revision =
    self.revision + 1
end


-- Перестраивает препятствия боя.
function NavigationGrid:
  rebuildFromBattle(battle)
  local buildings = {}

  if
    battle
    and battle.buildingSystem
  then
    buildings =
      battle.buildingSystem
        .buildings or {}
  end

  self:rebuildDynamicObstacles(
    buildings
  )
end


-- Проверяет проходимость клетки.
function NavigationGrid:isWalkable(
  column,
  row,
  ignoreDynamic
)
  if not self:isInside(
    column,
    row
  ) then
    return false
  end

  local key =
    self:getKey(
      column,
      row
    )

  if self.staticBlocked[key] then
    return false
  end

  if
    not ignoreDynamic
    and self.dynamicBlocked[key]
  then
    return false
  end

  return true
end


-- Проверяет мировую позицию.
function NavigationGrid:
  isWorldWalkable(
    worldX,
    worldZ,
    ignoreDynamic
  )
  local column, row =
    self:worldToCell(
      worldX,
      worldZ
    )

  if not column then
    return false
  end

  return self:isWalkable(
    column,
    row,
    ignoreDynamic
  )
end


-- Ищет ближайшую свободную клетку.
function NavigationGrid:
  findNearestWalkable(
    sourceColumn,
    sourceRow,
    maximumRadius
  )
  if
    self:isWalkable(
      sourceColumn,
      sourceRow
    )
  then
    return
      sourceColumn,
      sourceRow
  end

  maximumRadius =
    maximumRadius
    or math.max(
      self.columns,
      self.rows
    )

  for radius = 1,
    maximumRadius
  do
    local minimumColumn =
      sourceColumn - radius

    local maximumColumn =
      sourceColumn + radius

    local minimumRow =
      sourceRow - radius

    local maximumRow =
      sourceRow + radius

    local bestColumn = nil
    local bestRow = nil
    local bestDistance = nil

    for row = minimumRow,
      maximumRow
    do
      for column = minimumColumn,
        maximumColumn
      do
        local onBorder =
          column == minimumColumn
          or column == maximumColumn
          or row == minimumRow
          or row == maximumRow

        if
          onBorder
          and self:isWalkable(
            column,
            row
          )
        then
          local dx =
            column - sourceColumn

          local dz =
            row - sourceRow

          local distance =
            dx * dx + dz * dz

          if
            not bestDistance
            or distance <
              bestDistance
          then
            bestColumn = column
            bestRow = row
            bestDistance = distance
          end
        end
      end
    end

    if bestColumn then
      return
        bestColumn,
        bestRow
    end
  end

  return nil, nil
end


-- Проверяет прямой отрезок.
function NavigationGrid:
  isSegmentWalkable(
    startX,
    startZ,
    finishX,
    finishZ
  )
  local dx =
    finishX - startX

  local dz =
    finishZ - startZ

  local distance =
    math.sqrt(
      dx * dx + dz * dz
    )

  if distance <= .001 then
    return self:isWorldWalkable(
      startX,
      startZ
    )
  end

  local step =
    math.max(
      self.cellSize * .35,
      .25
    )

  local sampleCount =
    math.max(
      1,
      math.ceil(
        distance / step
      )
    )

  for index = 0,
    sampleCount
  do
    local progress =
      index / sampleCount

    local sampleX =
      startX + dx * progress

    local sampleZ =
      startZ + dz * progress

    if
      not self:isWorldWalkable(
        sampleX,
        sampleZ
      )
    then
      return false
    end
  end

  return true
end


-- Возвращает номер версии препятствий.
function NavigationGrid:getRevision()
  return self.revision
end


return NavigationGrid