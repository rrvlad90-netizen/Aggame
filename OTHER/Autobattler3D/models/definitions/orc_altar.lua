local BuildingFactory =
  require(
    'models.definitions.building_factory'
  )


return BuildingFactory.create({
  id = 'orc_altar',

  path =
    'models/OrcBuildings/altar_of_storm.md3',

  texture =
    'models/OrcBuildings/AltarOfStorms_main_diffuse.jpg',

  scale = .01,
  yOffset = 0,
  rotationOffset = math.pi,
  colliderRadius = 4.5
})