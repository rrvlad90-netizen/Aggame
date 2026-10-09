return {
  {
    id =
      'HumanMainCity_HumanBorderTown',

    from = 'HumanMainCity',
    to = 'HumanBorderTown',

    days = 2,
    bidirectional = true,

    battleMapPool = 'road',
    dangerMultiplier = .6,

    mapPoints = {
      {
        x = 240,
        y = 360
      },

      {
        x = 330,
        y = 290
      },

      {
        x = 420,
        y = 220
      }
    }
  },

  {
    id =
      'HumanBorderTown_OrcForwardCamp',

    from = 'HumanBorderTown',
    to = 'OrcForwardCamp',

    days = 4,
    bidirectional = true,

    battleMapPool = 'road',
    dangerMultiplier = 1,

    mapPoints = {
      {
        x = 420,
        y = 220
      },

      {
        x = 640,
        y = 360
      },

      {
        x = 860,
        y = 500
      }
    }
  },

  {
    id =
      'HumanMainCity_OrcForwardCamp',

    from = 'HumanMainCity',
    to = 'OrcForwardCamp',

    days = 5,
    bidirectional = true,

    battleMapPool = 'road',
    dangerMultiplier = 1,

    mapPoints = {
      {
        x = 240,
        y = 360
      },

      {
        x = 550,
        y = 430
      },

      {
        x = 860,
        y = 500
      }
    }
  },

  {
    id =
      'HumanBorderTown_OrcMainCamp',

    from = 'HumanBorderTown',
    to = 'OrcMainCamp',

    days = 5,
    bidirectional = true,

    battleMapPool = 'road',
    dangerMultiplier = 1,

    mapPoints = {
      {
        x = 420,
        y = 220
      },

      {
        x = 730,
        y = 290
      },

      {
        x = 1040,
        y = 360
      }
    }
  },

  {
    id =
      'OrcForwardCamp_OrcMainCamp',

    from = 'OrcForwardCamp',
    to = 'OrcMainCamp',

    days = 2,
    bidirectional = true,

    battleMapPool = 'road',
    dangerMultiplier = .6,

    mapPoints = {
      {
        x = 860,
        y = 500
      },

      {
        x = 950,
        y = 430
      },

      {
        x = 1040,
        y = 360
      }
    }
  }
}