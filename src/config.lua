local Config = {}

Config.screen = {
    width = 800,
    height = 600
}

Config.window = {
    title = "Arcade Action Platformer"
}

Config.camera = {
    -- Позиция игрока на экране по X.
    -- 0.4 значит игрок будет примерно на 40% ширины экрана,
    -- чтобы впереди было видно больше пространства.
    playerScreenXFactor = 0.4,

    -- Насколько плавно камера догоняет цель.
    -- Чем больше число, тем быстрее камера двигается.
    followSpeed = 10
}

Config.physics = {
    gravity = 900
}

Config.world = {
    -- Насколько далеко за экраном entity может находиться,
    -- прежде чем её можно будет удалить.
    offscreenMargin = 300
}

Config.assets = {
    -- Размер fallback-картинки, если настоящий PNG не найден.
    fallbackImageWidth = 32,
    fallbackImageHeight = 32
}

Config.loading = {
    text = "LOADING"
}

Config.audio = {
    musicVolume = 0.75,
    soundVolume = 0.85,

    -- Ограничение на количество одновременно проигрываемых звуков.
    -- Это защищает от ситуации, когда много ударов создают слишком много Source.
    maxSoundInstances = 24
}

Config.input = {
    touchHideDelay = 3.0,

    touchButtonScale = 1.0,
    touchButtonAlpha = 0.65
}

Config.ui = {
    fontSize = 16,
    bigFontSize = 28,

    healthBarWidth = 180,
    healthBarHeight = 18,

    actorHealthBarWidth = 42,
    actorHealthBarHeight = 4
}

Config.debug = {
    enabled = false,

    drawBboxes = false,
    drawHitboxes = false,
    drawFps = true,
    drawPlayerPosition = false,
    drawCamera = false
}

return Config