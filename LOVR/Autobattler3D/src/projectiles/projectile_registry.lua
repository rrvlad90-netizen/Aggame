local ProjectileList =
  require('projectiles.projectilelist')

local ProjectileRegistry = {}
ProjectileRegistry.__index =
  ProjectileRegistry

local VALID_TRAJECTORIES = {
  straight = true,
  arc = true
}

local VALID_HIT_MODES = {
  target = true,
  point = true
}

local VALID_SPRITE_MODES = {
  billboard = true,
  directional = true
}


-- Проверяет описание анимации.
local function validateAnimation(
  projectile,
  animationName,
  allowEmpty
)
  local animation =
    projectile.animations
    and projectile.animations[
      animationName
    ]

  assert(
    animation,
    string.format(
      'Projectile "%s" has no "%s" animation',
      projectile.id,
      animationName
    )
  )

  assert(
    type(animation.frames) == 'table',
    string.format(
      'Projectile "%s" has invalid "%s" frames',
      projectile.id,
      animationName
    )
  )

  if not allowEmpty then
    assert(
      #animation.frames > 0,
      string.format(
        'Projectile "%s" has empty "%s" animation',
        projectile.id,
        animationName
      )
    )
  end
end


-- Создаёт реестр снарядов.
function ProjectileRegistry.new()
  local self =
    setmetatable(
      {},
      ProjectileRegistry
    )

  self.definitions = {}
  self.list = {}

  for _, definition in ipairs(
    ProjectileList
  ) do
    self:register(definition)
  end

  return self
end


-- Проверяет и регистрирует снаряд.
function ProjectileRegistry:register(
  definition
)
  assert(
    type(definition.id) == 'string',
    'Projectile has no id'
  )

  assert(
    not self.definitions[
      definition.id
    ],
    'Duplicate projectile id: ' ..
    definition.id
  )

  assert(
    VALID_TRAJECTORIES[
      definition.trajectory
    ],
    'Invalid projectile trajectory: ' ..
    definition.id
  )

  assert(
    VALID_HIT_MODES[
      definition.hitMode
    ],
    'Invalid projectile hit mode: ' ..
    definition.id
  )

  assert(
    VALID_SPRITE_MODES[
      definition.spriteMode
    ],
    'Invalid projectile sprite mode: ' ..
    definition.id
  )

  local allowEmpty =
    definition.visible == false

  validateAnimation(
    definition,
    'flight',
    allowEmpty
  )

  validateAnimation(
    definition,
    'impact',
    allowEmpty
  )

  definition.alpha =
    definition.alpha or 1

  definition.scale =
    definition.scale or 1

  definition.trail =
    definition.trail
    or {
      enabled = false
    }

  self.definitions[
    definition.id
  ] = definition

  self.list[#self.list + 1] =
    definition
end


-- Возвращает описание снаряда.
function ProjectileRegistry:get(
  projectileId
)
  return assert(
    self.definitions[
      projectileId
    ],
    'Unknown projectile: ' ..
    tostring(projectileId)
  )
end


-- Возвращает список снарядов.
function ProjectileRegistry:getAll()
  return self.list
end


return ProjectileRegistry