return {
    id = "flying_shooter",
    name = "Flying Shooter",

    entityType = "enemy",
    targetGroup = "enemy",

    health = 2,
    speed = 80,
    gravity = 0,
    flying = true,

    showHealthBar = true,

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
	
	--Вариант 1  висит на месте, только качается и стреляет:
	--speed = 0,
	--movementMode = "idle",
	--keepMovingDuringAttack = false,
	
	
	--Вариант 2 — летит к игроку, но останавливается для выстрела:
	--speed = 80,
	--movementMode = "chase",
	--keepMovingDuringAttack = false,
	
	
	--Вариант 3 — летит к игроку и стреляет на ходу:
	speed = 60,
	movementMode = "chase",
	keepMovingDuringAttack = true,
	--attackMoveSpeed = 25,--Замедлится
	attackMoveSpeed = 60, --оставляем такую же скорость для продолжения движения

    -- Амплитуда полёта.
    flyAmplitude = 10,
    flyFrequency = 3,

    canvas = {
        width = 44,
        height = 36
    },

    -- Для летающего врага anchor лучше держать в центре.
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

            -- 4 кадра * 0.35 = примерно 1.4 сек cooldown.
            -- shootChance в текущем AI пока нет, поэтому стреляет всегда при range.
            frameDuration = 0.35,

            frames = {
                "assets/enemies/flying_shooter/attack_1.png",
                "assets/enemies/flying_shooter/attack_2.png",
                "assets/enemies/flying_shooter/attack_3.png",
                "assets/enemies/flying_shooter/attack_4.png"
            },

            events = {
                {
                    frame = 3,
                    type = "createEntity",

                    -- В текущем проекте EnemyFireball пока нет.
                    -- Используем существующий enemy projectile.
                    id = "stone_enemy",

                    x = 24,
                    y = 0,
                    direction = "forward",

                    overrides = {
                        damage = 1,
                        maxDistance = 520,
                        damageTargets = {
                            player = true
                        },
                        collides = {
                            actors = false,
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