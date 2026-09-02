return {
  id = 'orc_catapult',
  slot = 'catapult',

  name = 'Orc Catapult',
  description = 'Orc artillery firing heavy rocks.',

  model = 'catapult',

  corpse = {
    mode = 'always'
  },

  fallDeath = {
    enabled = false
  },

  health = 400,

  damageMinimum = 20,
  damageMaximum = 30,
  damageType = 'normal',

  moveSpeed = 1.25,
  radius = .9,

  spawnSpacing = 2.4,
  routeSpacing = 2.4,
  squadSize = 2,

  attackDistance = 0,
  sightDistance = 42,

  rangedAttack = {
    projectile = 'catapult_rock',

    minimumDistance = 8,
    maximumDistance = 38,

    cooldownMinimum = 4.2,
    cooldownMaximum = 5,

    spawnHeight = 2,
    spawnForward = .8,
    targetHeight = 0
  },

  spearDamageMultiplier = 1,
  magicDamageMultiplier = 1
}