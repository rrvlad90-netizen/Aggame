return {
  id = 'orc_ogre',
  slot = 'giant1',

  name = 'Ogre',
  description = 'A massive orc shock unit.',

  model = 'ogre',

  corpse = {
    mode = 'always'
  },

  fallDeath = {
    enabled = false
  },

  -- Полный отряд при найме.
  squadSize = 3,

  health = 1100,

damageMinimum = 220,
damageMaximum = 260,
  damageType = 'normal',

  moveSpeed = 2.4,
  radius = 0.8,

  spawnSpacing = 2.4,
  routeSpacing = 2.4,
  squadSize = 3,

attackDistance = 1.9,
  sightDistance = 30,
  
	alliedPassThroughSlots = {
	  all = true,

	  -- Великаны сталкиваются с другими
	  -- великанами своего слота.
	  exceptSameSlot = true,

	  -- Катапульты также блокируют проход.
	  blockedSlots = {
		catapult = true
	  }
	},

	meleeArea = {
	  enabled = true,
	  radius = 3.1,

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
  magicDamageMultiplier = 1
}