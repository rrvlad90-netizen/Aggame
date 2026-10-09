local Cities =
  require('campaigns.world01.cities')

local Routes =
  require('campaigns.world01.routes')

local Recruitment =
  require(
    'campaigns.world01.recruitment'
  )

local Director =
  require('campaigns.world01.director')

local BattleMaps =
  require(
    'campaigns.world01.battle_maps'
  )

local Deployments =
  require(
    'campaigns.world01.deployments'
  )


return {
  id = 'world01',
  name = 'World 01',

  description =
    'Humans fight the Orc Horde.',

  worldMap = {
    image =
      'campaigns/world01/MapWorld01.png',

    width = 1280,
    height = 720
  },

  startingGold = 1000,

  maximumArmies = 10,
  maximumSquadsPerArmy = 10,

  participants = {
    {
      id = 'humans',
      side = 'human',

      controller = 'player',
      team = 1,

      capital = 'HumanMainCity'
    },

    {
      id = 'orc_horde',
      side = 'orcs',

      controller = 'director',
      team = 2,

      capital = 'OrcMainCamp'
    }
  },

  neutralSide = 'monsters',

  cities = Cities,
  routes = Routes,
  recruitment = Recruitment,
  director = Director,

  battleMaps = BattleMaps,
  deployments = Deployments,

  objectives = {
    cities = {
      'OrcMainCamp'
    }
  },

  defeat = {
    capital = 'HumanMainCity'
  },

  autoSave = {
    enabled = true,
    file = 'campaign_world01.lua'
  }
}