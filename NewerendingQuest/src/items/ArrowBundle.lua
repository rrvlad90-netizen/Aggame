local Config =
    require("src.config")

local ArrowData =
    require("data.items.arrow_bundle")

local ArrowBundle = {}
ArrowBundle.__index = ArrowBundle

-- Создаёт связку стрел.
function ArrowBundle.new(
    assets,
    x,
    z,
    amount,
    options
)
    local self =
        setmetatable(
            {},
            ArrowBundle
        )

    options = options or {}

    self.type = "arrow_bundle"

    self.x = x
    self.z = z

    self.amount =
        amount or
        ArrowData.amount

    self.pickupRadius =
        ArrowData.pickupRadius *
        Config.worldUnitsPerMeter

    self.revealRadius =
        (
            ArrowData.revealRadius or
            1.8
        ) *
        Config.worldUnitsPerMeter

    self.visible =
        options.visible ~= false

    self.isMonsterDrop =
        options.isMonsterDrop == true

    self.active = true
    self.collected = false

    self.image =
        assets:getImage(
            ArrowData.imageKey
        )

    return self
end

-- Обновляет связку стрел.
function ArrowBundle:update(
    dt,
    player,
    cameraZ
)
    if
        not self.active or
        self.collected
    then
        return
    end

    if
        self.isMonsterDrop and
        cameraZ and
        self.z <
        cameraZ -
        Config.projection.visibleBehindDepth
    then
        self.active = false
        return
    end

    local dx =
        player.x - self.x

    local dz =
        player.z - self.z

    local distanceSquared =
        dx * dx + dz * dz

    if
        not self.visible and
        distanceSquared <=
        self.revealRadius *
        self.revealRadius
    then
        self.visible = true
    end

    if
        not self.visible or
        player:isArrowQuiverFull()
    then
        return
    end

    local radius =
        self.pickupRadius +
        player.collisionRadius

    if
        distanceSquared <=
        radius * radius
    then
        local added =
            player:addArrows(
                self.amount
            )

        if added > 0 then
            self.collected = true
            self.active = false
        end
    end
end

-- Рисует связку стрел.
function ArrowBundle:draw(
    projection,
    cameraX,
    cameraZ
)
    if
        not self.active or
        self.collected or
        not self.visible
    then
        return
    end

    local x, y, perspectiveScale =
        projection:project(
            self.x,
            self.z,
            cameraX,
            cameraZ
        )

    local alpha =
        projection:
        getVisibilityAlpha(
            self.z,
            cameraZ
        ) *
        ArrowData.alpha

    if self.image then
        local spriteScale =
            perspectiveScale *
            ArrowData.spriteHeight /
            self.image:getHeight() *
            ArrowData.scale

        love.graphics.setColor(
            1,
            1,
            1,
            alpha
        )

        love.graphics.draw(
            self.image,
            x,
            y,
            0,
            spriteScale,
            spriteScale,
            self.image:getWidth() / 2,
            self.image:getHeight()
        )
    else
        love.graphics.setColor(
            0.76,
            0.63,
            0.34,
            alpha
        )

        love.graphics.rectangle(
            "fill",
            x - 14 * perspectiveScale,
            y - 7 * perspectiveScale,
            28 * perspectiveScale,
            7 * perspectiveScale
        )
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return ArrowBundle