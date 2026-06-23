return {
    id = player_projectile_down,

    damage = 1,
    deathType = normal,

    damageTargets = {
        enemy = true
    },

    -- Летит строго вниз.
    speed = 0,
    vx = 0,
    vy = 430,
    gravity = 0,

    maxDistance = 520,
    lifeTime = 2.0,

    collides = {
        actors = true,
        player = false,
        platforms = true,
        ground = false
    },

    impactEffect = explosion,

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

    rotateToVelocity = true,
    rotationOffset = 0,
    rotationSmoothing = 0,
    rotationMinSpeed = 1,

    color = {
        0.4,
        0.8,
        1.0
    },

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.08,
            frames = {
               "assets/projectiles/proj.png"
            }
        },

        death = {
            loop = false,
            frameDuration = 0.08,
            frames = {
                "assets/projectiles/proj.png"
            }
        }
    }
}