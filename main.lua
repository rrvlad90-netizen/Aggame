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
local PlayerSelect = require("src.player_select")

local game = {
    mode = "main_menu",

    flow = {},
    flowIndex = 1,

    selectedMenuIndex = 1,
    selectedPauseIndex = 1,
    selectedGameOverIndex = 1,

    scene = nil,
    sceneReturnMode = nil,

    playerSelect = nil,

    level = nil,
    world = nil,
    player = nil,
	
	playerLives = nil,
	playerMaxLives = nil,

    loadingProgress = 0,
    pendingStart = nil
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
local function createSelectedPlayer(x, y)
    local playerId = Save.getSelectedPlayerId() or "warrior"
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
    stopWorld()
    stopPlayerSelect()
    stopScene()

    local definition = Registry.loadScene(sceneId)

    game.scene = Scene:new(definition)
    game.sceneReturnMode = returnMode
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

-- Запускает уровень по id.
local function startLevel(levelId)
    stopWorld()
    stopScene()
    stopPlayerSelect()

    local levelDefinition = Registry.loadLevel(levelId)

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

    game.mode = "main_menu"
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
	
	--сброс жизней
	game.playerLives = nil 
    game.playerMaxLives = nil
	
    startFlow(1)
end

-- Продолжает игру из save.
local function continueGame()
    startFlow(Save.getFlowIndex())
end

-- Перезапускает текущий уровень.
local function restartCurrentLevel()
    local item = getCurrentFlowItem()

    if item and item.type == "level" then
        startLevel(item.id)
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
    startScene("game_over", "game_over_menu")
end

local function startDefeatScene(returnMode)
    startScene(getLevelDefeatScene(), returnMode)
end

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
        return
    end

    if item.action == "exit" then
        love.event.quit()
        return
    end
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

-- Обновляет scene.
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
--        local nextTarget = game.scene:getNextTarget()
        stopScene()

		if game.sceneReturnMode == "restart_level" then
			restartCurrentLevel()
			return
		end

 --       if nextTarget then
 --           startTransitionTarget(nextTarget)
 --           return
 --       end

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

    if direction ~= 0 then
        player:setMoveDirection(direction)
    else
        player:stopMoving()
    end

    if Input.wasPressed("jump") then
        player:jump()
    end

    if Input.wasPressed("shoot") then
        player:shoot()
    end

    if Input.wasPressed("melee") then
        player:melee()
    end

    if Input.wasPressed("crouch") then
        player:crouch()
    end

    if Input.wasPressed("strafe") then
        player:strafe()
    end
end

---проверка жизней игрока
local function handlePlayerDeath()
    local lives = game.playerLives or (game.player and game.player.lives) or 1

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

-- love.load вызывается Love2D при старте игры.
function love.load()
    math.randomseed(os.time())

    love.window.setTitle(Config.window.title)
    love.window.setMode(Config.screen.width, Config.screen.height)

    Assets.init()
    Registry.loadAll()
    Input.init()
    UI.init()
    Save.load()

    game.flow = loadFlow()
    game.mode = "main_menu"
end

-- love.update вызывается каждый кадр.
function love.update(dt)
    -- Защита физики от больших скачков времени при подвисаниях.
    -- Без этого actor/projectile могут за один кадр пролететь сквозь платформу.
    dt = math.min(dt, 1 / 30)

    Input.update(dt)

    if game.mode == "main_menu" then
        updateMainMenu()
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
    if game.mode == "main_menu" then
        UI.drawMenu("ARCADE", mainMenuItems, game.selectedMenuIndex)
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
end

-- love.keypressed обрабатывает нажатие клавиши.
function love.keypressed(key)
    if key == "f1" then
        Debug.toggle()
        return
    end

    if key == "return" then
        Input.press("confirm")
        return
    end

    Input.keypressed(key)
end

-- love.keyreleased обрабатывает отпускание клавиши.
function love.keyreleased(key)
    if key == "return" then
        Input.release("confirm")
        return
    end

    Input.keyreleased(key)
end

-- love.mousepressed обрабатывает клик мыши.
function love.mousepressed(x, y, button)
    if button == 1 then
        if game.mode == "main_menu" then
            local index = getMenuItemAt(mainMenuItems, x, y)

            if index then
                game.selectedMenuIndex = index
                confirmMainMenu()
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
            game.scene:skip()
            return
        end
    end

    Input.mousepressed(x, y, button)
end

-- love.mousereleased обрабатывает отпускание кнопки мыши.
function love.mousereleased(x, y, button)
    Input.mousereleased(x, y, button)
end

-- love.touchpressed обрабатывает touch-нажатие.
function love.touchpressed(id, x, y)
    Input.touchpressed(id, x, y)
end

-- love.touchreleased обрабатывает отпускание touch.
function love.touchreleased(id, x, y)
    Input.touchreleased(id, x, y)
end


