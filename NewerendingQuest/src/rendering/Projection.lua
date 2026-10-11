local Projection = {}
Projection.__index = Projection

-- Ограничивает число заданным диапазоном.
local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

-- Создаёт классическую псевдо-3D проекцию.
function Projection.new(config)
    local self = setmetatable({}, Projection)

    self.centerX = config.centerX
    self.horizonY = config.horizonY
    self.nearY = config.nearY
    self.behindY = config.behindY

    self.visibleDepth = config.visibleDepth
    self.visibleBehindDepth = config.visibleBehindDepth

    self.farFadeStart = config.farFadeStart
    self.behindFadeStart = config.behindFadeStart

    self.nearScale = config.nearScale
    self.farScale = config.farScale
    self.behindScale = config.behindScale
	
	self.horizontalNearScale = config.horizontalNearScale
	self.horizontalFarScale = config.horizontalFarScale
	self.horizontalCurve = config.horizontalCurve

    self.depthCurve = config.depthCurve
    self.scaleCurve = config.scaleCurve

    return self
end

-- Преобразует координаты мира в координаты экрана.
function Projection:project(worldX, worldZ, cameraX, cameraZ)
    local relativeZ = worldZ - cameraZ
	local horizontalScale
	
    local screenY
    local scale

    if relativeZ >= 0 then
        local depth = clamp(
            relativeZ / self.visibleDepth,
            0,
            1
        )

        local remaining = 1 - depth

        local verticalFactor =
            remaining ^ self.depthCurve

        local scaleFactor =
            remaining ^ self.scaleCurve

        screenY =
            self.horizonY +
            (self.nearY - self.horizonY) *
            verticalFactor

        scale =
            self.farScale +
            (self.nearScale - self.farScale) *
            scaleFactor
			
		horizontalScale =
			self.horizontalFarScale +
			(
				self.horizontalNearScale -
				self.horizontalFarScale
			) *
			remaining ^ self.horizontalCurve	
			
    else
		local behindDistance = -relativeZ

		-- Продолжаем скорость движения из ближней точки проекции.
		local nearPixelsPerUnit =
			(self.nearY - self.horizonY) *
			self.depthCurve /
			self.visibleDepth

		-- Аналогично продолжаем скорость увеличения спрайта.
		local nearScalePerUnit =
			(self.nearScale - self.farScale) *
			self.scaleCurve /
			self.visibleDepth

		screenY =
			self.nearY +
			behindDistance * nearPixelsPerUnit

		scale =
			self.nearScale +
			behindDistance * nearScalePerUnit
			
		local nearHorizontalScalePerUnit =
		(
			self.horizontalNearScale -
			self.horizontalFarScale
		) *
		self.horizontalCurve /
		self.visibleDepth

	horizontalScale =
		self.horizontalNearScale +
		behindDistance *
		nearHorizontalScalePerUnit	
	end

	local screenX =
		self.centerX +
		(worldX - cameraX) * horizontalScale

	return
		screenX,
		screenY,
		scale,
		relativeZ,
		horizontalScale
end

-- Проверяет видимость объекта по глубине.
function Projection:isDepthVisible(worldZ, cameraZ)
    local relativeZ = worldZ - cameraZ

    return
        relativeZ >= -self.visibleBehindDepth and
        relativeZ <= self.visibleDepth
end

-- Вычисляет плавное проявление у горизонта.
function Projection:getFarAlpha(relativeZ)
    if relativeZ <= self.farFadeStart then
        return 1
    end

    local fadeLength =
        self.visibleDepth -
        self.farFadeStart

    if fadeLength <= 0 then
        return 0
    end

    return clamp(
        1 -
        (relativeZ - self.farFadeStart) /
        fadeLength,
        0,
        1
    )
end

-- Вычисляет плавное исчезновение позади игрока.
function Projection:getBehindAlpha(relativeZ)
    local behindDistance = -relativeZ

    if behindDistance <= self.behindFadeStart then
        return 1
    end

    local fadeLength =
        self.visibleBehindDepth -
        self.behindFadeStart

    if fadeLength <= 0 then
        return 0
    end

    return clamp(
        1 -
        (behindDistance - self.behindFadeStart) /
        fadeLength,
        0,
        1
    )
end

-- Возвращает итоговую прозрачность объекта.
function Projection:getVisibilityAlpha(worldZ, cameraZ)
    local relativeZ = worldZ - cameraZ

    if relativeZ >= 0 then
        return self:getFarAlpha(relativeZ)
    end

    return self:getBehindAlpha(relativeZ)
end

return Projection