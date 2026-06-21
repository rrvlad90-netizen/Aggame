local Config = require("src.config")
local Assets = require("src.assets")
local Registry = require("src.registry")
local UI = require("src.ui")
local Input = require("src.input")
local Save = require("src.save")
local Debug = require("src.debug")
local Level = require("src.level")
local World = require("src.world")
local Player = require("src.player")
local Scene = require("src.scene")
local Viewport = require("src.viewport")
local PlayerSelect = require("src.player_select")

local game = {
    mode = "main_menu",

    flow = {},
    flowIndex = 1,

    selectedMenuIndex = 1,
    selectedPauseIndex = 1,
    selectedGameOverIndex = 1,

	currentSceneId = nil,
	lastSceneBeforeLevel = nil,

    scene = nil,
    sceneReturnMode = nil,
	currentLevelId = nil, --запоминаем текущий уровень

    playerSelect = nil,

    level = nil,
    world = nil,
    player = nil,
	
	playerLives = nil,
	playerMaxLives = nil,
	
    levelEntryLevelId = nil,
    levelEntryLives = nil,
    restoreLevelEntryOnNextLevel = false,	

    loadingProgress = 0,
    pendingStart = nil,

	fullscreenToggleCooldown = 0,--Защита от частого нажатия Alt+Enter
	optionsVolumeCooldown = 0,--Защита от частого изменения звука
}

local optionsMenuItems = {
    {
        label = "Sound Volume",
        volume = "sound",
        touchLabel = "Touch Size",
        touch = "size"
    },
    {
        label = "Music Volume",
        volume = "music",
        touchLabel = "Touch Alpha",
        touch = "alpha"
    },

    {label = "Left", action = "left"},
    {label = "Right", action = "right"},
    {label = "Up", action = "up"},
    {label = "Down", action = "down"},
    {label = "Jump", action = "jump"},
    {label = "Shoot", action = "shoot"},
    {label = "Melee", action = "melee"},
    {label = "Crouch", action = "crouch"},
    {label = "Block", action = "block"},
    {label = "Strafe", action = "strafe"},
    {label = "Pause", action = "pause"},
    {label = "Confirm", action = "confirm"},
    {label = "Reset Controls", special = "reset_controls"},
    {label = "Back", special = "back"}
}

local mainMenuItems = {
    {label = "New Game", action = "new_game"},
    {label = "Continue", action = "continue"},
    {label = "Options", action = "options"},
    {label = "Exit", action = "exit"}
}

local pauseMenuItems = {
    {label = "Continue", action = "continue"},
    {label = "Restart Level", action = "restart"},
    {label = "Exit to Menu", action = "exit_to_menu"}
}

local gameOverMenuItems = {
    {label = "Restart Level", action = "restart"},
    {label = "Exit to Menu", action = "exit_to_menu"}
}


-- Возвращает индекс пункта меню под координатами мыши.
local function getMenuItemAt(items, x, y)
    local startY = 230
    local buttonW = 260
    local buttonH = 44
    local buttonX = Config.screen.width / 2 - buttonW / 2

    for index, _ in ipairs(items or {}) do
        local buttonY = startY + (index - 1) * 58

        if x >= buttonX
            and x <= buttonX + buttonW
            and y >= buttonY
            and y <= buttonY + buttonH
        then
            return index
        end
    end

    return nil
end

-- Загружает flow игры из data/flow.lua.
local function loadFlow()
    local chunk = love.filesystem.load("data/flow.lua")

    if not chunk then
        return {}
    end

    return chunk() or {}
end

-- Возвращает текущий элемент flow.
local function getCurrentFlowItem()
    return game.flow[game.flowIndex]
end

-- Сохраняет текущий progress flow.
local function saveCurrentProgress()
    Save.setFlowIndex(game.flowIndex)
end

-- Полностью останавливает текущий world.
local function stopWorld()
    if game.world then
        game.world:stop()
    end

    game.world = nil
    game.level = nil
end

-- Полностью останавливает текущую scene.
local function stopScene()
    if game.scene then
        game.scene:stop()
    end

    game.scene = nil
end

-- Полностью останавливает player select.
local function stopPlayerSelect()
    if game.playerSelect then
        game.playerSelect:stop()
    end

    game.playerSelect = nil
end

-- Создаёт игрока по выбранному player id.
--Теперь в уровне можно задать явный тип игрока который будетиспльзоваться без (player screen)
local function createSelectedPlayer(x, y)
    local playerId = nil

    if game.level and game.level.playerId then
        playerId = game.level.playerId
    else
        playerId = Save.getSelectedPlayerId() or "warrior"
    end

    local definition = Registry.loadPlayer(playerId)

    definition.x = x
    definition.y = y

    local defaultLives = definition.lives or 3

    if game.playerMaxLives == nil then
        game.playerMaxLives = defaultLives
    end

    if game.playerLives == nil then
        game.playerLives = defaultLives
    end

    definition.lives = game.playerLives

    return Player:new(definition)
end

-- Запускает scene по id.
local function startScene(sceneId, returnMode)
    if sceneId == "$lastSceneBeforeLevel" then
        sceneId = game.lastSceneBeforeLevel or "game_over"
    end

    stopWorld()
    stopPlayerSelect()
    stopScene()

    local definition = Registry.loadScene(sceneId)

    game.scene = Scene:new(definition)
    game.sceneReturnMode = returnMode
    game.currentSceneId = sceneId
    game.scene:start()

    game.mode = "scene"
end

-- Запускает player select.
local function startPlayerSelect(flowItem)
    stopWorld()
    stopScene()
    stopPlayerSelect()

    game.playerSelect = PlayerSelect:new(flowItem)
    game.playerSelect:start()

    game.mode = "player_select"
end


-- Синхронизирует глобальные lives с текущим player-ом.
local function syncPlayerLivesFromPlayer()
    if game.player then
        game.playerLives = game.player.lives
    end
end

-- Запоминает lives, с которыми игрок вошёл на уровень.
local function rememberLevelEntryState(levelId)
    game.levelEntryLevelId = levelId
    game.levelEntryLives = game.playerLives
end

-- Восстанавливает lives на состояние входа в этот уровень.
local function restoreLevelEntryState(levelId)
    if game.levelEntryLevelId ~= levelId then
        return
    end

    if game.levelEntryLives == nil then
        return
    end

    game.playerLives = game.levelEntryLives
end

-- Запускает уровень по id.
local function startLevel(levelId)
    if game.currentSceneId then
        game.lastSceneBeforeLevel = game.currentSceneId
        Save.setContinueSceneId(game.currentSceneId)
    end

    stopWorld()
    stopScene()
    stopPlayerSelect()

    local levelDefinition = Registry.loadLevel(levelId)

    game.currentLevelId = levelId
    game.level = Level:new(levelDefinition)

    game.player = createSelectedPlayer(
        game.level.playerStart.x,
        game.level.playerStart.y
    )

    game.world = World:new(game.level, game.player)

    saveCurrentProgress()

    game.mode = "level"
end

-- Переходит к следующему элементу flow.
local function advanceFlow()
    game.flowIndex = game.flowIndex + 1

    if game.flowIndex > #game.flow then
        game.mode = "main_menu"
        return
    end

    local item = getCurrentFlowItem()

    if not item then
        game.mode = "main_menu"
        return
    end

    if item.type == "scene" then
        startScene(item.id, "flow")
        return
    end

    if item.type == "player_select" then
        startPlayerSelect(item)
        return
    end

    if item.type == "level" then
        startLevel(item.id)
        return
    end
end

-- Запускает явный переход на scene или level.
-- Используется для nextTarget из levelEnd, scene и player_select.
local function startTransitionTarget(target)
    if not target then
        advanceFlow()
        return
    end

    local targetType = target.type or target.kind

    if targetType == "scene" then
        startScene(target.id, "transition")
        return
    end

    if targetType == "level" then
        startLevel(target.id)
        return
    end

    if targetType == "flow" then
        advanceFlow()
        return
    end
	
	if target.type == "mode" then
		stopWorld()
		stopPlayerSelect()
		stopScene()

		game.mode = target.id or "main_menu"
    return
	end
end

-- Запускает явный переход на scene или level.
-- Используется для nextTarget из levelEnd и scene.
local function startTransitionTarget(target)
    if not target then
        advanceFlow()
        return
    end

    local targetType = target.type or target.kind

    if targetType == "scene" then
        startScene(target.id, "transition")
        return
    end

    if targetType == "level" then
        startLevel(target.id)
        return
    end

    if targetType == "flow" then
        advanceFlow()
        return
    end

    game.mode = "main_menu"
end

-- Запускает flow с указанного индекса.
local function startFlow(index)
    game.flowIndex = index or 1

    local item = getCurrentFlowItem()

    if not item then
        game.mode = "main_menu"
        return
    end

    if item.type == "scene" then
        startScene(item.id, "flow")
        return
    end

    if item.type == "player_select" then
        startPlayerSelect(item)
        return
    end

    if item.type == "level" then
        startLevel(item.id)
        return
    end
end

-- Начинает новую игру.
local function startNewGame()
    Save.startNewGame()

    game.playerLives = nil
    game.playerMaxLives = nil

    game.levelEntryLevelId = nil
    game.levelEntryLives = nil
    game.restoreLevelEntryOnNextLevel = false

    startFlow(1)
end

-- Продолжает игру из save.
local function continueGame()
    local continueSceneId = Save.getContinueSceneId()

    if continueSceneId then
        startScene(continueSceneId, "flow")
        return
    end

    startFlow(Save.getFlowIndex())
end

-- Перезапускает текущий уровень.
local function restartCurrentLevel()
    local levelId = game.currentLevelId

    if not levelId then
        local item = getCurrentFlowItem()

        if item and item.type == "level" then
            levelId = item.id
        end
    end

    if levelId then
        startLevel(levelId, {
            restoreEntryState = true,
            keepEntryState = true
        })
    else
        game.mode = "main_menu"
    end
end

-- Запускает defeat/game over scene текущего уровня.
local function getLevelDefeatScene()
    if game.level and game.level.defeatScene then
        return game.level.defeatScene
    end

    return "game_over"
end

local function startGameOver()
    startScene("game_over", "main_menu")
end

local function startDefeatScene(returnMode)
    startScene(getLevelDefeatScene(), returnMode)
end

local getOptionsLayout

---Настройки тачпада
local function applyTouchSettings(buttonScale, buttonAlpha)
    Config.input.touchButtonScale = math.max(0.5, math.min(2.0, buttonScale or 1.0))
    Config.input.touchButtonAlpha = math.max(0.1, math.min(1.0, buttonAlpha or 0.65))

    Input.touchButtons = Input.createDefaultTouchButtons()
end

local function applySavedTouchSettings()
    local buttonScale, buttonAlpha = Save.getTouchSettings()

    applyTouchSettings(buttonScale, buttonAlpha)
end

local function saveTouchSettings()
    Save.setTouchSettings(
        Config.input.touchButtonScale,
        Config.input.touchButtonAlpha
    )
end

local function getTouchSettingPercent(item)
    if not item or not item.touch then
        return 0
    end

    if item.touch == "size" then
        return math.floor((Config.input.touchButtonScale or 1.0) * 100 + 0.5)
    end

    if item.touch == "alpha" then
        return math.floor((Config.input.touchButtonAlpha or 0.65) * 100 + 0.5)
    end

    return 0
end

local function setTouchSettingPercent(item, percent)
    if not item or not item.touch then
        return
    end

    if item.touch == "size" then
        percent = math.max(50, math.min(200, percent or 100))

        Config.input.touchButtonScale = percent / 100
        applyTouchSettings(
            Config.input.touchButtonScale,
            Config.input.touchButtonAlpha
        )
    elseif item.touch == "alpha" then
        percent = math.max(10, math.min(100, percent or 65))

        Config.input.touchButtonAlpha = percent / 100
        applyTouchSettings(
            Config.input.touchButtonScale,
            Config.input.touchButtonAlpha
        )
    end

    saveTouchSettings()
    Input.showTouchButtons()
end

local function changeTouchSettingByPoint(item, points)
    if not item or not item.touch then
        return
    end

    local currentPercent = getTouchSettingPercent(item)

    setTouchSettingPercent(
        item,
        currentPercent + (points or 0)
    )
end


-------------функция поиска touch-кнопки в options
local function getOptionsTouchButtonAt(x, y)
    local layout = getOptionsLayout()

    for index, item in ipairs(optionsMenuItems or {}) do
        if item.touch then
            local rowY = layout.startY + (index - 1) * layout.rowH
            local buttonY = rowY + 3
            local buttonH = layout.buttonH - 6

            local minusX = layout.rightX + layout.minusOffsetX
            local plusX = layout.rightX + layout.plusOffsetX

            local insideY = y >= buttonY and y <= buttonY + buttonH

            if insideY
                and x >= minusX
                and x <= minusX + layout.smallButtonW
            then
                return item, index, -1
            end

            if insideY
                and x >= plusX
                and x <= plusX + layout.smallButtonW
            then
                return item, index, 1
            end
        end
    end

    return nil, nil, nil
end

---настройки звука и музыки
local function clampVolume(volume)
    return math.max(0, math.min(1, volume or 0))
end

local function volumeToPercent(volume)
    return math.floor(clampVolume(volume) * 100 + 0.5)
end

local function saveAudioSettings()
    Save.setAudioSettings(
        Config.audio.musicVolume,
        Config.audio.soundVolume
    )
end

local function applySavedAudioSettings()
    local musicVolume, soundVolume = Save.getAudioSettings()

    Assets.setAudioVolumes(musicVolume, soundVolume)
end

local function changeOptionVolume(item, delta)
    if not item or not item.volume then
        return
    end

    if item.volume == "sound" then
        Assets.setSoundVolume(Config.audio.soundVolume + delta)
    elseif item.volume == "music" then
        Assets.setMusicVolume(Config.audio.musicVolume + delta)
    end

    saveAudioSettings()
end

local function canChangeOptionsVolume()
    if game.optionsVolumeCooldown > 0 then
        return false
    end

    game.optionsVolumeCooldown = Config.audio.volumeChangeCooldown or 0.12

    return true
end
-----



-- Обрабатывает подтверждение пункта главного меню.
local function confirmMainMenu()
    local item = mainMenuItems[game.selectedMenuIndex]

    if not item then
        return
    end

    if item.action == "new_game" then
        startNewGame()
        return
    end

    if item.action == "continue" then
        continueGame()
        return
    end

	if item.action == "options" then
        game.mode = "options_menu"
        game.selectedOptionsIndex = 1
        game.remapAction = nil
        return
    end

    if item.action == "exit" then
        love.event.quit()
        return
    end
end


-- Обрабатывает подтверждение options menu.
local function confirmOptionsMenu()
    game.selectedOptionsIndex = game.selectedOptionsIndex or 1

    local item = optionsMenuItems[game.selectedOptionsIndex]

    if not item then
        return
    end

    -- Громкость теперь меняется только мышкой по -/+.
    -- Enter / Confirm на строке громкости ничего не делает.
    if item.volume then
        return
    end

    if item.special == "reset_controls" then
        Input.resetKeyBindings()
        Save.setKeyboardBindings(Input.getKeyBindings())
        return
    end

    if item.special == "back" then
        game.mode = "main_menu"
        game.remapAction = nil
        return
    end

    if item.action then
        game.remapAction = item.action
        return
    end
end


-- Обрабатывает клавишу при переназначении.
local function handleOptionsKeyPressed(key)
    if not game.remapAction then
        return false
    end

    if key == "escape" then
        game.remapAction = nil
        return true
    end

    if key == "f1" then
        return false
    end

    Input.setKeyBinding(game.remapAction, key)
    Save.setKeyboardBindings(Input.getKeyBindings())

    game.remapAction = nil

    return true
end

-- Обрабатывает подтверждение pause menu.
local function confirmPauseMenu()
    local item = pauseMenuItems[game.selectedPauseIndex]

    if not item then
        return
    end

    if item.action == "continue" then
        game.mode = "level"
        return
    end

    if item.action == "restart" then
        restartCurrentLevel()
        return
    end

    if item.action == "exit_to_menu" then
        stopWorld()
        game.mode = "main_menu"
        return
    end
end

-- Обрабатывает подтверждение game over menu.
local function confirmGameOverMenu()
    local item = gameOverMenuItems[game.selectedGameOverIndex]

    if not item then
        return
    end

    if item.action == "restart" then
        restartCurrentLevel()
        return
    end

    if item.action == "exit_to_menu" then
        stopWorld()
        game.mode = "main_menu"
        return
    end
end


-- Обновляет выбор пункта меню.
local function updateMenuSelection(maxItems, selectedIndex)
    if Input.wasPressed("up") then
        selectedIndex = selectedIndex - 1
    end

    if Input.wasPressed("down") then
        selectedIndex = selectedIndex + 1
    end

    if selectedIndex < 1 then
        selectedIndex = maxItems
    elseif selectedIndex > maxItems then
        selectedIndex = 1
    end

    return selectedIndex
end

function getOptionsLayout()
    local rowH = 34
    local buttonH = 28
    local startY = 160

    local smallButtonW = 34
    local valueW = 46

    local leftX = 40
    local rightX = 410
    local groupW = 350

    local labelOffsetX = 12
    local minusOffsetX = 190
    local valueOffsetX = 232
    local plusOffsetX = 282

    local buttonW = 460
    local buttonX = Config.screen.width / 2 - buttonW / 2

    return {
        rowH = rowH,
        buttonH = buttonH,
        startY = startY,

        smallButtonW = smallButtonW,
        valueW = valueW,

        leftX = leftX,
        rightX = rightX,
        groupW = groupW,

        labelOffsetX = labelOffsetX,
        minusOffsetX = minusOffsetX,
        valueOffsetX = valueOffsetX,
        plusOffsetX = plusOffsetX,

        buttonW = buttonW,
        buttonX = buttonX
    }
end

--Звук
local function getOptionsItemAt(x, y)
    local layout = getOptionsLayout()

    for index, _ in ipairs(optionsMenuItems or {}) do
        local rowY = layout.startY + (index - 1) * layout.rowH

        if x >= layout.buttonX
            and x <= layout.buttonX + layout.buttonW
            and y >= rowY
            and y <= rowY + layout.buttonH
        then
            return index
        end
    end

    return nil
end

local function getOptionsVolumeButtonAt(x, y)
    local layout = getOptionsLayout()

    for index, item in ipairs(optionsMenuItems or {}) do
        if item.volume then
            local rowY = layout.startY + (index - 1) * layout.rowH
            local buttonY = rowY + 3
            local buttonH = layout.buttonH - 6

            local minusX = layout.leftX + layout.minusOffsetX
            local plusX = layout.leftX + layout.plusOffsetX

            local insideY = y >= buttonY and y <= buttonY + buttonH

            if insideY
                and x >= minusX
                and x <= minusX + layout.smallButtonW
            then
                return item, index, -1
            end

            if insideY
                and x >= plusX
                and x <= plusX + layout.smallButtonW
            then
                return item, index, 1
            end
        end
    end

    return nil, nil, nil
end

---Функции изменения громкости 
local function getVolumePercent(item)
    if not item or not item.volume then
        return 0
    end

    if item.volume == "sound" then
        return math.floor((Config.audio.soundVolume or 0) * 100 + 0.5)
    end

    if item.volume == "music" then
        return math.floor((Config.audio.musicVolume or 0) * 100 + 0.5)
    end

    return 0
end

local function setOptionVolumePercent(item, percent)
    if not item or not item.volume then
        return
    end

    percent = math.max(0, math.min(100, percent or 0))

    local volume = percent / 100

    if item.volume == "sound" then
        Assets.setSoundVolume(volume)
    elseif item.volume == "music" then
        Assets.setMusicVolume(volume)
    end

    Save.setAudioSettings(
        Config.audio.musicVolume,
        Config.audio.soundVolume
    )
end

local function changeOptionVolumeByPoint(item, points)
    if not item or not item.volume then
        return
    end

    local currentPercent = getVolumePercent(item)

    setOptionVolumePercent(
        item,
        currentPercent + (points or 0)
    )
end

local function handleOptionsPointerPressed(x, y)
    local volumeItem, volumeIndex, volumePoints = getOptionsVolumeButtonAt(x, y)

    if volumeItem then
        game.selectedOptionsIndex = volumeIndex
        changeOptionVolumeByPoint(volumeItem, volumePoints)
        return true
    end

    local touchItem, touchIndex, touchPoints = getOptionsTouchButtonAt(x, y)

    if touchItem then
        game.selectedOptionsIndex = touchIndex
        changeTouchSettingByPoint(touchItem, touchPoints)
        return true
    end

    local index = getOptionsItemAt(x, y)

    if index then
        game.selectedOptionsIndex = index
        confirmOptionsMenu()
        return true
    end

    return false
end
-----
-- Обновляет options menu.
local function updateOptionsMenu()
    if game.remapAction then
        return
    end

    game.selectedOptionsIndex = game.selectedOptionsIndex or 1

    game.selectedOptionsIndex = updateMenuSelection(
        #optionsMenuItems,
        game.selectedOptionsIndex
    )

    if Input.wasPressed("pause") then
        game.mode = "main_menu"
        game.remapAction = nil
        return
    end

    if Input.wasPressed("jump")
        or Input.wasPressed("shoot")
        or Input.wasPressed("melee")
        or Input.wasPressed("confirm")
    then
        confirmOptionsMenu()
    end
end

-- Обновляет главный экран меню.
local function updateMainMenu()
    game.selectedMenuIndex = updateMenuSelection(
        #mainMenuItems,
        game.selectedMenuIndex
    )

    if Input.wasPressed("jump")
        or Input.wasPressed("shoot")
        or Input.wasPressed("melee")
        or Input.wasPressed("confirm")
    then
        confirmMainMenu()
    end
end

-- Обновляет pause menu.
local function updatePauseMenu()
    game.selectedPauseIndex = updateMenuSelection(
        #pauseMenuItems,
        game.selectedPauseIndex
    )

    if Input.wasPressed("pause") then
        game.mode = "level"
        return
    end

    if Input.wasPressed("jump")
        or Input.wasPressed("shoot")
        or Input.wasPressed("melee")
        or Input.wasPressed("confirm")
    then
        confirmPauseMenu()
    end
end

-- Обновляет game over menu.
local function updateGameOverMenu()
    game.selectedGameOverIndex = updateMenuSelection(
        #gameOverMenuItems,
        game.selectedGameOverIndex
    )

    if Input.wasPressed("jump")
        or Input.wasPressed("shoot")
        or Input.wasPressed("melee")
        or Input.wasPressed("confirm")
    then
        confirmGameOverMenu()
    end
end

local applySceneLivesDelta

local function updateScene(dt)
    game.scene:update(dt)

    if Input.wasPressed("jump")
        or Input.wasPressed("shoot")
        or Input.wasPressed("melee")
        or Input.wasPressed("confirm")
    then
        game.scene:skip()
    end

    if game.scene:isFinished() then
        local nextTarget = game.scene:getNextTarget()
        local livesDelta = game.scene:getLivesDelta()

        stopScene()

        if not applySceneLivesDelta(livesDelta) then
            return
        end

        if game.sceneReturnMode == "restart_level" then
            restartCurrentLevel()
            return
        end

        if game.sceneReturnMode == "main_menu" then
            game.mode = "main_menu"
            return
        end

        if nextTarget then
            startTransitionTarget(nextTarget)
            return
        end

        if game.sceneReturnMode == "game_over_menu" then
            game.mode = "game_over_menu"
            return
        end

        advanceFlow()
    end
end

-- Обновляет player select.
local function updatePlayerSelect(dt)
    game.playerSelect:update(dt)

    if game.playerSelect:isFinished() then
        local nextTarget = game.playerSelect:getNextTarget()

        Save.setSelectedPlayerId(game.playerSelect.selectedPlayerId)
        stopPlayerSelect()

        if nextTarget then
            startTransitionTarget(nextTarget)
            return
        end

        advanceFlow()
    end
end

-- Передаёт input игроку.
local function updatePlayerInput()
    local player = game.player

    if not player or player.dead then
        return
    end

    local direction = Input.getMoveDirection()

    player:setCrouchHeld(Input.isDown("crouch"))

    if direction ~= 0 then
        player:setMoveDirection(direction)
    else
        player:stopMoving()
    end

    player:setBlockHeld(Input.isDown("block"))

    if Input.wasPressed("jump") then
        player:jump()
    end

    if Input.wasPressed("shoot") then
        player:shoot({
            up = Input.isDown("up"),
            forward = direction ~= 0 and direction == player.facing,
            moving = direction ~= 0
        })
    end

    if Input.wasPressed("melee") then
        player:melee({
            moving = direction ~= 0
        })
    end

    if Input.wasPressed("strafe") then
        player:strafe()
    end
end

-- Применяет изменение жизней из scene.
-- Возвращает false, если жизни закончились и запущен game over.
applySceneLivesDelta = function(delta)
    delta = delta or 0

    if delta == 0 then
        return true
    end

    local lives = game.playerLives or (game.player and game.player.lives) or 1

    lives = math.max(0, lives + delta)
    game.playerLives = lives

    if game.player then
        game.player.lives = lives
    end

    if lives <= 0 then
        startGameOver()
        return false
    end

    return true
end

----Респавн игрока если все условия сошлись
local function tryRespawnAtCheckpoint()
    if not game.world then
        return false
    end

    if not game.world:hasActiveCheckpoint() then
        return false
    end

    local lives = game.playerLives or (game.player and game.player.lives) or 1

    -- Если это последняя жизнь, checkpoint не срабатывает.
    if lives <= 1 then
        return false
    end

    lives = lives - 1
    game.playerLives = lives

    if game.player then
        game.player.lives = lives
    end

    if game.world:respawnPlayerAtCheckpoint() then
        game.mode = "level"
        return true
    end

    return false
end
---проверка жизней игрока
local function handlePlayerDeath()
    if tryRespawnAtCheckpoint() then
        return
    end

    local lives = game.playerLives or (game.player and game.player.lives) or 1

    if game.player and game.player.resetWeaponOnLifeLoss then
        game.player:resetWeaponOnLifeLoss()
    end

    lives = lives - 1
    game.playerLives = lives

    if game.player then
        game.player.lives = lives
    end

    if lives <= 0 then
        startGameOver()
        return
    end

    startDefeatScene("restart_level")
end


-- Обновляет уровень.
local function updateLevel(dt)
    if Input.wasPressed("pause") then
        game.mode = "pause_menu"
        return
    end

    updatePlayerInput()

    game.world:update(dt)

----------Оставляем синхронизацию, чтобы pickup жизни сохранялся при прохождении уровня:	
	syncPlayerLivesFromPlayer()
	
--Это важно: иначе pickup увеличит player.lives, 
--но глобальный game.playerLives останется старым, 
--и после смерти логика может потерять добавленную жизнь.	
	if game.player then
        game.playerLives = game.player.lives
    end	

	if game.world.result == "transition" then
        startTransitionTarget(game.world.nextTarget)
        return
    end
	
	if game.world.result == "transition" then
        startTransitionTarget(game.world.nextTarget)
        return
    end

    if game.world.result == "victory" then
        advanceFlow()
        return
    end
	
	if game.world.result == "player_dead" then
		handlePlayerDeath()
		return
	end

    if game.world.result == "restart" then
        restartCurrentLevel()
        return
    end

	if game.world.result == "game_over" then
		startGameOver()
		return
	end

	if game.world.result == "defeat" then
		startDefeatScene("game_over_menu")
		return
	end
end

----ALT+ENTER (Fullscreen)
local function toggleFullscreen()
    if game.fullscreenToggleCooldown > 0 then
        return
    end

    game.fullscreenToggleCooldown = 0.75

    Input.clear()

    local fullscreen = love.window.getFullscreen()

    love.window.setFullscreen(not fullscreen, "desktop")

    Input.clear()
end

local function isAltEnter(key)
    local isEnter = key == "return" or key == "kpenter"
    local isAlt = love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt")

    return isEnter and isAlt
end

-- love.load вызывается Love2D при старте игры.
function love.load()
    math.randomseed(os.time())

    Assets.init()
    Registry.loadAll()
    Input.init()
    UI.init()
    Save.load()
	applySavedAudioSettings()
	applySavedTouchSettings()

	Input.setKeyBindings(Save.getKeyboardBindings())

    game.flow = loadFlow()
    game.mode = "main_menu"
end

-- love.update вызывается каждый кадр.
function love.update(dt)
    -- Защита от частого нажатия Alt+Enter.
    if game.fullscreenToggleCooldown > 0 then
        game.fullscreenToggleCooldown = math.max(
            0,
            game.fullscreenToggleCooldown - dt
        )
    end

    -- Защита от частого изменения звука.
    -- Сейчас можно оставить, но громкость мышкой уже не должна зависеть от этого.
    if game.optionsVolumeCooldown > 0 then
        game.optionsVolumeCooldown = math.max(
            0,
            game.optionsVolumeCooldown - dt
        )
    end

    -- Защита физики от больших скачков времени при подвисаниях.
    -- Без этого actor/projectile могут за один кадр пролететь сквозь платформу.
    dt = math.min(dt, 1 / 30)

    Input.update(dt)

    if game.mode == "main_menu" then
        updateMainMenu()
    elseif game.mode == "options_menu" then
        updateOptionsMenu()
    elseif game.mode == "pause_menu" then
        updatePauseMenu()
    elseif game.mode == "game_over_menu" then
        updateGameOverMenu()
    elseif game.mode == "scene" then
        updateScene(dt)
    elseif game.mode == "player_select" then
        updatePlayerSelect(dt)
    elseif game.mode == "level" then
        updateLevel(dt)
    end

    Input.endFrame()
end

-- love.draw вызывается каждый кадр для отрисовки.
function love.draw()
    Viewport.begin()

    if game.mode == "main_menu" then
        UI.drawMenu("ARCADE", mainMenuItems, game.selectedMenuIndex)
    elseif game.mode == "options_menu" then
        UI.drawOptionsMenu(optionsMenuItems, game.selectedOptionsIndex, game.remapAction)
    elseif game.mode == "pause_menu" then
        if game.world then
            game.world:draw()
        end

        UI.drawMenu("PAUSE", pauseMenuItems, game.selectedPauseIndex)
    elseif game.mode == "game_over_menu" then
        UI.drawMenu("GAME OVER", gameOverMenuItems, game.selectedGameOverIndex)
    elseif game.mode == "scene" and game.scene then
        game.scene:draw()
    elseif game.mode == "player_select" and game.playerSelect then
        game.playerSelect:draw()
    elseif game.mode == "level" and game.world then
        game.world:draw()
        UI.drawHud(game.player)

        for _, actor in ipairs(game.world.actors) do
            UI.drawActorHealthBar(actor, game.world.camera)
        end
    else
        UI.drawLoading(game.loadingProgress)
    end

    UI.drawTouchButtons()
    UI.drawDebug(game.world)

    Viewport.finish()
end

-- love.keypressed обрабатывает нажатие клавиши.
function love.keypressed(key)
--проверка Alt+Enter выше handleOptionsKeyPressed, 
--иначе в Options можно случайно назначить Enter как клавишу вместо переключения fullscreen.
-------Для Android вообще убрать
    if isAltEnter(key) then
        toggleFullscreen()
        return
    end

    if game.mode == "options_menu" and handleOptionsKeyPressed(key) then
        return
    end

    if key == "f1" then
        Debug.toggle()
        return
    end

    Input.keypressed(key)
end

-- love.keyreleased обрабатывает отпускание клавиши.
function love.keyreleased(key)
    Input.keyreleased(key)
end

-- love.mousepressed обрабатывает клик мыши.
function love.mousepressed(x, y, button)
    x, y = Viewport.toVirtual(x, y)

    if button == 1 then
        if game.mode == "main_menu" then
            local index = getMenuItemAt(mainMenuItems, x, y)

            if index then
                game.selectedMenuIndex = index
                confirmMainMenu()
                return
            end
        end

        if game.mode == "options_menu" then
            if handleOptionsPointerPressed(x, y) then
                return
            end
        end

        if game.mode == "pause_menu" then
            local index = getMenuItemAt(pauseMenuItems, x, y)

            if index then
                game.selectedPauseIndex = index
                confirmPauseMenu()
                return
            end
        end

        if game.mode == "game_over_menu" then
            local index = getMenuItemAt(gameOverMenuItems, x, y)

            if index then
                game.selectedGameOverIndex = index
                confirmGameOverMenu()
                return
            end
        end

        if game.mode == "scene" and game.scene then
            game.scene:click(x, y)
            return
        end
    end

    -- ВАЖНО: level/input получает мышь только после меню.
    Input.mousepressed(x, y, button)
end

-- love.mousereleased обрабатывает отпускание кнопки мыши.
function love.mousereleased(x, y, button)
    x, y = Viewport.toVirtual(x, y)

    Input.mousereleased(x, y, button)
end

-- love.touchpressed обрабатывает touch-нажатие.
function love.touchpressed(id, x, y)
    local windowX = x * love.graphics.getWidth()
    local windowY = y * love.graphics.getHeight()

    x, y = Viewport.toVirtual(windowX, windowY)

    if game.mode == "scene" and game.scene then
        game.scene:click(x, y)
        return
    end

    Input.pointerPressed(x, y)
end

-- love.touchreleased обрабатывает отпускание touch.
function love.touchreleased(id, x, y)
    local windowX = x * love.graphics.getWidth()
    local windowY = y * love.graphics.getHeight()

    x, y = Viewport.toVirtual(windowX, windowY)

    Input.pointerReleased(x, y)
end


