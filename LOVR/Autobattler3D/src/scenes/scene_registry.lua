local SceneList =
  require('scenes.scenelist')

local SceneRegistry = {}
SceneRegistry.__index = SceneRegistry


function SceneRegistry.new()
  local self =
    setmetatable({}, SceneRegistry)

  self.scenes = {}

  for id, modulePath in pairs(
    SceneList
  ) do
    local definition =
      require(modulePath)

    assert(
      definition.id == id,
      'Scene id mismatch: ' ..
      tostring(id)
    )

    self.scenes[id] = definition
  end

  return self
end


function SceneRegistry:get(id)
  return assert(
    self.scenes[id],
    'Unknown scene: ' ..
    tostring(id)
  )
end


return SceneRegistry