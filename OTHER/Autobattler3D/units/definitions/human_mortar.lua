return {
  id = 'human_mortar',
  slot = 'catapult',

  name = 'Mortar Team',
  description = 'Human artillery using explosive shells.',

  model = 'mortarteam',

  corpse = {
    mode = 'always'
  },

  fallDeath = {
    enabled = false
  },

  health = 380,

  damageMinimum = 15,
  damageMaximum = 25,
  damageType = 'normal',

  moveSpeed = 1.6,
  radius = .75,

  spawnSpacing = 2,
  routeSpacing = 2,
  squadSize = 2,

  attackDistance = 0,
  sightDistance = 38,

  rangedAttack = {
    projectile = 'cannon_orb',

    minimumDistance = 6,
    maximumDistance = 34,

    cooldownMinimum = 3.4,
    cooldownMaximum = 4.2,

    spawnHeight = 1.35,
    spawnForward = .65,
    targetHeight = 0
  },

  spearDamageMultiplier = 1,
  magicDamageMultiplier = 1
}