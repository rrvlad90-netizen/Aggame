return {
    id = "special_goblin",
    name = "Special Goblin",

    entityType = "enemy",
    targetGroup = "enemy",

    health = 2,
    speed = 90,
    gravity = 900,
    flying = false,

    -- solid = true,
	
	alpha = 0.75,

    facing = -1,
    flipSprite = true,

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
                "assets/goblin/walk_1.png",
                "assets/goblin/walk_1.png",
                "assets/goblin/walk_2.png"
            }
        },

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

        choose_special = {
            loop = false,
            lockInput = true,
            frameDuration = 0.06,
            frames = {
                "assets/goblin/walk_1.png",
                "assets/goblin/walk_1.png"
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

        special02 = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/goblin/walk_1.png",
                "assets/goblin/attack_1.png"
            },
            events = {
                {
                    frame = 1,
                    type = "move",
                    x = -20,
                    y = 0
                },
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

        special03 = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/goblin/walk_1.png",
                "assets/goblin/walk_2.png",
                "assets/goblin/attack_1.png"
            },
            events = {
                {
                    frame = 1,
                    type = "move",
                    x = -20,
                    y = 0
                },
                {
                    frame = 2,
                    type = "move",
                    x = -20,
                    y = 0
                },
                {
                    frame = 3,
                    type = "createEntity",
                    id = "stone_enemy",
                    x = 34,
                    y = -42,
                    direction = "forward",
                    overrides = {
                        damageTargets = {
                            player = true
                        },
                        collides = {
                            actors = false,
                            player = true,
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
                "assets/goblin/turn_1.png",
                "assets/goblin/turn_2.png"
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