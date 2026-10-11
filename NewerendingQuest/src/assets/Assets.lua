local WyvernData =
    require("data.entities.enemies.wyvern")

local PlayerData =
    require("data.entities.player")

local Forest =
    require("data.biomes.forest")

local Swamp =
    require("data.biomes.swamp")

local Dungeon =
    require("data.biomes.dungeon")

local KikimoraData =
    require("data.entities.kikimora")

local SkeletonData =
    require("data.entities.enemies.skeleton")

local PortalData =
    require("data.entities.portal")

local ArrowBundleData =
    require("data.items.arrow_bundle")

local ShieldPickupData =
    require("data.items.shield")

local HealthPotionData =
    require("data.items.health_potion")

local Assets = {}
Assets.__index = Assets

-- Создаёт хранилище ресурсов.
function Assets.new()
    local self =
        setmetatable({}, Assets)

    self.images = {}
    self.imageGroups = {}

    self.animationImages = {}
    self.missingAnimationImages = {}

    return self
end

-- Загружает ресурсы игры.
function Assets:load()
    self:loadImage(
        "playerFallback",
        PlayerData.fallbackImage
    )

    self:preloadAnimations(
        PlayerData.animations
    )

    self:loadImage(
        Forest.groundImage,
        "assets/images/biomes/forest/ground_grass.png"
    )

    self:loadImageGroup(
        Forest.treeGroup,
        Forest.treeImages
    )

    self:loadImageGroup(
        Forest.bushGroup,
        Forest.bushImages
    )

    self:loadImageGroup(
        Forest.rockGroup,
        Forest.rockImages
    )

    self:loadImageGroup(
        Forest.mushroomGroup,
        Forest.mushroomImages
    )

    self:loadImage(
        Swamp.groundImage,
        "assets/images/biomes/swamp/ground_water.png"
    )

    self:loadImage(
        Swamp.hummockImage,
        "assets/images/biomes/swamp/hummock.png"
    )

    self:preloadAnimations(
        KikimoraData.animations
    )

    self:loadImage(
        Dungeon.groundImage,
        "assets/images/biomes/dungeon/floor.png"
    )

    self:loadImageGroup(
        Dungeon.columnGroup,
        Dungeon.columnImages
    )

    self:loadImageGroup(
        Dungeon.rockGroup,
        Dungeon.rockImages
    )

    self:loadImageGroup(
        Dungeon.mushroomGroup,
        Dungeon.mushroomImages
    )

    self:loadImage(
        ArrowBundleData.imageKey,
        ArrowBundleData.image
    )

    self:loadImage(
        ShieldPickupData.imageKey,
        ShieldPickupData.image
    )
	
	self:preloadAnimations(
		WyvernData.animations
	)

    for _, variant in pairs(
        HealthPotionData.variants
    ) do
        self:getFileImage(
            variant.image
        )
    end

    self:preloadAnimations(
        SkeletonData.animations
    )

    self:preloadAnimations(
        PortalData.animations
    )
end

-- Создаёт изображение.
function Assets:createImage(path)
    if
        not path or
        not love.filesystem.getInfo(path)
    then
        print(
            "Image not found: " ..
            tostring(path)
        )

        return nil
    end

    local image =
        love.graphics.newImage(path)

    image:setFilter(
        "nearest",
        "nearest"
    )

    return image
end

-- Загружает именованное изображение.
function Assets:loadImage(name, path)
    local image =
        self:createImage(path)

    if image then
        self.images[name] = image
    end
end

-- Загружает группу изображений.
function Assets:loadImageGroup(
    name,
    paths
)
    local group = {}

    for _, path in ipairs(
        paths or {}
    ) do
        local image =
            self:createImage(path)

        if image then
            group[#group + 1] =
                image
        end
    end

    self.imageGroups[name] =
        group
end

-- Загружает кадр анимации.
function Assets:loadAnimationImage(path)
    if not path then
        return nil
    end

    if self.animationImages[path] then
        return
            self.animationImages[path]
    end

    if
        self.missingAnimationImages[
            path
        ]
    then
        return nil
    end

    local image =
        self:createImage(path)

    if image then
        self.animationImages[path] =
            image
    else
        self.missingAnimationImages[path] =
            true
    end

    return image
end

-- Предварительно загружает анимации.
function Assets:preloadAnimations(
    animations
)
    for _, animation in pairs(
        animations or {}
    ) do
        for _, frame in ipairs(
            animation.frames or {}
        ) do
            local path = frame

            if type(frame) == "table" then
                path = frame.image
            end

            self:loadAnimationImage(
                path
            )
        end
    end
end

-- Возвращает именованное изображение.
function Assets:getImage(name)
    return self.images[name]
end

-- Загружает изображение по пути.
function Assets:getFileImage(path)
    if not path then
        return nil
    end

    return
        self:getAnimationImage(
            path
        )
end

-- Возвращает кадр анимации.
function Assets:getAnimationImage(path)
    return
        self.animationImages[path] or
        self:loadAnimationImage(path)
end

-- Возвращает вариант группы.
function Assets:getVariant(
    groupName,
    variant
)
    local group =
        self.imageGroups[
            groupName
        ]

    if
        not group or
        #group == 0
    then
        return nil
    end

    local index =
        ((variant or 1) - 1) %
        #group +
        1

    return group[index]
end

-- Возвращает количество вариантов.
function Assets:getVariantCount(
    groupName
)
    local group =
        self.imageGroups[
            groupName
        ]

    return
        group and
        #group or
        0
end

return Assets