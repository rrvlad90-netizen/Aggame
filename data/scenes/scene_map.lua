return {
    id = "scene_map",

    music = nil,

    skipAllowed = true,
    clickNotSkipScene = true, --клик мимо картинки ничего не делает.

    nextScene = "scenelevel1", --куда попадем если анимаиця scene заончилась

    frames = {
        {
            image = "assets/scenes/scene_map.png",  ---Здесь картинка сзади
            duration = 110,  ---Поставил побольше что бы успеть выбрать

            text = "CHOOSE SCENE",
            textX = 80,
            textY = 620,
            textW = 1120,
            textH = 60,
            textAlign = "center",

            images = {
                {
                    image = "assets/scenes/buttons/choose1.png",   -- кликабельные картинки поверх которые появятся на экране
                    x = 120,
                    y = 120,
                    clickable = true,
                    nextScene = "scenelevel1"
                },
                {
                    image = "assets/scenes/buttons/choose2.png", -- кликабельные картинки поверх которые появятся на экране
                    x = 420,
                    y = 120,
                    clickable = true,
                    nextScene = "scenelevel2"
                }
            }
        }
    }
}