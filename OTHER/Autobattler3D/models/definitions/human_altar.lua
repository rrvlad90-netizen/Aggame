local BuildingFactory =
  require(
    'models.definitions.building_factory'
  )


return BuildingFactory.create({
  id = 'human_altar',

  path =
    'models/HumanBuildings/altar_of_king.md3',

  textures = {
    [1] =
      'models/HumanBuildings/AltarOfKingsHD.jpg',

    [2] =
      'models/HumanBuildings/AltarOfKings2.JPG',

    default =
      'models/HumanBuildings/AltarOfKingsHD.jpg'
  },

  scale = .01,
  yOffset = 0,
  rotationOffset = 0,
  colliderRadius = 4.5
})