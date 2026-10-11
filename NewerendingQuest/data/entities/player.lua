local directions = {
    "north",
    "north_east",
    "east",
    "south_east",
    "south",
    "south_west",
    "west",
    "north_west"
}

local diagonal =
    1 / math.sqrt(2)

local directionVectors = {
    north = { x = 0, y = 1 },
    north_east = { x = diagonal, y = diagonal },
    east = { x = 1, y = 0 },
    south_east = { x = diagonal, y = -diagonal },
    south = { x = 0, y = -1 },
    south_west = { x = -diagonal, y = -diagonal },
    west = { x = -1, y = 0 },
    north_west = { x = -diagonal, y = diagonal }
}

local animations = {}

-- Формирует путь к кадру.
local function frame(
    root,
    direction,
    name
)
    return string.format(
        "%s/%s/%s.png",
        root,
        direction,
        name
    )
end

-- Создаёт полный направленный набор анимаций.
local function addAnimationSet(
    keyPrefix,
    root,
    hasBlock
)
    for _, direction in ipairs(
        directions
    ) do
        local prefix =
            keyPrefix ..
            "idle_" ..
            direction

        animations[prefix] = {
            loop = true,
            frameDuration = 0.16,

            frames = {
                frame(
                    root,
                    direction,
                    "idle_01"
                )
            }
        }

        animations[
            keyPrefix ..
            "walk_" ..
            direction
        ] = {
            loop = true,
            frameDuration = 0.12,

            frames = {
                frame(
                    root,
                    direction,
                    "walk_01"
                ),

                frame(
                    root,
                    direction,
                    "walk_02"
                )
            }
        }

        animations[
            keyPrefix ..
            "run_" ..
            direction
        ] = {
            loop = true,
            frameDuration = 0.09,

            frames = {
                frame(root, direction, "run_01"),
                frame(root, direction, "run_02"),
                frame(root, direction, "run_03"),
                frame(root, direction, "run_04")
            }
        }

        animations[
            keyPrefix ..
            "jump_" ..
            direction
        ] = {
            loop = true,
            frameDuration = 0.12,

            frames = {
                frame(
                    root,
                    direction,
                    "jump_01"
                )
            }
        }

        animations[
            keyPrefix ..
            "fall_" ..
            direction
        ] = {
            loop = true,
            frameDuration = 0.12,

            frames = {
                frame(
                    root,
                    direction,
                    "fall_01"
                )
            }
        }

        animations[
            keyPrefix ..
            "shoot_" ..
            direction
        ] = {
            loop = false,
            frameDuration = 0.1,

            frames = {
                frame(root, direction, "shoot_01"),
                frame(root, direction, "shoot_02"),
                frame(root, direction, "shoot_03")
            }
        }

        animations[
            keyPrefix ..
            "melee_" ..
            direction
        ] = {
            loop = false,
            frameDuration = 0.12,

            frames = {
                frame(root, direction, "melee_01"),
                frame(root, direction, "melee_02"),
                frame(root, direction, "melee_03")
            }
        }

        animations[
            keyPrefix ..
            "death_" ..
            direction
        ] = {
            loop = false,
            frameDuration = 0.15,

            frames = {
                frame(root, direction, "death_01"),
                frame(root, direction, "death_02"),
                frame(root, direction, "death_03"),
                frame(root, direction, "death_04")
            }
        }

        if hasBlock then
            animations[
                keyPrefix ..
                "block_" ..
                direction
            ] = {
                loop = true,
                frameDuration = 0.14,

                frames = {
                    frame(root, direction, "block_01"),
                    frame(root, direction, "block_02")
                }
            }
			
			animations[
				keyPrefix ..
				"block_pain_" ..
				direction
			] = {
				loop = false,
				frameDuration = 0.12,

				frames = {
					frame(
						root,
						direction,
						"block_pain_01"
					),

					frame(
						root,
						direction,
						"block_pain_02"
					),

					frame(
						root,
						direction,
						"block_pain_03"
					)
				}
			}
        end
    end
end

addAnimationSet(
    "",
    "assets/images/player",
    false
)

addAnimationSet(
    "shield_",
    "assets/images/player_with_shield",
    true
)

-- Общая ненаправленная анимация появления.
animations.spawn = {
    loop = false,
    frameDuration = 0.15,

    frames = {
        "assets/images/player/spawn_01.png",
        "assets/images/player/spawn_02.png",
        "assets/images/player/spawn_03.png",
        "assets/images/player/spawn_04.png"
    }
}

-- Появление со щитом.
animations.shield_spawn = {
    loop = false,
    frameDuration = 0.15,
	
    frames = {
        "assets/images/player_with_shield/spawn_01.png",
        "assets/images/player_with_shield/spawn_02.png",
        "assets/images/player_with_shield/spawn_03.png",
        "assets/images/player_with_shield/spawn_04.png"
    }
}

return {
    id = "player",
    name = "Player",

    fallbackImage =
        "assets/images/player/player_idle.png",

    scale = 1,
    spriteHeight = 100,

    maxHealth = 5,
    continues = 3,

    damageInvulnerability = 0.8,
    deathDuration = 0.6,

    spawn = {
        duration = 0.6,

        shockwave = {
            enabled = true,
            time = 0.3,
            radius = 5,
            force = 180,
            damage = 0
        }
    },

    forwardSpeed = 120,
    backwardSpeed = 75,
    sideSpeed = 160,

    runSpeedMultiplier = 1.65,

    collisionRadius = 18,
    jumpHeight = 115,

    defaultDirection = "north",

    ammo = {
        arrows = {
            startAmount = 5,
            maximumAmount = 30
        }
    },

    shield = {
        maximumDurability = 100,
		blockPainDuration = 0.36,
        -- Ноль означает блокирование передней полусферы.
        minimumFrontDot = 0,

        blockSound =
            "assets/sounds/player/shield_block.wav",

        breakSound =
            "assets/sounds/player/shield_break.wav"
    },

    rangedAttack = {
        duration = 0.3,
        releaseTime = 0.12
    },

    meleeAttack = {
        damage = 1,

        duration = 0.36,
        hitTime = 0.14,

        range = 3,
        width = 2
    },

    jumps = {
        near = {
            rows = 1,
            forward = 150,
            duration = 0.48
        },

        medium = {
            rows = 2,
            forward = 300,
            duration = 0.65
        },

        far = {
            rows = 3,
            forward = 450,
            duration = 0.82
        }
    },

    directions = directions,
    directionVectors = directionVectors,
    animations = animations
}