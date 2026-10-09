local MapList =
  require('maps.maplist')

local MapRegistry = {}
MapRegistry.__index = MapRegistry


-- Создаёт реестр игровых карт.
function MapRegistry.new()
  local self =
    setmetatable({}, MapRegistry)

  self.maps = {}
  self.list = {}

  for _, map in ipairs(MapList) do
    self:register(map)
  end

  return self
end


-- Проверяет и регистрирует карту.
function MapRegistry:register(map)
  assert(
    type(map.id) == 'string',
    'Map has no id'
  )

  assert(
    type(map.name) == 'string',
    'Map has no name: ' ..
    map.id
  )

  assert(
    type(map.field) == 'table',
    'Map has no field: ' ..
    map.id
  )

  assert(
    type(map.squads) == 'table',
    'Map has no squads: ' ..
    map.id
  )

  assert(
    not self.maps[map.id],
    'Duplicate map id: ' ..
    map.id
  )

  self.maps[map.id] = map
  self.list[#self.list + 1] = map
end


-- Возвращает карту по идентификатору.
function MapRegistry:get(mapId)
  return assert(
    self.maps[mapId],
    'Unknown map: ' ..
    tostring(mapId)
  )
end


-- Возвращает список карт для меню.
function MapRegistry:getAll()
  return self.list
end


-- Проверяет существование карты.
function MapRegistry:has(mapId)
  return self.maps[mapId] ~= nil
end


return MapRegistry