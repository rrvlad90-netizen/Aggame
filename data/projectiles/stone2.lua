return {
    id = "stone",

    damage = 1,
    deathType = "heavy",

    damageTargets = {
        enemy = true
    },

    flight = "arc",

    -- Базовая скорость снаряда.
    -- Направление будет задаваться через facing в Projectile:new.
    speed = 320,
    vy = -180,
    gravity = 700,

    maxDistance = 520,
    lifeTime = 3.0,

    collides = {
        actors = true,
        player = false,
        platforms = true,
        ground = false
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
                {}
            }
        },

        death = {
            loop = false,
            frameDuration = 0.08,
            frames = {
                {},
                {}
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