return {
    id = "level2",

    defeatScene = "scenelevel2", ---на какую сцену отправить игрока, при его смерти на уровне

    music = nil,

    bounds = {
        left = 0,
        right = 2200,
        top = 0,
        bottom = 600
    },

    playerStart = {
        x = 120,
        y = 455
    },

    backgrounds = {
        {
            image = nil,
            scrollFactor = 0.15
        },
        {
            image = nil,
            scrollFactor = 0.35
        },
        {
            image = nil,
            scrollFactor = 0.65
        },
        {
            image = nil,
            scrollFactor = 0.95
        },
        {
            image = nil,
            scrollFactor = 1.15,
            layer = "front"
        }
    },

    actors = {
        {
            id = "goblin",
            x = 620,
            y = 455,
            appearDistance = 600
        },
		{
            id = "goblin",
            x = 920,
            y = 455,
            appearDistance = 600,
			solid = true
        },
        {
            id = "goblin",
            x = 1220,
            y = 455,
            appearDistance = 600
        }
    },

    platforms = {
        -- Основная земля уровня.
        -- Теперь это обычная платформа, а не отдельная ground-физика.
        {
            id = "wood_platform",
            x = 0,
            y = 455,
            w = 2200,
            h = 145,
            visualHeight = 145,
            solid = true,
            color = {0.18, 0.22, 0.26}
        },
    },

    effects = {},

    levelEnd = {
	    id = "door_level2",
        x = 2000,
        y = 455,

        canvas = {
            width = 48,
            height = 80
        },

        offset = {
            x = 24,
            y = 80
        },

        bbox = {
            x = 0,
            y = 0,
            w = 48,
            h = 80
        },

        image = nil
    }
}