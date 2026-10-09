-- Настраивает приложение.
function lovr.conf(t)
  t.identity = 'lane-autobattler'
  t.modules.headset = false

  t.window.title = 'Lane Autobattler'
  t.window.fullscreen = true
  t.window.msaa = 4
end