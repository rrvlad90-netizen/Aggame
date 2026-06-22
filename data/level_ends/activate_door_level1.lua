return {
    id = "activate_door_level1",

    -- Дверь больше не срабатывает от простого касания.
    activateIfTouch = true,

    -- Можно вести сразу на уровень.
    nextLevel = "level2",

    -- Или на сцену:
    -- nextScene = "scenelevel2",

    animations = {
        idle = {
            loop = true,
            frames = {
                "assets/doors/door_idle_1.png"
            }
        },

        open = {
            loop = false,
            frames = {
                "assets/doors/door_open_1.png",
                "assets/doors/door_open_2.png",
                "assets/doors/door_open_3.png"
            }
        }
    }
}