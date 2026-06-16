return {
    id = "level1",
	
	defeatScene = "scenelevel1", ---на какую сцену отправить игрока, при его смерти на уровне

    music = nil,

    bounds = {
        left = 0,
        right = 3200,
        top = 0,
        bottom = 700
    },

    playerStart = {
        x = 120,
        y = 555
    },


    backgrounds = {
        {
            image = "assets/levels/level1/sky1.png",
            scrollFactor = 0.15,

--Если нужно растянуть ровно на ширину экрана, можно руками посчитать:
--scaleX = 1280 / 640

			scaleX = 1,
			scaleY = 1.2,

			offsetY = -40
  --  	    scrollSpeed = 120,
  --  	    scrollDirection = "left"
        },
        {
            image = "assets/levels/level1/mountains1.png",
            scrollFactor = 0.35,
			
			scaleX = 1,
			scaleY = 1.2,

			offsetY = -80
 --   	    scrollSpeed = 122,
 --   	    scrollDirection = "left"
        },
        {
            image = "assets/levels/level1/trees1.png",
            scrollFactor = 0.65,
			
			scaleX = 1,
			scaleY = 1.2,		
			
			offsetY = -40

 --   	    scrollSpeed = 125,
 --   	    scrollDirection = "left"
        },
        {
            image = "assets/levels/level1/bk4.png",
            scrollFactor = 0.95,

			scaleX = 1,
			scaleY = 1.2,

			offsetY = -40
			
 --   	    scrollSpeed = 126,
 --   	    scrollDirection = "left"
        },
        {
            image = "assets/levels/level1/bushes1.png",
            scrollFactor = 1.15,
            layer = "front",
			
			scaleX = 1,
			scaleY = 1.2,
						

 --  	    scrollSpeed = 118,
 --   	    scrollDirection = "left"
        }
    },

    actors = {
        {
            id = "goblin",
            x = 620,
            y = 555,
            appearDistance = 600
        },
        {
            id = "goblin",
            x = 920,
            y = 555,
            appearDistance = 600
        }
    },

    platforms = {
        -- Основная земля уровня.
        -- Теперь это обычная платформа, а не отдельная ground-физика.
        {
            id = "wood_road",
            x = 0,
            y = 555,  ---!!!!это реальная физическая верхняя линия.
            w = 3200,
            h = 145,
            visualHeight = 445, -----!!!!!это не координата. Это высота картинки/визуала.
            solid = true,
            color = {0.18, 0.22, 0.26}
        },

        -- Возвышенная платформа для прыжков.
        {
            id = "wood_platform",
            x = 420,
            y = 400,
			--solid = true --нельзя пройти сбоку и снаряды врезаются
        }
    },

    pickups = {
        {
            id = "health_small",
            x = 520,
            y = 555
        },
        {
            id = "ammo_small",
            x = 720,
            y = 555
        }
    },

    decors = {
        {
            id = "rock_small",
            x = 360,
            y = 555,
            layer = "back"
        }
    },

    effects = {},

    levelEnd = {
	    id = "door_level1",
        x = 2000,
        y = 555,

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