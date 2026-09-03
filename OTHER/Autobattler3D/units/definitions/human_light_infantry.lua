return {
  id = 'human_light_infantry',
  slot = 'light_infantry',

  name = 'Human Swordsman',
  description = 'Basic human melee infantry.',

  model = 'footman',

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
  magicDamageMultiplier = 1
}