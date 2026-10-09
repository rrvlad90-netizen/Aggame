return {
  profiles = {
    standard = {
      {
        slot = 'light_infantry',
        label = 'Light Infantry',

        minimumCityLevel = 1,

        cost = 250,
        turns = 2,

        campaignClass = 'infantry',
        campaignPower = 10
      },

      {
        slot = 'archer',
        label = 'Ranged Infantry',

        minimumCityLevel = 2,

        cost = 350,
        turns = 2,

        campaignClass = 'ranged',
        campaignPower = 11
      },

      {
        slot = 'cavalry',
        label = 'Cavalry',

        minimumCityLevel = 3,

        cost = 500,
        turns = 3,

        campaignClass = 'cavalry',
        campaignPower = 18
      },

      {
        slot = 'giant1',
        label = 'Giant',

        minimumCityLevel = 4,

        cost = 800,
        turns = 4,

        campaignClass = 'large',
        campaignPower = 45
      },

      {
        slot = 'catapult',
        label = 'Siege Weapon',

        minimumCityLevel = 4,

        cost = 750,
        turns = 4,

        campaignClass = 'siege',
        campaignPower = 38
      },

      {
        slot = 'dragon1',
        label = 'Dragon',

        minimumCityLevel = 5,

        cost = 1500,
        turns = 6,

        campaignClass = 'large',
        campaignPower = 80
      }
    }
  },

  classBonuses = {
    infantry = {
      cavalry = .30
    },

    cavalry = {
      ranged = .35,
      siege = .35
    },

    ranged = {
      large = .30
    },

    large = {
      infantry = .30
    },

    siege = {
      infantry = .35,
      large = .35
    }
  }
}