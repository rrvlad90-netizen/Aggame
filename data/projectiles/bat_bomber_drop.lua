return {
    id = "bat_bomber_drop",

    damage = 1,
    deathType = "normal",

    damageTargets = {
        player = true,
        npc = true
    },

    image = "assets/enemies/bat_bomber/drop.png",

    vx = 0,
    vy = 280,
    gravity = 0,

    maxDistance = 900,
    lifeTime = 4.0,
	
	---------ТЕНИ
	shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 70,
    shadowHeight = 14,
    shadowOffsetY = 2,
	---------	
	

    collides = {
        actors = true,
        player = true,
        platforms = true,
        ground = true
    },

    canvas = {
        width = 12,
        height = 16
    },

    offset = {
        x = 6,
        y = 8
    },

    bbox = {
        x = 0,
        y = 0,
        w = 12,
        h = 16
    },
	
	rotateToVelocity = true,      -- включает поворот по vx/vy
	rotationOffset = 0,           -- поправка угла под ориентацию спрайта
	rotationSmoothing = 0,        -- 0 = мгновенно, например 18 = плавно
	rotationMinSpeed = 1,          -- ниже этой скорости угол не обновляется

    color = {1.0, 0.25, 0.2},

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

            -- Чтобы explosion появился сразу при попадании.
            fireFirstFrameEvents = true,

            frames = {
                "assets/projectiles/enemyproj.png",
                "assets/projectiles/enemyproj.png"
            },

            events = {
                {
                    frame = 1,
                    type = "createEntity",
                    id = "explosion",

                    -- Старые impactOffsetX/Y.
                    x = -32,
                    y = -32
                }
            }
        }
    }
}