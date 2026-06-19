return {
    id = "diagonal_down_projectile",

    damage = 1,
    deathType = "normal",

    damageTargets = {
        player = true,
        npc = true
    },

    -- Горизонталь задаётся через speed + facing.
    speed = 220,

    -- Положительный Y = летит вниз.
    vy = 180,
    gravity = 700,

    maxDistance = 700,
    lifeTime = 4.0,

    alpha = 1,
	
	---------ТЕНИ
	shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 70,
    shadowHeight = 14,
    shadowOffsetY = 2,
	---------	

    collides = {
        actors = false,
        player = true,
        platforms = true,
        ground = false
    },

    impactEffect = "explosion",

    canvas = {
        width = 14,
        height = 14
    },

    offset = {
        x = 7,
        y = 7
    },

    bbox = {
        x = 0,
        y = 0,
        w = 14,
        h = 14
    },
	
	rotateToVelocity = true,      -- включает поворот по vx/vy
	rotationOffset = 0,           -- поправка угла под ориентацию спрайта
	rotationSmoothing = 0,        -- 0 = мгновенно, например 18 = плавно
	rotationMinSpeed = 1,          -- ниже этой скорости угол не обновляется	
	

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
                "assets/projectiles/enemyproj.png",
                "assets/projectiles/enemyproj.png"
            }
        }
    }
}