return {
    id = "spawner_for_runnin",

    layer = "front",

    x = 0,
    y = 0,

    defaultAnimation = "spawn_loop",
    spawnAnimation = "spawn_loop",

    trackPlayer = false,
    trackAfterSpawn = false,

    canvas = {
        width = 64,
        height = 64
    },

    offset = {
        x = 32,
        y = 32
    },

    alpha = 0.5,

    animations = {
        spawn_loop = {
            loop = false,
            frameDuration = 0.35,
            frames = {
                "assets/decors/torch_01.png",
                "assets/decors/torch_02.png"
            },
            events = {
                {
                    frame = 2,
                    type = "randomState",
                    states = {
                        "special_goblin",
                        "special_bat",
                        "special_platform",
                        "special_combo"
                    }
                }
            }
        },

        special_goblin = {
            loop = false,
			fireFirstFrameEvents = true,
            frameDuration = 0.25,
            frames = {
                "assets/decors/torch_01.png",
				"assets/decors/torch_01.png",
                "assets/decors/torch_01.png",
				"assets/decors/torch_01.png",				
                "assets/decors/torch_02.png"
            },
            events = {
                {
                    frame = 1,
                    type = "createEntity",
                    id = "runner_goblin",
                    spawnX = 830,
                    spawnY = 555,
                    facing = -1
                },
                {
                    frame = 2,
                    type = "setState",
                    state = "spawn_loop"
                }
            }
        },

        special_bat = {
            loop = false,
			fireFirstFrameEvents = true,
            frameDuration = 0.25,
            frames = {
                "assets/decors/torch_01.png",
                "assets/decors/torch_01.png",
				"assets/decors/torch_01.png",
                "assets/decors/torch_01.png",
				"assets/decors/torch_01.png",				
                "assets/decors/torch_02.png"
            },
            events = {
                {
                    frame = 1,
                    type = "createEntity",
                    id = "runner_bomber_bat",
                    spawnX = 850,
                    spawnY = 300,
                    facing = -1
                },
                {
                    frame = 2,
                    type = "setState",
                    state = "spawn_loop"
                }
            }
        },

        special_platform = {
            loop = false,
			fireFirstFrameEvents = true,
            frameDuration = 0.25,
            frames = {
                "assets/decors/torch_01.png",
                "assets/decors/torch_01.png",
				"assets/decors/torch_01.png",				
                "assets/decors/torch_02.png"
            },
            events = {
                {
                    frame = 1,
                    type = "createEntity",
                    id = "move_left_platform",
                    spawnX = 850,
                    spawnY = 430
                },
                {
                    frame = 2,
                    type = "setState",
                    state = "spawn_loop"
                }
            }
        },

        special_combo = {
            loop = false,
			fireFirstFrameEvents = true,
            frameDuration = 0.25,
            frames = {
                "assets/decors/torch_01.png",
                "assets/decors/torch_02.png",
                "assets/decors/torch_01.png",
				"assets/decors/torch_01.png",				
                "assets/decors/torch_01.png"
            },
            events = {
                {
                    frame = 1,
                    type = "createEntity",
                    id = "runner_goblin",
                    spawnX = 830,
                    spawnY = 555,
                    facing = -1
                },
                {
                    frame = 2,
                    type = "createEntity",
                    id = "runner_bomber_bat",
                    spawnX = 850,
                    spawnY = 260,
                    facing = -1
                },
                {
                    frame = 2,
                    type = "createEntity",
                    id = "move_left_platform",
                    spawnX = 850,
                    spawnY = 390
                },

                -- 1% шанс создать LevelEnd.
                {
                    frame = 3,
                    type = "createEntity",
                    id = "door_level1",
                    spawnX = 740,
                    spawnY = 555,
                    chance = 3
                },
                {
                    frame = 3,
                    type = "setState",
                    state = "spawn_loop"
                }
            }
        }
    }
}