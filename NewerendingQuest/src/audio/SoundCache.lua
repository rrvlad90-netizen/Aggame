local SoundCache = {
    sources = {},
    missing = {}
}

-- Загружает звук при первом использовании.
function SoundCache:get(path)
    if not path then
        return nil
    end

    if self.sources[path] then
        return self.sources[path]
    end

    if self.missing[path] then
        return nil
    end

    if not love.filesystem.getInfo(path) then
        print("Sound not found: " .. path)
        self.missing[path] = true
        return nil
    end

    local source =
        love.audio.newSource(
            path,
            "static"
        )

    self.sources[path] = source

    return source
end

-- Воспроизводит независимую копию звука.
function SoundCache:play(path)
    local source = self:get(path)

    if not source then
        return
    end

    source:clone():play()
end

return SoundCache