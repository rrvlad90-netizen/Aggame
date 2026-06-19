return {
    id = "player_arc_projectile",

    -- Урон наносит сам projectile при пересечении с bbox врага.
    damage = 1,
    --deathType = "heavy",

    damageTargets = {
        enemy = true
    },

    -- Дуга: горизонтальная скорость + начальный подъём + gravity.
    flight = "arc",

    -- Projectile:new превратит speed в vx с учётом facing игрока.
    speed = 320,
    vy = -220,
    gravity = 700,

    maxDistance = 560,
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


	rotateToVelocity = true,      -- включает поворот по vx/vy
	rotationOffset = 0,           -- поправка угла под ориентацию спрайта
	rotationSmoothing = 0,        -- 0 = мгновенно, например 18 = плавно
	rotationMinSpeed = 1,          -- ниже этой скорости угол не обновляется
	
	
	--rotationOffset = math.pi / 2	--Если sprite стрелы нарисован носом вверх, поставь:
	--rotationOffset = math.pi --Если носом влево


    -- Только визуальный эффект попадания.
    -- Damage у эффекта должен быть 0.
    --impactEffect = "explosion",

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.08,
            frames = {
                "assets/projectiles/arrow.png"
            }
        },

        death = {
            loop = false,
            frameDuration = 0.08,
            frames = {
                "assets/projectiles/arrow.png"
            }
        }
    }
}