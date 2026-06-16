return {
    id = "door_level2",

    -- Что запускается при столкновении игрока с этим level_end.
    -- Можно заменить на nextScene = "scene_id".
	nextScene = "game_over",
    --nextLevel = "level2",

    canvas = {
        width = 48,
        height = 80
    },

    offset = {
        x = 24,
        y = 80
    },

    bbox = {
        x = 0,
        y = 0,
        w = 48,
        h = 80
    },

    image = nil,

    alpha = 1,
    color = {1.0, 0.85, 0.2}
}