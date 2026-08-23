return {
    id = "level1",
	
	--playerId = "dduck_bow",
	
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

--	oneSide = true, --по уровню можно идти только в одну сторону
--	oneSideBackMargin = 0,

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
	
		checkpoints = {
--		{
--			id = "checkpoint_flag",

--			x = 800,
--			y = 555,

--			respawnX = 760,
--			respawnY = 555
--		},

		{
			id = "checkpoint_flag",

			x = 1700,
			y = 555,

			--respawnX = 1360,--респавн в яму
			respawnX = 1660, --респавн верный (рядом с чекпоинтом)
			respawnY = 555
		}
	},

    actors = {
--	    {
--            id = "ghost_dragon",  --при атаке сквозь него проходит проджектайл и не наносит урона
--            x = 620,
--            y = 455,
--            appearDistance = 600
--        },
--        {
--            id = "goblin_blocker",  --всегда блокирует удар
--            x = 620,
--            y = 555,
--            appearDistance = 600
--        },
		{
            id = "friendly_special_goblin",
            x = 380,
            y = 315,
            appearDistance = 600
        },
--		{
--            id = "special_goblin",
--            x = 820,
--            y = 555,
--            appearDistance = 600
--        },
		
--        {
--           id = "flying_shooter",
--           x = 920,
--           y = 475,
--           appearDistance = 600
--        },
        {
			id = "flying_aim_shooter",
            x = 1020,
            y = 435,
            appearDistance = 600
        },
        {
			id = "dragon",
            x = 1320,
            y = 435,
            appearDistance = 600
        },		
        {
		    id = "bat_bomber",
            x = 1520,
            y = 425,
            appearDistance = 600
        },
		{
			id = "jumping_goblin",
			x = 1800,
			y = 555,
			appearDistance = 600
		}
		
    },

    platforms = {
        
        {
            id = "wood_road", -- Основная земля уровня, это обычная платформа, а не отдельная ground-физика.
            x = 0,
            y = 555,  ---!!!!это реальная физическая верхняя линия.
            w = 1200,
			--w = 3200,
            h = 145,
            visualHeight = 445, -----!!!!!это не координата. Это высота картинки/визуала.
            solid = true,
            color = {0.18, 0.22, 0.26}
		},
		
		---между ними разместил дыру
		
		{
            id = "wood_road",  -- Основная земля уровня
            x = 1400,
            y = 555,  ---!!!!это реальная физическая верхняя линия.
            w = 2200,
			--w = 3200,
            h = 145,
            visualHeight = 445, -----!!!!!это не координата. Это высота картинки/визуала.
            solid = true,
            color = {0.18, 0.22, 0.26}
		},
		
        {
            id = "falling_platform",
            x = 120,
            y = 155,
			--solid = true --нельзя пройти сбоку и снаряды врезаются
        },
		
		{
            id = "dissapear_platform",
            x = 320,
            y = 355,
			--solid = true --нельзя пройти сбоку и снаряды врезаются
        },
 
 
		 {
			id = "slope_ground",

			x = 180,
			y = 455,

			w = 240,
			h = 100,

			slope = true,
			slopeWalkOn = true,--Если true — игрок/actor сможет зайти на склон с земли/платформы.
			--Если false или не указано — то можно только запрыгнуть сверху, сбоку зайти нельзя
			slopeStepHeight = 48,

			slopeLeftY = 555,
			slopeRightY = 455,
			slopeBottomY = 555,

			solid = true,
			--solid = true --нельзя пройти сбоку и снаряды врезаются

			color = {0.35, 0.25, 0.15}
		},
        -- Возвышенная платформа для прыжков.
        {
            id = "wood_platform",
            x = 420,
            y = 455,
			--solid = true --нельзя пройти сбоку и снаряды врезаются
        },
		{
			id = "slope_ground",

			-- Ставим в конец wood_platform x = 420, w = 160.
			x = 580,
			y = 455,

			w = 240,
			h = 100,

			slope = true,
			slopeWalkOn = false, --Если false или не указано — то можно только запрыгнуть сверху, сбоку зайти нельзя
			slopeStepHeight = 48,

			-- Обратное направление: слева высоко, справа низко.
			slopeLeftY = 455,
			slopeRightY = 555,
			slopeBottomY = 555,

			solid = false,

			color = {0.35, 0.25, 0.15}
		},
		-- Площадка над лестницей.
        {
            id = "wood_platform",

            x = 620,
            y = 220,

            w = 220,
            h = 24,

            solid = false
        },
    },
	

    pickups = {
        {
            id = "health_small",
            x = 520,
            y = 555
        },
        {
            id = "bow_weapon",
            x = 720,
            y = 555
        },
		{
			id = "life_small",
			x = 500,
			y = 300
		}
    },

    decors = {
	
		{
			id = "pit_zone", --яма

			x = 0,
			y = 850,

			bbox = {
				x = 0,
				y = 0,
				w = 3200,
				h = 220
			},

			canvas = {
				width = 3200,
				height = 220,
			},
	---для теста, но можно и оставить 
	--если только внизу уровня всегда держать		
			alpha = 0.75, 
			color = {1, 0, 0},
	---		
		},	
		{
			id = "despawn_zone",
			x = -1220,
			y = -150
		},
        {
            id = "rock_small",
            x = 360,
            y = 555,
            layer = "back"
        },
		{
            id = "goblin_watcher",
            x = 390,
            y = 465,
            layer = "middle"
        },
--		{
--            id = "torch",
--            x = 790,
--            y = 505,
--            layer = "back"
--        },
		{
            id = "tree",
            x = 990,
            y = 505,
            layer = "front"
        },		
		
    },

effects = {},

    ladders = {
        {
            id = "ladder_floor_1",

            x = 700,
            y = 200,

            width = 48,
            height = 355,

            climbSpeed = 120,
            layer = "middle",

            -- Для проверки сделаем лестницу яркой.
            color = {1, 0, 0, 1}
        }
    },

    levelEnds = {
        {
            id = "activate_door_level1",
            x = 100,
            y = 555,

            layer = "middle",
            alpha = 1,
            activateIfTouch = true,
            nextLevel = "level2",

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
            }
        },

        {
            id = "door_level1",
            x = 2000,
            y = 555,

            layer = "front",
            alpha = 0.85,
            activateIfTouch = false,
            nextScene = "scenelevel2",

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
}