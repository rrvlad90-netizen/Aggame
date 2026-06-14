return {
    id = "explosion",

    damage = 0,
    deathType = "normal",

    damageTargets = {},

    hidden = false,

    canvas = {
        width = 64,
        height = 64
    },

    offset = {
        x = 32,
        y = 32
    },

    bbox = {
        x = 0,
        y = 0,
        w = 64,
        h = 64
    },

    alpha = 0.75,

    animations = {
        idle = {
            loop = false,
            frameDuration = 0.08,
            frames = {
                nil,
                nil,
                nil,
                nil
            },
            events = {
                {
                    frame = 1,
                    type = "playSound",
                    sound = "assets/sounds/explosion.wav"
                }
            }
        }
    }
}