return {
    id = "dduck_bow",
    name = "dduck bow",
	
	portrait = "assets/players/dduck/portrait.png",


    health = 5,
    lives = 3,

    speed = 180,
    jumpPower = -430,
    gravity = 900,

    comboWindow = 0.35,

    shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 54,
    shadowHeight = 10,
    shadowOffsetY = 2,

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

        melee_run = {
            "melee_run01",
            "melee_run02",
            "melee_run03"
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
                "assets/players/warrior_full/spawn_1.png",
                "assets/players/warrior_full/spawn_2.png",
                "assets/players/warrior_full/spawn_3.png"
            }
        },

        idle = {
            loop = true,
            frameDuration = 0.16,
            frames = {
                "assets/players/warrior_full/idle_1.png",
                "assets/players/warrior_full/idle_2.png"
            }
        },

        run = {
            loop = true,
            frameDuration = 0.1,
            frames = {
                "assets/players/warrior_full/run_1.png",
                "assets/players/warrior_full/run_2.png",
                "assets/players/warrior_full/run_3.png",
                "assets/players/warrior_full/run_4.png"
            }
        },

        jump = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/warrior_full/jump_1.png"
            }
        },

        fall = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/warrior_full/fall_1.png"
            }
        },

        crouch = {
            loop = true,
            frameDuration = 0.14,
            frames = {
                "assets/players/warrior_full/crouch_1.png"
            }
        },

        block = {
            loop = true,
            lockInput = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/warrior_full/block_1.png"
            }
        },

        crouch_block = {
            loop = true,
            lockInput = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/warrior_full/crouch_block_1.png"
            }
        },

        shoot_stand = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_stand_1.png",
                "assets/players/warrior_full/shoot_stand_2.png",
                "assets/players/warrior_full/shoot_stand_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -42,
                    direction = "forward"
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_run = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_run_1.png",
                "assets/players/warrior_full/shoot_run_2.png",
                "assets/players/warrior_full/shoot_run_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -42,
                    direction = "forward"
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_jump = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_jump_1.png",
                "assets/players/warrior_full/shoot_jump_2.png",
                "assets/players/warrior_full/shoot_jump_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -42,
                    direction = "forward"
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_fall = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_fall_1.png",
                "assets/players/warrior_full/shoot_fall_2.png",
                "assets/players/warrior_full/shoot_fall_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -42,
                    direction = "forward"
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_crouch = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_crouch_1.png",
                "assets/players/warrior_full/shoot_crouch_2.png",
                "assets/players/warrior_full/shoot_crouch_3.png"
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
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_up_stand = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_up_stand_1.png",
                "assets/players/warrior_full/shoot_up_stand_2.png",
                "assets/players/warrior_full/shoot_up_stand_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 8,
                    y = -68
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_up_run = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_up_run_1.png",
                "assets/players/warrior_full/shoot_up_run_2.png",
                "assets/players/warrior_full/shoot_up_run_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 8,
                    y = -68
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_up_jump = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_up_jump_1.png",
                "assets/players/warrior_full/shoot_up_jump_2.png",
                "assets/players/warrior_full/shoot_up_jump_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 8,
                    y = -68
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_up_fall = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_up_fall_1.png",
                "assets/players/warrior_full/shoot_up_fall_2.png",
                "assets/players/warrior_full/shoot_up_fall_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 8,
                    y = -68
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_diagonal_up_run = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_diagonal_up_run_1.png",
                "assets/players/warrior_full/shoot_diagonal_up_run_2.png",
                "assets/players/warrior_full/shoot_diagonal_up_run_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -58,
                    direction = "forward"
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_diagonal_up_jump = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_diagonal_up_jump_1.png",
                "assets/players/warrior_full/shoot_diagonal_up_jump_2.png",
                "assets/players/warrior_full/shoot_diagonal_up_jump_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -58,
                    direction = "forward"
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        shoot_diagonal_up_fall = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/shoot_diagonal_up_fall_1.png",
                "assets/players/warrior_full/shoot_diagonal_up_fall_2.png",
                "assets/players/warrior_full/shoot_diagonal_up_fall_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_arc_projectile",
                    x = 34,
                    y = -58,
                    direction = "forward"
                },
				{
					frame = 2,
					type = "consumeWeaponUse",
					amount = 1
				}
            }
        },

        melee_stand01 = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/melee_stand01_1.png",
                "assets/players/warrior_full/melee_stand01_2.png",
                "assets/players/warrior_full/melee_stand01_3.png"
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
                "assets/players/warrior_full/melee_stand02_1.png",
                "assets/players/warrior_full/melee_stand02_2.png",
                "assets/players/warrior_full/melee_stand02_3.png"
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
                "assets/players/warrior_full/melee_stand03_1.png",
                "assets/players/warrior_full/melee_stand03_2.png",
                "assets/players/warrior_full/melee_stand03_3.png"
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

        melee_run01 = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/melee_run01_1.png",
                "assets/players/warrior_full/melee_run01_2.png",
                "assets/players/warrior_full/melee_run01_3.png"
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

        melee_run02 = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/melee_run02_1.png",
                "assets/players/warrior_full/melee_run02_2.png",
                "assets/players/warrior_full/melee_run02_3.png"
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

        melee_run03 = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/melee_run03_1.png",
                "assets/players/warrior_full/melee_run03_2.png",
                "assets/players/warrior_full/melee_run03_3.png"
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

        melee_jump = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/warrior_full/melee_jump_1.png",
                "assets/players/warrior_full/melee_jump_2.png",
                "assets/players/warrior_full/melee_jump_3.png"
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
                "assets/players/warrior_full/melee_fall_1.png",
                "assets/players/warrior_full/melee_fall_2.png",
                "assets/players/warrior_full/melee_fall_3.png"
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
                "assets/players/warrior_full/melee_crouch_1.png",
                "assets/players/warrior_full/melee_crouch_2.png",
                "assets/players/warrior_full/melee_crouch_3.png"
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
                "assets/players/warrior_full/strafe_1.png",
                "assets/players/warrior_full/strafe_2.png",
                "assets/players/warrior_full/strafe_3.png"
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
                "assets/players/warrior_full/pain_1.png",
                "assets/players/warrior_full/pain_2.png"
            }
        },

        death = {
            loop = false,
            lockInput = true,
            frameDuration = 0.15,
            frames = {
                "assets/players/warrior_full/death_1.png",
                "assets/players/warrior_full/death_2.png",
                "assets/players/warrior_full/death_3.png"
            }
        }
    }
}