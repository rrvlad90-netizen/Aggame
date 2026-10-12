local Settings = {}

local FILE_NAME = "settings.txt"

local defaults = {
    musicVolume = 0.7,
    effectsVolume = 1
}

local function clamp(value)
    return math.max(0, math.min(1, value))
end

function Settings.load()
    local result = {
        musicVolume = defaults.musicVolume,
        effectsVolume = defaults.effectsVolume
    }

    if not love.filesystem.getInfo(FILE_NAME) then
        return result
    end

    local contents = love.filesystem.read(FILE_NAME)

    if not contents then
        return result
    end

    local music =
        contents:match("musicVolume=([%d%.]+)")

    local effects =
        contents:match("effectsVolume=([%d%.]+)")

    if music then
        result.musicVolume =
            clamp(tonumber(music) or defaults.musicVolume)
    end

    if effects then
        result.effectsVolume =
            clamp(tonumber(effects) or defaults.effectsVolume)
    end

    return result
end

function Settings.save(settings)
    local contents = string.format(
        "musicVolume=%.2f\neffectsVolume=%.2f\n",
        clamp(settings.musicVolume),
        clamp(settings.effectsVolume)
    )

    return love.filesystem.write(
        FILE_NAME,
        contents
    )
end

return Settings
