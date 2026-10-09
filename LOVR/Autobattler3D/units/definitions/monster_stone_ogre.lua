return {
  id = 'monster_stone_ogre',
  slot = 'giant1',

  name = 'Stone Ogre',

  description =
    'A neutral monster guarding strategic points.',

  model = 'ogre',

  tint = {
    .52,
    .56,
    .6,
    1
  },

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

  moveSpeed = 2.4,
  radius = .8,

  spawnSpacing = 2.4,
  routeSpacing = 2.4,
  squadSize = 4,

  attackDistance = 1.9,
  sightDistance = 30,

	alliedPassThroughSlots = {
	  all = true,

	  -- Великаны сталкиваются с другими
	  -- великанами своего слота.
	  exceptSameSlot = true,
	},

  meleeArea = {
    enabled = true,
    radius = 3.1,

    -- Охранники не повреждают друг друга.
    friendlyFire = false,

    damageFalloff = 'uniform',
    launchOnKill = true
  },

  bodyPush = {
    enabled = true,
    distance = .35
  },

  spearDamageMultiplier = 1,
  magicDamageMultiplier = 1
}