return {
    id = "checkpoint_flag",

    layer = "middle",

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

    respawnX = nil,
    respawnY = nil,

    activateSound = nil,

    color = {0.2, 0.8, 1.0},

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.16,
            frames = {
                {}
                -- "assets/checkpoints/checkpoint_idle_1.png"
            }
        },

        active = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                {}
                -- "assets/checkpoints/checkpoint_active_1.png"
            }
        }
    }
}