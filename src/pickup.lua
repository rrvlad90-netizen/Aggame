local Assets = require("src.assets")
local Collision = require("src.collision")
local Shadow = require("src.shadow")

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
	
------ТЕНЬ опционально


pickup.shadowType = config.shadowType
        or config.shadow_type
        or 0

    pickup.shadowAlpha = config.shadowAlpha
        or config.shadow_alpha
        or 0.3

    pickup.shadowWidth = config.shadowWidth
        or config.shadow_width

    pickup.shadowHeight = config.shadowHeight
        or config.shadow_height

    pickup.shadowOffsetX = config.shadowOffsetX
        or config.shadow_offset_x
        or 0

    pickup.shadowOffsetY = config.shadowOffsetY
        or config.shadow_offset_y
        or 0

    pickup.shadowScaleX = config.shadowScaleX
        or config.shadow_scale_x

    pickup.shadowScaleY = config.shadowScaleY
        or config.shadow_scale_y

    pickup.shadowVisible = false
    pickup.shadowX = 0
    pickup.shadowY = 0

---------	
    pickup.kind = config.kind or "health"
	
	-- Если true, pickup не подбирается касанием.
    -- Его нужно активировать кнопкой Down рядом с игроком.
    pickup.manualCollect = config.manualCollect == true
        or config.manual_collect == true

    -- Дополнительная зона подбора вокруг bbox.
    -- 0 = только точное пересечение hitbox pickup/player.
    pickup.collectRange = config.collectRange
        or config.collect_range
        or 0

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
---Weapon
	pickup.weaponPlayerId = config.weaponPlayerId
        or config.weapon_player_id

    pickup.weaponUses = config.weaponUses
        or config.weapon_uses
        or 0		
----
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

-- Возвращает hitbox ручного подбора.
-- collectRange расширяет обычный bbox pickup-а во все стороны.
function Pickup:getCollectHitbox()
    local box = self:getHitbox()
    local range = self.collectRange or 0

    if range <= 0 then
        return box
    end

    return {
        x = box.x - range,
        y = box.y - range,
        w = box.w + range * 2,
        h = box.h + range * 2
    }
end

-- Возвращает true, если pickup требует нажатия Down.
function Pickup:requiresManualCollect()
    return self.manualCollect == true
end

-- Возвращает true, если pickup можно подобрать автоматически касанием.
function Pickup:canAutoCollect()
    return self:canCollect()
        and not self:requiresManualCollect()
end

-- Проверяет, может ли игрок вручную подобрать pickup.
function Pickup:canManualCollect(player)
    if not player or not player.getHitbox then
        return false
    end

    if not self:canCollect() or not self:requiresManualCollect() then
        return false
    end

    return Collision.intersects(
        self:getCollectHitbox(),
        player:getHitbox()
    )
end

-- Возвращает дистанцию до игрока для выбора ближайшего pickup-а.
function Pickup:getDistanceSquaredToPlayer(player)
    local pickupBox = self:getHitbox()
    local playerBox = player:getHitbox()

    local pickupCenterX = pickupBox.x + pickupBox.w / 2
    local pickupCenterY = pickupBox.y + pickupBox.h / 2

    local playerCenterX = playerBox.x + playerBox.w / 2
    local playerCenterY = playerBox.y + playerBox.h / 2

    local dx = pickupCenterX - playerCenterX
    local dy = pickupCenterY - playerCenterY

    return dx * dx + dy * dy
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
	
	if self.kind == "weapon"
			and self.weaponPlayerId
			and self.weaponUses > 0
		then
			if player.addWeapon
				and player:addWeapon(self.weaponPlayerId, self.weaponUses)
			then
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

	Shadow.draw(self, camera)

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