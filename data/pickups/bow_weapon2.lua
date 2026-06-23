return {
    id = "bow_weapon",

    kind = "weapon",

    weaponPlayerId = "dduck_bow",
	
	-- NAME заменится на id базового игрока:
    -- warrior -> warrior_bow
    -- elf -> elf_bow
    -- mage -> mage_bow
    weaponPlayerId = "NAME_bow",
	
	
	
    weaponUses = 10,

    image = nil,

    canvas = {
        width = 32,
        height = 32
    },

    offset = {
        x = 16,
        y = 16
    },

    bbox = {
        x = 0,
        y = 0,
        w = 32,
        h = 32
    },

    color = {0.8, 0.5, 0.15},

    shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 42,
    shadowHeight = 8,
    shadowOffsetY = 2
}