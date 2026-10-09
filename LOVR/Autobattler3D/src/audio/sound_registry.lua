local SoundRegistry = {
  sources = {},
  failed = {}
}


-- Загружает звуковой источник.
function SoundRegistry.get(path)
  if not path then
    return nil
  end

  if SoundRegistry.sources[path] then
    return SoundRegistry.sources[path]
  end

  if SoundRegistry.failed[path] then
    return nil
  end

  local loaded, source =
    pcall(
      lovr.audio.newSource,
      path
    )

  if not loaded then
    print(
      'Sound load error "' ..
      path ..
      '": ' ..
      tostring(source)
    )

    SoundRegistry.failed[path] = true
    return nil
  end

  SoundRegistry.sources[path] = source

  return source
end


-- Проигрывает звук с начала.
function SoundRegistry.play(path)
  local source =
    SoundRegistry.get(path)

  if not source then
    return
  end

  source:stop()
  source:play()
end


return SoundRegistry