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

local animations = {}

-- Формирует путь к кадру виверны.
local function frame(
    direction,
    name
)
    return string.format(
        "assets/images/enemies/wyvern/%s/%s.png",
        direction,
        name
    )
end

-- Создаёт анимации восьми направлений.
for _, direction in ipairs(directions) do
    animations[
        "idle_" .. direction
    ] = {
        loop = true,
        frameDuration = 0.2,

        frames = {
            frame(direction, "idle_01"),
            frame(direction, "idle_02"),
            frame(direction, "idle_03"),
            frame(direction, "idle_04"),
            frame(direction, "idle_05")			
        }
    }

    animations[
        "fly_" .. direction
    ] = {
        loop = true,
        frameDuration = 0.14,

        frames = {
            frame(direction, "idle_01"),
            frame(direction, "idle_02"),
            frame(direction, "idle_03"),
            frame(direction, "idle_04"),
            frame(direction, "idle_05")	
        }
    }

    animations[
        "attack_" .. direction
    ] = {
        loop = false,
        frameDuration = 0.15,

        frames = {
            frame(direction, "attack_01"),
            frame(direction, "attack_02"),
            frame(direction, "attack_03"),
            frame(direction, "attack_04"),			
            frame(direction, "attack_05")
        }
    }

    animations[
        "hurt_" .. direction
    ] = {
        loop = false,
        frameDuration = 0.12,

        frames = {
            frame(direction, "hurt_01"),
            frame(direction, "hurt_01")
        }
    }

    animations[
        "death_" .. direction
    ] = {
        loop = false,
        frameDuration = 0.16,

        frames = {
            frame(direction, "death_01"),
            frame(direction, "death_02"),
            frame(direction, "death_03"),
            frame(direction, "death_04"),
            frame(direction, "death_05"),			
            frame(direction, "death_06")
        }
    }
end

return {
    id = "wyvern",
    name = "Wyvern",

    health = 4,

    speed = 58,
    retreatSpeed = 70,

    collisionRadius = 24,

    spriteHeight = 95,
    scale = 1,

    flyingHeight = 75,

    -- Значения указываются в игровых метрах.
    detectionRange = 32,

    preferredMinimumRange = 7,
    preferredMaximumRange = 12,

    attackCooldown = 1.8,
    attackFireTime = 0.2,
    attackDuration = 0.45,

    hurtDuration = 0.24,
    deathDuration = 0.64,

    defaultDirection = "south",

    directions = directions,
    animations = animations
}