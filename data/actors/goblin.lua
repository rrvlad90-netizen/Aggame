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
        width = 64,
        height = 80
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
                nil,
                nil
            }
        },

        walk = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                nil,
                nil,
                nil,
                nil
            }
        },

        attack_melee = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                nil,
                nil,
                nil
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
                nil,
                nil
            }
        },

        death = {
            loop = false,
            lockInput = true,
            frameDuration = 0.14,
            frames = {
                nil,
                nil,
                nil
            },
            events = {
                {
                    frame = 1,
                    type = "playSound",
                    sound = "assets/sounds/enemy_death.wav"
                }
            }
        }
    }
}