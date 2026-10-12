return {
    id = "easy_swamp_01",
    name = "First Swamp",

    biome = "swamp",
    seed = 1001,
    generationMode = "fixed",
			
	preview = {
		image =
			"assets/images/previews/first_swamp.png",

		fadeOutDuration = 0.5,
		displayDuration = 1.5,
		fadeInDuration = 0.5
	},
	
	background = {
		clearColor = {
			0.42,
			0.7,
			0.9,
			1
		},

		sky = {
			image =
				"assets/images/backgrounds/swamp/sky.png",
				
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
				"assets/images/backgrounds/swamp/mountains.png",

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
				"assets/images/backgrounds/swamp/trees.png",

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

    assets = {
        music = nil
    },

	exit = {
		type = "portal",

		scale = 1,
		activationRadius = 1.8,

		destination = {
			type = "next"
		}
	},

    platforms = {
        {
            type = "hummock",
            lane = 3,
            row = 0,
            radius = 125
        },
        {
            type = "hummock",
            lane = 3,
            row = 1,
            radius = 78
        },
        {
            type = "hummock",
            lane = 2,
            row = 3,
            radius = 78
        },
        {
            type = "hummock",
            lane = 3,
            row = 6,
            radius = 78
        },
        {
            type = "kikimora",
            lane = 3,
            row = 7,
            radius = 78
        },
        {
            type = "hummock",
            lane = 4,
            row = 9,
            radius = 78
        },
        {
            type = "hummock",
            lane = 4,
            row = 12,
            radius = 78
        },
        {
            type = "hummock",
            lane = 3,
            row = 13,
            radius = 100,
            goal = true
        }
    }
}