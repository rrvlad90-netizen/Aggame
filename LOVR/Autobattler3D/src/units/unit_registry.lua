local UnitList =
  require('units.unitlist')

local UnitRegistry = {}
UnitRegistry.__index = UnitRegistry


-- Создаёт реестр полных определений юнитов.
function UnitRegistry.new()
  local self =
    setmetatable({}, UnitRegistry)

  self.definitions = {}

  for _, definition in ipairs(UnitList) do
    assert(
      type(definition.id) == 'string',
      'Unit definition has no id'
    )

    assert(
      type(definition.slot) == 'string',
      'Unit definition has no slot: ' ..
      definition.id
    )

    assert(
      not self.definitions[definition.id],
      'Duplicate unit id: ' ..
      definition.id
    )

    self.definitions[definition.id] =
      definition
  end

  return self
end


-- Возвращает полное определение юнита.
function UnitRegistry:get(unitId)
  return assert(
    self.definitions[unitId],
    'Unknown unit id: ' ..
    tostring(unitId)
  )
end


-- Проверяет существование определения.
function UnitRegistry:has(unitId)
  return
    self.definitions[unitId] ~= nil
end


return UnitRegistry