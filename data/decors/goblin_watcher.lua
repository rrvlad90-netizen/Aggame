return {
    id = "goblin_watcher",

    layer = "back",

    x = 0,
    y = 0,

    --trackPlayer = true, -- переходит в idleleft, idle и idleright в зависимости от положения игрока

    leftAnimation = "idleleft",
    centerAnimation = "idle",
    rightAnimation = "idleright",

	defaultAnimation = "spawn",

    centerRange = 100,

    canvas = {
        width = 69,
        height = 77
    },


    animations = {
        spawn = {
            loop = false,
            frameDuration = 0.42,
            frames = {
                "assets/decors/goblin_watcher/goblin_watcher_center2.png",
                "assets/decors/goblin_watcher/goblin_watcher_center2.png",
                "assets/decors/goblin_watcher/goblin_watcher_center2.png",
                "assets/decors/goblin_watcher/goblin_watcher_center2.png",
                "assets/decors/goblin_watcher/goblin_watcher_center2.png",
                "assets/decors/goblin_watcher/goblin_watcher_center2.png",
                "assets/decors/goblin_watcher/goblin_watcher_center2.png"
            },
			events = {
				{
					frame = 7,
					type = "setTracking",
					enabled = true
				}
			}
        },

        idleleft = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/decors/goblin_watcher/goblin_watcher_left1.png",
                "assets/decors/goblin_watcher/goblin_watcher_left2.png"
            }
        },

        idle = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/decors/goblin_watcher/goblin_watcher_center1.png",
                "assets/decors/goblin_watcher/goblin_watcher_center2.png"
            }
        },

        idleright = {
            loop = true,
            frameDuration = 0.12,
            frames = {
                "assets/decors/goblin_watcher/goblin_watcher_right1.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png",
				"assets/decors/goblin_watcher/goblin_watcher_right2.png",
				"assets/decors/goblin_watcher/goblin_watcher_right2.png",
                "assets/decors/goblin_watcher/goblin_watcher_right2.png"
            },
					events = {
						{
							frame = 13,
							type = "createEntity",
							id = "goblin",
							x = 80,
							y = 0
						},
						{
							frame = 14,
							type = "setTracking",
							enabled = false  --отключаем слежку за игроком что бы не сбивала дургие анимации
						},
						{
							frame = 15,
							type = "randomState",
							states = {
								"special1",
								"special2",
								"special3"
							}
						},
					}
				},
				
					special1 = {
						loop = false,
						frameDuration = 0.12,
						frames = {
							"assets/decors/goblin_watcher/goblin_special1.png",
							"assets/decors/goblin_watcher/goblin_special1.png"
							},
							events = {
								{
									frame = 2,
									type = "setState",
									state = "removeDecor"
								},
						}
					},
					special2 = {
						loop = false,
						frameDuration = 0.12,
						frames = {
							"assets/decors/goblin_watcher/goblin_special2.png",
							"assets/decors/goblin_watcher/goblin_special2.png"
							},
								events = {
								{
									frame = 2,
									type = "setState",
									state = "removeDecor"
								},					
						}
					},
					special3 = {
						loop = false,
						frameDuration = 0.12,
						frames = {
							"assets/decors/goblin_watcher/goblin_special3.png",
							"assets/decors/goblin_watcher/goblin_special3.png"
							},
							events = {
								{
									frame = 2,
									type = "setState",
									state = "removeDecor"
								},							
						}
					},
				
		removeDecor = {
        loop = false,
        frames = {
            "assets/decors/goblin_watcher/goblin_watcher_center1.png",
            "assets/decors/goblin_watcher/goblin_watcher_center1.png"
        }
    }
    }
}