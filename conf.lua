function love.conf(t)
    t.identity = "arcade_action_platformer"
    t.version = "11.5"

    t.window.title = "Arcade Action Platformer"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = false
    t.window.fullscreen = false
    t.window.vsync = 1
    t.window.msaa = 0

    t.console = true

    t.modules.audio = true
    t.modules.data = true
    t.modules.event = true
    t.modules.font = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = false
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = true
    t.modules.system = true
    t.modules.thread = true
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = false
    t.modules.window = true
end