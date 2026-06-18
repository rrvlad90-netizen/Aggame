return {
    id = "torch",

    layer = "middle",

    x = 0,
    y = 0,

    alpha = 0.75,

    canvas = {
        width = 60,
        height = 100
    },

    offset = {
        x = 32,
        y = 64
    },

    defaultAnimation = "idle",

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.12,

            frames = {
                "assets/decors/torch_01.png",
                "assets/decors/torch_02.png",
				"assets/decors/torch_01.png",
                "assets/decors/torch_02.png"
            },

            events = {
                {
                    frame = 1,
                    type = "playSound",
                    sound = "assets/sounds/drop11.wav"
                }
            }
        }
    }
}