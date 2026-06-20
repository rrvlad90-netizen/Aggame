local Config = require("src.config")

local Assets = {}

Assets.images = {}
Assets.sounds = {}
Assets.music = {}

Assets.soundInstances = {}
Assets.loadingQueue = {}
Assets.loadingIndex = 1

-- Инициализирует кеши ресурсов.
-- Можно вызывать при старте игры или перед полной перезагрузкой.
function Assets.init()
    Assets.images = {}
    Assets.sounds = {}
    Assets.music = {}

    Assets.soundInstances = {}
    Assets.loadingQueue = {}
    Assets.loadingIndex = 1
end

-- Проверяет, существует ли файл внутри проекта Love2D.
function Assets.exists(path)
    return path and love.filesystem.getInfo(path) ~= nil
end

-- Создаёт fallback-картинку, если настоящий PNG не найден.
-- Сейчас это красный квадрат, чтобы сразу было видно ошибочный путь.
function Assets.createFallbackImage(width, height)
    width = width or Config.assets.fallbackImageWidth
    height = height or Config.assets.fallbackImageHeight

    local canvas = love.graphics.newCanvas(width, height)

    love.graphics.setCanvas(canvas)
    love.graphics.clear(1, 0, 0, 1)

    love.graphics.setColor(0.4, 0, 0)
    love.graphics.rectangle("line", 0, 0, width, height)

    love.graphics.setColor(1, 1, 1)
    love.graphics.line(0, 0, width, height)
    love.graphics.line(width, 0, 0, height)

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)

    return canvas
end


-- Возвращает кешированную fallback-картинку указанного размера.
-- Важно: не создаём новый Canvas каждый кадр, если image == nil.
function Assets.getFallbackImage(width, height)
    width = width or Config.assets.fallbackImageWidth
    height = height or Config.assets.fallbackImageHeight

    local key = "__fallback:" .. tostring(width) .. "x" .. tostring(height)

    if Assets.images[key] then
        return Assets.images[key]
    end

    local image = Assets.createFallbackImage(width, height)

    Assets.images[key] = image

    return image
end

-- Возвращает картинку по пути.
-- Если картинка уже была загружена, берёт её из кеша.
-- Если файла нет, создаёт fallback-картинку.
function Assets.getImage(path)
    if not path then
        return Assets.getFallbackImage()
    end

    if Assets.images[path] then
        return Assets.images[path]
    end

    local image = nil

    if Assets.exists(path) then
        image = love.graphics.newImage(path)
    else
        image = Assets.createFallbackImage()
    end

    Assets.images[path] = image

    return image
end

-- Возвращает sound source по пути.
-- Если файла нет, возвращает nil.
function Assets.getSound(path)
    if not path then
        return nil
    end

    if Assets.sounds[path] then
        return Assets.sounds[path]
    end

    if not Assets.exists(path) then
        return nil
    end

    local source = love.audio.newSource(path, "static")
    source:setVolume(Config.audio.soundVolume)

    Assets.sounds[path] = source

    return source
end

-- Возвращает music source по пути.
-- Музыка грузится как stream.
function Assets.getMusic(path)
    if not path then
        return nil
    end

    if Assets.music[path] then
        return Assets.music[path]
    end

    if not Assets.exists(path) then
        return nil
    end

    local source = love.audio.newSource(path, "stream")
    source:setVolume(Config.audio.musicVolume)
    source:setLooping(true)

    Assets.music[path] = source

    return source
end

-- Удаляет из списка активных звуков те, которые уже закончили играть.
function Assets.cleanupSoundInstances()
    for index = #Assets.soundInstances, 1, -1 do
        local source = Assets.soundInstances[index]

        if not source:isPlaying() then
            table.remove(Assets.soundInstances, index)
        end
    end
end

-- Проигрывает звук.
-- Если звуков одновременно слишком много, новый звук не проигрывается.
function Assets.playSound(path)
    local source = Assets.getSound(path)

    if not source then
        return
    end

    Assets.cleanupSoundInstances()

    if #Assets.soundInstances >= Config.audio.maxSoundInstances then
        return
    end

    local instance = source:clone()
    instance:setVolume(Config.audio.soundVolume)
    instance:play()

    table.insert(Assets.soundInstances, instance)
end

-- Добавляет путь в очередь preload, если он не пустой.
function Assets.addToPreloadQueue(path)
    if not path then
        return
    end

    table.insert(Assets.loadingQueue, path)
end

-- Очищает очередь preload.
function Assets.clearPreloadQueue()
    Assets.loadingQueue = {}
    Assets.loadingIndex = 1
end

-- Создаёт простую очередь preload из списка путей.
-- Пока сюда можно передавать массив строк.
function Assets.buildPreloadQueue(paths)
    Assets.clearPreloadQueue()

    for _, path in ipairs(paths or {}) do
        Assets.addToPreloadQueue(path)
    end
end

-- Загружает один ресурс из очереди preload.
-- Возвращает true, если загрузка ещё продолжается.
-- Возвращает false, если очередь закончилась.
function Assets.preloadStep()
    local path = Assets.loadingQueue[Assets.loadingIndex]

    if not path then
        return false
    end

    local extension = string.lower(string.match(path, "%.([^%.]+)$") or "")

    if extension == "png"
        or extension == "jpg"
        or extension == "jpeg"
    then
        Assets.getImage(path)
    elseif extension == "ogg"
        or extension == "mp3"
        or extension == "wav"
    then
        Assets.getSound(path)
    end

    Assets.loadingIndex = Assets.loadingIndex + 1

    return Assets.loadingIndex <= #Assets.loadingQueue
end

-- Возвращает прогресс preload от 0 до 1.
function Assets.getLoadingProgress()
    if #Assets.loadingQueue == 0 then
        return 1
    end

    return math.min(
        1,
        (Assets.loadingIndex - 1) / #Assets.loadingQueue
    )
end

local function clampVolume(volume)
    return math.max(0, math.min(1, volume or 0))
end

-- Меняет громкость всех звуков.
function Assets.setSoundVolume(volume)
    Config.audio.soundVolume = clampVolume(volume)

    for _, source in pairs(Assets.sounds or {}) do
        source:setVolume(Config.audio.soundVolume)
    end

    for _, source in ipairs(Assets.soundInstances or {}) do
        source:setVolume(Config.audio.soundVolume)
    end
end

-- Меняет громкость всей музыки.
function Assets.setMusicVolume(volume)
    Config.audio.musicVolume = clampVolume(volume)

    for _, source in pairs(Assets.music or {}) do
        source:setVolume(Config.audio.musicVolume)
    end
end

-- Применяет обе громкости сразу.
function Assets.setAudioVolumes(musicVolume, soundVolume)
    Assets.setMusicVolume(musicVolume)
    Assets.setSoundVolume(soundVolume)
end

return Assets