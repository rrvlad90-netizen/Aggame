local BuildingFactory =
  require(
    'models.definitions.building_factory'
  )


return BuildingFactory.create({
  id = 'human_barracks',

  path =
    'models/HumanBuildings/barraks.md3',

  texture =
    'models/HumanBuildings/barraks.png',

  scale = .01,
  yOffset = 0,
  rotationOffset = 0,
  colliderRadius = 4
})