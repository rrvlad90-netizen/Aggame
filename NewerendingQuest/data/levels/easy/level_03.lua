return {
    id = "easy_dungeon_01",
    name = "Abandoned Dungeon",

    biome = "dungeon",
    seed = 3001,
    generationMode = "procedural",

    controls = {
        movement = "free",

        jumps = {
            "medium"
        },

        melee = true,
        ranged = true,
        shield = true,

        hint =
            "EXPLORE THE DUNGEON\n" ..
            "FIND PASSAGES BETWEEN THE HALLS"
    },

    preview = {
        image =
            "assets/images/previews/dungeon.png",

        fadeOutDuration = 0.5,
        displayDuration = 1.5,
        fadeInDuration = 0.5
    },

    size = {
        width = 70,
        length = 160
    },

    layout = {
        enabled = true,

        roomCount = 5,

        wallSpacing = 2,
        wallHeight = 135,

        openingWidth = 7,
        sideMargin = 6,

        passageClearance = 5,
        decorationClearance = 1,

        wallCollisionRadius = 1.05,

        wall = {
            -- Позднее:
            -- image =
            --     "assets/images/biomes/dungeon/wall.png",

            image = nil,

            color = {
                0.28,
                0.27,
                0.26,
                1
            },

            topColor = {
                0.4,
                0.38,
                0.35,
                1
            },

            lineColor = {
                0.16,
                0.15,
                0.14,
                1
            }
        }
    },
	
	combatRooms = {
    enabled = true,

    -- Двери закрываются после того,
    -- как игрок пройдёт два метра в зал.
    triggerDistance = 2,

    doorHeight = 150,
    doorDepth = 0.7,

	lighting = {
		enabled = true,

		-- Общая освещённость подземелья.
		ambient = {
			0.24,
			0.22,
			0.2
		},

		player = {
			enabled = true,

			radius = 285,
			intensity = 0.74,

			offsetY = 48,
			flicker = 0.025,

			color = {
				1,
				0.88,
				0.68
			}
		},

		mushrooms = {
			enabled = true,

			radius = 115,
			intensity = 0.4,

			offsetY = 12,
			flicker = 0.08,

			color = {
				0.28,
				0.78,
				0.5
			}
		}
	},

    door = {
			-- Позднее можно добавить:
			-- closedImage =
			--     "assets/images/biomes/dungeon/door_closed.png",
			--
			-- openImage =
			--     "assets/images/biomes/dungeon/door_open.png",

			closedImage = nil,
			openImage = nil,

			color = {
				0.3,
				0.23,
				0.14,
				1
			},

			darkColor = {
				0.14,
				0.11,
				0.08,
				1
			},

			metalColor = {
				0.42,
				0.43,
				0.44,
				1
			}
		}
	},
	
	traps = {
		enabled = true,

		countPerRoom = 2,

		triggerRadius = 1.35,
		minimumDistance = 5,

		roomMargin = 5,
		passageClearance = 3,

		warningDuration = 0.65,
		activeDuration = 0.55,
		cooldownDuration = 2.2,

		damage = 1,

		-- Минимальная высота прыжка,
		-- при которой шипы безопасны.
		safeJumpHeight = 0.7,

		visual = {
			radius = 34,
			spikeHeight = 38,

			-- Позднее:
			-- idleImage =
			--     "assets/images/biomes/dungeon/spikes_idle.png",
			--
			-- warningImage =
			--     "assets/images/biomes/dungeon/spikes_warning.png",
			--
			-- activeImage =
			--     "assets/images/biomes/dungeon/spikes_active.png",

			idleImage = nil,
			warningImage = nil,
			activeImage = nil,

			idleColor = {
				0.22,
				0.21,
				0.2,
				1
			},

			warningColor = {
				0.78,
				0.46,
				0.12,
				1
			},

			activeColor = {
				0.72,
				0.72,
				0.68,
				1
			},

			darkColor = {
				0.12,
				0.11,
				0.1,
				1
			}
		}
	},

    enemies = {
        skeletonCount = 8,
        shieldSkeletonCount = 3,
        wyvernCount = 0
    },

    generator = {
        objectCount = 180,

        columnChance = 0.32,
        rockChance = 0.43,
        mushroomChance = 0.25,

        decorationWidth = 76,

        -- Случайные проходы теперь создаёт layout.
        safeCorridorWidth = 0,

        startSafeRadius = 8,
        finishSafeRadius = 8,

        arrowBundleCount = 7
    },

    visuals = {
        column = {
            scale = 1,
            alpha = 1,
            collisionRadius = 1.25
        },

        rock = {
            scale = 1,
            alpha = 1,
            collisionRadius = 1.1
        },

        mushroom = {
            scale = 1,
            alpha = 1
        }
    },

    assets = {
        music = nil
    }
}