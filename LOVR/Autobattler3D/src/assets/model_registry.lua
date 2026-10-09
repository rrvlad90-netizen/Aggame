local ModelList =
  require('models.modellist')

local Md3Loader =
  require('src.md3.loader')

local GroupedObjLoader =
  require(
    'src.assets.grouped_obj_loader'
  )

assert(
  type(ModelList) == 'table',
  'models/modellist.lua must return a table'
)

local ModelRegistry = {}
ModelRegistry.__index = ModelRegistry


-- Создаёт задачу загрузки кадра.
local function createFrameTask(
  asset,
  animationName,
  sourceFrame,
  label
)
  return {
    label = label,

    run = function()
      asset:preloadFrame(
        animationName,
        sourceFrame
      )
    end
  }
end


-- Создаёт реестр моделей.
function ModelRegistry.new()
  local self =
    setmetatable({}, ModelRegistry)

  self.definitions = {}
  self.assets = {}

  self.defaultMaterial =
    lovr.graphics.newMaterial({})

  for _, definition in ipairs(
    ModelList
  ) do
    assert(
      definition.id,
      'Model definition has no id'
    )

    assert(
      not self.definitions[
        definition.id
      ],
      'Duplicate model id: ' ..
      definition.id
    )

    self.definitions[
      definition.id
    ] = definition
  end

  return self
end


-- Возвращает описание модели.
function ModelRegistry:getDefinition(
  modelId
)
  return assert(
    self.definitions[modelId],
    'Unknown model id: ' ..
    tostring(modelId)
  )
end


-- Загружает обычную OBJ-модель.
function ModelRegistry:loadObjAsset(
  definition
)
  local model =
    lovr.graphics.newModel(
      definition.path
    )

  local material = nil

  if definition.texture then
    local texture =
      lovr.graphics.newTexture(
        definition.texture
      )

    material =
      lovr.graphics.newMaterial({
        texture = texture
      })
  end

  return {
    kind = 'obj',
    model = model,
    material = material,
    definition = definition
  }
end


-- Загружает OBJ, разделённый по geoset.
function ModelRegistry:loadGroupedObjAsset(
  definition
)
  return GroupedObjLoader.load(
    definition
  )
end


-- Загружает составную MD3-модель.
function ModelRegistry:loadMd3Asset(
  definition
)
  local asset = {
    kind = 'md3',
    definition = definition,
    modelSetData = {}
  }


  -- Возвращает описание анимации.
  function asset:getAnimation(
    animationName
  )
    return assert(
      definition.animations
      and definition.animations[
        animationName
      ],
      'Unknown MD3 animation: ' ..
      tostring(animationName)
    )
  end


  -- Определяет набор моделей кадра.
  function asset:getModelSetId(
    animation,
    sourceFrame
  )
    if
      animation.frameModelSets
      and animation.frameModelSets[
        sourceFrame
      ]
    then
      return animation.frameModelSets[
        sourceFrame
      ]
    end

    return
      animation.modelSet
      or definition.defaultModelSet
      or 'default'
  end


-- Загружает постоянные данные набора.
function asset:getModelSetData(
  modelSetId
)
  if self.modelSetData[modelSetId] then
    return self.modelSetData[
      modelSetId
    ]
  end

  local modelSet =
    assert(
      definition.modelSets
      and definition.modelSets[
        modelSetId
      ],
      'Unknown MD3 model set: ' ..
      tostring(modelSetId)
    )

  local parts =
    assert(
      modelSet.parts,
      'MD3 model set has no parts'
    )

  assert(
    #parts >= 1
    and #parts <= 8,
    'MD3 model set must contain 1-8 parts'
  )

  local modelSetData = {
    id = modelSetId,
    parts = {}
  }

  for _, part in ipairs(parts) do
    local partPath =
      assert(
        part.path,
        'MD3 part has no path'
      )

    print(
      'Loading MD3: ' ..
      tostring(partPath)
    )

    modelSetData.parts[
      #modelSetData.parts + 1
    ] = {
      frameOffset =
        part.frameOffset or 0,

      data =
        Md3Loader.loadData(
          partPath,

          part.textures
            or part.texture
            or {},

          part.zOffset or 0
        )
    }
  end

  self.modelSetData[modelSetId] =
    modelSetData

  return modelSetData
end


  -- Преобразует кадр описания
  -- в индекс кадра MD3.
  function asset:getMd3Frame(
    animation,
    sourceFrame
  )
    local sourceFrameBase =
      animation.sourceFrameBase
      or definition.sourceFrameBase
      or 1

    return
      sourceFrame -
      sourceFrameBase
  end


  -- Предварительно создаёт кадр.
  function asset:preloadFrame(
    animationName,
    sourceFrame
  )
    local animation =
      self:getAnimation(
        animationName
      )

    local modelSetId =
      self:getModelSetId(
        animation,
        sourceFrame
      )

    local md3Frame =
      self:getMd3Frame(
        animation,
        sourceFrame
      )

    local modelSetData =
      self:getModelSetData(
        modelSetId
      )

    for _, part in ipairs(
      modelSetData.parts
    ) do
      part.data:preloadFrame(
        md3Frame +
        part.frameOffset
      )
    end
  end


  -- Создаёт экземпляр MD3-модели.
  function asset:createInstance()
    local instance = {
      asset = self,
      modelSets = {},
      currentModelSet = nil,
      currentModelSetId = nil,
      currentFrame = nil
    }


    -- Создаёт экземпляры частей набора.
    function instance:getModelSetInstance(
      modelSetId
    )
      if self.modelSets[modelSetId] then
        return self.modelSets[
          modelSetId
        ]
      end

      local modelSetData =
        self.asset:getModelSetData(
          modelSetId
        )

      local modelSetInstance = {
        data = modelSetData,
        parts = {}
      }

      for _, partData in ipairs(
        modelSetData.parts
      ) do
        modelSetInstance.parts[
          #modelSetInstance.parts + 1
        ] = {
          frameOffset =
            partData.frameOffset,

          instance =
            partData.data:
              createInstance()
        }
      end

      self.modelSets[modelSetId] =
        modelSetInstance

      return modelSetInstance
    end


    -- Устанавливает кадр.
    function instance:setFrame(
      animationName,
      sourceFrame
    )
      local animation =
        self.asset:getAnimation(
          animationName
        )

      local modelSetId =
        self.asset:getModelSetId(
          animation,
          sourceFrame
        )

      local md3Frame =
        self.asset:getMd3Frame(
          animation,
          sourceFrame
        )

      local modelSetInstance =
        self:getModelSetInstance(
          modelSetId
        )

      for _, part in ipairs(
        modelSetInstance.parts
      ) do
        part.instance:setFrame(
          md3Frame +
          part.frameOffset
        )
      end

      self.currentModelSet =
        modelSetInstance

      self.currentModelSetId =
        modelSetId

      self.currentFrame =
        md3Frame
    end


    -- Рисует активный набор.
    function instance:draw(
      pass,
      x,
      y,
      z,
      scale,
      yaw,
      defaultMaterial,
      alpha,
      tint
    )
      if not self.currentModelSet then
        return
      end

      for _, part in ipairs(
        self.currentModelSet.parts
      ) do
        part.instance:draw(
          pass,
          x,
          y,
          z,
          scale,
          yaw,
          defaultMaterial,
          alpha,
          tint
        )
      end
    end


    return instance
  end


  return asset
end


-- Загружает ресурс по формату.
function ModelRegistry:loadAsset(modelId)
  local definition =
    self:getDefinition(modelId)

  local asset

  if definition.format == 'md3' then
    asset =
      self:loadMd3Asset(
        definition
      )

  elseif
    definition.format ==
      'multi_obj'
  then
    local MultiObjLoader =
      require(
        'src.assets.multi_obj_loader'
      )

    asset =
      MultiObjLoader.load(
        definition
      )

  elseif
    definition.format ==
      'grouped_obj'
  then
    asset =
      self:loadGroupedObjAsset(
        definition
      )

  else
    asset =
      self:loadObjAsset(
        definition
      )
  end

  self.assets[modelId] = asset

  return asset
end


-- Возвращает загруженный ресурс.
function ModelRegistry:get(modelId)
  if not self.assets[modelId] then
    return self:loadAsset(
      modelId
    )
  end

  return self.assets[modelId]
end


-- Создаёт очередь предварительной
-- загрузки кадров.
function ModelRegistry:createPreloadQueue(
  modelIds
)
  local queue = {
    tasks = {},
    index = 1,
    completed = 0,
    total = 0,
    currentLabel = '',
    finished = false
  }

  local knownTasks = {}

  for _, modelId in ipairs(
    modelIds or {}
  ) do
    local definition =
      self:getDefinition(
        modelId
      )

    if definition.format == 'md3' then
      local asset =
        self:get(modelId)

      local animationNames =
        definition.preloadAnimations
        or {}

      for _, animationName in ipairs(
        animationNames
      ) do
        local animation =
          asset:getAnimation(
            animationName
          )

        for sourceFrame =
          animation.firstFrame,
          animation.lastFrame
        do
          local modelSetId =
            asset:getModelSetId(
              animation,
              sourceFrame
            )

          local md3Frame =
            asset:getMd3Frame(
              animation,
              sourceFrame
            )

          local taskKey =
            modelId ..
            ':' ..
            modelSetId ..
            ':' ..
            tostring(md3Frame)

          if not knownTasks[taskKey] then
            knownTasks[taskKey] = true

            local label =
              modelId ..
              ' / ' ..
              animationName ..
              ' / ' ..
              tostring(sourceFrame)

            queue.tasks[
              #queue.tasks + 1
            ] = createFrameTask(
              asset,
              animationName,
              sourceFrame,
              label
            )
          end
        end
      end
    end
  end

  queue.total =
    #queue.tasks

  queue.finished =
    queue.total == 0

  return queue
end


-- Выполняет задачи загрузки.
function ModelRegistry:updatePreloadQueue(
  queue,
  taskCount
)
  if
    not queue
    or queue.finished
  then
    return true
  end

  taskCount =
    taskCount or 1

  for _ = 1, taskCount do
    local task =
      queue.tasks[
        queue.index
      ]

    if not task then
      queue.finished = true
      break
    end

    queue.currentLabel =
      task.label

    task.run()

    queue.completed =
      queue.completed + 1

    queue.index =
      queue.index + 1
  end

  if queue.completed >= queue.total then
    queue.finished = true
  end

  return queue.finished
end


-- Возвращает прогресс загрузки.
function ModelRegistry:getPreloadProgress(
  queue
)
  if
    not queue
    or queue.total == 0
  then
    return 1
  end

  return math.min(
    1,
    queue.completed /
    queue.total
  )
end


return ModelRegistry