return {
  id = 'dwarf_with_rifle',
  slot = 'archer',

  name = 'Dwarf Rifleman',
  description = 'Dwarf armed with a rifle.',

  model = 'dwarf_with_rifle',

	-- Позволяет стрелкам проходить сквозь
	-- союзных стрелков при плотном заторе.
	--alliedPassThroughSlots = {
	  --archer = true
	--},


  corpse = {
    mode = 'random',
    stayChance = .35
  },

  -- Полный отряд при найме.
  squadSize = 20,

  health = 160,

  damageMinimum = 9,
  damageMaximum = 12,
  damageType = 'normal',

  moveSpeed = 3,
  radius = .4,
  
  -- Раздвигает стрелков по маршруту шире
  -- минимальной дистанции столкновения.
  spawnSpacing = .95,
  routeSpacing = .95,

  attackDistance = 1.35,
  sightDistance = 28,

  rangedAttack = {
    projectile = 'bullet',

    minimumDistance = 3,
    maximumDistance = 24,

    cooldownMinimum = 1.4,
    cooldownMaximum = 1.8,

    spawnHeight = 1.15,
    spawnForward = .5,
    targetHeight = .8
  },

  spearDamageMultiplier = 1,
  magicDamageMultiplier = 1
}