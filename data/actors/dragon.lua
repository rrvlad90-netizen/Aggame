return {
    id = "dragon",
    name = "Dragon",

    entityType = "enemy",
    targetGroup = "enemy",

    flying = true,
    gravity = 0,

    health = 2,
    speed = 90,

    showHealthBar = false,

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

    searchRange = 550, ------!!!!!!!!!!!!!!!!!
    movementMode = "chase",

    -- Если хочешь, чтобы он летел во время атаки.
    keepMovingDuringAttack = true,
    attackMoveSpeed = 35,

    flyAmplitude = 0, -- 0 = летит ровно.без амплитуды
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

            frameDuration = 0.6,

            frames = {
                "assets/enemies/dragon/attack_1.png",
                "assets/enemies/dragon/attack_2.png"
            },

            events = {
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
                }
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