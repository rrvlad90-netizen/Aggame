return {
  id = 'orc_cavalry',
  slot = 'cavalry',

  name = 'Orc Wolf Rider',
  description = 'Fast orc wolf cavalry.',

  model = 'rider',

  corpse = {
    mode = 'random',
    stayChance = .5
  },

  health = 320,

  damageMinimum = 50,
  damageMaximum = 75,
  damageType = 'normal',

	moveSpeed = 5.2,
	radius = .45,

	spawnSpacing = 1.25,
	routeSpacing = 1.25,

	squadSize = 20,

  attackDistance = 1.75,
  sightDistance = 30,

	charge = {
	  enabled = true,
	  windowDuration = 1,

	  damageMinimum = 220,
	  damageMaximum = 280,

	  launchOnKill = true
	},

  spearDamageMultiplier = 1,
  magicDamageMultiplier = 1
}