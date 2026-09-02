local BuildingCatalog = {}


BuildingCatalog.types = {
  altar = {
    id = 'altar',

    health = 3000,

    buildCost = 0,
    buildTime = 0,
    buildDepth = 0,

    colliderRadius = 9,

    recruitOptions = {
      {
        slot = 'dragon1',
        cost = 8000,
        mockup = '1'
      }
    }
  },

  barracks = {
    id = 'barracks',

    health = 1200,

    buildCost = 800,
    buildTime = 2.5,
    buildDepth = 7,

    colliderRadius = 8,

    recruitOptions = {
      {
        slot = 'light_infantry',
        cost = 250,
        count = 30,
        mockup = '1'
      },

      {
        slot = 'archer',
        cost = 300,
        count = 30,
        mockup = '2'
      },

      {
        slot = 'cavalry',
        cost = 500,
        mockup = '3'
      },

      {
        slot = 'catapult',
        cost = 1200,
        mockup = '4'
      },

      {
        slot = 'giant1',
        cost = 1800,
        mockup = '5'
      }
    }
  },

  tower = {
    id = 'tower',

    health = 900,

    buildCost = 1100,
    buildTime = 2.2,
    buildDepth = 7,

    colliderRadius = 6,

    attack = {
      projectile = 'arrow',
      maximumDistance = 28,
      cooldown = 1,
      spawnHeight = 15
    }
  }
}


BuildingCatalog.models = {
  human = {
    altar = 'human_altar',
    barracks = 'human_barracks',
    tower = 'human_tower'
  },

  orcs = {
    altar = 'orc_altar',
    barracks = 'orc_barracks',
    tower = 'orc_tower'
  }
}


-- Возвращает описание типа здания.
function BuildingCatalog.get(buildingType)
  return assert(
    BuildingCatalog.types[buildingType],
    'Unknown building type: ' ..
    tostring(buildingType)
  )
end


-- Возвращает модель здания фракции.
function BuildingCatalog.getModel(
  sideId,
  buildingType
)
  local sideModels =
    assert(
      BuildingCatalog.models[sideId],
      'Unknown building side: ' ..
      tostring(sideId)
    )

  return assert(
    sideModels[buildingType],
    'Side has no building model: ' ..
    tostring(buildingType)
  )
end


return BuildingCatalog