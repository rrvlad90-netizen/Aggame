return {
  id = 'orc_red_dragon',
  slot = 'dragon1',

  name = 'Red Dragon',
  description = 'A flying red dragon.',

  model = 'red_dragon',

  corpse = {
    mode = 'never'
  },

  fallDeath = {
    enabled = false
  },

  health = 1000,

  damageMinimum = 110,
  damageMaximum = 150,
  damageType = 'normal',

  moveSpeed = 4.5,
  radius = .2,
  squadSize = 1,

  attackDistance = 2.3,
  sightDistance = 34,

  flying = {
    enabled = true,
    height = 5
  },

  meleeDive = {
    enabled = true,
    attackHeight = 1.1,
    descentSpeed = 6,
    ascentSpeed = 4
  },

  meleeArea = {
    enabled = true,
    radius = 2.5,
    friendlyFire = true,
    damageFalloff = 'uniform',
    launchOnKill = true
  },

  rangedAttack = {
    projectile = 'fireball',

    minimumDistance = 5,
    maximumDistance = 30,

    cooldownMinimum = 2.5,
    cooldownMaximum = 3.2,

    spawnHeight = .6,
    spawnForward = 1,
    targetHeight = .8
  },

  deathEffect = {
    projectile = 'air_explosion'
  },

  spearDamageMultiplier = 1,
  magicDamageMultiplier = .7
}