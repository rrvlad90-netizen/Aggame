local UnitSlots =
  require('src.units.unit_slots')

local units = {}

for _, slot in ipairs(UnitSlots) do
  units[slot.id] = 'empty_unit'
end

units.light_infantry =
  'orc_light_infantry'

units.archer =
  'troll_with_axes'
  
units.cavalry = 'orc_cavalry'  

units.giant1 = 'orc_ogre'

units.catapult = 'orc_catapult'

units.dragon1 = 'orc_red_dragon'

return {
  id = 'orcs',
  name = 'Orcs',

  author = 'Autobattler3D',

  description =
    'An aggressive orc warband.',

  preview = nil,
  units = units
}