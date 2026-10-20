return {
    id = "ending_scene",
    name = "The End",

    biome = "scene",
    generationMode = "scene",

    background = {
        clearColor = {
            0.025,
            0.025,
            0.035,
            1
        }
    },

    scene = {
        skippable = true,

        music =
            "assets/music/ending.ogg",

        musicVolume = 0.7,
        loopMusic = true,

        fadeDuration = 0.6,

        destination = {
            type = "next"
        },

        slides = {
            {
                image =
                    "assets/images/scenes/ending_01.png",

                text =
                    "THE JOURNEY THROUGH THE SWAMP, " ..
                    "FOREST AND DUNGEON WAS OVER.",

                duration = 5,
                fit = "contain",

                color = {
                    0.12,
                    0.16,
                    0.2,
                    1
                }
            },

            {
                image =
                    "assets/images/scenes/ending_02.png",

                text =
                    "BEYOND THE LAST GATE, " ..
                    "A NEW DAWN WAS WAITING.",

                duration = 5,
                fit = "contain",

                color = {
                    0.2,
                    0.14,
                    0.1,
                    1
                }
            },

            {
                image =
                    "assets/images/scenes/ending_03.png",

                text =
                    "NEWER ENDING QUEST",

                duration = 5,
                fit = "contain",

                color = {
                    0.08,
                    0.08,
                    0.1,
                    1
                }
            }
        }
    }
}