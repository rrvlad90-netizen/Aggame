return {
    id = "wyvern_fireball",

    image =
        "assets/images/projectiles/enemies/wyvern/fireball.png",

    speed = 310,
    lifetime = 4,

    damage = 1,
    collisionRadius = 10,

    height = 52,

    spriteHeight = 30,
    scale = 1,

    hit = {
        frameDuration = 0.08,
        spriteHeight = 48,
        scale = 1,

        frames = {
            "assets/images/projectiles/enemies/wyvern/hit_01.png",
            "assets/images/projectiles/enemies/wyvern/hit_02.png",
            "assets/images/projectiles/enemies/wyvern/hit_03.png"
        }
    }
}