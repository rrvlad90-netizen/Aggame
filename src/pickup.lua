local Assets = require("src.assets")
local Collision = require("src.collision")

local Pickup = {}
Pickup.__index = Pickup

-- Создаёт pickup из definition.
-- Pickup используется для аптечек, патронов и других предметов.
function Pickup:new(config)
    config = config or {}

    local pickup = setmetatable({}, Pickup)

    pickup.id = config.id or "pickup"

    pickup.x = config.x or 0
    pickup.y = config.y or 0

    pickup.canvas = config.canvas or {
        width = config.w or config.width or 32,
        height = config.h or config.height or 32
    }

    pickup.offset = config.offset or {
        x = pickup.canvas.width / 2,
        y = pickup.canvas.height / 2
    }

    pickup.bbox = config.bbox or {
        x = 0,
        y = 0,
        w = pickup.canvas.width,
        h = pickup.canvas.height
    }

    pickup.image = config.image

    pickup.alpha = config.alpha or 1
    pickup.color = config.color or {0.2, 0.9, 0.25}

    pickup.kind = config.kind or "health"

    pickup.healAmount = config.healAmount
        or config.heal_amount
        or 0

    pickup.ammoType = config.ammoType
        or config.ammo_type

    pickup.ammoAmount = config.ammoAmount
        or config.ammo_amount
        or 0
		
	pickup.lifeAmount = config.lifeAmount
        or config.life_amount
        or 0	

    pickup.vx = config.vx or config.speedX or config.speed_x or 0
    pickup.vy = config.vy or config.speedY or config.speed_y or 0
    pickup.gravity = config.gravity or 0

    pickup.collected = false
    pickup.dead = false

    return pickup
end

-- Обновляет pickup.
function Pickup:update(dt)
    if self.dead or self.collected then
        return
    end

    self.x = self.x + self.vx * dt

    if self.gravity ~= 0 then
        self.vy = self.vy + self.gravity * dt
    end

    self.y = self.y + self.vy * dt
end

-- Возвращает hitbox pickup-а.
function Pickup:getHitbox()
    return Collision.localBoxToWorld(self, self.bbox)
end

-- Проверяет, можно ли подобрать pickup.
function Pickup:canCollect()
    return not self.dead and not self.collected
end

-- Применяет pickup к player.
-- Возвращает true, если pickup был успешно использован.
function Pickup:applyToPlayer(player)
    if not self:canCollect() then
        return false
    end

    if self.kind == "health" and self.healAmount > 0 then
        if player.heal and player:heal(self.healAmount) then
            self.collected = true
            self.dead = true
            return true
        end
    end

    if self.kind == "ammo" and self.ammoAmount > 0 then
        if player.addAmmo and player:addAmmo(self.ammoType, self.ammoAmount) then
            self.collected = true
            self.dead = true
            return true
        end
    end
	
	if self.kind == "life" and self.lifeAmount > 0 then
        if player.addLife and player:addLife(self.lifeAmount) then
            self.collected = true
            self.dead = true
            return true
        end
    end	

    return false
end

-- Рисует pickup.
function Pickup:draw(camera)
    local screenX = self.x - (camera and camera.x or 0)
    local screenY = self.y - (camera and camera.y or 0)

    if self.image then
        local image = Assets.getImage(self.image)

        love.graphics.setColor(1, 1, 1, self.alpha)
        love.graphics.draw(
            image,
            screenX,
            screenY,
            0,
            1,
            1,
            self.offset.x,
            self.offset.y
        )
        love.graphics.setColor(1, 1, 1)

        return
    end

    love.graphics.setColor(
        self.color[1],
        self.color[2],
        self.color[3],
        self.alpha
    )

    love.graphics.rectangle(
        "fill",
        screenX - self.offset.x,
        screenY - self.offset.y,
        self.canvas.width,
        self.canvas.height,
        4,
        4
    )

    love.graphics.setColor(1, 1, 1)
end

-- Возвращает true, если pickup можно удалить.
function Pickup:isRemovable()
    return self.dead or self.collected
end

return Pickup