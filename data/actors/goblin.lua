return {
    id = "goblin",
    name = "Goblin",

    entityType = "enemy",
    targetGroup = "enemy",

    health = 2,
    speed = 90,
    gravity = 900,
    flying = false,

    facing = -1,
	flipSprite = true, --если не туда нарисовал спрайты то разворачиваю

    hates = {
        player = true
    },

    damageTargets = {
        player = true
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
                "assets/goblin/walk_1.png",
                "assets/goblin/walk_1.png"
            }
        },

        walk = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/goblin/walk_1.png",
                "assets/goblin/walk_2.png"
            }
        },

        attack_melee = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/goblin/walk_1.png",
                "assets/goblin/attack_1.png"
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
		

        pain = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/goblin/walk_1.png",
                "assets/goblin/walk_1.png"
            }
        },


		heavydeath = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
			
			-- Важно: без этого флага frame = 1 events не сработают при старте анимации.
            fireFirstFrameEvents = true,
			
            frameDuration = 0.14,
            frames = {
                "assets/goblin/heavydeath_1.png",
                "assets/goblin/heavydeath_2.png"
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
                "assets/goblin/death_1.png",
                "assets/goblin/death_2.png"
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