local LevelLoader = {}
LevelLoader.__index = LevelLoader

-- Загружает кампанию и уровни.
function LevelLoader.new(campaignId)
    local self =
        setmetatable({}, LevelLoader)

    self.campaign =
        require(
            "data.campaigns." ..
            campaignId
        )

    assert(
        type(
            self.campaign.levels
        ) == "table",
        "Campaign has no levels"
    )

    self.levels = {}
    self.levelsById = {}

    self.index = 0

    for _, moduleName in ipairs(
        self.campaign.levels
    ) do
        local level =
            require(moduleName)

        self:validateLevel(
            level
        )

        self.levels[
            #self.levels + 1
        ] = level

        self.levelsById[
            level.id
        ] = level
    end

    return self
end

-- Проверяет описание уровня.
function LevelLoader:validateLevel(level)
    assert(
        level.id,
        "Level has no id"
    )

    assert(
        level.name,
        "Level has no name"
    )

    assert(
        level.biome,
        "Level has no biome"
    )

    assert(
        level.generationMode,
        "Level has no generationMode"
    )

    if
        level.generationMode ==
        "fixed"
    then
        assert(
            type(
                level.platforms
            ) == "table",
            "Fixed level has no platforms"
        )
    end
end

-- Возвращает следующий уровень.
function LevelLoader:loadNext()
    self.index =
        self.index + 1

    return
        self.levels[
            self.index
        ]
end

-- Загружает уровень по идентификатору.
function LevelLoader:loadById(levelId)
    local level =
        self.levelsById[
            levelId
        ]

    if not level then
        return nil
    end

    for index, candidate in ipairs(
        self.levels
    ) do
        if candidate.id == levelId then
            self.index = index
            break
        end
    end

    return level
end

-- Загружает назначение портала.
function LevelLoader:loadDestination(
    destination
)
    destination =
        destination or {
            type = "next"
        }

    if destination.type == "next" then
        return self:loadNext()
    end

    if destination.type == "level" then
        return self:loadById(
            destination.id
        )
    end

    error(
        "Unknown portal destination: " ..
        tostring(
            destination.type
        )
    )
end

-- Возвращает все уровни.
function LevelLoader:getLevels()
    return self.levels
end

-- Возвращает текущий номер.
function LevelLoader:getIndex()
    return self.index
end

return LevelLoader