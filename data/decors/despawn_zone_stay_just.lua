return {
    id = "despawn_zone_stay_just",

    layer = "front",

    x = 0,
    y = 0,

    canvas = {
        width = 96,
        height = 900
    },

    offset = {
        x = 0,
        y = 0
    },

    bbox = {
        x = 0,
        y = 0,
        w = 96,
        h = 900
    },

    cleanupZone = true,

    -- Пока тестируем — печатает каждое удаление.
    printCleanup = true,

    -- Игрока не трогаем.
    removePlayer = false,

    -- LevelEnd лучше не удалять по умолчанию.
    removeLevelEnd = false,

    removeActors = true,
    removeProjectiles = true,
    removeEffects = true,
    removePickups = true,
    removePlatforms = true,
    removeDecors = true,

    -- Для теста можно видеть красную полупрозрачную стену.
    -- Потом поставишь alpha = 0.
    alpha = 0.2,
    color = {1, 0, 0}
}