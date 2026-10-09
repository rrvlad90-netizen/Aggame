local UnitSlots =
  require('src.units.unit_slots')

local units = {}

for _, slot in ipairs(UnitSlots) do
  units[slot.id] = 'empty_unit'
end

units.giant1 =
  'monster_stone_ogre'


return {
  id = 'monsters',
  name = 'Monsters',

  author = 'Autobattler3D',

  description =
    'Neutral creatures guarding strategic points.',

  preview = nil,
  selectable = false,

  campaignColor = {
    .55,
    .55,
    .55,
    1
  },

  units = units
}