return {
    id = "falling_platform",
    x = 800,
    y = 420,

    w = 120,
    h = 24,
    visualHeight = 24,

    collisionEnabled = true,

    triggerOnStand = true,
    triggerState = "fallingdown",

    animations = {
        idle = {
            loop = true,
            frames = {
                "assets/platforms/platform_idle_1.png"
            }
        },

        fallingdown = {
            loop = false,
            frameDuration = 0.22,

            -- Падает, пока animation играет.
            vy = 280,

            -- Когда animation закончилась — остановилась.
            stopOnFinish = true,

            -- После окончания можно удалить:
            -- removeOnFinish = true,

            -- Или вернуть в idle:
            nextState = "idle",

            frames = {
                "assets/platforms/platform_fall_1.png",
                "assets/platforms/platform_fall_2.png",
				"assets/platforms/platform_fall_2.png",
				"assets/platforms/platform_fall_2.png",
				"assets/platforms/platform_fall_2.png",
                "assets/platforms/platform_fall_3.png"
            }
        }
    }
}