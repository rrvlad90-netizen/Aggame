return {
    id = "easy_forest_01",
    name = "Forest Clearing",

    biome = "forest",
	
	controls = {
		movement = "free",

		jumps = {
			"medium"
		},

		melee = true,
		ranged = true,
		shield = true,

		hint =
			"MOVE FREELY\n" ..
			"JUMP, ATTACK, SHOOT AND BLOCK"
	},	
	
	enemies = {
        skeletonCount = 3,
        shieldSkeletonCount = 1,
        wyvernCount = 15,
		
		wyvernRangedOnly = false  --на легком уровне их можно бить мечом
		--wyvernRangedOnly = true --только стрелами можно одолжеть
    },
	
    seed = 2001,
    generationMode = "procedural",

    preview = {
        image =
            "assets/images/previews/forest_clearing.png",

        fadeOutDuration = 0.5,
        displayDuration = 1.5,
        fadeInDuration = 0.5
    },
	
	background = {
		clearColor = {
			0.32,
			0.62,
			0.82,
			1
		},

		sky = {
			image =
				"assets/images/backgrounds/forest/sky.png",

			parallax = 0.02,
			scrollSpeed = 0,
			scale = 1,
			offset = {
				x = 0,
				y = 0
			},
			alpha = 1,
			align = "top",
			repeatX = true
		},

		mountains = {
			image =
				"assets/images/backgrounds/forest/mountains.png",

			parallax = 0.08,
			scrollSpeed = 0,
			scale = 1,
			offset = {
				x = 0,
				y = 0
			},
			alpha = 1,
			align = "bottom",
			repeatX = true
		},

		trees = {
			image =
				"assets/images/backgrounds/forest/trees.png",

			parallax = 0.18,
			scrollSpeed = 0,
			scale = 1,
			offset = {
				x = 0,
				y = 0
			},
			alpha = 1,
			align = "bottom",
			repeatX = true
		}
	},	

    -- Размер игровой области в метрах.
    size = {
        width = 150,
        length = 180
    },

	rivers = {
		count = 3,

		startMargin = 18,
		finishMargin = 18,
		minimumSpacing = 24,

		-- Продолжение за боковые края карты.
		renderExtension = 70,

		renderDistance = 50,

		bridgeReveal = {
			startDistance = 52,
			fullDistance = 50
		},

		width = {
			minimum = 4,
			maximum = 7
		},

		bend = {
			enabled = true,
			minimumStrength = 2,
			maximumStrength = 6
		},

		bank = {
			width = 1.5,
			depth = 0.8,
			vegetationClearance = 1.5
		},

		bridge = {
			width = 4.5,
			lengthPadding = 1,
			sideMargin = 4,
			railingHeight = 0.9,

			-- Свободное пространство перед мостом.
			approachClearance = 6
		}
	},
	
	rendering = {
		distance = 34,
		behindDistance = 8
	},

	generator = {
		objectsPerChunk = 160,
		chunksAhead = 1,
		
		treeChance = 0.55,
		bushChance = 0.32,
		rockChance = 0.09,
		mushroomChance = 0.04,
		treeMinimumDistance = 5,

		decorationWidth = 180,
		safeCorridorWidth = 6,
		startSafeRadius = 8
	},

    -- Настройки отображения объектов уровня.
    visuals = {
        tree = {
            scale = 1.15,

            offset = {
                x = 0,
                y = 0
            },

            alpha = 1,
			
			collisionRadius = 1.4
        },

        bush = {
            scale = 0.9,

            offset = {
                x = 0,
                y = 0
            },

            alpha = 0.9
        }
    },

	exit = {
		type = "portal",

		-- Положение X в метрах.
		x = 0,

		-- Расстояние от дальнего края в метрах.
		distanceFromEnd = 4,

		scale = 1,
		activationRadius = 1.8,

		destination = {
			type = "next"
		}
	},

    assets = {
        music = nil
    }
}