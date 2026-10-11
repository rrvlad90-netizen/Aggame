return {
    id = "kikimora",
    name = "Kikimora",

    type = "hazard",

    stationary = true,
    invulnerable = true,

    scale = 1,

    -- Время безопасного ожидания с головой над водой.
    safeDuration = 2.4,

    animations = {
        -- Кикимора полностью скрыта под водой.
        spawn = {
            loop = false,
            frameDuration = 0.20,

            frames = {
                "assets/images/biomes/swamp/kikimora/kiknull.png"
            }
        },

        -- Безопасная фаза: над водой видна голова.
        safe = {
            loop = true,
            frameDuration = 0.10,

            frames = {
                "assets/images/biomes/swamp/kikimora/k7.png"
            }
        },

        -- Кикимора начинает выныривать.
        warning = {
            loop = false,
            frameDuration = 0.04,

            -- Первый кадр показывается дольше.
            frameDurations = {
                [1] = 0.10
            },

            frames = {
                "assets/images/biomes/swamp/kikimora/k7.png",
                "assets/images/biomes/swamp/kikimora/h0.png",
                "assets/images/biomes/swamp/kikimora/i0.png",
                "assets/images/biomes/swamp/kikimora/j0.png",
                "assets/images/biomes/swamp/kikimora/k0.png"
            }
        },

        -- Выныривание и попытка схватить игрока.
        grab = {
            loop = false,
            frameDuration = 0.12,

            frames = {
                "assets/images/biomes/swamp/kikimora/k1.png",
                "assets/images/biomes/swamp/kikimora/k2.png",
                "assets/images/biomes/swamp/kikimora/k3.png",
                "assets/images/biomes/swamp/kikimora/k4.png",
                "assets/images/biomes/swamp/kikimora/k5.png",
                "assets/images/biomes/swamp/kikimora/k6.png"
            },

            events = {
                {
                    -- Кадр k4.
                    frame = 4,
                    type = "grab"
                }
            }
        },

        -- Кикимора погружается обратно под воду.
        submerge = {
            loop = false,
            frameDuration = 0.04,

            -- Последний невидимый кадр служит паузой.
            frameDurations = {
                [6] = 1.56
            },

            frames = {
                "assets/images/biomes/swamp/kikimora/k1.png",
                "assets/images/biomes/swamp/kikimora/k0.png",
                "assets/images/biomes/swamp/kikimora/j0.png",
                "assets/images/biomes/swamp/kikimora/i0.png",
                "assets/images/biomes/swamp/kikimora/h0.png",
                "assets/images/biomes/swamp/kikimora/kiknull.png"
            }
        },

        -- Не используется, но сохранено из OpenBOR.
        walk = {
            loop = true,
            frameDuration = 0.10,

            frames = {
                "assets/images/biomes/swamp/kikimora/kiknull.png"
            }
        },

        -- Пока не используется: кикимора неуязвима.
        death = {
            loop = false,
            frameDuration = 0.05,

            frames = {
                "assets/images/biomes/swamp/kikimora/j0.png",
                "assets/images/biomes/swamp/kikimora/i0.png",
                "assets/images/biomes/swamp/kikimora/h0.png",
                "assets/images/biomes/swamp/kikimora/k7.png"
            }
        }
    }
}