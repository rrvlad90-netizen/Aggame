return {
    id = "jumping_goblin",
    name = "Jumping Goblin",

    entityType = "enemy",
    targetGroup = "enemy",

    health = 2,
    speed = 90,
    gravity = 900,
    flying = false,

    facing = -1,
    flipSprite = true,

    hates = {
        player = true
    },

    damageTargets = {
        player = true
    },

    showHealthBar = true,

    nopain = false,
    painChance = 50,

    heavyDeathEffect = "goblin_heavydeath_jump",
	
---------ТЕНИ
	shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 70,
    shadowHeight = 14,
    shadowOffsetY = 2,
	---------	

    canvas = {
        width = 69,
        height = 77
    },

    offset = {
        x = 32,
        y = 80
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
            },
            events = {
                {
                    frame = 2,
                    type = "randomState",
                    states = {
                        "jump_short",
                        "jump_high"
                    },
                    chance = 25
                }
            }
        },

        walk = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_2.png"
            },
            events = {
                {
                    frame = 2,
                    type = "randomState",
                    states = {
                        "jump_short",
                        "jump_forward",
                        "jump_high"
                    },
                    chance = 25
                }
            }
        },

        -- Прыжок на месте.
        jump_short = {
            loop = false,
            lockInput = true,
			fireFirstFrameEvents = true,
            frameDuration = 0.1,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_2.png",
                "assets/enemies/goblin/walk_1.png"
            },
            events = {
                {
                    frame = 1,
                    type = "jump",
                    height = 420,
                    speed = 0,
                    distance = 0
                }
            }
        },

        -- Прыжок вперёд.
        -- Если хочешь, чтобы он прыгал только вверх — поставь speed = 0.
        jump_forward = {
            loop = false,
            lockInput = true,
			fireFirstFrameEvents = true,
            frameDuration = 0.1,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_2.png",
                "assets/enemies/goblin/walk_1.png"
            },
            events = {
                {
                    frame = 1,
                    type = "jump",
                    height = 430,
                    speed = 160,
                    distance = 120
                }
            }
        },

        -- Высокий прыжок.
        jump_high = {
            loop = false,
            lockInput = true,
			fireFirstFrameEvents = true,
            frameDuration = 0.1,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_2.png",
                "assets/enemies/goblin/walk_1.png"
            },
            events = {
                {
                    frame = 1,
                    type = "jump",
                    height = 560,
                    speed = 0,
                    distance = 0
                }
            }
        },

        attack_melee = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/attack_1.png"
            },
            events = {
                {
                    frame = 2,
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