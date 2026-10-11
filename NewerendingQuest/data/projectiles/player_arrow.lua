local images = {}

local directions = {
    "north",
    "north_east",
    "east",
    "south_east",
    "south",
    "south_west",
    "west",
    "north_west"
}

for _, direction in ipairs(directions) do
    images[direction] =
        string.format(
            "assets/images/projectiles/player/arrow/%s.png",
            direction
        )
end

return {
    id = "player_arrow",

    speed = 520,
    lifetime = 2.5,
    damage = 1,

    collisionRadius = 8,

    height = 52,
    spriteHeight = 28,
    scale = 1,

    images = images,

    hit = {
        frameDuration = 0.08,
        spriteHeight = 46,
        scale = 1,

        frames = {
            "assets/images/projectiles/player/arrow/hit_01.png",
            "assets/images/projectiles/player/arrow/hit_02.png",
            "assets/images/projectiles/player/arrow/hit_03.png"
        }
    }
}