{
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
    printCleanup = true,

    removeActors = true,
    removeProjectiles = true,
    removeEffects = true,
    removePickups = true,
    removePlatforms = true,

    -- Если у платформ есть отдельный decor-спрайт,
    -- лучше пока не стирать decors, иначе визуал может исчезнуть,
    -- а физическая платформа останется.
    removeDecors = false,

    removePlayer = false,
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