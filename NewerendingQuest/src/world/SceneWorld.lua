local Config = require("src.config")

local SceneWorld = {}
SceneWorld.__index = SceneWorld

local function clamp(
    value,
    minimum,
    maximum
)
    return math.max(
        minimum,
        math.min(maximum, value)
    )
end

function SceneWorld.new(
    projection,
    assets,
    level
)
    local self =
        setmetatable({}, SceneWorld)

    self.projection = projection
    self.assets = assets
    self.level = level

    self.definition =
        level.scene or {}

    self.minX = 0
    self.maxX = 0
    self.minZ = 0
    self.maxZ = 0

    self.slides = {}

    for _, definition in ipairs(
        self.definition.slides or {}
    ) do
        self.slides[
            #self.slides + 1
        ] = {
            image =
                definition.image and
                assets:getFileImage(
                    definition.image
                ) or
                nil,

            text =
                definition.text or "",

            duration =
                definition.duration or
                4,

            fit =
                definition.fit or
                "contain",

            color =
                definition.color or {
                    0.12,
                    0.12,
                    0.15,
                    1
                }
        }
    end

    self.slideIndex = 1
    self.slideTime = 0

    self.fadeDuration =
        self.definition.fadeDuration or
        0.6

    self.finished = false
    self.destinationTaken = false

    self.music = nil

    self:startMusic()

    return self
end

function SceneWorld:startMusic()
    local path =
        self.definition.music

    if
        not path or
        not love.filesystem.getInfo(path)
    then
        return
    end

    self.music =
        love.audio.newSource(
            path,
            "stream"
        )

    self.music:setLooping(
        self.definition.loopMusic ~= false
    )

    self.music:setVolume(
        self.definition.musicVolume or
        0.7
    )

    self.music:play()
end

function SceneWorld:stopMusic()
    if self.music then
        self.music:stop()
        self.music = nil
    end
end

function SceneWorld:leave()
    self:stopMusic()
end

function SceneWorld:finish()
    if self.finished then
        return
    end

    self.finished = true
    self:stopMusic()
end

-- Полностью блокирует управление игроком.
function SceneWorld:blocksPlayerInput()
    return true
end

function SceneWorld:isScene()
    return true
end

function SceneWorld:getCameraBounds()
    return {
        minX = 0,
        maxX = 0
    }
end

function SceneWorld:getSpawnPosition()
    return 0, 0
end

function SceneWorld:setCameraPosition(
    x,
    z
)
end

function SceneWorld:allowsWalking()
    return false
end

function SceneWorld:usesForwardOnlyJumps()
    return false
end

function SceneWorld:isSafePosition(
    x,
    z,
    collisionRadius
)
    return true
end

function SceneWorld:prepareRespawn(
    x,
    z,
    collisionRadius
)
end

-- Во время сцены обрабатывается только Escape.
function SceneWorld:keypressed(key)
    if
        key == "escape" and
        self.definition.skippable ~= false
    then
        self:finish()
    end

    -- Любая клавиша поглощается, чтобы
    -- не открывалась пауза и не работал игрок.
    return true
end

function SceneWorld:update(
    dt,
    player,
    enemies
)
    if self.finished then
        return
    end

    local slide =
        self.slides[
            self.slideIndex
        ]

    if not slide then
        self:finish()
        return
    end

    self.slideTime =
        self.slideTime + dt

    if
        self.slideTime <
        slide.duration
    then
        return
    end

    self.slideIndex =
        self.slideIndex + 1

    self.slideTime = 0

    if
        self.slideIndex >
        #self.slides
    then
        self:finish()
    end
end

function SceneWorld:isLevelComplete()
    return self.finished
end

function SceneWorld:getExitDestination()
    if not self.finished then
        return nil
    end

    return
        self.definition.destination or {
            type = "next"
        }
end

-- Использует тот же механизм перехода,
-- что и портал обычного уровня.
function SceneWorld:takePortalDestination()
    if
        not self.finished or
        self.destinationTaken
    then
        return nil
    end

    self.destinationTaken = true

    return
        self.definition.destination or {
            type = "next"
        }
end

function SceneWorld:getSlideAlpha(slide)
    local fadeDuration =
        math.max(
            0.001,
            self.fadeDuration
        )

    local fadeIn =
        clamp(
            self.slideTime /
            fadeDuration,
            0,
            1
        )

    local fadeOut =
        clamp(
            (
                slide.duration -
                self.slideTime
            ) /
            fadeDuration,
            0,
            1
        )

    return math.min(
        fadeIn,
        fadeOut
    )
end

function SceneWorld:drawSlideImage(
    image,
    fit,
    alpha
)
    local imageAreaHeight =
        Config.virtualHeight - 130

    local scaleX =
        Config.virtualWidth /
        image:getWidth()

    local scaleY =
        imageAreaHeight /
        image:getHeight()

    local scale

    if fit == "cover" then
        scale =
            math.max(
                scaleX,
                scaleY
            )
    else
        scale =
            math.min(
                scaleX,
                scaleY
            )
    end

    local width =
        image:getWidth() *
        scale

    local height =
        image:getHeight() *
        scale

    love.graphics.setColor(
        1,
        1,
        1,
        alpha
    )

    love.graphics.draw(
        image,

        (
            Config.virtualWidth -
            width
        ) / 2,

        (
            imageAreaHeight -
            height
        ) / 2,

        0,
        scale,
        scale
    )
end

-- Временный фон вместо отсутствующей картинки.
function SceneWorld:drawSlideMockup(
    slide,
    alpha
)
    local color =
        slide.color

    love.graphics.setColor(
        color[1] or 0.12,
        color[2] or 0.12,
        color[3] or 0.15,
        alpha * (color[4] or 1)
    )

    love.graphics.rectangle(
        "fill",
        70,
        45,
        Config.virtualWidth - 140,
        Config.virtualHeight - 205
    )

    love.graphics.setColor(
        1,
        1,
        1,
        alpha * 0.15
    )

    love.graphics.rectangle(
        "line",
        70,
        45,
        Config.virtualWidth - 140,
        Config.virtualHeight - 205
    )
end

function SceneWorld:drawSlideText(
    text,
    alpha
)
    love.graphics.setColor(
        0,
        0,
        0,
        0.78 * alpha
    )

    love.graphics.rectangle(
        "fill",
        0,
        Config.virtualHeight - 130,
        Config.virtualWidth,
        130
    )

    love.graphics.setColor(
        1,
        1,
        1,
        alpha
    )

    love.graphics.printf(
        text,
        70,
        Config.virtualHeight - 95,
        Config.virtualWidth - 140,
        "center"
    )
end

function SceneWorld:draw(
    player,
    projectiles,
    enemies,
    pickups
)
    love.graphics.clear(
        0.025,
        0.025,
        0.035,
        1
    )

    local slide =
        self.slides[
            self.slideIndex
        ]

    if not slide then
        return
    end

    local alpha =
        self:getSlideAlpha(slide)

    if slide.image then
        self:drawSlideImage(
            slide.image,
            slide.fit,
            alpha
        )
    else
        self:drawSlideMockup(
            slide,
            alpha
        )
    end

    self:drawSlideText(
        slide.text,
        alpha
    )

    love.graphics.setColor(1, 1, 1, 1)
end

return SceneWorld