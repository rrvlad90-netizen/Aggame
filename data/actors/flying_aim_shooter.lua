return {
    id = "flying_aim_shooter",
    name = "Flying Aim Shooter",

    entityType = "enemy",
    targetGroup = "enemy",

    flying = true,
    gravity = 0,

    health = 2,
    speed = 70,
	
	---------ТЕНИ
	shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 70,
    shadowHeight = 14,
    shadowOffsetY = 2,
	---------	

    showHealthBar = true,

    facing = -1,
    flipSprite = true,
	
    hates = {
        player = true,
	    npc = true
    },

    damageTargets = {
        player = true,
	    npc = true
    },

    searchRange = 520,
    movementMode = "chase",

    -- Если хочешь, чтобы он стрелял на ходу.
    keepMovingDuringAttack = true,
    attackMoveSpeed = 25,

    -- Лёгкое покачивание в воздухе.
    flyAmplitude = 10,
    flyFrequency = 3,

    canvas = {
        width = 44,
        height = 36
    },

    offset = {
        x = 22,
        y = 18
    },

    bbox = {
        x = 4,
        y = 4,
        w = 36,
        h = 28
    },

    attackGroups = {
        {
            minDistance = 0,
            maxDistance = 520,
            animations = {
                "attack"
            }
        }
    },

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/enemies/flying_shooter/idle_1.png",
                "assets/enemies/flying_shooter/idle_2.png"
            }
        },

        walk = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/enemies/flying_shooter/idle_1.png",
                "assets/enemies/flying_shooter/idle_2.png"
            }
        },

        attack = {
            loop = false,
            lockInput = true,

            -- 3 кадра * 0.22 = примерно 0.66 сек между выстрелами.
            -- Увеличь frameDuration, если нужен больший cooldown.
            frameDuration = 0.22,

            frames = {
                "assets/enemies/flying_shooter/attack_1.png",
                "assets/enemies/flying_shooter/attack_2.png",
                "assets/enemies/flying_shooter/attack_3.png"
            },

            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "enemy_aim_projectile",

                    -- Точка вылета относительно врага.
                    x = 24,
                    y = 0,

                    -- Новая логика EventRunner:
                    -- берём позицию игрока в момент выстрела
                    -- и рассчитываем vx/vy один раз.
                    aimAtTarget = true,
                    aimMode = "straight",
                    projectileSpeed = 280,

                    -- Можно целиться чуть выше/ниже центра игрока.
                    targetOffsetY = 0,

                    overrides = {
                        damage = 1,
                        gravity = 0,

                        rotateToVelocity = true,
                        rotationOffset = 0,
                        rotationSmoothing = 0,

                        damageTargets = {
                            player = true,
							npc = true  --!!!!
                        },

                        collides = {
                            actors = true, --!!!!
                            player = true,
                            platforms = true,
                            ground = false
                        }
                    }
                }
            }
        },

        pain = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/enemies/flying_shooter/idle_1.png"
            }
        },

        death = {
            loop = false,
            lockInput = true,
            frameDuration = 0.12,
            frames = {
                "assets/enemies/flying_shooter/death_1.png",
                "assets/enemies/flying_shooter/death_2.png"
            }
        }
    }
}