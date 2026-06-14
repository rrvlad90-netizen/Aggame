return {
    id = "level1",

    music = nil,

    bounds = {
        left = 0,
        right = 2200,
        top = 0,
        bottom = 600
    },

    playerStart = {
        x = 120,
        y = 455
    },

    backgrounds = {
        {
            image = nil,
            scrollFactor = 0.15
        },
        {
            image = nil,
            scrollFactor = 0.35
        },
        {
            image = nil,
            scrollFactor = 0.65
        },
        {
            image = nil,
            scrollFactor = 0.95
        },
        {
            image = nil,
            scrollFactor = 1.15,
            layer = "front"
        }
    },

    ground = {
        image = nil,
        y = 455,
        visualY = 455,
        visualHeight = 145
    },

    actors = {
        {
            id = "goblin",
            x = 620,
            y = 455,
            appearDistance = 600
        },
        {
            id = "goblin",
            x = 920,
            y = 455,
            appearDistance = 600
        }
    },

    platforms = {
        {
            id = "wood_platform",
            x = 420,
            y = 340
        }
    },

    pickups = {
        {
            id = "health_small",
            x = 520,
            y = 420
        },
        {
            id = "ammo_small",
            x = 720,
            y = 420
        }
    },

    decors = {
        {
            id = "rock_small",
            x = 360,
            y = 455,
            layer = "back"
        }
    },

    effects = {},

    levelEnd = {
        x = 2000,
        y = 455,

        canvas = {
            width = 48,
            height = 80
        },

        offset = {
            x = 24,
            y = 80
        },

        bbox = {
            x = 0,
            y = 0,
            w = 48,
            h = 80
        },

        image = nil
    }
}