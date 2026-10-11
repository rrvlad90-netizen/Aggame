local Config = require("src.config")

local LevelTransition = {}
LevelTransition.__index = LevelTransition

-- Создаёт контроллер перехода между уровнями.
function LevelTransition.new(assets)
    local self = setmetatable({}, LevelTransition)

    self.assets = assets

    self.active = false
    self.phase = "idle"
    self.time = 0

    self.level = nil
    self.preview = nil
    self.previewImage = nil

    self.onSwitch = nil
    self.onComplete = nil

    return self
end

-- Запускает переход к указанному уровню.
function LevelTransition:start(
    level,
    onSwitch,
    onComplete
)
    self.level = level
    self.preview = level.preview or {}

    self.preview.fadeOutDuration =
        self.preview.fadeOutDuration or 0.5

    self.preview.displayDuration =
        self.preview.displayDuration or 1.5

    self.preview.fadeInDuration =
        self.preview.fadeInDuration or 0.5

    self.previewImage = nil

    if self.preview.image then
        self.previewImage =
            self.assets:getFileImage(
                self.preview.image
            )
    end

    self.onSwitch = onSwitch
    self.onComplete = onComplete

    self.active = true
    self.phase = "fade_out"
    self.time = 0
end

-- Возвращает безопасную длительность фазы.
function LevelTransition:getDuration(name)
    return math.max(
        self.preview[name] or 0,
        0.001
    )
end

-- Обновляет текущую фазу перехода.
function LevelTransition:update(dt)
    if not self.active then
        return
    end

    self.time = self.time + dt

    if self.phase == "fade_out" then
        local duration =
            self:getDuration(
                "fadeOutDuration"
            )

        if self.time >= duration then
            self.time = 0
            self.phase = "preview"

            if self.onSwitch then
                self.onSwitch()
            end
        end

        return
    end

    if self.phase == "preview" then
        local duration =
            self:getDuration(
                "displayDuration"
            )

        if self.time >= duration then
            self.time = 0
            self.phase = "fade_in"
        end

        return
    end

    if self.phase == "fade_in" then
        local duration =
            self:getDuration(
                "fadeInDuration"
            )

        if self.time >= duration then
            self.active = false
            self.phase = "idle"
            self.time = 0

            if self.onComplete then
                self.onComplete()
            end
        end
    end
end

-- Проверяет активность перехода.
function LevelTransition:isActive()
    return self.active
end

-- Возвращает прозрачность чёрного экрана.
function LevelTransition:getFadeAlpha()
    if self.phase == "fade_out" then
        return math.min(
            1,
            self.time /
            self:getDuration(
                "fadeOutDuration"
            )
        )
    end

    if self.phase == "preview" then
        return 1
    end

    if self.phase == "fade_in" then
        return math.max(
            0,
            1 -
            self.time /
            self:getDuration(
                "fadeInDuration"
            )
        )
    end

    return 0
end

-- Рисует изображение превью.
function LevelTransition:drawPreviewImage()
    if not self.previewImage then
        return
    end

    local maximumWidth =
        Config.virtualWidth * 0.72

    local maximumHeight =
        Config.virtualHeight * 0.55

    local scale = math.min(
        maximumWidth /
        self.previewImage:getWidth(),

        maximumHeight /
        self.previewImage:getHeight()
    )

    local width =
        self.previewImage:getWidth() *
        scale

    local height =
        self.previewImage:getHeight() *
        scale

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(
        self.previewImage,
        Config.virtualWidth / 2 -
        width / 2,
        Config.virtualHeight / 2 -
        height / 2 + 25,
        0,
        scale,
        scale
    )
end

-- Рисует название следующего уровня.
function LevelTransition:drawLevelTitle()
    local font = love.graphics.getFont()

    local title =
        self.level.name or
        self.level.id or
        "Next level"

    love.graphics.setColor(1, 1, 1)

    love.graphics.print(
        title,
        Config.virtualWidth / 2 -
        font:getWidth(title) / 2,
        70
    )

    local biome =
        string.upper(
            self.level.biome or ""
        )

    love.graphics.setColor(
        0.7,
        0.8,
        0.7
    )

    love.graphics.print(
        biome,
        Config.virtualWidth / 2 -
        font:getWidth(biome) / 2,
        95
    )
end

-- Рисует текущую фазу перехода.
function LevelTransition:draw()
    if not self.active then
        return
    end

    if self.phase == "preview" then
        love.graphics.setColor(0, 0, 0, 1)

        love.graphics.rectangle(
            "fill",
            0,
            0,
            Config.virtualWidth,
            Config.virtualHeight
        )

        self:drawPreviewImage()
        self:drawLevelTitle()

        love.graphics.setColor(1, 1, 1)
        return
    end

    love.graphics.setColor(
        0,
        0,
        0,
        self:getFadeAlpha()
    )

    love.graphics.rectangle(
        "fill",
        0,
        0,
        Config.virtualWidth,
        Config.virtualHeight
    )

    love.graphics.setColor(1, 1, 1)
end

return LevelTransition