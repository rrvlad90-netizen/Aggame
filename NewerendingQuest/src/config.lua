local Config = {
    virtualWidth = 1280,
    virtualHeight = 720,

    -- Количество координат мира в одном игровом метре.
    worldUnitsPerMeter = 20,

    projection = {
        centerX = 640,
        horizonY = 150,
        nearY = 620,

        visibleDepth = 1000,
        visibleBehindDepth = 200,

        farFadeStart = 850,
        behindFadeStart = 180,

        -- Масштаб самих спрайтов.
        nearScale = 1.0,
        farScale = 0.10,

        depthCurve = 1.85,
        scaleCurve = 1.75,

        -- Отдельное масштабирование горизонтальных координат.
        horizontalNearScale = 1.0,
        horizontalFarScale = 0.35,
        horizontalCurve = 1.35,

        worldHalfWidth = 3600,
        depthLineSize = 100
    },

    -- Параметры лесного генератора.
    world = {
        seed = 1729,
        chunkLength = 1000,
        chunksAhead = 2,
        objectsPerChunk = 120,

        spriteHeights = {
            tree = 150,
            bush = 58
        }
    },

    -- Параметры болотного генератора.
    swamp = {
        seed = 4815,
        generateAhead = 1800,

        laneCount = 5,
        laneSpacing = 160,
        rowSpacing = 150,

        hummockRadiusMin = 68,
        hummockRadiusMax = 78,

        decoyChance = 0.4,

        kikimoraChance = 0.22,
    },

    debug = {
        showDepthLines = false
    },

    touch = {
        hideDelay = 3
    }
}

return Config