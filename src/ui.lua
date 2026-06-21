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

-- Рисует оставшиеся uses weapon-формы.
function UI.drawWeaponUses(player)
    if not player then
        return
    end

    if not player.weaponPlayerId then
        return
    end

    love.graphics.setFont(UI.font)
    love.graphics.setColor(1, 1, 1)

    love.graphics.print(
        "Weapon: " .. tostring(player.weaponUses or 0),
        20,
        74
    )
end

-- Рисует короткое сообщение игроку. (например о том что wepon не найден - нет файла с оружием)
function UI.drawPlayerMessage(player)
    if not player then
        return
    end

    if not player.messageText then
        return
    end

    if not player.messageTimer or player.messageTimer <= 0 then
        return
    end

    love.graphics.setFont(UI.font)
    love.graphics.setColor(1, 0.9, 0.35)

    love.graphics.printf(
        player.messageText,
        0,
        112,
        Config.screen.width,
        "center"
    )

    love.graphics.setColor(1, 1, 1)
end

-- Рисует ammo.
function UI.drawAmmo(player)
    if not player or not player.ammo then
        return
    end

	local y = 74

	if player.weaponPlayerId then
		y = 98
	end

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
    UI.drawWeaponUses(player)
    UI.drawAmmo(player)
    UI.drawPlayerMessage(player) -- Рисует короткое сообщение игроку. (например о том что wepon не найден - нет файла с оружием)
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


-- Рисует меню настроек управления.
function UI.drawOptionsMenu(items, selectedIndex, remapAction)
    love.graphics.clear(0.04, 0.04, 0.06)

    love.graphics.setFont(UI.bigFont)
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(
        "OPTIONS",
        0,
        50,
        Config.screen.width,
        "center"
    )

    love.graphics.setFont(UI.font)

    if remapAction then
        love.graphics.setColor(1, 0.9, 0.35)
        love.graphics.printf(
            "Press new key for: " .. string.upper(remapAction),
            0,
            105,
            Config.screen.width,
            "center"
        )

        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.printf(
            "ESC - cancel",
            0,
            130,
            Config.screen.width,
            "center"
        )
    else
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.printf(
            "Click -/+ for audio and touchpad, Enter - change key, Esc - back",
            0,
            105,
            Config.screen.width,
            "center"
        )
    end

    local startY = 160
    local rowH = 34
    local buttonH = 28

    local leftX = 40
    local rightX = 410
    local groupW = 350

    local smallButtonW = 34
    local valueW = 46

    local labelOffsetX = 12
    local minusOffsetX = 190
    local valueOffsetX = 232
    local plusOffsetX = 282

    local buttonW = 460
    local buttonX = Config.screen.width / 2 - buttonW / 2

    local function drawOptionGroup(groupX, y, label, value, alpha)
        love.graphics.setColor(0.08, 0.08, 0.1, 0.85 * alpha)
        love.graphics.rectangle("fill", groupX, y, groupW, buttonH, 6, 6)

        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.rectangle("line", groupX, y, groupW, buttonH, 6, 6)

        love.graphics.print(label, groupX + labelOffsetX, y + 6)

        UI.drawButton(
            {
                x = groupX + minusOffsetX,
                y = y + 3,
                w = smallButtonW,
                h = buttonH - 6
            },
            "-",
            alpha
        )

        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.printf(
            tostring(value),
            groupX + valueOffsetX,
            y + 6,
            valueW,
            "center"
        )

        UI.drawButton(
            {
                x = groupX + plusOffsetX,
                y = y + 3,
                w = smallButtonW,
                h = buttonH - 6
            },
            "+",
            alpha
        )
    end

    for index, item in ipairs(items or {}) do
        local y = startY + (index - 1) * rowH
        local alpha = 1

        if selectedIndex and selectedIndex ~= index then
            alpha = 0.65
        end

        if item.volume or item.touch then
            local volumeLabel = item.label or "Volume"
            local volumeValue = 0

            if item.volume == "sound" then
                volumeValue = math.floor(Config.audio.soundVolume * 100 + 0.5)
            elseif item.volume == "music" then
                volumeValue = math.floor(Config.audio.musicVolume * 100 + 0.5)
            end

            drawOptionGroup(
                leftX,
                y,
                volumeLabel,
                volumeValue,
                alpha
            )

            local touchLabel = item.touchLabel or "Touch"
            local touchValue = 0

            if item.touch == "size" then
                touchValue = math.floor(Config.input.touchButtonScale * 100 + 0.5)
            elseif item.touch == "alpha" then
                touchValue = math.floor(Config.input.touchButtonAlpha * 100 + 0.5)
            end

            drawOptionGroup(
                rightX,
                y,
                touchLabel,
                touchValue,
                alpha
            )
        else
            love.graphics.setColor(0.08, 0.08, 0.1, 0.85 * alpha)
            love.graphics.rectangle("fill", buttonX, y, buttonW, buttonH, 6, 6)

            love.graphics.setColor(1, 1, 1, alpha)
            love.graphics.rectangle("line", buttonX, y, buttonW, buttonH, 6, 6)

            local text = item.label or item.action or ""

            if item.action then
                text = text .. ": " .. string.upper(Input.getPrimaryKey(item.action))
            end

            love.graphics.printf(
                text,
                buttonX + 12,
                y + 6,
                buttonW - 24,
                "left"
            )
        end
    end

    love.graphics.setColor(1, 1, 1)
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