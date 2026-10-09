local BuildingFactory =
  require(
    'models.definitions.building_factory'
  )


return BuildingFactory.create({
  id = 'orc_barracks',

  path =
    'models/OrcBuildings/OrcBarraks.md3',

  texture =
    'models/OrcBuildings/OrcBarraks.png',

  scale = .01,
  yOffset = 0,
  rotationOffset = math.pi,
  colliderRadius = 4
})