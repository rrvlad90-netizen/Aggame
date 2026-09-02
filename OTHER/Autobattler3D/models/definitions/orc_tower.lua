local BuildingFactory =
  require(
    'models.definitions.building_factory'
  )


return BuildingFactory.create({
  id = 'orc_tower',

  parts = {
    {
      id = 'tower_base',

      path =
        'models/OrcBuildings/orctower1.md3',

      texture =
        'models/OrcBuildings/orctower.jpg'
    },

    {
      id = 'tower_top',

      path =
        'models/OrcBuildings/orctower2.md3',

      texture =
        'models/OrcBuildings/orctower.jpg'
    }
  },

  scale = .01,
  yOffset = 0,
  rotationOffset = math.pi,
  colliderRadius = 3
})