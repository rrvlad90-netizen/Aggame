return {
  id = 'dwarf_with_rifle',
  slot = 'archer',

  name = 'Dwarf Rifleman',
  description = 'Dwarf armed with a rifle.',

  model = 'dwarf_with_rifle',

  corpse = {
    mode = 'random',
    stayChance = .35
  },

  health = 160,

  damageMinimum = 12,
  damageMaximum = 18,
  damageType = 'normal',

  moveSpeed = 3,
  radius = .4,

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