return {
    id = "warrior",
    name = "Warrior",

    portrait = nil,

    health = 5,
    lives = 3,

    speed = 180,
    jumpPower = -430,
    gravity = 900,

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
        }
    },

    abilities = {
        canMove = true,
        canJump = true,
        canDoubleJump = false,
        canShoot = true,
        canMelee = true,
        canCrouch = true,
        canStrafe = true
    },

    ammo = {
        stone = nil
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

        run = {
            loop = true,
            frameDuration = 0.1,
            frames = {
                nil,
                nil,
                nil,
                nil
            }
        },

        jump = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                nil
            }
        },

        shoot = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                nil,
                nil,
                nil
            },
            events = {
                {
                    frame = 2,
                    type = "createEntity",
                    id = "stone",
                    x = 34,
                    y = -42,
                    direction = "forward"
                }
            }
        },

        melee = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                nil,
                nil,
                nil
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

        crouch = {
            loop = false,
            lockInput = true,
            frameDuration = 0.12,
            frames = {
                nil,
                nil
            },
            events = {
                {
                    frame = 1,
                    type = "setBbox",
                    bbox = "crouch"
                },
                {
                    frame = 2,
                    type = "setBbox",
                    bbox = "stand"
                }
            }
        },

        strafe = {
            loop = false,
            lockInput = true,
            frameDuration = 0.08,
            frames = {
                nil,
                nil,
                nil
            },
            events = {
                {
                    frame = 2,
                    type = "move",
                    x = -30,
                    y = 0
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
            frameDuration = 0.15,
            frames = {
                nil,
                nil,
                nil
            }
        }
    }
}