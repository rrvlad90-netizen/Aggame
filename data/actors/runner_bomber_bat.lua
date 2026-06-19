return {
    id = "runner_bomber_bat",
    name = "Runner Bomber Bat",

    entityType = "enemy",
    targetGroup = "enemy",

    flying = true,
    gravity = 0,

    health = 2,
    speed = 120,
	
	---------ТЕНИ
	shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 70,
    shadowHeight = 14,
    shadowOffsetY = 2,
	---------	

    movementMode = "runner",
	
    facing = -1,

    nopain = true,

    contactDamage = 1,
    contactDamageCooldown = 0.6,
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

    keepMovingDuringAttack = true,
    attackMoveSpeed = 70,

    flyAmplitude = 14,
    flyFrequency = 3,

    searchRange = 700,

    attackGroups = {
        {
            minDistance = 0,
            maxDistance = 140,
            animations = {
                "attack_drop"
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
            frameDuration = 0.14,
            frames = {
                "assets/enemies/bat_bomber/attack_1.png",
                "assets/enemies/bat_bomber/attack_2.png",
                "assets/enemies/bat_bomber/attack_3.png",
                "assets/enemies/bat_bomber/attack_4.png"
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
                    id = "bat_bomber_drop",
                    x = 0,
                    y = 24
                }
            }
        },

        death = {
            loop = false,
            lockInput = true,
            holdLastFrame = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.1,
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