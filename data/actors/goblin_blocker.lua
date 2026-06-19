return {
    id = "goblin_blocker",
    name = "Goblin Blocker",

    entityType = "enemy",
    targetGroup = "enemy",

    health = 22,
    speed = 90,
    gravity = 900,
    flying = false,

--  solid = true,--блокирует всех

	---------ТЕНИ
	shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 70,
    shadowHeight = 14,
    shadowOffsetY = 2,
	---------

--Можно так
--nopain = false,
--painChance = 35,--перебьет флаг nopain 


--Можно отдельно вообще так
--painChance = 0, --это тоже самое что nopain = false

--но лучше так
    painChance = 35, 
	
    alpha = 0.95,

    facing = -1,
    flipSprite = true, --если не туда нарисовал спрайты то разворачиваю

    hates = {
        player = true,
	    npc = true
    },

    damageTargets = {
        player = true,
	    npc = true
    },

    showHealthBar = true,

    VictoryIfDeath = false,
    DefeatIfDeath = false,

    nopain = false,

    heavyDeathEffect = "goblin_heavydeath_jump",

    canvas = {
        width = 69,
        height = 77
    },

    offset = {
        x = 32,
        y = -60
    },

    bbox = {
        x = 20,
        y = 18,
        w = 24,
        h = 62
    },

    hitboxes = {
        claw = {
            x = 6,
            y = 26,
            w = 34,
            h = 32
        }
    },

    attackGroups = {
        {
            minDistance = 0,
            maxDistance = 46,
            animations = {
                "attack_melee"
            }
        }
    },

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.16,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_1.png"
            }
        },

        walk = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_2.png"
            }
        },

        attack_melee = {
            loop = false,
            lockInput = true,
            frameDuration = 0.24,
            frames = {
                "assets/enemies/goblin/walk_1.png",
				"assets/enemies/goblin/walk_1.png",
				"assets/enemies/goblin/walk_1.png",				
                "assets/enemies/goblin/attack_1.png"
            },
            events = {
                {
                    frame = 2,
                    type = "setState",
                    state = "special_block",
                    chance = 25
                },
                {
                    frame = 3,
                    type = "damageHitbox",
                    hitbox = "claw",
                    damage = 1,
                    deathType = "normal",
                    damageTargets = {
                        player = true
                    }
                }
            }
        },

        -- Блок: отдельная animation state.
        -- Если actor перешёл сюда, он получает invulnerable на время блока.
        special_block = {
            loop = false,
            lockInput = true,
			fireFirstFrameEvents = true, --без этого нельзя ставить событие на первый кадр анимации			
			
            frameDuration = 0.4,
            frames = {
                "assets/enemies/goblin/block_1.png",
                "assets/enemies/goblin/block_1.png",
                "assets/enemies/goblin/block_1.png",
				"assets/enemies/goblin/block_1.png"
            },
            events = {
                {
                    frame = 1,
                    type = "setInvulnerable",
                    value = true,
                    --duration = 0.3 --сколько будет длится блок (сумма кадров фреймов)
                },
				{
                    frame = 3,
                    type = "setInvulnerable",
                    value = false, --а можно просто оключить по кадру, так более упорядоченее
                },
				{
                    frame = 4,
                    type = "setState",
					state = "walk",
                }				
            }
        },

        --Если turn не прописан, actor будет разворачиваться мгновенно.
        turn = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,

            frames = {
                "assets/enemies/goblin/turn_1.png",
                "assets/enemies/goblin/turn_2.png"
            }
        },

        pain = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_1.png"
            }
        },

        heavydeath = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,

            frameDuration = 0.14,
            frames = {
                "assets/enemies/goblin/heavydeath_1.png",
                "assets/enemies/goblin/heavydeath_2.png"
            },
            events = {
                {
                    frame = 1,
                    type = "playSound",
                    sound = "assets/sounds/hit2.wav"
                }
            }
        },

        death = {
            loop = false,
            lockInput = true,

            -- Важно: без этого флага frame = 1 events не сработают при старте анимации.
            fireFirstFrameEvents = true,

            frameDuration = 0.44,
            frames = {
                "assets/enemies/goblin/death_1.png",
                "assets/enemies/goblin/death_2.png"
            },
            events = {
                {
                    frame = 1,
                    type = "playSound",
                    sound = "assets/sounds/hit2.wav"
                }
            }
        }
    }
}