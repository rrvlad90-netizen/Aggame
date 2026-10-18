return {
    id = "easy_forest_01",
    name = "Forest Clearing",

    biome = "forest",

    controls = {
        movement = "free",

        jumps = {
            "medium"
        },

        melee = true,
        ranged = true,
        shield = true,

        hint =
            "MOVE FREELY\n" ..
            "JUMP, ATTACK, SHOOT AND BLOCK"
    },

    enemies = {
        skeletonCount = 3,
        shieldSkeletonCount = 1,
        wyvernCount = 15,

        -- На лёгком уровне виверн
        -- можно атаковать мечом.
        wyvernRangedOnly = false
    },

    seed = 2001,
    generationMode = "procedural",

    preview = {
        image =
            "assets/images/previews/forest_clearing.png",

        fadeOutDuration = 0.5,
        displayDuration = 1.5,
        fadeInDuration = 0.5
    },

    -- Настоящий объект горы за порталом.
    endMountain = {
        enabled = true,

        -- Когда PNG будет готов:
        -- image =
        --     "assets/images/backgrounds/forest/end_mountain.png",

        -- Пока используется мокап.
        image = nil,

        x = 0,

        distanceBehindPortal = 8,

        scale = 1,
        spriteHeight = 680,
        alpha = 1,
        offsetY = 0,

        renderMargin = 20,

        mockupWidth = 900,
        mockupHeight = 680,

        mockupColor = {
            0.24,
            0.27,
            0.3,
            1
        },

        mockupDarkColor = {
            0.16,
            0.18,
            0.21,
            1
        },

        snowColor = {
            0.75,
            0.78,
            0.8,
            1
        }
    },

    background = {
        clearColor = {
            0.32,
            0.62,
            0.82,
            1
        },

        -- Приближение фона к концу уровня.
        approach = {
            enabled = true,

            startProgress = 0.05,
            endProgress = 1,

            -- Небо не приближается.
            layerScales = {
                mountains = 1.8,
                landscape = 1.55,
                trees = 1.35
            },

            parallaxMultipliers = {
                mountains = 1.35,
                landscape = 1.5,
                trees = 1.7
            },

            -- Дальняя фоновая гора.
            destinationMountain = {
                enabled = true,

                -- Позднее здесь также можно
                -- использовать отдельный PNG.
                image = nil,

                startScale = 0.45,
                endScale = 1.65,

                baseY = 310,
                alpha = 1,
                parallax = 0.04,
                offsetX = 0,

                mockupWidth = 540,
                mockupHeight = 260,

                mockupColor = {
                    0.24,
                    0.27,
                    0.3,
                    1
                },

                mockupFarColor = {
                    0.18,
                    0.21,
                    0.24,
                    1
                },

                snowColor = {
                    0.72,
                    0.76,
                    0.78,
                    1
                }
            }
        },

        sky = {
            image =
                "assets/images/backgrounds/forest/sky.png",

            parallax = 0.02,
            scrollSpeed = 0,
            scale = 1,

            offset = {
                x = 0,
                y = 0
            },

            alpha = 1,
            align = "top",
            repeatX = true
        },

        mountains = {
            image =
                "assets/images/backgrounds/forest/mountains.png",

            parallax = 0.08,
            scrollSpeed = 0,
            scale = 1,

            offset = {
                x = 0,
                y = 0
            },

            alpha = 1,
            align = "bottom",
            repeatX = true
        },

        trees = {
            image =
                "assets/images/backgrounds/forest/trees.png",

            parallax = 0.18,
            scrollSpeed = 0,
            scale = 1,

            offset = {
                x = 0,
                y = 0
            },

            alpha = 1,
            align = "bottom",
            repeatX = true
        }
    },

    -- Размер игровой области в метрах.
    size = {
        width = 150,
        length = 180
    },

    rivers = {
        count = 3,

        startMargin = 18,
        finishMargin = 18,
        minimumSpacing = 24,

        -- Продолжение рек за боковые края.
        renderExtension = 70,

        renderDistance = 50,

        bridgeReveal = {
            startDistance = 52,
            fullDistance = 50
        },

        width = {
            minimum = 4,
            maximum = 7
        },

        bend = {
            enabled = true,
            minimumStrength = 2,
            maximumStrength = 6
        },

        bank = {
            width = 1.5,
            depth = 0.8,
            vegetationClearance = 1.5
        },

        bridge = {
            width = 4.5,
            lengthPadding = 1,
            sideMargin = 4,
            railingHeight = 0.9,

            approachClearance = 6
        }
    },

    rendering = {
        distance = 34,
        behindDistance = 8
    },

    generator = {
        objectsPerChunk = 160,
        chunksAhead = 1,

        treeChance = 0.55,
        bushChance = 0.32,
        rockChance = 0.09,
        mushroomChance = 0.04,

        treeMinimumDistance = 5,

        decorationWidth = 180,
        safeCorridorWidth = 6,
        startSafeRadius = 8
    },

    visuals = {
        tree = {
            scale = 1.15,
            alpha = 1,
            collisionRadius = 1.4,

            offset = {
                x = 0,
                y = 0
            }
        },

        bush = {
            scale = 0.9,
            alpha = 0.9,

            offset = {
                x = 0,
                y = 0
            }
        }
    },

    exit = {
        type = "portal",

        x = 0,

        distanceFromEnd = 4,

        scale = 1,
        activationRadius = 1.8,

        destination = {
            type = "next"
        }
    },

    assets = {
        music = nil
    }
}