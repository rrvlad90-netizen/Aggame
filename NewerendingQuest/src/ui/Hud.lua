local Config = require("src.config")

local Hud = {}
Hud.__index = Hud

local function clamp(value)
    return math.max(0, math.min(1, value))
end

function Hud.new()
    local self = setmetatable({}, Hud)

    self.fonts = {
        small = love.graphics.newFont(14),
        normal = love.graphics.newFont(18),
        level = love.graphics.newFont(20)
    }

    return self
end

function Hud:drawPanel(x, y, width, height)
    love.graphics.setColor(
        0.025,
        0.035,
        0.045,
        0.88
    )

    love.graphics.rectangle(
        "fill",
        x,
        y,
        width,
        height,
        8,
        8
    )

    love.graphics.setColor(
        0.33,
        0.38,
        0.38,
        0.9
    )

    love.graphics.rectangle(
        "line",
        x,
        y,
        width,
        height,
        8,
        8
    )
end

function Hud:drawBar(
    x,
    y,
    width,
    height,
    value,
    maximum,
    color
)
    local ratio = 0

    if maximum and maximum > 0 then
        ratio =
            clamp(value / maximum)
    end

    love.graphics.setColor(
        0.08,
        0.09,
        0.10,
        1
    )

    love.graphics.rectangle(
        "fill",
        x,
        y,
        width,
        height,
        4,
        4
    )

    if ratio > 0 then
        love.graphics.setColor(
            color[1],
            color[2],
            color[3],
            color[4] or 1
        )

        love.graphics.rectangle(
            "fill",
            x,
            y,
            width * ratio,
            height,
            4,
            4
        )
    end

    love.graphics.setColor(
        0.42,
        0.45,
        0.44,
        0.9
    )

    love.graphics.rectangle(
        "line",
        x,
        y,
        width,
        height,
        4,
        4
    )
end

function Hud:drawPlayerStatus(player)
    local x = 16
    local y = 16
    local width = 330

    local height =
        player.hasShield and
        154 or
        112

    self:drawPanel(
        x,
        y,
        width,
        height
    )

    love.graphics.setFont(self.fonts.small)
    love.graphics.setColor(
        0.9,
        0.9,
        0.86,
        1
    )

    love.graphics.print(
        "HEALTH",
        x + 16,
        y + 10
    )

    local healthText =
        tostring(player.health) ..
        " / " ..
        tostring(player.maxHealth)

    love.graphics.printf(
        healthText,
        x + 16,
        y + 10,
        width - 32,
        "right"
    )

    self:drawBar(
        x + 16,
        y + 32,
        width - 32,
        14,
        player.health,
        player.maxHealth,
        {
            0.72,
            0.16,
            0.14,
            1
        }
    )

    love.graphics.setFont(self.fonts.normal)
    love.graphics.setColor(
        0.9,
        0.84,
        0.62,
        1
    )

    love.graphics.print(
        "LIVES: " ..
        tostring(player.continues),
        x + 16,
        y + 58
    )

    love.graphics.printf(
        "ARROWS: " ..
        tostring(player.arrows) ..
        " / " ..
        tostring(player.maximumArrows),
        x + 16,
        y + 58,
        width - 32,
        "right"
    )

    self:drawBar(
        x + 16,
        y + 86,
        width - 32,
        9,
        player.arrows,
        player.maximumArrows,
        {
            0.82,
            0.66,
            0.28,
            1
        }
    )

    if player.hasShield then
        love.graphics.setFont(self.fonts.small)
        love.graphics.setColor(
            0.72,
            0.82,
            0.9,
            1
        )

        love.graphics.print(
            "SHIELD",
            x + 16,
            y + 108
        )

        love.graphics.printf(
            tostring(player.shieldDurability) ..
            " / " ..
            tostring(
                player.maximumShieldDurability
            ),
            x + 16,
            y + 108,
            width - 32,
            "right"
        )

        self:drawBar(
            x + 16,
            y + 132,
            width - 32,
            10,
            player.shieldDurability,
            player.maximumShieldDurability,
            {
                0.25,
                0.58,
                0.86,
                1
            }
        )
    end
end

function Hud:drawLevelStatus(world)
    local width = 350
    local height = 72

    local x =
        Config.virtualWidth -
        width -
        16

    local y = 16

    self:drawPanel(
        x,
        y,
        width,
        height
    )

    love.graphics.setFont(self.fonts.small)
    love.graphics.setColor(
        0.68,
        0.72,
        0.72,
        1
    )

    love.graphics.printf(
        "LEVEL " ..
        tostring(world:getLevelNumber()),
        x + 16,
        y + 10,
        width - 32,
        "right"
    )

    love.graphics.setFont(self.fonts.level)
    love.graphics.setColor(
        0.9,
        0.84,
        0.62,
        1
    )

    love.graphics.printf(
        world:getLevelName(),
        x + 16,
        y + 36,
        width - 32,
        "right"
    )
end

function Hud:draw(player, world)
    self:drawPlayerStatus(player)
    self:drawLevelStatus(world)

    love.graphics.setColor(1, 1, 1, 1)
end

return Hud