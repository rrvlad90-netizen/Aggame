Ниже схема добавления контента в текущую архитектуру. Важно: модель и игровой юнит — разные определения.

1. Новый юнит
Шаг 1. Добавить ресурсы
Рекомендуемая структура:

text
models/my_unit/
+-- my_unit_walk.md3
+-- my_unit_attack.md3
+-- my_unit_death.md3
L-- my_unit_texture.png

sprites/units/my_unit.png

sounds/my_unit/
+-- attack1.ogg
+-- attack2.ogg
+-- attack3.ogg
+-- hit1.ogg
+-- hit2.ogg
+-- hit3.ogg
+-- death1.ogg
+-- death2.ogg
L-- death3.ogg
Шаг 2. Создать описание модели
Создай:

text
models/definitions/my_unit.lua
За основу проще взять похожую модель:

ближний боец — footman.lua;
стрелок — troll_with_axes.lua;
великан — ogre.lua;
летающий — red_dragon.lua.
Важные поля:

lua
return {
  id = 'my_unit',
  format = 'md3',

  scale = .012,
  yOffset = .35,
  rotationOffset = 0,

  modelSets = {
    walk = {
      parts = {
        {
          path =
            'models/my_unit/my_unit_walk.md3',

          texture =
            'models/my_unit/my_unit_texture.png'
        }
      }
    }
  },

  battleAnimations = {
    idle = 'idle',
    forward = 'walk',

    attacks = {
      {
        start = 'attack_start',
        hit = 'attack_hit',
        finish = 'attack_end'
      }
    },

    deaths = {
      'death'
    }
  },

  animations = {
    -- Описания кадров.
  },

  preloadAnimations = {
    'idle',
    'walk',
    'attack_start',
    'attack_hit',
    'attack_end',
    'death'
  }
}
Шаг 3. Зарегистрировать модель
Добавь:

lua
require(
  'models.definitions.my_unit'
),
в modellist.lua.

Шаг 4. Создать игровой профиль
Создай:

text
units/definitions/my_unit.lua
Пример:

lua
return {
  id = 'my_unit',
  slot = 'heavy_infantry',

  name = 'My Unit',
  description = 'Description.',

  model = 'my_unit',

  health = 400,

  damageMinimum = 25,
  damageMaximum = 40,
  damageType = 'normal',

  moveSpeed = 2.8,
  radius = .5,

  spawnSpacing = 1.15,
  routeSpacing = 1.15,

  squadSize = 15,

  attackDistance = 1.8,
  sightDistance = 26,

  corpse = {
    mode = 'random',
    stayChance = .4
  },

  spearDamageMultiplier = 1,
  magicDamageMultiplier = 1
}
Для стрелка добавляется:

lua
rangedAttack = {
  projectile = 'arrow',

  minimumDistance = 3,
  maximumDistance = 22,

  cooldownMinimum = 1.5,
  cooldownMaximum = 2,

  spawnHeight = 1.2,
  spawnForward = .5,
  targetHeight = .8
},
Шаг 5. Зарегистрировать юнита
Добавь:

lua
require(
  'units.definitions.my_unit'
),
в unitlist.lua.

Шаг 6. Назначить юнита фракции
Например, в human.lua:

lua
units.heavy_infantry =
  'my_unit'
Для орков аналогично меняется sides/orcs.lua.

Чтобы нанимать слот в казарме, добавь в recruitOptions:

lua
{
  slot = 'heavy_infantry',
  cost = 600,
  count = 15,
  mockup = '6'
}
И при необходимости точку появления:

lua
heavy_infantry = {
  side = 0,
  forward = 5
}
2. Новое здание
Шаг 1. Добавить модели и текстуры
text
models/MyBuildings/my_building.md3
models/MyBuildings/my_building.png
Для каждой фракции можно использовать отдельную модель.

Шаг 2. Создать определения моделей
text
models/definitions/human_my_building.lua
models/definitions/orc_my_building.lua
Для статичного MD3:

lua
local BuildingFactory =
  require(
    'models.definitions.building_factory'
  )

return BuildingFactory.create({
  id = 'human_my_building',

  path =
    'models/MyBuildings/my_building.md3',

  texture =
    'models/MyBuildings/my_building.png',

  scale = .01,
  yOffset = 0,
  rotationOffset = 0,
  colliderRadius = 4
})
Оба определения нужно зарегистрировать в models/modellist.lua.

Шаг 3. Добавить тип здания
В building_catalog.lua:

lua
my_building = {
  id = 'my_building',

  health = 1500,

  buildCost = 1000,
  buildTime = 3,
  buildDepth = 7,

  colliderRadius = 7
},
Шаг 4. Добавить модели фракций
В BuildingCatalog.models:

lua
human = {
  -- Остальные здания.
  my_building = 'human_my_building'
},

orcs = {
  -- Остальные здания.
  my_building = 'orc_my_building'
}
Шаг 5. Разместить на карте
lua
{
  id = 'player_my_building',
  side = 'player',
  type = 'my_building',

  x = 20,
  z = 35,
  yaw = math.pi,

  built = false,
  routeId = 'player_center'
}
Если здание должно стрелять, нанимать войска или определять победу, потребуется добавить его поведение в building_system.lua. Сейчас специальная логика существует только для башни, казармы и алтаря.

3. Новая карта
Шаг 1. Создать файл
text
maps/my_map.lua
Минимальная структура:

lua
return {
  id = 'my_map',
  name = 'My Map',

  description = 'Map description.',
  preview = nil,

  victoryCondition = 'altar',

  music = {
    path = 'music/my_map.mp3',
    volume = .35,
    loop = true
  },

  economy = {
    startingGold = 1000,
    incomeAmount = 25,
    incomeInterval = 1.2
  },

  field = {
    width = 120,
    length = 180,

    floorY = 0,
    floorThickness = .2,

    ground = {
      texture = 'textures/maps/my_map/ground.png',
      tileSize = 24,
      visualWidth = 600,
      visualLength = 600
    },

    sky = {
      texture = 'textures/maps/my_map/sky.png',
      radius = 300,
      alpha = 1
    }
  },

  squads = {
    player = {
      slot = 'light_infantry',

      groups = {
        {
          count = 20,
          x = 0,
          z = 40,
          defaultRoute = 'player_center'
        }
      }
    },

    enemy = {
      slot = 'light_infantry',

      groups = {
        {
          count = 20,
          x = 0,
          z = -40,
          defaultRoute = 'enemy_center'
        }
      }
    }
  },

  buildings = {},
  routes = {
    player = {},
    enemy = {}
  },

  enemyScript = {
    duration = 300,
    events = {}
  },

  decors = {}
}
Шаг 2. Зарегистрировать карту
В maplist.lua:

lua
return {
  require('maps.test_field'),
  require('maps.fortress_battle'),
  require('maps.my_map')
}
Шаг 3. Добавить в кампанию
В campaigns/main.lua:

lua
{
  map = 'my_map',
  scene = 'my_map_intro',
  playerSide = 'human',
  enemySide = 'orcs'
}
Сцену регистрируй в scenes/scenelist.lua.

4. Фоны и превью
Рекомендуемая структура:

text
textures/ui/backgrounds/main_menu.png
textures/ui/backgrounds/battle_setup.png

textures/ui/previews/maps/my_map.png
textures/ui/previews/sides/human.png
textures/ui/previews/sides/orcs.png
textures/ui/previews/units/my_unit.png

textures/scenes/my_map_intro.png
В карте:

lua
preview =
  'textures/ui/previews/maps/my_map.png'
Во фракции:

lua
preview =
  'textures/ui/previews/sides/human.png'
Скин самой 3D-модели хранится рядом с моделью:

text
models/my_unit/my_unit_texture.png
и подключается через:

lua
texture =
  'models/my_unit/my_unit_texture.png'
  
  
  5. Укажи превью
В файле карты:

lua
preview =
  'textures/ui/previews/maps/fortress_battle.png',
Во фракции людей:

lua
preview =
  'textures/ui/previews/sides/human.png',
Во фракции орков:

lua
preview =
  'textures/ui/previews/sides/orcs.png',
Структура файлов:

text
textures/ui/
+-- backgrounds/
¦   +-- main_menu.png
¦   L-- battle_setup.png
L-- previews/
    +-- maps/
    ¦   +-- test_field.png
    ¦   L-- fortress_battle.png
    L-- sides/
        +-- human.png
        L-- orcs.png
		
Картинки меню 
textures/ui/backgrounds/main_menu.png
textures/ui/backgrounds/battle_setup.png