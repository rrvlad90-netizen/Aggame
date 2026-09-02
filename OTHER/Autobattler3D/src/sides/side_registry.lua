local SideList =
  require('sides.sidelist')

local UnitSlots =
  require('src.units.unit_slots')

local SideRegistry = {}
SideRegistry.__index = SideRegistry


-- Создаёт реестр игровых сторон.
function SideRegistry.new(unitRegistry)
  local self =
    setmetatable({}, SideRegistry)

  self.unitRegistry = unitRegistry
  self.sides = {}
  self.list = {}

  for _, side in ipairs(SideList) do
    self:register(side)
  end

  return self
end


-- Проверяет и регистрирует сторону.
function SideRegistry:register(side)
  assert(
    type(side.id) == 'string',
    'Side has no id'
  )

  assert(
    type(side.name) == 'string',
    'Side has no name: ' ..
    side.id
  )

  assert(
    not self.sides[side.id],
    'Duplicate side id: ' ..
    side.id
  )

  side.units = side.units or {}

  for _, slot in ipairs(UnitSlots) do
    local unitId =
      side.units[slot.id]
      or 'empty_unit'

    side.units[slot.id] = unitId

    if unitId ~= 'empty_unit' then
      local definition =
        self.unitRegistry:get(unitId)

      assert(
        definition.slot == slot.id,
        string.format(
          'Unit "%s" cannot occupy slot "%s"',
          unitId,
          slot.id
        )
      )
    end
  end

  self.sides[side.id] = side
  self.list[#self.list + 1] = side
end


-- Возвращает сторону по идентификатору.
function SideRegistry:get(sideId)
  return assert(
    self.sides[sideId],
    'Unknown side: ' ..
    tostring(sideId)
  )
end


-- Возвращает список сторон для меню.
function SideRegistry:getAll()
  return self.list
end


-- Возвращает юнита выбранного слота.
function SideRegistry:resolveUnit(
  sideId,
  slotId
)
  local side = self:get(sideId)

  local unitId =
    side.units[slotId]
    or 'empty_unit'

  if unitId == 'empty_unit' then
    return nil
  end

  return self.unitRegistry:get(unitId)
end


return SideRegistry