local Dungeon = {
    id = "dungeon",

    groundImage = "dungeonFloor",

    columnGroup = "dungeonColumns",
    rockGroup = "dungeonRocks",
    mushroomGroup = "dungeonMushrooms",

    groundColor = {
        0.12,
        0.1,
        0.09
    },

    groundTextureWorldSize = 140,

    visuals = {
        column = {
            spriteHeight = 180,
            scale = 1,
            alpha = 1,

            collisionRadius = 1.25,

            offset = {
                x = 0,
                y = 0
            }
        },

        rock = {
            spriteHeight = 65,
            scale = 1,
            alpha = 1,

            collisionRadius = 1.1,

            offset = {
                x = 0,
                y = 0
            }
        },

        mushroom = {
            spriteHeight = 38,
            scale = 1,
            alpha = 1,

            collisionRadius = 0,

            offset = {
                x = 0,
                y = 0
            }
        }
    }
}

Dungeon.columnImages = {}
Dungeon.rockImages = {}
Dungeon.mushroomImages = {}

-- Формирует пять вариантов колонн.
for index = 1, 5 do
    Dungeon.columnImages[index] =
        string.format(
            "assets/images/biomes/dungeon/columns/column_%02d.png",
            index
        )
end

-- Формирует десять вариантов камней.
for index = 1, 10 do
    Dungeon.rockImages[index] =
        string.format(
            "assets/images/biomes/dungeon/rocks/rock_%02d.png",
            index
        )
end

-- Формирует пять вариантов грибов.
for index = 1, 5 do
    Dungeon.mushroomImages[index] =
        string.format(
            "assets/images/biomes/dungeon/mushrooms/mushroom_%02d.png",
            index
        )
end

return Dungeon