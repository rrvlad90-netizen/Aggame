return {
    id = "friendly_special_goblin",
    name = "Friendl Special Goblin",

	entityType = "npc",
	targetGroup = "npc",

    health = 2,
    speed = 90,
    gravity = 900,
    flying = false,

    -- solid = true,
	---------ТЕНИ
	shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 70,
    shadowHeight = 14,
    shadowOffsetY = 2,
	---------	
	
	
	alpha = 0.15,

    facing = -1,
    flipSprite = true,

	hates = {
		enemy = true
	},

	damageTargets = {
		enemy = true
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

    animationGroups = {
        special = {
            "special01",
            "special02",
            "special03"
        }
    },

    attackGroups = {
        {
            minDistance = 0,
            maxDistance = 180,
            animations = {
                "choose_special"
            }
        }
    },

    animations = {
        spawn = {
            loop = false,
            lockInput = true,
            frameDuration = 0.14,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_2.png"
            }
        },

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

        choose_special = {
            loop = false,
            lockInput = true,
            frameDuration = 0.06,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_1.png"
            },
            events = {
                {
                    frame = 2,
                    type = "randomStateGroup",
                    group = "special"
                }
            }
        },

        special01 = {
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
                        enemy = true
                    }
                }
            }
        },

        special02 = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/attack_1.png",
				"assets/enemies/goblin/walk_1.png",
				"assets/enemies/goblin/walk_2.png",
				"assets/enemies/goblin/walk_1.png",
				"assets/enemies/goblin/walk_2.png",
				"assets/enemies/goblin/walk_1.png"			
            },
            events = {
                {
                    frame = 3,
                    type = "move",
                    x = -15,
                    y = 0
                },
				{
                    frame = 4,
                    type = "move",
                    x = -15,
                    y = 0
                },
				{
                    frame = 5,
                    type = "move",
                    x = -15,
                    y = 0
                },
				{
                    frame = 6,
                    type = "move",
                    x = -15,
                    y = 0
                },
                {
                    frame = 2,
                    type = "damageHitbox",
                    hitbox = "claw",
                    damage = 1,
                    deathType = "normal",
                    damageTargets = {
                        enemy = true
                    }
                }
            }
        },

        special03 = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/attack_1.png",
				"assets/enemies/goblin/walk_1.png",
				"assets/enemies/goblin/walk_2.png",
				"assets/enemies/goblin/walk_1.png",
				"assets/enemies/goblin/walk_2.png",
				"assets/enemies/goblin/walk_1.png"	
            },
            events = {
               {
                    frame = 3,
                    type = "move",
                    x = -15,
                    y = 0
                },
				{
                    frame = 4,
                    type = "move",
                    x = -15,
                    y = 0
                },
				{
                    frame = 5,
                    type = "move",
                    x = -15,
                    y = 0
                },
				{
                    frame = 6,
                    type = "move",
                    x = -15,
                    y = 0
                },
                {
                    frame = 3,
                    type = "createEntity",
                    id = "stone", ---Не забывать ему прописать его проджектайл
                    x = 34,
                    y = -42,
                    direction = "forward",
                    overrides = {
                        damageTargets = {
                            enemy = true
                        },
                        collides = {
                            actors = true, --бьет акторов
                            player = false, --не бьет игрока
                            platforms = true,
                            ground = true
                        }
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