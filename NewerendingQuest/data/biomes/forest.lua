local Forest = {
    id = "forest",

    groundImage = "forestGround",

    treeGroup = "forestTrees",
    bushGroup = "forestBushes",
    rockGroup = "forestRocks",
    mushroomGroup = "forestMushrooms",

    groundColor = {
        0.28,
        0.48,
        0.24
    },

    groundTextureWorldSize = 160,

    visuals = {
        tree = {
            spriteHeight = 150,
            scale = 1,
            alpha = 1,
            collisionRadius = 1.4,

            offset = {
                x = 0,
                y = 0
            }
        },

        bush = {
            spriteHeight = 58,
            scale = 1,
            alpha = 1,
            collisionRadius = 0,

            offset = {
                x = 0,
                y = 0
            }
        },

        rock = {
            spriteHeight = 62,
            scale = 1,
            alpha = 1,
            collisionRadius = 1,

            offset = {
                x = 0,
                y = 0
            }
        },

        mushroom = {
            spriteHeight = 34,
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

Forest.treeImages = {}
Forest.bushImages = {}
Forest.rockImages = {}
Forest.mushroomImages = {}

-- Формирует варианты лесных объектов.
for index = 1, 10 do
    Forest.treeImages[index] =
        string.format(
            "assets/images/biomes/forest/trees/tree_%02d.png",
            index
        )

    Forest.bushImages[index] =
        string.format(
            "assets/images/biomes/forest/bushes/bush_%02d.png",
            index
        )

    Forest.rockImages[index] =
        string.format(
            "assets/images/biomes/forest/rocks/rock_%02d.png",
            index
        )
end

-- Грибов используется пять видов.
for index = 1, 5 do
    Forest.mushroomImages[index] =
        string.format(
            "assets/images/biomes/forest/mushrooms/mushroom_%02d.png",
            index
        )
end

return Forest