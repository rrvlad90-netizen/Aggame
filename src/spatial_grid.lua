local SpatialGrid = {}
SpatialGrid.__index = SpatialGrid

-- Создаёт индекс, разбивающий мир на горизонтальные секции.
function SpatialGrid:new(cellSize)
    local grid = setmetatable({}, SpatialGrid)

    grid.cellSize = math.max(32, cellSize or 256)
    grid.buckets = {}

    return grid
end

-- Полностью очищает индекс.
function SpatialGrid:clear()
    self.buckets = {}
end

-- Возвращает номера секций, пересекаемых прямоугольником.
function SpatialGrid:getCellRange(rect, padding)
    rect = rect or {}
    padding = padding or 0

    local left = (rect.x or 0) - padding
    local right = (rect.x or 0) + (rect.w or 0) + padding

    return math.floor(left / self.cellSize),
        math.floor(right / self.cellSize)
end

-- Добавляет объект во все горизонтальные секции его hitbox.
function SpatialGrid:insert(item, rect)
    if not item or not rect then
        return
    end

    local firstCell, lastCell = self:getCellRange(rect)

    for cell = firstCell, lastCell do
        self.buckets[cell] = self.buckets[cell] or {}
        table.insert(self.buckets[cell], item)
    end
end

-- Перестраивает индекс для переданного списка объектов.
function SpatialGrid:rebuild(items, getRect)
    self:clear()

    for _, item in ipairs(items or {}) do
        local rect = getRect and getRect(item) or nil

        if rect then
            self:insert(item, rect)
        end
    end
end

-- Возвращает уникальные объекты из пересекаемых секций.
function SpatialGrid:query(rect, padding)
    if not rect then
        return {}
    end

    local result = {}
    local seen = {}
    local firstCell, lastCell = self:getCellRange(rect, padding)

    for cell = firstCell, lastCell do
        for _, item in ipairs(self.buckets[cell] or {}) do
            if not seen[item] then
                seen[item] = true
                table.insert(result, item)
            end
        end
    end

    return result
end

return SpatialGrid