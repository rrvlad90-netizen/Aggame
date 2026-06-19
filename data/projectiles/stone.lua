return {
    id = "stone",

    -- Прямой урон от самого камня.
    damage = 1,
    deathType = "heavy",

    damageTargets = {
        enemy = true
    },

    -- Камень летит прямо по горизонтали.
    flight = "straight",

    -- Projectile:new превратит speed в vx с учётом facing игрока.
    speed = 360,
    vy = 0,
    gravity = 0,

    maxDistance = 520,
    lifeTime = 3.0,
	
	
	---------ТЕНИ
	shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 70,
    shadowHeight = 14,
    shadowOffsetY = 2,
	---------	

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

    -- Эффект остаётся только визуалом попадания.
    -- Урон должен наносить сам stone через damage/damageTargets.
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
            }
        }
    }
}