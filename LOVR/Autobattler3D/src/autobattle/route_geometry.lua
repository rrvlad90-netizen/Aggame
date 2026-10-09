local RouteGeometry = {}


-- Ограничивает значение диапазоном.
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


-- Вычисляет накопленную длину маршрута.
function RouteGeometry.getCumulative(
  route
)
  local points = route.points
  local cumulative = {}

  if #points == 0 then
    return cumulative
  end

  cumulative[1] = 0

  for index = 2, #points do
    local previous =
      points[index - 1]

    local point =
      points[index]

    local dx =
      point.x - previous.x

    local dz =
      point.z - previous.z

    cumulative[index] =
      cumulative[index - 1] +
      math.sqrt(
        dx * dx + dz * dz
      )
  end

  return cumulative
end


-- Проецирует позицию на маршрут.
function RouteGeometry.projectProgress(
  route,
  x,
  z
)
  local points = route.points

  if #points == 0 then
    return 0
  end

  if #points == 1 then
    return 0
  end

  local cumulative =
    RouteGeometry.getCumulative(
      route
    )

  local bestDistance = nil
  local bestProgress = 0

  for index = 1, #points - 1 do
    local first = points[index]
    local second = points[index + 1]

    local segmentX =
      second.x - first.x

    local segmentZ =
      second.z - first.z

    local lengthSquared =
      segmentX * segmentX +
      segmentZ * segmentZ

    if lengthSquared > .0001 then
      local raw =
        (
          (x - first.x) *
            segmentX +
          (z - first.z) *
            segmentZ
        ) / lengthSquared

      local progress =
        clamp(raw, 0, 1)

      local projectedX =
        first.x +
        segmentX * progress

      local projectedZ =
        first.z +
        segmentZ * progress

      local dx = x - projectedX
      local dz = z - projectedZ

      local distanceSquared =
        dx * dx + dz * dz

      if
        not bestDistance
        or distanceSquared <
          bestDistance
      then
        local length =
          math.sqrt(
            lengthSquared
          )

        bestDistance =
          distanceSquared

        bestProgress =
          cumulative[index] +
          length * progress
      end
    end
  end

  -- Позволяет определить положение
  -- перед первой точкой маршрута.
  do
    local first = points[1]
    local second = points[2]

    local segmentX =
      second.x - first.x

    local segmentZ =
      second.z - first.z

    local lengthSquared =
      segmentX * segmentX +
      segmentZ * segmentZ

    if lengthSquared > .0001 then
      local raw =
        (
          (x - first.x) *
            segmentX +
          (z - first.z) *
            segmentZ
        ) / lengthSquared

      if raw < 0 then
        local projectedX =
          first.x +
          segmentX * raw

        local projectedZ =
          first.z +
          segmentZ * raw

        local dx = x - projectedX
        local dz = z - projectedZ

        local distanceSquared =
          dx * dx + dz * dz

        if
          not bestDistance
          or distanceSquared <
            bestDistance
        then
          bestDistance =
            distanceSquared

          bestProgress =
            raw *
            math.sqrt(
              lengthSquared
            )
        end
      end
    end
  end

  return bestProgress
end


-- Возвращает медианный прогресс отряда.
function RouteGeometry.getSquadProgress(
  squad,
  route
)
  local values = {}

  for _, unit in ipairs(
    squad.units
  ) do
    if unit:isTargetable() then
      values[#values + 1] =
		RouteGeometry.projectProgress(
            route,
            unit.x,
            unit.z
          )
    end
  end

  if #values == 0 then
    return
      RouteGeometry.getSquadProgress(
          route,
          squad.startX,
          squad.startZ
        )
  end

  table.sort(values)

  local middle =
    math.floor(
      (#values + 1) / 2
    )

  if #values % 2 == 1 then
    return values[middle]
  end

  return
    (
      values[middle] +
      values[middle + 1]
    ) / 2
end


-- Возвращает первую непройденную точку.
function RouteGeometry.getEntryPointIndex(
  squad,
  route,
  maximumIndex
)
  local points = route.points

  if #points <= 1 then
    return 1
  end

  maximumIndex =
    math.min(
      maximumIndex or #points,
      #points
    )

  local progress =
    RouteGeometry.getSquadProgress(
        squad,
        route
      )

  local cumulative =
    RouteGeometry.getCumulative(
      route
    )

  local tolerance =
    squad.gameConfig.navigation
      .waypointRadius
    or 1

  if progress < -tolerance then
    return 1
  end

  for index = 2, maximumIndex do
    if
      cumulative[index] >
      progress + tolerance
    then
      return index
    end
  end

  return maximumIndex
end


return RouteGeometry