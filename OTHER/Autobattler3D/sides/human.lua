local UnitSlots =
  require('src.units.unit_slots')

local units = {}

for _, slot in ipairs(UnitSlots) do
  units[slot.id] = 'empty_unit'
end

units.light_infantry = 'human_light_infantry'

units.archer = 'dwarf_with_rifle'

units.cavalry = 'human_cavalry'

units.giant1 = 'human_ent'

units.catapult = 'human_mortar'

units.dragon1 = 'human_sorceress'

return {
  id = 'human',
  name = 'Human',

  author = 'Autobattler3D',

  description =
    'A disciplined human army.',

  preview = nil,
  units = units
}