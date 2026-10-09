return {
  id = 'orc_tower',
  format = 'multi_obj',

  scale = .03,
  yOffset = 0,
  rotationOffset = math.pi,

  solid = true,

  collider = {
    type = 'circle',
    radius = 6
  },

  parts = {
    {
      id = 'tower_base',

      path =
        'models/OrcBuildings/orctower1.obj',

      texture =
        'models/OrcBuildings/orctower.jpg'
    },

    {
      id = 'tower_top',

      path =
        'models/OrcBuildings/orctower2.obj',

      texture =
        'models/OrcBuildings/orctower.jpg'
    }
  }
}