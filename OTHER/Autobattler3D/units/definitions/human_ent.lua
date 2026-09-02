return {
  id = 'human_ent',
  slot = 'giant1',

  name = 'Ancient Protector',
  description = 'A living tree fighting for humans.',

  model = 'ent',

  corpse = {
    mode = 'always'
  },

  fallDeath = {
    enabled = false
  },

  health = 1100,

damageMinimum = 220,
damageMaximum = 260,

  damageType = 'normal',

  moveSpeed = 2,
  radius = 0.8,

  spawnSpacing = 2.6,
  routeSpacing = 2.6,
  squadSize = 3,


attackDistance = 1.9,
  sightDistance = 30,

meleeArea = {
  enabled = true,
  radius = 2.1,
  friendlyFire = true,
  damageFalloff = 'uniform',
  launchOnKill = true
},

--  firstStrike = {
--    enabled = true,
--    damageMultiplier = 2,
--    radiusMultiplier = 2,
--    launchOnKill = true
--  },

  bodyPush = {
    enabled = true,
    distance = .35
  },

  spearDamageMultiplier = 1,
  magicDamageMultiplier = .8
}