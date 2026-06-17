return {
    id = "bat_corpse",

    image = "assets/enemies/bat_bomber/death_1.png",

    canvas = {
        width = 128,
        height = 128
    },

    offset = {
        x = 50,
        y = 160
    },

    bbox = {
        x = 0,
        y = 0,
        w = 70,
        h = 70
    },

    color = {0.45, 0.45, 0.45},

    -- В текущей системе vx < 0 летит влево.
    -- Если нужно вправо — поставь vx = 80.
    vx = 80,
    vy = 0,
    gravity = 900,

    collideGround = true,
    collidePlatforms = true,

    removeOnImpact = true,

    -- Не удаляем труп по завершению анимации.
    -- Он должен жить до удара о землю/платформу.
    removeWhenAnimationFinished = false,

    impactEffect = "explosion_damage",

    -- Смещение explosion относительно позиции трупа.
    impactOffsetX = 3,
    impactOffsetY = -10,

    animations = {
        idle = {
            loop = true,
            frameDuration = 0.12,

            -- Чтобы звук сработал сразу при создании corpse.
            fireFirstFrameEvents = true,

            frames = {
                "assets/enemies/bat_bomber/batbombercorpse_1.png"
            },

            events = {
                {
                    frame = 1,
                    type = "playSound",
                    sound = "assets/sounds/sfx/hit2.wav"
                }
            }
        }
    }
}