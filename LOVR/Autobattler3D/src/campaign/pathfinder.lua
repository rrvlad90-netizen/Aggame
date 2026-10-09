local Pathfinder = {}
Pathfinder.__index = Pathfinder


function Pathfinder.new(state)
  local self =
    setmetatable(
      {},
      Pathfinder
    )

  self.state = state
  self.connections = {}

  self:buildGraph()

  return self
end


function Pathfinder:addConnection(
  from,
  to,
  route
)
  self.connections[from] =
    self.connections[from] or {}

  self.connections[from][
    #self.connections[from] + 1
  ] = {
    to = to,
    route = route,
    days = route.days
  }
end


function Pathfinder:buildGraph()
  for _, route in ipairs(
    self.state.definition.routes
  ) do
    assert(
      self.state.citiesById[
        route.from
      ],
      'Unknown route city: ' ..
      tostring(route.from)
    )

    assert(
      self.state.citiesById[
        route.to
      ],
      'Unknown route city: ' ..
      tostring(route.to)
    )

    assert(
      type(route.days) == 'number'
      and route.days > 0,
      'Invalid route duration: ' ..
      tostring(route.id)
    )

    self:addConnection(
      route.from,
      route.to,
      route
    )

    if
      route.bidirectional
      ~= false
    then
      self:addConnection(
        route.to,
        route.from,
        route
      )
    end
  end
end


function Pathfinder:
  canEnterCity(
    ownerId,
    cityId,
    targetCityId
  )
  if cityId == targetCityId then
    return true
  end

  local city =
    self.state:getCity(cityId)

  return
    self.state:isAllied(
      ownerId,
      city.owner
    )
end


function Pathfinder:findPath(
  ownerId,
  startCityId,
  targetCityId
)
  if startCityId ==
    targetCityId
  then
    return {
      cityIds = {
        startCityId
      },

      segments = {},
      totalDays = 0
    }
  end

  self.state:getCity(startCityId)
  self.state:getCity(targetCityId)

  local distances = {
    [startCityId] = 0
  }

  local previous = {}
  local visited = {}

  while true do
    local current = nil
    local currentDistance = nil

    for cityId, distance in pairs(
      distances
    ) do
      if
        not visited[cityId]
        and (
          not currentDistance
          or distance <
            currentDistance
        )
      then
        current = cityId
        currentDistance = distance
      end
    end

    if not current then
      break
    end

    if current == targetCityId then
      break
    end

    visited[current] = true

    for _, connection in ipairs(
      self.connections[current]
      or {}
    ) do
      local nextCity =
        connection.to

      if self:canEnterCity(
        ownerId,
        nextCity,
        targetCityId
      ) then
        local nextDistance =
          currentDistance +
          connection.days

        if
          distances[nextCity] == nil
          or nextDistance <
            distances[nextCity]
        then
          distances[nextCity] =
            nextDistance

          previous[nextCity] = {
            cityId = current,
            connection = connection
          }
        end
      end
    end
  end

  if not distances[
    targetCityId
  ] then
    return nil
  end

  local reversedSegments = {}
  local cursor = targetCityId

  while cursor ~= startCityId do
    local entry = previous[cursor]

    if not entry then
      return nil
    end

    reversedSegments[
      #reversedSegments + 1
    ] = {
      from = entry.cityId,
      to = cursor,

      routeId =
        entry.connection.route.id,

      days =
        entry.connection.days
    }

    cursor = entry.cityId
  end

  local segments = {}
  local cityIds = {
    startCityId
  }

  for index =
    #reversedSegments,
    1,
    -1
  do
    local segment =
      reversedSegments[index]

    segments[
      #segments + 1
    ] = segment

    cityIds[
      #cityIds + 1
    ] = segment.to
  end

  return {
    cityIds = cityIds,
    segments = segments,

    totalDays =
      distances[targetCityId]
  }
end


return Pathfinder