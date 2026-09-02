local Entity =
  require('src.world.entity')

local Decor = {}
Decor.__index = Decor


-- Создаёт неподвижную декорацию.
function Decor.new(
  data,
  modelRegistry,
  index
)
  local self =
    setmetatable({}, Decor)

  local position =
    data.position
    or {
      0, 0, 0
    }

  local offset =
    data.offset
    or {
      0, 0, 0
    }

  self.solid =
    data.solid == true

  self.radius =
    data.radius or 0

  self.entity = Entity.new({
    id =
      data.id
      or 'decor_' .. tostring(index),

    model =
      assert(
        data.model,
        'Decor has no model'
      ),

    position = {
      (position[1] or 0) +
        (offset[1] or 0),

      (position[2] or 0) +
        (offset[2] or 0),

      (position[3] or 0) +
        (offset[3] or 0)
    },

    yaw = data.yaw or 0,
    scale = data.scale,
    alpha = data.alpha or 1,
    tint = data.tint,

    solid = self.solid,

    collider = {
      type = 'circle',
      radius = self.radius
    }
  }, modelRegistry)

  return self
end


-- Разрешает столкновение с бойцом.
function Decor:resolveUnitCollision(unit)
  if
    not self.solid
    or self.radius <= 0
  then
    return
  end

  if unit.flyingBehavior then
    return
  end

  self.entity:resolveCircleCollision(
    unit,
    unit.radius
  )
end


-- Рисует декорацию.
function Decor:draw(pass)
  self.entity:draw(pass)
end


return Decor