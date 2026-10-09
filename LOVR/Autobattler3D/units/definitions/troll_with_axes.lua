return {
  id = 'troll_with_axes',
  slot = 'archer',

  name = 'Troll Axe Thrower',
  description = 'Troll using throwing axes.',

  model = 'troll_with_axes',
  
  -- Стрелки не блокируют других стрелков.
  --alliedPassThroughSlots = {
  --  archer = true
  --},

  corpse = {
    mode = 'random',
    stayChance = .4
  },

  -- Полный отряд при найме.
  squadSize = 20,
  
  health = 180,

  damageMinimum = 9,
  damageMaximum = 12,
  damageType = 'normal',

  moveSpeed = 3,
  radius = .55,

  -- Диаметр двух троллей плюс
  -- небольшой запас столкновения.
  spawnSpacing = 1.25,
  routeSpacing = 1.25,

  attackDistance = 1.55,
  sightDistance = 26,

  rangedAttack = {
    projectile = 'axe',

    minimumDistance = 3,
    maximumDistance = 20,

    cooldownMinimum = 1.6,
    cooldownMaximum = 2.1,

    spawnHeight = 1.3,
    spawnForward = .55,
    targetHeight = .8
  },

  spearDamageMultiplier = 1,
  magicDamageMultiplier = 1
}