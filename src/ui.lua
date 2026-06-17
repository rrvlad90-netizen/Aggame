local Config = require("src.config")
local Input = require("src.input")

local UI = {}

UI.font = nil
UI.bigFont = nil

-- Создаёт UI font.
-- Если Config.ui.fontPath задан и файл существует, используем TTF. --для кириллицы
-- Иначе fallback на стандартный Love2D font. --для латинницы
local function createFont(size)
    local fontPath = Config.ui.fontPath

    if fontPath and love.filesystem.getInfo(fontPath) then
        return love.graphics.newFont(fontPath, size)
    end

    return love.graphics.newFont(size)
end

-- Инициализирует шрифты UI.
function UI.init()
    UI.font = createFont(Config.ui.fontSize)
    UI.bigFont = createFont(Config.ui.bigFontSize)

    love.graphics.setFont(UI.font)
end


-- Рисует простой прямоугольник-кнопку с текстом.
function UI.drawButton(button, text, alpha)
    alpha = alpha or 1

    love.graphics.setColor(0.08, 0.08, 0.1, 0.85 * alpha)
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h, 8, 8)

    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.rectangle("line", button.x, button.y, button.w, button.h, 8, 8)

    love.graphics.setFont(UI.font)
    love.graphics.printf(
        text or "",
        button.x,
        button.y + button.h / 2 - Config.ui.fontSize / 2,
        button.w,
        "center"
    )

    love.graphics.setColor(1, 1, 1)
end

-- Рисует loading screen.
function UI.drawLoading(progress)
    progress = progress or 0

    love.graphics.clear(0.04, 0.04, 0.06)

    love.graphics.setFont(UI.bigFont)
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(
        Config.loading.text,
        0,
        Config.screen.height / 2 - 50,
        Config.screen.width,
        "center"
    )

    love.graphics.setFont(UI.font)

    love.graphics.printf(
        tostring(math.floor(progress * 100)) .. "%",
        0,
        Config.screen.height / 2,
        Config.screen.width,
        "center"
    )

    local barW = 300
    local barH = 18
    local barX = Config.screen.width / 2 - barW / 2
    local barY = Config.screen.height / 2 + 35

    love.graphics.setColor(0.15, 0.15, 0.18)
    love.graphics.rectangle("fill", barX, barY, barW, barH)

    love.graphics.setColor(0.25, 0.75, 1.0)
    love.graphics.rectangle("fill", barX, barY, barW * progress, barH)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", barX, barY, barW, barH)
end

-- Рисует HP игрока.
function UI.drawPlayerHealth(player)
    if not player then
        return
    end

    local x = 20
    local y = 20
    local w = Config.ui.healthBarWidth
    local h = Config.ui.healthBarHeight

    local ratio = 0

    if player.maxHealth > 0 then
        ratio = player.health / player.maxHealth
    end

    love.graphics.setFont(UI.font)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("HP", x, y - 2)

    love.graphics.setColor(0.08, 0.08, 0.08)
    love.graphics.rectangle("fill", x + 34, y, w, h)

    love.graphics.setColor(0.2, 0.9, 0.25)
    love.graphics.rectangle("fill", x + 34, y, w * ratio, h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x + 34, y, w, h)

    love.graphics.printf(
        tostring(player.health) .. " / " .. tostring(player.maxHealth),
        x + 34,
        y + 2,
        w,
        "center"
    )
end

-- Рисует lives игрока.
function UI.drawPlayerLives(player)
    if not player then
        return
    end

    love.graphics.setFont(UI.font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Lives: " .. tostring(player.lives), 20, 48)
end

-- Рисует ammo.
function UI.drawAmmo(player)
    if not player or not player.ammo then
        return
    end

    local y = 74

    love.graphics.setFont(UI.font)
    love.graphics.setColor(1, 1, 1)

    for ammoType, amount in pairs(player.ammo) do
        love.graphics.print(
            tostring(ammoType) .. ": " .. tostring(amount),
            20,
            y
        )

        y = y + 18
    end
end

-- Рисует HUD игрока.
function UI.drawHud(player)
    UI.drawPlayerHealth(player)
    UI.drawPlayerLives(player)
    UI.drawAmmo(player)
end

-- Рисует HP bar actor-а над его физическим bbox.
function UI.drawActorHealthBar(actor, camera)
    if not actor or not actor.showHealthBar then
        return
    end

    if actor.dead then
        return
    end

    if not actor.getHitbox then
        return
    end

    local bbox = actor:getHitbox()

    local ratio = 0

    if actor.maxHealth > 0 then
        ratio = actor.health / actor.maxHealth
    end

    ratio = math.max(0, math.min(1, ratio))

    local w = Config.ui.actorHealthBarWidth
    local h = Config.ui.actorHealthBarHeight

    local x = bbox.x + bbox.w / 2 - (camera and camera.x or 0) - w / 2
    local y = bbox.y - (camera and camera.y or 0) - 8

    love.graphics.setColor(0.05, 0.05, 0.05, 0.9)
    love.graphics.rectangle("fill", x, y, w, h)

    love.graphics.setColor(0.2, 0.9, 0.25, 0.95)
    love.graphics.rectangle("fill", x, y, w * ratio, h)

    love.graphics.setColor(1, 1, 1)
end

-- Рисует touch-кнопки.
function UI.drawTouchButtons()
    if not Input.areTouchButtonsVisible() then
        return
    end

    local alpha = Config.input.touchButtonAlpha

    for _, button in ipairs(Input.touchButtons) do
        UI.drawButton(button, string.upper(button.action), alpha)
    end
end

-- Рисует простое меню.
function UI.drawMenu(title, items, selectedIndex)
    love.graphics.clear(0.04, 0.04, 0.06)

    love.graphics.setFont(UI.bigFont)
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(
        title,
        0,
        120,
        Config.screen.width,
        "center"
    )

    love.graphics.setFont(UI.font)

    local startY = 230
    local buttonW = 260
    local buttonH = 44
    local buttonX = Config.screen.width / 2 - buttonW / 2

    for index, item in ipairs(items or {}) do
        local button = {
            x = buttonX,
            y = startY + (index - 1) * 58,
            w = buttonW,
            h = buttonH
        }

        local alpha = 1

        if selectedIndex and selectedIndex ~= index then
            alpha = 0.65
        end

        UI.drawButton(button, item.label or item.text or tostring(item), alpha)
    end
end

-- Рисует debug-информацию.
function UI.drawDebug(world)
    if not Config.debug.enabled then
        return
    end

    love.graphics.setFont(UI.font)
    love.graphics.setColor(1, 1, 1)

    local y = 8

    if Config.debug.drawFps then
        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), Config.screen.width - 90, y)
        y = y + 18
    end
	
	if world then
        love.graphics.print(
            "Actors: " .. tostring(#(world.actors or {})),
            Config.screen.width - 180,
            y
        )
        y = y + 18

        love.graphics.print(
            "Projectiles: " .. tostring(#(world.projectiles or {})),
            Config.screen.width - 180,
            y
        )
        y = y + 18

        love.graphics.print(
            "Effects: " .. tostring(#(world.effects or {})),
            Config.screen.width - 180,
            y
        )
        y = y + 18
    end

    if Config.debug.drawPlayerPosition and world and world.player then
        love.graphics.print(
            "Player: "
            .. math.floor(world.player.x)
            .. ", "
            .. math.floor(world.player.y),
            Config.screen.width - 180,
            y
        )
    end
end

return UI