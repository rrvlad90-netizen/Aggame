local KikimoraData =
    require("data.entities.kikimora")

local Animator =
    require("src.animation.Animator")

local Kikimora = {}
Kikimora.__index = Kikimora

-- Создаёт кикимору в ячейке болотной сетки.
function Kikimora.new(
    lane,
    row,
    x,
    z,
    radius,
    assets,
    phaseOffsetRatio
)
    local self = setmetatable({}, Kikimora)

	-- При true кикимора ждёт появления игрока.
	self.waitingForPlayer = false

    self.type = KikimoraData.id

    self.lane = lane
    self.row = row
    self.x = x
    self.z = z
    self.radius = radius
    self.mainPath = true

    self.state = "safe"

    self.stateTime =
        (phaseOffsetRatio or 0) *
        KikimoraData.safeDuration

    self.animator = Animator.new(
        assets,
        KikimoraData.animations,
        "safe"
    )

    return self
end

-- Переходит к следующей фазе поведения.
function Kikimora:advanceState()
    if self.state == "safe" then
        self.state = "warning"
    elseif self.state == "warning" then
        self.state = "grab"
    elseif self.state == "grab" then
        self.state = "submerge"
    else
        self.state = "safe"
    end

    self.stateTime = 0

    self.animator:play(
        self.state,
        true
    )
end

-- Проверяет возможность приземления.
function Kikimora:isSafeForLanding()
    return
        self.state == "safe" or
        self.state == "warning"
end

-- Проверяет нахождение игрока на кикиморе.
function Kikimora:containsPlayer(player)
    if player.state ~= "grounded" then
        return false
    end

    local dx = player.x - self.x
    local dz = player.z - self.z

    local safeRadius =
        self.radius -
        player.collisionRadius

    return
        safeRadius > 0 and
        dx * dx + dz * dz <=
        safeRadius * safeRadius
end

-- Обрабатывает событие кадра.
function Kikimora:handleEvent(event, player)
    if
        event.type == "grab" and
        self:containsPlayer(player)
    then
        player:beGrabbed()
    end
end

-- Возвращает кикимору в безопасное состояние.
function Kikimora:resetAndWaitForPlayer()
    if self.waitingForPlayer then
        return
    end

    self.state = "safe"
    self.stateTime = 0
    self.waitingForPlayer = true

    self.animator:play(
        "safe",
        true
    )
end

-- Обновляет цикл поведения и анимацию.
function Kikimora:update(dt, player)
	if self.waitingForPlayer then
		if self:containsPlayer(player) then
			self.waitingForPlayer = false
			self.stateTime = 0

			self.animator:play(
				"safe",
				true
			)
		else
			return
		end
	end

    self.stateTime =
        self.stateTime +
        dt

    local events =
        self.animator:update(dt)

    for _, event in ipairs(events) do
        self:handleEvent(event, player)
    end

    if self.state == "safe" then
        if
            self.stateTime >=
            KikimoraData.safeDuration
        then
            self:advanceState()
        end

        return
    end

    if self.animator:isFinished() then
        self:advanceState()
    end
end

-- Рисует текущий кадр кикиморы.
function Kikimora:draw(
    projection,
    cameraX,
    cameraZ
)
    local x, y, perspectiveScale =
        projection:project(
            self.x,
            self.z,
            cameraX,
            cameraZ
        )

    local alpha =
        projection:getVisibilityAlpha(
            self.z,
            cameraZ
        )

    local image =
        self.animator:getCurrentImage()

    if image then
        local spriteScale =
            self.radius *
            2 *
            perspectiveScale /
            image:getWidth() *
            (KikimoraData.scale or 1)

        self.animator:draw(
            x,
            y,
            spriteScale,
            alpha
        )

        return
    end

    self:drawPlaceholder(
        x,
        y,
        perspectiveScale,
        alpha
    )
end

-- Рисует замену при отсутствии PNG.
function Kikimora:drawPlaceholder(
    x,
    y,
    scale,
    alpha
)
    if self.state == "submerge" then
        return
    end

    local height =
        self.state == "grab" and
        80 * scale or
        24 * scale

    love.graphics.setColor(
        0.25,
        0.55,
        0.3,
        alpha
    )

    love.graphics.ellipse(
        "fill",
        x,
        y - height,
        self.radius * 0.65 * scale,
        self.radius * 0.42 * scale
    )

    love.graphics.setColor(1, 1, 1)
end

return Kikimora