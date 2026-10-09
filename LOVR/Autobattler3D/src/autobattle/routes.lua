local Routes = {}


-- Создаёт описание маршрута.
local function createRoute(
  id,
  title,
  team,
  endpointX,
  endpointZ,
  points,
  width
)
  return {
    id = id,
    title = title,
    team = team,

    endpoint = {
      x = endpointX,
      z = endpointZ
    },

    points = points,
    width = width or 18
  }
end


Routes.teams = {
  allies = {
    createRoute(
      'allied_center',
      'CENTER',
      'allies',
      0,
      -30,
      {
        { x = 0, z = 12 },
        { x = 0, z = -8 },
        { x = 0, z = -30 }
      }
    ),

    createRoute(
      'allied_left',
      'LEFT',
      'allies',
      -22,
      -26,
      {
        { x = -5, z = 12 },
        { x = -14, z = -4 },
        { x = -22, z = -26 }
      }
    ),

    createRoute(
      'allied_right',
      'RIGHT',
      'allies',
      22,
      -26,
      {
        { x = 5, z = 12 },
        { x = 14, z = -4 },
        { x = 22, z = -26 }
      }
    )
  },

  enemies = {
    createRoute(
      'enemy_center',
      'CENTER',
      'enemies',
      0,
      30,
      {
        { x = 0, z = -12 },
        { x = 0, z = 8 },
        { x = 0, z = 30 }
      }
    ),

    createRoute(
      'enemy_left',
      'LEFT',
      'enemies',
      22,
      26,
      {
        { x = 5, z = -12 },
        { x = 14, z = 4 },
        { x = 22, z = 26 }
      }
    ),

    createRoute(
      'enemy_right',
      'RIGHT',
      'enemies',
      -22,
      26,
      {
        { x = -5, z = -12 },
        { x = -14, z = 4 },
        { x = -22, z = 26 }
      }
    )
  }
}


-- Возвращает маршруты стороны.
function Routes.getForTeam(team)
  return Routes.teams[team] or {}
end


-- Ищет маршрут по идентификатору.
function Routes.get(team, routeId)
  for _, route in ipairs(
    Routes.getForTeam(team)
  ) do
    if route.id == routeId then
      return route
    end
  end

  return nil
end


return Routes