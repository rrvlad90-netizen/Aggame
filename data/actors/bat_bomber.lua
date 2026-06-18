return {
    id = "bat_bomber",
    name = "Bat Bomber",

    entityType = "enemy",
    targetGroup = "enemy",

    flying = true,
    gravity = 0,

    --x = 0,
    --y = 150,

    speed = 90,
    health = 2,

    facing = -1,
    --flipSprite = true,

    hates = {
        player = true
    },

    damageTargets = {
        player = true
    },

    showHealthBar = true,
	
	
	--Вариант 3 — летит к игроку и стреляет на ходу:
	speed = 60,
	movementMode = "chase",
	keepMovingDuringAttack = true,
	--attackMoveSpeed = 25,--Замедлится
	attackMoveSpeed = 60, --оставляем такую же скорость для продолжения движения

    canvas = {
        width = 128,
        height = 128
    },

    offset = {
        x = 50,
        y = 160
    },

    bbox = {
        x = 8,
        y = 40,
        w = 54,
        h = 62
    },

    movementMode = "chase",
    searchRange = 600,

    -- Старый dropRangeX = 90.
    -- Старый dropChance = 0.55 сделан через повторы attack_drop/attack_wait.
    -- Старый dropCooldown = 1.4 сделан длиной attack-анимации.
    attackGroups = {
        {
            minDistance = 0,
            maxDistance = 90,
            animations = {
                "attack_drop",
                "attack_drop",
                "attack_drop",
                "attack_drop",
                "attack_drop",
                "attack_drop",

                "attack_wait",
                "attack_wait",
                "attack_wait",
                "attack_wait",
                "attack_wait"
            }
        }
    },

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.08,
            frames = {
                "assets/enemies/bat_bomber/fly_1.png",
                "assets/enemies/bat_bomber/fly_2.png",
                "assets/enemies/bat_bomber/fly_3.png",
                "assets/enemies/bat_bomber/fly_4.png"
            }
        },

        walk = {
            loop = true,
            frameDuration = 0.08,
            frames = {
                "assets/enemies/bat_bomber/fly_1.png",
                "assets/enemies/bat_bomber/fly_2.png",
                "assets/enemies/bat_bomber/fly_3.png",
                "assets/enemies/bat_bomber/fly_4.png"
            }
        },

        attack_drop = {
            loop = false,
            lockInput = true,
            frameDuration = 0.2,
            frames = {
                "assets/enemies/bat_bomber/attack_1.png",
                "assets/enemies/bat_bomber/attack_2.png",
                "assets/enemies/bat_bomber/attack_3.png",
                "assets/enemies/bat_bomber/attack_4.png",
                "assets/enemies/bat_bomber/fly_1.png",
                "assets/enemies/bat_bomber/fly_2.png",
                "assets/enemies/bat_bomber/fly_3.png"
            },
            events = {
                {
                    frame = 1,
                    type = "setVelocity",
                    vx = 0,
                    vy = 0
                },
                {
                    frame = 3,
                    type = "playSound",
                    sound = "assets/sounds/sfx/drop.wav"
                },
                {
                    frame = 3,
                    type = "createEntity",
                    id = "bat_bomber_drop",
                    x = 0,
                    y = 24
                }
            }
        },

        attack_wait = {
            loop = false,
            lockInput = true,
            frameDuration = 0.2,
            frames = {
                "assets/enemies/bat_bomber/fly_1.png",
                "assets/enemies/bat_bomber/fly_2.png",
                "assets/enemies/bat_bomber/fly_3.png",
                "assets/enemies/bat_bomber/fly_4.png",
                "assets/enemies/bat_bomber/fly_1.png",
                "assets/enemies/bat_bomber/fly_2.png",
                "assets/enemies/bat_bomber/fly_3.png"
            },
            events = {
                {
                    frame = 1,
                    type = "setVelocity",
                    vx = 0,
                    vy = 0
                }
            }
        },

        pain = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/enemies/bat_bomber/fly_1.png",
                "assets/enemies/bat_bomber/fly_2.png"
            }
        },

        death = {
            loop = false,
            lockInput = true,
            holdLastFrame = true,
            frameDuration = 0.1,

            -- Важно: без этого frame = 1 event не сработает сразу при старте death.
            fireFirstFrameEvents = true,

            frames = {
                "assets/enemies/bat_bomber/death_1.png"
            },
            events = {
                {
                    frame = 1,
                    type = "playSound",
                    sound = "assets/sounds/sfx/hit2.wav"
                },
                {
                    frame = 1,
                    type = "createEntity",
                    id = "bat_corpse",
                    x = 0,
                    y = -44,
                    overrides = {
                        gravity = 900
					}
                }
            }
        }
    }
}