return {
    id = "dissapear_platform",
    x = 600,
    y = 420,

    w = 120,
    h = 24,
    visualHeight = 24,

    collisionEnabled = true,

    triggerOnStand = true,
    triggerState = "disable",

    animations = {
        idle = {
            loop = true,
            frames = {
                "assets/platforms/platform_idle_1.png"
            }
        },

        disable = {
            loop = false,
            frameDuration = 0.42,

            -- Автоматически выключит collision в конце animation.
            collisionOffOnFinish = true,

            frames = {
                "assets/platforms/platform_disable_1.png",
                "assets/platforms/platform_disable_2.png",
                "assets/platforms/platform_disable_3.png"
            },
		events = {		
				{
					frame = 3,
					type = "remove"
				}
			},
        }
    }
}