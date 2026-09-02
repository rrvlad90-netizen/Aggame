local SpatialGrid = {}
SpatialGrid.__index = SpatialGrid

local KEY_OFFSET = 32768
local KEY_SCALE = 65536


-- Создаёт пространственную сетку.
function SpatialGrid.new(cellSize)
  local self =
    setmetatable({}, SpatialGrid)

  self.cellSize = cellSize
  self.cells = {}
  self.usedKeys = {}

  return self
end


-- Преобразует координаты ячейки в ключ.
local function makeKey(cellX, cellZ)
  return
    (cellX + KEY_OFFSET) *
    KEY_SCALE +
    (cellZ + KEY_OFFSET)
end


-- Возвращает координату ячейки.
function SpatialGrid:getCellCoordinate(value)
  return math.floor(
    value / self.cellSize
  )
end


-- Очищает сетку без пересоздания объекта.
function SpatialGrid:clear()
  for _, key in ipairs(self.usedKeys) do
    self.cells[key] = nil
  end

  self.usedKeys = {}
end


-- Возвращает ячейку или создаёт её.
function SpatialGrid:getOrCreateCell(
  cellX,
  cellZ
)
  local key =
    makeKey(cellX, cellZ)

  local cell =
    self.cells[key]

  if cell then
    return cell
  end

  cell = {}
  self.cells[key] = cell

  self.usedKeys[
    #self.usedKeys + 1
  ] = key

  return cell
end


-- Добавляет бойца в сетку.
function SpatialGrid:insert(unit)
  local cellX =
    self:getCellCoordinate(unit.x)

  local cellZ =
    self:getCellCoordinate(unit.z)

  local cell =
    self:getOrCreateCell(
      cellX,
      cellZ
    )

  cell[#cell + 1] = unit

  unit.gridCellX = cellX
  unit.gridCellZ = cellZ
end


-- Перестраивает сетку живых бойцов.
function SpatialGrid:rebuild(units)
  self:clear()

  for _, unit in ipairs(units) do
    if unit:isSpatiallyActive() then
      self:insert(unit)
    end
  end
end


-- Перебирает бойцов возле позиции.
function SpatialGrid:forEachNearby(
  x,
  z,
  radius,
  callback
)
  local minimumCellX =
    self:getCellCoordinate(x - radius)

  local maximumCellX =
    self:getCellCoordinate(x + radius)

  local minimumCellZ =
    self:getCellCoordinate(z - radius)

  local maximumCellZ =
    self:getCellCoordinate(z + radius)

  for cellX =
    minimumCellX,
    maximumCellX
  do
    for cellZ =
      minimumCellZ,
      maximumCellZ
    do
      local key =
        makeKey(cellX, cellZ)

      local cell =
        self.cells[key]

      if cell then
        for _, unit in ipairs(cell) do
          callback(unit)
        end
      end
    end
  end
end


-- Ищет ближайшего подходящего бойца.
function SpatialGrid:findNearest(
  x,
  z,
  radius,
  predicate
)
  local nearest = nil
  local nearestDistanceSquared =
    radius * radius

  self:forEachNearby(
    x,
    z,
    radius,

    function(unit)
      if predicate(unit) then
        local dx = unit.x - x
        local dz = unit.z - z

        local distanceSquared =
          dx * dx + dz * dz

        if
          distanceSquared <=
          nearestDistanceSquared
        then
          nearest = unit

          nearestDistanceSquared =
            distanceSquared
        end
      end
    end
  )

  return nearest,
    nearestDistanceSquared
end


return SpatialGrid