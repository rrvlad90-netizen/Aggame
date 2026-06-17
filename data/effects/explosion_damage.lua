return {
    id = "explosion_damage",

    damage = 1,
    deathType = "heavy",

    damageTargets = {
        player = true,
        npc = true
    },

    damageOnce = true,

    hidden = false,

    canvas = {
        width = 50,
        height = 36
    },

    offset = {
        x = 0,
        y = 150
    },

    hitbox = {
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

            fireFirstFrameEvents = true,

            frames = {
                "assets/effects/explosion_1.png",
                "assets/effects/explosion_2.png",
                "assets/effects/explosion_3.png",
                "assets/effects/explosion_4.png"
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