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

local function frame(direction, name)
    return string.format(
        "assets/images/enemies/skeleton/%s/%s.png",
        direction,
        name
    )
end

for _, direction in ipairs(directions) do
    animations["idle_" .. direction] = {
        loop = true,
        frameDuration = 0.16,
        frames = {
            frame(direction, "idle_01")
        }
    }

    animations["walk_" .. direction] = {
        loop = true,
        frameDuration = 0.14,
        frames = {
            frame(direction, "walk_01"),
            frame(direction, "walk_02")
        }
    }

    animations["attack_" .. direction] = {
        loop = false,
        frameDuration = 0.15,
        frames = {
            frame(direction, "attack_01"),
            frame(direction, "attack_02"),
            frame(direction, "attack_03")
        }
    }

    animations["hurt_" .. direction] = {
        loop = false,
        frameDuration = 0.18,
        frames = {
            frame(direction, "hurt_01")
        }
    }

    animations["block_" .. direction] = {
        loop = false,
        frameDuration = 0.15,
        frames = {
            frame(direction, "block_01"),
            frame(direction, "block_02")
        }
    }

    animations["death_" .. direction] = {
        loop = false,
        frameDuration = 0.15,
        frames = {
            frame(direction, "death_01"),
            frame(direction, "death_02"),
            frame(direction, "death_03"),
            frame(direction, "death_04")
        }
    }
end

return {
    id = "skeleton",
    name = "Skeleton",

    health = 3,

    speed = 55,

    detectionRange = 32,
    attackRange = 1.1,

    attackDamage = 1,
    attackDuration = 0.45,
    attackHitTime = 0.22,
    attackCooldown = 0.75,

    collisionRadius = 22,

    spriteHeight = 105,
	
	shadow = {
		enabled = true,
		radius = 22,
		verticalScale = 0.35,
		alpha = 0.28,
		offsetY = 2
	},
	
    scale = 1,

    showHealthBar = false,

    hurtDuration = 0.18,
    blockDuration = 0.3,
    deathDuration = 0.6,

    shieldBlockChance = 0.35,
	
	retreatSpeed = 70,
	retreatRange = 9,
	
	navigation = {
		enabled = true,

		-- Размер клетки в метрах.
		cellSize = 2,

		-- Частота пересчёта пути.
		repathInterval = 0.7,

		waypointRadius = 0.65,
		maximumIterations = 5000,

		-- Область поиска вперёд и назад.
		zMargin = 12
	},	
	
	drops = {
		-- true: предмет виден сразу.
		-- false: появляется после приближения к телу.
		visible = true,

		arrowBundleChance = 0.15,
		healthPotionChance = 0.08,

		-- При выпадении пузырька вероятность варианта +2.
		largePotionChance = 0.5,

		-- Смещение предметов ближе к камере, в метрах.
		forwardOffset = 0.9,

		-- Разнос предметов по сторонам, в метрах.
		sideOffset = 0.45
	},

    hitSound =
        "assets/sounds/enemies/skeleton_hit.wav",

    shieldBlockSound =
        "assets/sounds/enemies/skeleton_shield_block.wav",

    defaultDirection = "south",

    animations = animations
}