local Utils = {}

-- Возвращает value, ограниченный диапазоном minValue..maxValue.
function Utils.clamp(value, minValue, maxValue)
    if value < minValue then
        return minValue
    end

    if value > maxValue then
        return maxValue
    end

    return value
end

-- Возвращает знак числа:
-- -1 если число меньше 0;
-- 1 если число больше 0;
-- 0 если число равно 0.
function Utils.sign(value)
    if value < 0 then
        return -1
    end

    if value > 0 then
        return 1
    end

    return 0
end

-- Линейная интерполяция между a и b.
-- t обычно от 0 до 1.
function Utils.lerp(a, b, t)
    return a + (b - a) * t
end

-- Плавно двигает current к target с ограничением maxDelta.
function Utils.approach(current, target, maxDelta)
    if current < target then
        return math.min(current + maxDelta, target)
    end

    if current > target then
        return math.max(current - maxDelta, target)
    end

    return target
end

-- Возвращает квадрат дистанции между двумя точками.
-- Полезно для сравнения расстояний без math.sqrt.
function Utils.distanceSquared(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1

    return dx * dx + dy * dy
end

-- Возвращает дистанцию между двумя точками.
function Utils.distance(x1, y1, x2, y2)
    return math.sqrt(Utils.distanceSquared(x1, y1, x2, y2))
end

-- Возвращает случайный элемент массива.
function Utils.randomChoice(items)
    if not items or #items == 0 then
        return nil
    end

    return items[math.random(1, #items)]
end

-- Возвращает true с указанной вероятностью.
-- chance = 1 значит 100%.
-- chance = 0.5 значит 50%.
function Utils.roll(chance)
    chance = chance or 0

    return math.random() <= chance
end

-- Возвращает defaultValue, если value == nil.
function Utils.default(value, defaultValue)
    if value == nil then
        return defaultValue
    end

    return value
end

-- Делает поверхностную копию таблицы.
-- Вложенные таблицы не копируются глубоко.
function Utils.copyTable(source)
    local result = {}

    for key, value in pairs(source or {}) do
        result[key] = value
    end

    return result
end

-- Делает глубокую копию значения.
-- Если значение не таблица, возвращает его как есть.
function Utils.deepCopy(value)
    if type(value) ~= "table" then
        return value
    end

    local result = {}

    for key, childValue in pairs(value) do
        result[key] = Utils.deepCopy(childValue)
    end

    return result
end

-- Объединяет modelConfig и overrideConfig.
-- Значения из overrideConfig заменяют значения модели.
function Utils.mergeConfig(modelConfig, overrideConfig)
    local result = Utils.deepCopy(modelConfig or {})

	for key, value in pairs(overrideConfig or {}) do
		if key == "owner" then
			result[key] = value
		else
			result[key] = Utils.deepCopy(value)
		end
	end

    return result
end

-- Проверяет, начинается ли строка value со строки prefix.
function Utils.startsWith(value, prefix)
    return string.sub(value, 1, #prefix) == prefix
end

-- Безопасно получает центр прямоугольника по X.
function Utils.centerX(rect)
    return rect.x + rect.w / 2
end

-- Безопасно получает центр прямоугольника по Y.
function Utils.centerY(rect)
    return rect.y + rect.h / 2
end

return Utils