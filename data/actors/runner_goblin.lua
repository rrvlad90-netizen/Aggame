return {
    id = "runner_goblin",
    name = "Runner Goblin",

    entityType = "enemy",
    targetGroup = "enemy",

    health = 2,
    speed = 145,
    gravity = 900,
    flying = false,

    movementMode = "runner",
	ignoreLevelBounds = true, -- проходит сквозь границы экрана
	
    facing = -1,
    flipSprite = true,

    nopain = true,

    contactDamage = 1,
    contactDamageCooldown = 0.5,
    contactDamageTargets = {
        player = true
    },

    hates = {
        player = true
    },

    damageTargets = {
        player = true
    },

    showHealthBar = false,

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
            frameDuration = 0.12,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_2.png"
            }
        },

        walk = {
            loop = true,
            frameDuration = 0.1,
            frames = {
                "assets/enemies/goblin/walk_1.png",
                "assets/enemies/goblin/walk_2.png"
            }
        },

        attack_melee = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
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

        death = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.18,
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