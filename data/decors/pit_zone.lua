return {
    id = "pit_zone",

    layer = "back",

    x = 0,
    y = 0,

    hazardZone = true,

    -- Мгновенная смерть через огромный урон.
    hazardDamage = 999999,
    hazardCooldown = 0,
    hazardDeathType = "normal",

    hazardIgnoreInvulnerable = true,

    hazardDamageTargets = {
        player = true,
        enemy = true,
        npc = true
    },

    canvas = {
        width = 3200,
        height = 200
    },

    offset = {
        x = 0,
        y = 0
    },

    bbox = {
        x = 0,
        y = 0,
        w = 3200,
        h = 200
    },

    alpha = 0,
    color = {1, 0, 0}
}