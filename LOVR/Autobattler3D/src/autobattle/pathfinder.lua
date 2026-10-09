local Pathfinder = {}
Pathfinder.__index = Pathfinder


local SQRT_TWO =
  math.sqrt(2)


local directions = {
  { 1, 0, 1 },
  { -1, 0, 1 },
  { 0, 1, 1 },
  { 0, -1, 1 },

  { 1, 1, SQRT_TWO },
  { 1, -1, SQRT_TWO },
  { -1, 1, SQRT_TWO },
  { -1, -1, SQRT_TWO }
}


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


local function getHeuristic(
  firstColumn,
  firstRow,
  secondColumn,
  secondRow
)
  local dx =
    math.abs(
      secondColumn -
      firstColumn
    )

  local dz =
    math.abs(
      secondRow -
      firstRow
    )

  local diagonal =
    math.min(dx, dz)

  local straight =
    math.max(dx, dz) -
    diagonal

  return
    diagonal * SQRT_TWO +
    straight
end


-- Добавляет элемент в минимальную кучу.
local function heapPush(
  heap,
  item
)
  heap[#heap + 1] = item

  local index = #heap

  while index > 1 do
    local parent =
      math.floor(index * .5)

    if
      heap[parent].score <=
      item.score
    then
      break
    end

    heap[index] = heap[parent]
    index = parent
  end

  heap[index] = item
end


-- Извлекает лучший элемент.
local function heapPop(heap)
  local count = #heap

  if count == 0 then
    return nil
  end

  local result = heap[1]
  local last = heap[count]

  heap[count] = nil
  count = count - 1

  if count == 0 then
    return result
  end

  local index = 1

  while true do
    local left = index * 2
    local right = left + 1

    if left > count then
      break
    end

    local child = left

    if
      right <= count
      and heap[right].score <
        heap[left].score
    then
      child = right
    end

    if
      heap[child].score >=
      last.score
    then
      break
    end

    heap[index] = heap[child]
    index = child
  end

  heap[index] = last

  return result
end


-- Создаёт поиск пути.
function Pathfinder.new(
  navigationGrid,
  config
)
  assert(
    navigationGrid,
    'Pathfinder has no navigation grid'
  )

  local self =
    setmetatable({}, Pathfinder)

  self.grid = navigationGrid
  self.config = config or {}

  self.maximumVisited =
    self.config.maximumVisited
    or 20000

  self.nearestCellRadius =
    self.config.nearestCellRadius
    or 24

  self.approachSamples =
    self.config.approachSamples
    or 16

  return self
end


-- Возвращает координаты по ключу.
function Pathfinder:keyToCell(key)
  local zeroBased = key - 1

  local column =
    zeroBased %
    self.grid.columns + 1

  local row =
    math.floor(
      zeroBased /
      self.grid.columns
    ) + 1

  return column, row
end


-- Проверяет диагональный переход.
function Pathfinder:
  canUseDirection(
    column,
    row,
    direction
  )
  local dx = direction[1]
  local dz = direction[2]

  local targetColumn =
    column + dx

  local targetRow =
    row + dz

  if
    not self.grid:isWalkable(
      targetColumn,
      targetRow
    )
  then
    return false
  end

  -- Запрещает срезать угол между
  -- двумя непроходимыми клетками.
  if dx ~= 0 and dz ~= 0 then
    if
      not self.grid:isWalkable(
        column + dx,
        row
      )
      or not self.grid:isWalkable(
        column,
        row + dz
      )
    then
      return false
    end
  end

  return true
end


-- Восстанавливает путь по клеткам.
function Pathfinder:
  reconstructCells(
    cameFrom,
    finishKey
  )
  local reversed = {}
  local currentKey = finishKey

  while currentKey do
    local column, row =
      self:keyToCell(currentKey)

    reversed[#reversed + 1] = {
      column = column,
      row = row
    }

    currentKey =
      cameFrom[currentKey]
  end

  local result = {}

  for index = #reversed,
    1,
    -1
  do
    result[#result + 1] =
      reversed[index]
  end

  return result
end


-- Выполняет A* между клетками.
function Pathfinder:findCellPath(
  startColumn,
  startRow,
  finishColumn,
  finishRow
)
  local grid = self.grid

  if
    not grid:isWalkable(
      startColumn,
      startRow
    )
    or not grid:isWalkable(
      finishColumn,
      finishRow
    )
  then
    return nil, 'blocked'
  end

  local startKey =
    grid:getKey(
      startColumn,
      startRow
    )

  local finishKey =
    grid:getKey(
      finishColumn,
      finishRow
    )

  if startKey == finishKey then
    return {
      {
        column = startColumn,
        row = startRow
      }
    }
  end

  local openHeap = {}
  local cameFrom = {}
  local costFromStart = {}
  local closed = {}

  costFromStart[startKey] = 0

  heapPush(
    openHeap,
    {
      key = startKey,
      column = startColumn,
      row = startRow,
      cost = 0,

      score =
        getHeuristic(
          startColumn,
          startRow,
          finishColumn,
          finishRow
        )
    }
  )

  local visited = 0

  while #openHeap > 0 do
    local current =
      heapPop(openHeap)

    if not closed[current.key] then
      closed[current.key] = true
      visited = visited + 1

      if
        visited >
        self.maximumVisited
      then
        return nil, 'search_limit'
      end

      if current.key == finishKey then
        return
          self:reconstructCells(
            cameFrom,
            finishKey
          )
      end

      for _, direction in ipairs(
        directions
      ) do
        if
          self:canUseDirection(
            current.column,
            current.row,
            direction
          )
        then
          local nextColumn =
            current.column +
            direction[1]

          local nextRow =
            current.row +
            direction[2]

          local nextKey =
            grid:getKey(
              nextColumn,
              nextRow
            )

          if not closed[nextKey] then
            local movementCost =
              direction[3] *
              grid.cellSize

            local newCost =
              current.cost +
              movementCost

            local oldCost =
              costFromStart[nextKey]

            if
              not oldCost
              or newCost < oldCost
            then
              costFromStart[nextKey] =
                newCost

              cameFrom[nextKey] =
                current.key

              local heuristic =
                getHeuristic(
                  nextColumn,
                  nextRow,
                  finishColumn,
                  finishRow
                ) * grid.cellSize

              heapPush(
                openHeap,
                {
                  key = nextKey,
                  column = nextColumn,
                  row = nextRow,
                  cost = newCost,

                  score =
                    newCost +
                    heuristic
                }
              )
            end
          end
        end
      end
    end
  end

  return nil, 'unreachable'
end


-- Переводит путь клеток в мировой.
function Pathfinder:
  cellsToWorldPath(
    cells,
    startX,
    startZ,
    finishX,
    finishZ
  )
  local points = {
    {
      x = startX,
      z = startZ
    }
  }

  for index = 2, #cells do
    local cell = cells[index]

    local worldX, worldZ =
      self.grid:cellToWorld(
        cell.column,
        cell.row
      )

    points[#points + 1] = {
      x = worldX,
      z = worldZ
    }
  end

  local last =
    points[#points]

  if
    self.grid:isWorldWalkable(
      finishX,
      finishZ
    )
    and self.grid:
      isSegmentWalkable(
        last.x,
        last.z,
        finishX,
        finishZ
      )
  then
    if
      distanceSquared(
        last.x,
        last.z,
        finishX,
        finishZ
      ) > .01
    then
      points[#points + 1] = {
        x = finishX,
        z = finishZ
      }
    end
  end

  return points
end


-- Удаляет лишние повороты.
function Pathfinder:
  smoothPath(points)
  if #points <= 2 then
    return points
  end

  local result = {
    points[1]
  }

  local sourceIndex = 1

  while sourceIndex < #points do
    local selectedIndex =
      sourceIndex + 1

    for candidateIndex =
      #points,
      sourceIndex + 1,
      -1
    do
      local source =
        points[sourceIndex]

      local candidate =
        points[candidateIndex]

      if
        self.grid:
          isSegmentWalkable(
            source.x,
            source.z,
            candidate.x,
            candidate.z
          )
      then
        selectedIndex =
          candidateIndex

        break
      end
    end

    result[#result + 1] =
      points[selectedIndex]

    sourceIndex = selectedIndex
  end

  return result
end


-- Удаляет стартовую позицию пути.
function Pathfinder:
  removeStartPoint(points)
  local result = {}

  for index = 2, #points do
    result[#result + 1] =
      points[index]
  end

  return result
end


-- Ограничивает точку границами поля.
function Pathfinder:
  clampWorldPoint(
    worldX,
    worldZ
  )
  local grid = self.grid
  local padding =
    grid.cellSize * .5

  local minimumX =
    grid.originX + padding

  local maximumX =
    grid.originX +
    grid.width -
    padding

  local minimumZ =
    grid.originZ + padding

  local maximumZ =
    grid.originZ +
    grid.length -
    padding

  return
    math.max(
      minimumX,
      math.min(maximumX, worldX)
    ),
    math.max(
      minimumZ,
      math.min(maximumZ, worldZ)
    )
end


-- Ищет путь между мировыми точками.
function Pathfinder:findPath(
  startX,
  startZ,
  finishX,
  finishZ
)
  finishX, finishZ =
    self:clampWorldPoint(
      finishX,
      finishZ
    )

  local startColumn, startRow =
    self.grid:worldToCell(
      startX,
      startZ
    )

  local finishColumn, finishRow =
    self.grid:worldToCell(
      finishX,
      finishZ
    )

  if
    not startColumn
    or not finishColumn
  then
    return nil, 'outside_map'
  end

  startColumn, startRow =
    self.grid:
      findNearestWalkable(
        startColumn,
        startRow,
        self.nearestCellRadius
      )

  finishColumn, finishRow =
    self.grid:
      findNearestWalkable(
        finishColumn,
        finishRow,
        self.nearestCellRadius
      )

  if not startColumn then
    return nil, 'start_blocked'
  end

  if not finishColumn then
    return nil, 'finish_blocked'
  end

  local cells, reason =
    self:findCellPath(
      startColumn,
      startRow,
      finishColumn,
      finishRow
    )

  if not cells then
    return nil, reason
  end

  local worldPoints =
    self:cellsToWorldPath(
      cells,
      startX,
      startZ,
      finishX,
      finishZ
    )

  local smoothed =
    self:smoothPath(worldPoints)

  return
    self:removeStartPoint(
      smoothed
    )
end


-- Возвращает длину пути.
function Pathfinder:getPathLength(
  startX,
  startZ,
  path
)
  local total = 0
  local previousX = startX
  local previousZ = startZ

  for _, point in ipairs(
    path or {}
  ) do
    local dx =
      point.x - previousX

    local dz =
      point.z - previousZ

    total =
      total +
      math.sqrt(
        dx * dx + dz * dz
      )

    previousX = point.x
    previousZ = point.z
  end

  return total
end


-- Ищет путь к дистанции атаки.
function Pathfinder:
  findPathToRange(
    startX,
    startZ,
    targetX,
    targetZ,
    desiredRange
  )
  desiredRange =
    math.max(
      desiredRange or 0,
      self.grid.cellSize
    )

  local currentDistanceSquared =
    distanceSquared(
      startX,
      startZ,
      targetX,
      targetZ
    )

  if
    currentDistanceSquared <=
    desiredRange * desiredRange
  then
    return {}
  end

  local bestPath = nil
  local bestLength = nil

  for index = 1,
    self.approachSamples
  do
    local angle =
      (
        index - 1
      ) /
      self.approachSamples *
      math.pi * 2

    local candidateX =
      targetX +
      math.cos(angle) *
      desiredRange

    local candidateZ =
      targetZ +
      math.sin(angle) *
      desiredRange

    if
      self.grid:isWorldWalkable(
        candidateX,
        candidateZ
      )
    then
      local path =
        self:findPath(
          startX,
          startZ,
          candidateX,
          candidateZ
        )

      if path then
        local length =
          self:getPathLength(
            startX,
            startZ,
            path
          )

        if
          not bestLength
          or length < bestLength
        then
          bestPath = path
          bestLength = length
        end
      end
    end
  end

  if bestPath then
    return bestPath
  end

  return self:findPath(
    startX,
    startZ,
    targetX,
    targetZ
  )
end


return Pathfinder