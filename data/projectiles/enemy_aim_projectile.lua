return {
    id = "enemy_aim_projectile",

    damage = 1,
    deathType = "normal",

    damageTargets = {
        player = true
    },

    -- speed/vx/vy будут переопределены EventRunner-ом,
    -- когда event использует aimAtTarget = true.
    speed = 0,
    vx = 0,
    vy = 0,
    gravity = 0,

    maxDistance = 700,
    lifeTime = 3.0,

    rotateToVelocity = true,

    -- 0 подходит, если sprite снаряда смотрит вправо.
    -- Если sprite смотрит вверх, поставь math.pi / 2.
    rotationOffset = 0,

    -- 0 = мгновенно следует направлению.
    -- Например 18 = плавный доворот.
    rotationSmoothing = 0,
    rotationMinSpeed = 1,

    collides = {
        actors = false,
        player = true,
        platforms = true,
        ground = false
    },

    impactEffect = "explosion",

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
        1.0,
        0.35,
        0.1
    },

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.08,
            frames = {
                "assets/projectiles/enemyproj.png"
            }
        },

        death = {
            loop = false,
            frameDuration = 0.08,
            frames = {
                "assets/projectiles/enemyproj.png"
            }
        }
    }
}

--Если хочешь, чтобы снаряд летел дугой в позицию игрока, в enemy event замени:
--aimMode = "straight",
--projectileSpeed = 280,
--на:
--aimMode = "arc",
--travelTime = 0.9,
--и в overrides поставь: gravity = 700,