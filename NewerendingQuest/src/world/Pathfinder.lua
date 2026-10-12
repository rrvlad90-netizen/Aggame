local Pathfinder = {}

local DIRECTIONS = {
    { x = 1,  z = 0,  cost = 1 },
    { x = -1, z = 0,  cost = 1 },
    { x = 0,  z = 1,  cost = 1 },
    { x = 0,  z = -1, cost = 1 },

    { x = 1,  z = 1,  cost = 1.4142 },
    { x = 1,  z = -1, cost = 1.4142 },
    { x = -1, z = 1,  cost = 1.4142 },
    { x = -1, z = -1, cost = 1.4142 }
}

local function makeKey(x, z)
    return x .. ":" .. z
end

local function heuristic(x1, z1, x2, z2)
    local dx = math.abs(x2 - x1)
    local dz = math.abs(z2 - z1)

    local diagonal = math.min(dx, dz)
    local straight = math.max(dx, dz) - diagonal

    return diagonal * 1.4142 + straight
end

local function push(heap, node)
    heap[#heap + 1] = node

    local index = #heap

    while index > 1 do
        local parent =
            math.floor(index / 2)

        if heap[parent].score <= node.score then
            break
        end

        heap[index] = heap[parent]
        index = parent
    end

    heap[index] = node
end

local function pop(heap)
    if #heap == 0 then
        return nil
    end

    local first = heap[1]
    local last = table.remove(heap)

    if #heap == 0 then
        return first
    end

    local index = 1

    while true do
        local left = index * 2
        local right = left + 1

        if left > #heap then
            break
        end

        local child = left

        if
            right <= #heap and
            heap[right].score <
            heap[left].score
        then
            child = right
        end

        if heap[child].score >= last.score then
            break
        end

        heap[index] = heap[child]
        index = child
    end

    heap[index] = last

    return first
end

local function reversePath(path)
    local result = {}

    for index = #path, 1, -1 do
        result[#result + 1] =
            path[index]
    end

    return result
end

function Pathfinder.find(
    world,
    startX,
    startZ,
    targetX,
    targetZ,
    collisionRadius,
    options
)
    options = options or {}

    local cellSize =
        options.cellSize or 40

    local maximumIterations =
        options.maximumIterations or 5000

    local zMargin =
        options.zMargin or cellSize * 6

    local function worldToGrid(x, z)
        return
            math.floor(
                (x - world.minX) /
                cellSize + 0.5
            ),
            math.floor(
                (z - world.minZ) /
                cellSize + 0.5
            )
    end

    local function gridToWorld(x, z)
        return
            world.minX + x * cellSize,
            world.minZ + z * cellSize
    end

    local startGridX, startGridZ =
        worldToGrid(startX, startZ)

    local targetGridX, targetGridZ =
        worldToGrid(targetX, targetZ)

    local minimumGridX = 0

    local maximumGridX =
        math.ceil(
            (world.maxX - world.minX) /
            cellSize
        )

    local minimumSearchZ =
        math.max(
            world.minZ,
            math.min(startZ, targetZ) -
            zMargin
        )

    local maximumSearchZ =
        math.min(
            world.maxZ,
            math.max(startZ, targetZ) +
            zMargin
        )

    local _, minimumGridZ =
        worldToGrid(
            world.minX,
            minimumSearchZ
        )

    local _, maximumGridZ =
        worldToGrid(
            world.minX,
            maximumSearchZ
        )

    local blockedCache = {}

    local function isBlocked(gridX, gridZ)
        if
            gridX < minimumGridX or
            gridX > maximumGridX or
            gridZ < minimumGridZ or
            gridZ > maximumGridZ
        then
            return true
        end

        local key =
            makeKey(gridX, gridZ)

        if blockedCache[key] ~= nil then
            return blockedCache[key]
        end

        local x, z =
            gridToWorld(gridX, gridZ)

        local blocked =
            world:collidesAt(
                x,
                z,
                collisionRadius
            )

        blockedCache[key] = blocked

        return blocked
    end

    local openHeap = {}
    local openScores = {}
    local closed = {}
    local parents = {}
    local costs = {}

    local startKey =
        makeKey(
            startGridX,
            startGridZ
        )

    costs[startKey] = 0

    local startNode = {
        x = startGridX,
        z = startGridZ,

        score =
            heuristic(
                startGridX,
                startGridZ,
                targetGridX,
                targetGridZ
            )
    }

    push(openHeap, startNode)
    openScores[startKey] = startNode.score

    local iterations = 0
    local finalNode = nil

    while
        #openHeap > 0 and
        iterations < maximumIterations
    do
        iterations = iterations + 1

        local current = pop(openHeap)

        local currentKey =
            makeKey(
                current.x,
                current.z
            )

        if
            not closed[currentKey] and
            openScores[currentKey] ==
            current.score
        then
            closed[currentKey] = true

            if
                current.x == targetGridX and
                current.z == targetGridZ
            then
                finalNode = current
                break
            end

            for _, direction in ipairs(
                DIRECTIONS
            ) do
                local nextX =
                    current.x +
                    direction.x

                local nextZ =
                    current.z +
                    direction.z

                local nextKey =
                    makeKey(nextX, nextZ)

                if
                    not closed[nextKey] and
                    not isBlocked(nextX, nextZ)
                then
                    local diagonal =
                        direction.x ~= 0 and
                        direction.z ~= 0

                    local cornerBlocked = false

                    if diagonal then
                        cornerBlocked =
                            isBlocked(
                                current.x +
                                direction.x,
                                current.z
                            ) or
                            isBlocked(
                                current.x,
                                current.z +
                                direction.z
                            )
                    end

                    if not cornerBlocked then
                        local newCost =
                            costs[currentKey] +
                            direction.cost

                        if
                            costs[nextKey] == nil or
                            newCost < costs[nextKey]
                        then
                            costs[nextKey] =
                                newCost

                            parents[nextKey] = {
                                x = current.x,
                                z = current.z
                            }

                            local score =
                                newCost +
                                heuristic(
                                    nextX,
                                    nextZ,
                                    targetGridX,
                                    targetGridZ
                                )

                            openScores[nextKey] =
                                score

                            push(openHeap, {
                                x = nextX,
                                z = nextZ,
                                score = score
                            })
                        end
                    end
                end
            end
        end
    end

    if not finalNode then
        return nil
    end

    local path = {}
    local current = finalNode

    while current do
        local x, z =
            gridToWorld(
                current.x,
                current.z
            )

        path[#path + 1] = {
            x = x,
            z = z
        }

        local key =
            makeKey(
                current.x,
                current.z
            )

        current = parents[key]
    end

    path = reversePath(path)

    -- Первая точка находится около самого скелета.
    if #path > 0 then
        table.remove(path, 1)
    end

    path[#path + 1] = {
        x = targetX,
        z = targetZ
    }

    return path
end

return Pathfinder