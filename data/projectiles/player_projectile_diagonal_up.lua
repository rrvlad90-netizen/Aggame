return {
    id = "player_projectile_diagonal_up",

    damage = 1,
    deathType = "normal",

    damageTargets = {
        enemy = true
    },

    -- vx задаётся через speed и facing игрока.
    -- vy отрицательный, поэтому снаряд летит вверх.
    speed = 340,
    vy = -340,
    gravity = 0,

    maxDistance = 620,
    lifeTime = 2.0,

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

    color = {
        0.8,
        0.9,
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