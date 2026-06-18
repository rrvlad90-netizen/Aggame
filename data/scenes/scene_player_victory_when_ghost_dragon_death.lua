return {
    id = "scene_player_victory_when_ghost_dragon_death",

    livesDelta = 1, --добавим жизнь в качестве бонуса

    nextScene = "scenelevel2",

    frames = {
        {
            image = "assets/scenes/DragonGhostDeath.png",
            duration = 2,
            text = "ТЫ ПОБЕДИЛ ДРАКОНА ПРИЗРАКА!"
        }
    }
}