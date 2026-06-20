return {
    id = "despawn_zone",

	layer = "front",

    -- ВАЖНО: отрицательное значение.
    -- Это значит: зона находится левее экрана.
    x = -600,
    y = 0,

    followCamera = true,
    followCameraX = true,
    followCameraY = true,

    cleanupZone = true,
    printCleanup = false,--не печатаем сообщение для теста при удалении

    removeDecors = true, --декоры тоже удаляет
    removeActors = true,
    removeProjectiles = true,
    removeEffects = true,
    removePickups = true,
    removePlatforms = true,

    -- Игрока не трогаем.
    removePlayer = false,
    -- LevelEnd лучше не удалять по умолчанию.
    removeLevelEnd = false,

    canvas = {
        width = 120,
        height = 600
    },

    offset = {
        x = 0,
        y = 0
    },

    bbox = {
        x = 0,
        y = 0,
        w = 120,
        h = 600
    },

    alpha = 0.15,
    color = {1, 0, 0}
}