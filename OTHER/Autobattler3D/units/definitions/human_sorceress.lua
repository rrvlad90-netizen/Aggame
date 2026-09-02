return {
  id = 'human_sorceress',
  slot = 'dragon1',

  name = 'Flying Sorceress',
  description = 'A flying human sorceress.',

  model = 'sorceress',

  corpse = {
    mode = 'never'
  },

  fallDeath = {
    enabled = false
  },

  health = 800,

  damageMinimum = 65,
  damageMaximum = 90,
  damageType = 'magic',

  moveSpeed = 4,
  radius = .2,
  squadSize = 1,

  attackDistance = 1.8,
  sightDistance = 32,

  flying = {
    enabled = true,
    height = 3.3
  },

  meleeArea = {
    enabled = true,
    radius = 2,
    friendlyFire = true,
    damageFalloff = 'uniform',
    launchOnKill = true
  },

  rangedAttack = {
    projectile = 'blue_fireball',

    minimumDistance = 4,
    maximumDistance = 27,

    cooldownMinimum = 2,
    cooldownMaximum = 2.7,

    spawnHeight = .8, --на этой высоте снаряд вылетает
    spawnForward = .6,
    targetHeight = .8
  },

  deathEffect = {
    projectile = 'air_explosion'
  },

  spearDamageMultiplier = 1,
  magicDamageMultiplier = .65
}