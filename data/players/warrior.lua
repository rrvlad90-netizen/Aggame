return {
    id = "warrior",
    name = "Warrior",

    portrait = nil,

    health = 5,
    lives = 3,

    speed = 180,
    jumpPower = -430,
    gravity = 900,

    comboWindow = 0.35, --время для комбо(нужно успеть нажать что бы выйти вкомбо (поочереди анимации)
	
	----ТЕНЬ	
	shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 70,
    shadowHeight = 11,
    shadowOffsetY = 2,
	------
	
    canvas = {
        width = 64,
        height = 80
    },

    offset = {
        x = 32,
        y = 80
    },

    bboxes = {
        stand = {
            x = 20,
            y = 14,
            w = 24,
            h = 66
        },

        crouch = {
            x = 20,
            y = 38,
            w = 24,
            h = 42
        },

        none = {
            x = 0,
            y = 0,
            w = 0,
            h = 0
        }
    },

    defaultBbox = "stand",
    crouchBbox = "crouch",

    bbox = {
        x = 20,
        y = 14,
        w = 24,
        h = 66
    },

    hitboxes = {
        slash = {
            x = 34,
            y = 22,
            w = 38,
            h = 34
        },

        crouch_slash = {
            x = 34,
            y = 42,
            w = 38,
            h = 26
        }
    },

    abilities = {
        move = true,
        jump = true,
        canDoubleJump = true,
        shoot = true,
        melee = true,
        crouch = true,
        block = true,
        strafe = true,
        up = true
    },

    animationGroups = {
        melee_stand = {
            "melee_stand01",
            "melee_stand02",
            "melee_stand03"
        },

        -- В беге отдельной run-атаки нет.
        -- Если игрок бежит и жмёт melee, он останавливается и играет stand-combo.
        melee_run = {
            "melee_stand01",
            "melee_stand02",
            "melee_stand03"
        }
    },

    ammo = {
        stone = nil
    },

    animations = {
        spawn = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/players/warrior/spawn_1.png",
                "assets/players/warrior/spawn_2.png",
                "assets/players/warrior/spawn_3.png"
            }
        },

        idle = {
            loop = true,
            frameDuration = 0.16,
            frames = {
                "assets/players/warrior/idle_1.png",
                "assets/players/warrior/idle_2.png"
            }
        },

        run = {
            loop = true,
            frameDuration = 0.1,
            frames = {
                "assets/players/warrior/run_1.png",
                "assets/players/warrior/run_2.png",
                "assets/players/warrior/run_3.png",
                "assets/players/warrior/run_4.png"
            }
        },

        jump = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/warrior/jump_1.png"
            }
        },

        fall = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/warrior/fall_1.png"
            }
        },

        crouch = {
            loop = true,
            frameDuration = 0.14,
            frames = {
                "assets/players/warrior/crouch_1.png"
            }
        },

        block = {
            loop = true,
            lockInput = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/warrior/block_1.png"
            }
        },

        crouch_block = {
            loop = true,
            lockInput = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/warrior/crouch_block_1.png"
            }
        },

        shoot_stand = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/shoot_stand_1.png",
                "assets/players/warrior/shoot_stand_2.png",
                "assets/players/warrior/shoot_stand_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -42,
                    direction = "forward"
                }
            }
        },

        shoot_run = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/shoot_run_1.png",
                "assets/players/warrior/shoot_run_2.png",
                "assets/players/warrior/shoot_run_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -42,
                    direction = "forward"
                }
            }
        },

        shoot_jump = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/shoot_jump_1.png",
                "assets/players/warrior/shoot_jump_2.png",
                "assets/players/warrior/shoot_jump_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -42,
                    direction = "forward"
                }
            }
        },

        shoot_fall = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/shoot_fall_1.png",
                "assets/players/warrior/shoot_fall_2.png",
                "assets/players/warrior/shoot_fall_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -42,
                    direction = "forward"
                }
            }
        },

        shoot_crouch = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/shoot_crouch_1.png",
                "assets/players/warrior/shoot_crouch_2.png",
                "assets/players/warrior/shoot_crouch_3.png"
            },
            events = {
                {
                    frame = 1,
                    type = "setVelocity",
                    vx = 0
                },
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -32,
                    direction = "forward"
                }
            }
        },

        melee_stand01 = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/melee_stand01_1.png",
                "assets/players/warrior/melee_stand01_2.png",
                "assets/players/warrior/melee_stand01_3.png"
            },
            events = {
                {
                    frame = 1,
                    type = "setVelocity",
                    vx = 0
                },
                {
                    frame = 2,
                    type = "damageHitbox",
                    hitbox = "slash",
                    damage = 1,
                    deathType = "heavy",
                    damageTargets = {
                        enemy = true
                    }
                }
            }
        },

        melee_stand02 = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/melee_stand02_1.png",
                "assets/players/warrior/melee_stand02_2.png",
                "assets/players/warrior/melee_stand02_3.png"
            },
            events = {
                {
                    frame = 1,
                    type = "setVelocity",
                    vx = 0
                },
                {
                    frame = 2,
                    type = "damageHitbox",
                    hitbox = "slash",
                    damage = 1,
                    deathType = "heavy",
                    damageTargets = {
                        enemy = true
                    }
                }
            }
        },

        melee_stand03 = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/melee_stand03_1.png",
                "assets/players/warrior/melee_stand03_2.png",
                "assets/players/warrior/melee_stand03_3.png"
            },
            events = {
                {
                    frame = 1,
                    type = "setVelocity",
                    vx = 0
                },
                {
                    frame = 2,
                    type = "damageHitbox",
                    hitbox = "slash",
                    damage = 1,
                    deathType = "heavy",
                    damageTargets = {
                        enemy = true
                    }
                }
            }
        },

        melee_jump = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/melee_jump_1.png",
                "assets/players/warrior/melee_jump_2.png",
                "assets/players/warrior/melee_jump_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "damageHitbox",
                    hitbox = "slash",
                    damage = 1,
                    deathType = "heavy",
                    damageTargets = {
                        enemy = true
                    }
                }
            }
        },

        melee_fall = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/melee_fall_1.png",
                "assets/players/warrior/melee_fall_2.png",
                "assets/players/warrior/melee_fall_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "damageHitbox",
                    hitbox = "slash",
                    damage = 1,
                    deathType = "heavy",
                    damageTargets = {
                        enemy = true
                    }
                }
            }
        },

        melee_crouch = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/melee_crouch_1.png",
                "assets/players/warrior/melee_crouch_2.png",
                "assets/players/warrior/melee_crouch_3.png"
            },
            events = {
                {
                    frame = 1,
                    type = "setVelocity",
                    vx = 0
                },
                {
                    frame = 2,
                    type = "damageHitbox",
                    hitbox = "crouch_slash",
                    damage = 1,
                    deathType = "heavy",
                    damageTargets = {
                        enemy = true
                    }
                }
            }
        },

        strafe = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior/strafe_1.png",
                "assets/players/warrior/strafe_2.png",
                "assets/players/warrior/strafe_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "move",
                    x = 30,
                    y = 0
                }
            }
        },

        pain = {
            loop = false,
            lockInput = true,
            frameDuration = 0.1,
            frames = {
                "assets/players/warrior/pain_1.png",
                "assets/players/warrior/pain_2.png"
            }
        },

        death = {
            loop = false,
            lockInput = true,
            frameDuration = 0.15,
            frames = {
                "assets/players/warrior/death_1.png",
                "assets/players/warrior/death_2.png",
                "assets/players/warrior/death_3.png"
            }
        }
    }
}