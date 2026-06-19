return {
    id = "goblin_watcher",

    layer = "back", --не работает для платформ 
	--и это правильно ведь наш уровень это платформа. И ее мы перекрываем картинкой

    x = 0,
    y = 0,

    scale = 2.2,
	visualOffsetX = -40, --влево сместить
	visualOffsetY = -62, --вверх сместить

    defaultAnimation = "spawn",

    trackAfterSpawn = true, -- начнет следить за игроком (Tracking после spawn)

    leftAnimation = "idleleft",
    centerAnimation = "idle",
    rightAnimation = "idleright",

    centerRange = 100,
	
----ТЕНЬ	
	shadowType = 1,
    shadowAlpha = 0.22,
    shadowWidth = 70,
    shadowHeight = 11,
    shadowOffsetY = 2,
------

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
                    y = -290
                },
                {
                    frame = 14,
                    type = "setTracking",
                    enabled = false
                },
                {
                    frame = 15,
                    type = "randomState",
                    states = {
                        "special1",
                        "special2",
                        "special3"
                    }
                }
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
                }
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
                }
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
                }
            }
        },

        removeDecor = {
            loop = false,
            frameDuration = 0.12,
            frames = {
                "assets/decors/goblin_watcher/goblin_watcher_center1.png",
                "assets/decors/goblin_watcher/goblin_watcher_center1.png"
            }
        }
    }
}