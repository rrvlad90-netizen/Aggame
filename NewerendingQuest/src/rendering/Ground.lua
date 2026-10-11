local Config = require("src.config")

local Ground = {}
Ground.__index = Ground

-- Создаёт отрисовщик текстурированной поверхности.
function Ground.new(projection, assets, biome)
    local self = setmetatable({}, Ground)

    self.projection = projection
    self.biome = biome

    self.image = assets:getImage(biome.groundImage)
    self.mesh = nil
    self.rowCount = 40

    if self.image then
        self.image:setWrap("repeat", "repeat")
    end

    return self
end

-- Рисует основной цвет земли и PNG-текстуру.
function Ground:draw(cameraX, cameraZ)
    self:drawBaseColor()

    if not self.image then
        return
    end

    local vertices = self:createVertices(cameraX, cameraZ)

    if not self.mesh then
        self.mesh = love.graphics.newMesh(
            vertices,
            "strip",
            "dynamic"
        )

        self.mesh:setTexture(self.image)
    else
        self.mesh:setVertices(vertices)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.mesh)
end

-- Заполняет всю область ниже горизонта цветом биома.
function Ground:drawBaseColor()
    local color = self.biome.groundColor

    love.graphics.setColor(
        color[1],
        color[2],
        color[3]
    )

    love.graphics.rectangle(
        "fill",
        0,
        Config.projection.horizonY,
        Config.virtualWidth,
        Config.virtualHeight - Config.projection.horizonY
    )

    love.graphics.setColor(1, 1, 1)
end

-- Создаёт полосы перспективной текстуры травы.
function Ground:createVertices(cameraX, cameraZ)
    local vertices = {}

    local behind = Config.projection.visibleBehindDepth
    local ahead = Config.projection.visibleDepth
    local totalDepth = behind + ahead
    local textureSize = self.biome.groundTextureWorldSize

    for row = 0, self.rowCount do
        local progress = row / self.rowCount
        local relativeZ = -behind + totalDepth * progress
        local worldZ = cameraZ + relativeZ

		local _, screenY, _, _, horizontalScale =
			self.projection:project(
				cameraX,
				worldZ,
				cameraX,
				cameraZ
			)

		local leftWorldX =
			cameraX +
			(0 - Config.projection.centerX) /
			horizontalScale

		local rightWorldX =
			cameraX +
			(
				Config.virtualWidth -
				Config.projection.centerX
			) /
			horizontalScale

        local textureV = worldZ / textureSize
        local leftU = leftWorldX / textureSize
        local rightU = rightWorldX / textureSize

        vertices[#vertices + 1] = {
            0,
            screenY,
            leftU,
            textureV,
            1,
            1,
            1,
            1
        }

        vertices[#vertices + 1] = {
            Config.virtualWidth,
            screenY,
            rightU,
            textureV,
            1,
            1,
            1,
            1
        }
    end

    return vertices
end

return Ground