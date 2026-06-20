return {
    id = "level3",

    music = nil,

	bounds = {
		left = 0,
		right = 800,
		top = 0,
		bottom = 600
	},

    playerStart = {
        x = 120,
        y = 555
    },

    backgrounds = {
        {
            image = "assets/levels/level1/sky1.png",
            scrollFactor = 0.15,
            scaleX = 1,
            scaleY = 1.2,
            offsetY = -40,
            scrollSpeed = 16,
            scrollDirection = "left"
        },
        {
            image = "assets/levels/level1/mountains1.png",
            scrollFactor = 0.35,
            scaleX = 1,
            scaleY = 1.2,
            offsetY = -80,
            scrollSpeed = 24,
            scrollDirection = "left"
        },
        {
            image = "assets/levels/level1/trees1.png",
            scrollFactor = 0.65,
            scaleX = 1,
            scaleY = 1.2,
            offsetY = -40,
            scrollSpeed = 38,
            scrollDirection = "left"
        },
        {
            image = "assets/levels/level1/bk4.png",
            scrollFactor = 0.95,
            scaleX = 1,
            scaleY = 1.2,
            offsetY = -40,
            scrollSpeed = 52,
            scrollDirection = "left"
        },
        {
            image = "assets/levels/level1/bushes1.png",
            scrollFactor = 1.15,
            layer = "front",
            scaleX = 1,
            scaleY = 1.2,
            scrollSpeed = 72,
            scrollDirection = "left"
        }
    },

    actors = {},
	

    platforms = {
        {
            id = "wood_road",
            x = 0,
            y = 555,
            w = 900,
            h = 145,
            visualHeight = 445,
            solid = true,

            -- Физика земли стоит на месте.
            -- Двигается только картинка земли.
            imageScrollSpeed = 140,
            imageScrollDirection = "left",

            color = {
                0.18,
                0.22,
                0.26
            }
        }
    },

    pickups = {},

    decors = {
		{
			id = "despawn_zone_stay_just",
			x = -220,
			y = -150
		},
        {
            id = "spawner_for_runnin",
            x = 760,
            y = 140,
            layer = "front"
        }
    },

    effects = {},

    levelEnd = nil
}