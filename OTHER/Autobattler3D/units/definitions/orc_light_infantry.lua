return {
  id = 'orc_light_infantry',
  slot = 'light_infantry',

  name = 'Orc Grunt',
  description = 'Basic orc melee infantry.',

  model = 'grunt',

  -- Разрешает проход сквозь союзных
  -- стрелков.
  alliedPassThroughSlots = {
    archer = true
  },

  corpse = {
    mode = 'random',
    stayChance = .35
  },

  behavior = 'melee',

  health = 200,

  damageMinimum = 20,
  damageMaximum = 30,
  damageType = 'normal',

  moveSpeed = 3.2,
  radius = .45,

  attackDistance = 1.8,
  sightDistance = 25,

  spearDamageMultiplier = 1,
  magicDamageMultiplier = 1,

  fallDeath = {
    enabled = true,

    distanceMinimum = 2.8,
    distanceMaximum = 3.6,

    heightMinimum = 1.5,
    heightMaximum = 2,

    durationMinimum = .75,
    durationMaximum = .95
  }
}