return {
    id = "stone",

    damage = 1,
    deathType = "heavy",

    damageTargets = {
        enemy = true
    },

    flight = "arc",

    -- Пока полёт задаём напрямую через vx/vy/gravity.
    -- Позже можно будет сделать красивую обработку flight = "arc".
    vx = 320,
    vy = -180,
    gravity = 700,

    maxDistance = 520,
    lifeTime = 3.0,

    collides = {
        actors = true,
        player = false,
        platforms = true,
        ground = true
    },

    canvas = {
        width = 18,
        height = 18
    },

    offset = {
        x = 9,
        y = 9
    },

    bbox = {
        x = 0,
        y = 0,
        w = 18,
        h = 18
    },

    impactEffect = "explosion",

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.08,
            frames = {
                nil
            }
        },

        death = {
            loop = false,
            frameDuration = 0.08,
            frames = {
                nil,
                nil
            },
            events = {
                {
                    frame = 1,
                    type = "createEntity",
                    id = "explosion",
                    x = 0,
                    y = 0
                }
            }
        }
    }
}