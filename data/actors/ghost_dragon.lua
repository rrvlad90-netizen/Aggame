return {
    id = "ghost_dragon",
    name = "Ghost Dragon",

    entityType = "enemy",
    targetGroup = "enemy",

    flying = true,
    gravity = 0,

    health = 2,
    speed = 90,

    showHealthBar = false,

	
   SceneIfPlayerDieByActor = "scene_player_killed_by_ghost_dragon",
   SceneIfActorDeath = "scene_player_victory_when_ghost_dragon_death", --если победил

    -- По умолчанию по нему можно попадать.
    -- Во время attack он временно станет hittable = false.
    hittable = true,

    -- Немного прозрачный, чтобы визуально отличался от обычного dragon.
    alpha = 0.75,

    facing = -1,
    --flipSprite = true,

    hates = {
        player = true,
	    npc = true
    },

    damageTargets = {
        player = true,
	    npc = true
    },

    searchRange = 550,
    movementMode = "chase",

	--Вариант 3 — летит к игроку и стреляет на ходу:
	speed = 60,
	--movementMode = "chase",
	keepMovingDuringAttack = true,
	--attackMoveSpeed = 25,--Замедлится
	attackMoveSpeed = 60, --оставляем такую же скорость для продолжения движения


    flyAmplitude = 0,
    flyFrequency = 3,

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

    attackGroups = {
        {
            minDistance = 0,
            maxDistance = 350,
            animations = {
                "attack"
            }
        }
    },

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.08,
            frames = {
                "assets/enemies/dragon/attack_1.png",
                "assets/enemies/dragon/attack_2.png"
            }
        },

        walk = {
            loop = true,
            frameDuration = 0.08,
            frames = {
                "assets/enemies/dragon/attack_1.png",
                "assets/enemies/dragon/attack_2.png"
            }
        },

        attack = {
            loop = false,
            lockInput = true,

            -- Нужно, чтобы frame = 1 event сработал сразу при старте attack.
            fireFirstFrameEvents = true,---!!!

            -- 2 кадра * 0.6 = 1.2 сек.
            frameDuration = 0.6,

            frames = {
                "assets/enemies/dragon/attack_1.png",
                "assets/enemies/dragon/attack_2.png",
			    "assets/enemies/dragon/attack_2.png"
            },

            events = {
                {
                    frame = 1,  ---!!!
                    type = "setAlpha",
                    value = 0.25,

                    -- На всю длительность attack.
                    -- Пока hittable = false, удары/снаряды проходят сквозь dragon-а.
                    --duration = 1.2
                },
				{
                    frame = 1,  ---!!!
                    type = "setHittable",
                    value = false,

                    -- На всю длительность attack.
                    -- Пока hittable = false, удары/снаряды проходят сквозь dragon-а.
                    --duration = 1.2
                },
                {
                    frame = 2,
                    type = "playSound",
                    sound = "assets/sounds/sfx/drop.wav"
                },
                {
                    frame = 2,
                    type = "createEntity",
                    id = "diagonal_down_projectile",
                    x = 28,
                    y = 16,
                    direction = "forward",
                    overrides = {
                        damage = 1,
                        speed = 220,
                        damageTargets = {
                            player = true,
                            npc = true
                        },
                        collides = {
                            actors = false,
                            player = true,
                            platforms = true,
                            ground = false
                        }
                    }
                },
				{
                    frame = 3,
                    type = "setHittable",
                    value = true,

                    -- На всю длительность attack.
                    -- Пока hittable = false, удары/снаряды проходят сквозь dragon-а.
                    --duration = 1.2
                },
				{
                    frame = 3, 
                    type = "setAlpha",
                    value = 0.75,
                },
            }
        },

        pain = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/enemies/dragon/attack_1.png"
            }
        },

        death = {
            loop = false,
            lockInput = true,
            holdLastFrame = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.1,

            frames = {
                "assets/enemies/dragon/attack_1.png",
                "assets/enemies/dragon/attack_2.png"
            },

            events = {
                {
                    frame = 1,
                    type = "playSound",
                    sound = "assets/sounds/sfx/hit2.wav"
                },
                {
                    frame = 2,
                    type = "createEntity",
                    id = "explosion",
                    x = 0,
                    y = -44
                }
            }
        }
    }
}