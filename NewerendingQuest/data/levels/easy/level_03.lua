return {
    id = "easy_dungeon_01",
    name = "Abandoned Dungeon",

    biome = "dungeon",
    seed = 3001,
    generationMode = "procedural",

    preview = {
        image =
            "assets/images/previews/dungeon.png",

        fadeOutDuration = 0.5,
        displayDuration = 1.5,
        fadeInDuration = 0.5
    },

    -- Размер игровой области в метрах.
    size = {
        width = 70,
        length = 160
    },

    generator = {
        objectCount = 240,

        columnChance = 0.28,
        rockChance = 0.48,
        mushroomChance = 0.24,

        -- Декорации могут находиться за краями поля.
        decorationWidth = 100,

        -- Гарантированный свободный путь.
        safeCorridorWidth = 8,

        startSafeRadius = 8,
        finishSafeRadius = 8
    },

    visuals = {
        column = {
            scale = 1,
            alpha = 1,
            collisionRadius = 1.25
        },

        rock = {
            scale = 1,
            alpha = 1,
            collisionRadius = 1.1
        },

        mushroom = {
            scale = 1,
            alpha = 1
        }
    },

    assets = {
        music = nil
    }
}