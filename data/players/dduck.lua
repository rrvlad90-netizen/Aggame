return {
    id = "dduck",
    name = "dduck",
	
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
        height = 64
    },

    offset = {
        x = 0,
        y = 0
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
                "assets/players/dduck/dspawn_1.png",
                "assets/players/dduck/dspawn_2.png",
                "assets/players/dduck/dspawn_3.png"
            }
        },

        idle = {
            loop = true,
            frameDuration = 0.16,
            frames = {
                "assets/players/dduck/didle_1_3.png",
                "assets/players/dduck/didle_2.png"
            }
        },

        run = {
            loop = true,
            frameDuration = 0.1,
            frames = {
                "assets/players/dduck/dwalk_1.png",
                "assets/players/dduck/dwalk_2.png",
                "assets/players/dduck/dwalk_1.png",
                "assets/players/dduck/dwalk_4.png"
            }
        },

        jump = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/dduck/djump1.png"
            }
        },

        fall = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/dduck/djumpdown1.png"
            }
        },

        crouch = {
            loop = true,
            frameDuration = 0.14,
            frames = {
                "assets/players/dduck/dcrouch_1.png"
            }
        },

        block = {
            loop = true,
            lockInput = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/dduck/dguard_1.png",
				"assets/players/dduck/dguard_2.png"
            }
        },

        crouch_block = {
            loop = true,
            lockInput = true,
            frameDuration = 0.12,
            frames = {
                "assets/players/dduck/dguardcrouch_1.png"
            }
        },

        shoot_stand = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/dduck/dattack_1.png",
                "assets/players/dduck/dattack_1.png",
                "assets/players/dduck/dattack_1.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_forward",
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
                "assets/players/dduck/shoot_run_1.png",
                "assets/players/dduck/shoot_run_2.png",
                "assets/players/dduck/shoot_run_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_forward",
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
                "assets/players/dduck/dstartjumpattack_1.png",
                "assets/players/dduck/dstartjumpattack_1.png",
                "assets/players/dduck/dstartjumpattack_1.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_forward",
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
                "assets/players/dduck/djumpdownattack1.png",
                "assets/players/dduck/djumpdownattack1.png",
                "assets/players/dduck/djumpdownattack1.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_forward",
                    x = 34,
                    y = -42,
                    direction = "forward"
                }
            }
        },

        shoot_crouch = {
            loop = false,
            lockInput = true,
            fireFirstFrameEvents = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/dduck/dcrouchattack_1.png",
                "assets/players/dduck/dcrouchattack_1.png",
                "assets/players/dduck/dcrouchattack_1.png"
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
                    id = "player_projectile_forward",
                    x = 34,
                    y = -32,
                    direction = "forward"
                }
            }
        },

        shoot_up_stand = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/dduck/shoot_up_stand_1.png",
                "assets/players/dduck/shoot_up_stand_2.png",
                "assets/players/dduck/shoot_up_stand_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_up",
                    x = 8,
                    y = -68
                }
            }
        },

        shoot_up_run = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/dduck/shoot_up_run_1.png",
                "assets/players/dduck/shoot_up_run_2.png",
                "assets/players/dduck/shoot_up_run_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_up",
                    x = 8,
                    y = -68
                }
            }
        },

        shoot_up_jump = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/dduck/shoot_up_jump_1.png",
                "assets/players/dduck/shoot_up_jump_2.png",
                "assets/players/dduck/shoot_up_jump_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_up",
                    x = 8,
                    y = -68
                }
            }
        },

        shoot_up_fall = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/dduck/shoot_up_fall_1.png",
                "assets/players/dduck/shoot_up_fall_2.png",
                "assets/players/dduck/shoot_up_fall_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_up",
                    x = 8,
                    y = -68
                }
            }
        },

        shoot_diagonal_up_run = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/dduck/shoot_diagonal_up_run_1.png",
                "assets/players/dduck/shoot_diagonal_up_run_2.png",
                "assets/players/dduck/shoot_diagonal_up_run_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_diagonal_up",
                    x = 34,
                    y = -58,
                    direction = "forward"
                }
            }
        },

        shoot_diagonal_up_jump = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/dduck/shoot_diagonal_up_jump_1.png",
                "assets/players/dduck/shoot_diagonal_up_jump_2.png",
                "assets/players/dduck/shoot_diagonal_up_jump_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_diagonal_up",
                    x = 34,
                    y = -58,
                    direction = "forward"
                }
            }
        },

        shoot_diagonal_up_fall = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                "assets/players/dduck/shoot_diagonal_up_fall_1.png",
                "assets/players/dduck/shoot_diagonal_up_fall_2.png",
                "assets/players/dduck/shoot_diagonal_up_fall_3.png"
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "player_projectile_diagonal_up",
                    x = 34,
                    y = -58,
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
                "assets/players/dduck/melee_stand01_1.png",
                "assets/players/dduck/melee_stand01_2.png",
                "assets/players/dduck/melee_stand01_3.png"
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
                "assets/players/dduck/melee_stand02_1.png",
                "assets/players/dduck/melee_stand02_2.png",
                "assets/players/dduck/melee_stand02_3.png"
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
                "assets/players/dduck/melee_stand03_1.png",
                "assets/players/dduck/melee_stand03_2.png",
                "assets/players/dduck/melee_stand03_3.png"
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
                "assets/players/dduck/melee_run01_1.png",
                "assets/players/dduck/melee_run01_2.png",
                "assets/players/dduck/melee_run01_3.png"
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
                "assets/players/dduck/melee_run02_1.png",
                "assets/players/dduck/melee_run02_2.png",
                "assets/players/dduck/melee_run02_3.png"
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
                "assets/players/dduck/melee_run03_1.png",
                "assets/players/dduck/melee_run03_2.png",
                "assets/players/dduck/melee_run03_3.png"
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
                "assets/players/dduck/melee_jump_1.png",
                "assets/players/dduck/melee_jump_2.png",
                "assets/players/dduck/melee_jump_3.png"
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
                "assets/players/dduck/melee_fall_1.png",
                "assets/players/dduck/melee_fall_2.png",
                "assets/players/dduck/melee_fall_3.png"
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
                "assets/players/dduck/melee_crouch_1.png",
                "assets/players/dduck/melee_crouch_2.png",
                "assets/players/dduck/melee_crouch_3.png"
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
                "assets/players/dduck/dspawn_1.png",
                "assets/players/dduck/dspawn_1.png",
                "assets/players/dduck/dspawn_1.png"
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
                "assets/players/dduck/dpain1.png",
                "assets/players/dduck/dpain1.png"
            }
        },
		
--		win = {
--			loop = false,
--			lockInput = true,
--			frameDuration = 0.41,
--			frames = {
--				"assets/players/warrior/dspawn_1.png",
--				"assets/players/warrior/dspawn_2.png",
--				"assets/players/warrior/dspawn_3.png"
--			}
--		},

        death = {
            loop = false,
            lockInput = true,
            frameDuration = 0.15,
            frames = {
                "assets/players/dduck/dpain1.png",
                "assets/players/dduck/ddeath_1.png",
				"assets/players/dduck/ddeath_2.png",
                "assets/players/dduck/ddeath_3.png"
            }
        }
    }
}