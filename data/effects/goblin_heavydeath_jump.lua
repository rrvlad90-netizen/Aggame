return {
    id = "goblin_heavydeath_jump",

    image = nil,

    canvas = {
        width = 60,
        height = 60
    },

    offset = {
        x = 30,
        y = 60
    },

    bbox = {
        x = 0,
        y = 0,
        w = 60,
        h = 60
    },

    alpha = 1,

    -- Heavy death corpse летит по дуге.
    vx = 260,
    vy = -520,
    gravity = 1000,

    collideGround = true,
    collidePlatforms = true,

    removeOnImpact = true,
    impactEffect = "explosion",

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                nil
            }
        }
    }
}