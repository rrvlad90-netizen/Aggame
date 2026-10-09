local BuildingFactory =
  require(
    'models.definitions.building_factory'
  )


return BuildingFactory.create({
  id = 'human_tower',

  path =
    'models/HumanBuildings/tower.md3',

  texture =
    'models/HumanBuildings/tower.png',

  scale = .01,
  yOffset = 0,
  rotationOffset = 0,
  colliderRadius = 3
})