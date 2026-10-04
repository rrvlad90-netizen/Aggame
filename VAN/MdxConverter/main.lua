local INPUT = 'MDX/HiveGuard2.mdx'
local BLP_INPUT = 'MDX/none.blp'
local OUTPUT_DIR = [[D:\Converted]]

local normalizedBLP = BLP_INPUT:gsub('\\', '/')
local textureBase = normalizedBLP:match('([^/]+)%.blp$') or 'texture'

local TEXTURE = textureBase .. '.png'
local PNG_OUTPUT = OUTPUT_DIR .. '\\' .. TEXTURE

local FPS = 15
local SCALE = 1.0
local FLIP_V = false
local REVERSE_WINDING = true

---FOR SKIP!!!!!
local SKIP_GEOSETS = {
--geoset_01 = true,
--geoset_02 = true,
--geoset_03 = true,
--geoset_04 = true,

--geoset_05 = true,
--geoset_06 = true,
--geoset_07 = true,
--geoset_08 = true,
--geoset_09 = true,

--geoset_10 = true,
--geoset_11 = true,
--geoset_12 = true,
--geoset_13 = true,
--geoset_14 = true,  
--geoset_15 = true,  
--geoset_16 = true,--
  
--geoset_17 = true,  
--geoset_18 = true,  
--geoset_19 = true,  
--geoset_20 = true,  
--geoset_21 = true,    
--geoset_22 = true,   
--geoset_23 = true,  
--geoset_24 = true,  
--geoset_25 = true, --  
}
-- Binary reader ---------------------------------------------------------------

local Reader = {}
Reader.__index = Reader

function Reader.new(data)
  return setmetatable({ data = data, pos = 1 }, Reader)
end

function Reader:u8()
  local value = self.data:byte(self.pos)
  assert(value, 'Unexpected end of file')
  self.pos = self.pos + 1
  return value
end

function Reader:u16()
  local a, b = self.data:byte(self.pos, self.pos + 1)
  assert(b, 'Unexpected end of file')
  self.pos = self.pos + 2
  return a + b * 256
end

function Reader:u32()
  local a, b, c, d = self.data:byte(self.pos, self.pos + 3)
  assert(d, 'Unexpected end of file')
  self.pos = self.pos + 4
  return a + b * 256 + c * 65536 + d * 16777216
end

function Reader:f32()
  local bits = self:u32()
  local sign = bits >= 0x80000000 and -1 or 1

  if bits >= 0x80000000 then
    bits = bits - 0x80000000
  end

  local exponent = math.floor(bits / 0x800000)
  local mantissa = bits % 0x800000

  if exponent == 0 then
    return sign * mantissa * 2^-149
  elseif exponent == 255 then
    return mantissa == 0 and sign * math.huge or 0 / 0
  end

  return sign * (1 + mantissa / 0x800000) * 2^(exponent - 127)
end

function Reader:tag()
  local value = self.data:sub(self.pos, self.pos + 3)
  assert(#value == 4, 'Unexpected end of file')
  self.pos = self.pos + 4
  return value
end

function Reader:skip(bytes)
  self.pos = self.pos + bytes
end

-- Binary writer ---------------------------------------------------------------

local Writer = {}
Writer.__index = Writer

function Writer.new()
  return setmetatable({ parts = {}, size = 0 }, Writer)
end

function Writer:bytes(value)
  self.parts[#self.parts + 1] = value
  self.size = self.size + #value
end

function Writer:u8(value)
  self:bytes(string.char(value % 256))
end

function Writer:u16(value)
  if value < 0 then value = value + 65536 end

  self:bytes(string.char(
    value % 256,
    math.floor(value / 256) % 256
  ))
end

function Writer:u32(value)
  if value < 0 then value = value + 4294967296 end

  self:bytes(string.char(
    value % 256,
    math.floor(value / 256) % 256,
    math.floor(value / 65536) % 256,
    math.floor(value / 16777216) % 256
  ))
end

function Writer:f32(value)
  local sign = 0

  if value < 0 then
    sign = 0x80000000
    value = -value
  end

  if value == 0 then
    self:u32(sign)
    return
  end

  local mantissa, exponent = math.frexp(value)
  exponent = exponent + 126

  local fraction

  if exponent <= 0 then
    exponent = 0
    fraction = math.floor(value / 2^-149 + .5)
  elseif exponent >= 255 then
    exponent = 255
    fraction = 0
  else
    fraction = math.floor((mantissa * 2 - 1) * 0x800000 + .5)

    if fraction >= 0x800000 then
      fraction = 0
      exponent = exponent + 1
    end
  end

  self:u32(sign + exponent * 0x800000 + fraction)
end

function Writer:fixedString(value, length)
  value = value:sub(1, length - 1)
  self:bytes(value .. string.rep('\0', length - #value))
end

function Writer:result()
  return table.concat(self.parts)
end

-- MDX parser ------------------------------------------------------------------

local function expectTag(reader, expected)
  local actual = reader:tag()
  assert(actual == expected,
    string.format('Expected %s, got %s', expected, actual))
end

local function readFloatArray(reader, expected, width)
  expectTag(reader, expected)

  local count = reader:u32()
  local result = {}

  for i = 1, count do
    result[i] = {}

    for component = 1, width do
      result[i][component] = reader:f32()
    end
  end

  return result
end

local function readIntegerArray(reader, expected, width)
  expectTag(reader, expected)

  local count = reader:u32()
  local result = {}

  for i = 1, count do
    if width == 1 then
      result[i] = reader:u8()
    elseif width == 2 then
      result[i] = reader:u16()
    else
      result[i] = reader:u32()
    end
  end

  return result
end

local function readTrack(reader, components)
  local track = {
    interpolation = reader:u32(),
    globalSequence = reader:u32(),
    keys = {}
  }

  local count = track.interpolation
  track.interpolation = track.globalSequence
  track.globalSequence = reader:u32()

  -- Исправляем порядок полей:
  -- после тега идут count, interpolation, globalSequence.
  track.keys = {}

  for i = 1, count do
    local key = {
      time = reader:u32(),
      value = {}
    }

    for component = 1, components do
      key.value[component] = reader:f32()
    end

    if track.interpolation > 1 then
      key.inTan = {}
      key.outTan = {}

      for component = 1, components do
        key.inTan[component] = reader:f32()
      end

      for component = 1, components do
        key.outTan[component] = reader:f32()
      end
    end

    track.keys[i] = key
  end

  return track
end

local function readAnimationTrack(reader, components)
  local count = reader:u32()
  local interpolation = reader:u32()
  local globalSequence = reader:u32()

  local track = {
    interpolation = interpolation,
    globalSequence = globalSequence,
    keys = {}
  }

  for i = 1, count do
    local key = {
      time = reader:u32(),
      value = {}
    }

    for component = 1, components do
      key.value[component] = reader:f32()
    end

    if interpolation > 1 then
      key.inTan = {}
      key.outTan = {}

      for component = 1, components do
        key.inTan[component] = reader:f32()
      end

      for component = 1, components do
        key.outTan[component] = reader:f32()
      end
    end

    track.keys[i] = key
  end

  return track
end

local function parseNode(reader, finish, reservedBytes)
  local node = {
    name = reader.data:sub(reader.pos, reader.pos + 79):match('^[^%z]*'),
    tracks = {}
  }

  reader:skip(80)

  node.id = reader:u32()
  node.parent = reader:u32()
  node.flags = reader:u32()

  while reader.pos < finish - reservedBytes do
    local tag = reader:tag()

    if tag == 'KGTR' then
      node.tracks.translation = readAnimationTrack(reader, 3)
    elseif tag == 'KGRT' then
      node.tracks.rotation = readAnimationTrack(reader, 4)
    elseif tag == 'KGSC' then
      node.tracks.scale = readAnimationTrack(reader, 3)
    else
      error('Unsupported node track: ' .. tag)
    end
  end

  return node
end

local function parseNodeChunk(reader, finish, nodes, isBone)
  while reader.pos < finish do
    local start = reader.pos
    local size = reader:u32()
    local recordFinish = start + size

    assert(recordFinish <= finish, 'Invalid node size')

    local node = parseNode(reader, recordFinish, 0)

    -- Размер относится только к общей части Node.
    reader.pos = recordFinish

    if isBone then
      node.geoset = reader:u32()
      node.geosetAnimation = reader:u32()
      node.isBone = true
    end

    nodes[node.id] = node
    -- Здесь reader.pos уже указывает на следующую запись.
  end
end

local function parseSequenceChunk(reader, finish)
  local sequences = {}

  while reader.pos + 132 <= finish do
    local sequence = {
      name = reader.data:sub(reader.pos, reader.pos + 79):match('^[^%z]*')
    }

    reader:skip(80)

    sequence.start = reader:u32()
    sequence.finish = reader:u32()
    sequence.moveSpeed = reader:f32()
    sequence.flags = reader:u32()
    sequence.rarity = reader:f32()
    sequence.syncPoint = reader:u32()

    reader:skip(28) -- bounds

    sequences[#sequences + 1] = sequence
  end

  return sequences
end

local function parseGeoset(reader)
  local start = reader.pos
  local size = reader:u32()
  local finish = start + size

  local geoset = {}

  geoset.vertices = readFloatArray(reader, 'VRTX', 3)
  geoset.normals = readFloatArray(reader, 'NRMS', 3)

  readIntegerArray(reader, 'PTYP', 4)
  readIntegerArray(reader, 'PCNT', 4)

  geoset.indices = readIntegerArray(reader, 'PVTX', 2)
  geoset.vertexGroups = readIntegerArray(reader, 'GNDX', 1)
  geoset.matrixGroups = readIntegerArray(reader, 'MTGC', 4)
  geoset.matrixIndices = readIntegerArray(reader, 'MATS', 4)

  geoset.material = reader:u32()

  reader:u32() -- selection group
  reader:u32() -- selection flags
  reader:skip(28)

  local sequenceBounds = reader:u32()
  reader:skip(sequenceBounds * 28)

  geoset.uvs = {}

  if reader.pos < finish
    and reader.data:sub(reader.pos, reader.pos + 3) == 'UVAS'
  then
    reader:skip(4)

    local sets = reader:u32()

    for set = 1, sets do
      geoset.uvs[set] = readFloatArray(reader, 'UVBS', 2)
    end
  end

  -- Строим список костей для каждой vertex group.
  geoset.boneGroups = {}

  local matrixOffset = 1

  for group, matrixCount in ipairs(geoset.matrixGroups) do
    local bones = {}

    for index = 1, matrixCount do
      bones[index] = geoset.matrixIndices[matrixOffset]
      matrixOffset = matrixOffset + 1
    end

    geoset.boneGroups[group] = bones
  end

  reader.pos = finish
  return geoset
end

local function parseMDX(data)
  local reader = Reader.new(data)

  assert(reader:tag() == 'MDLX', 'Not an MDX file')

  local model = {
    geosets = {},
    sequences = {},
    nodes = {},
    pivots = {}
  }

  while reader.pos <= #data - 7 do
    local chunk = reader:tag()
    local size = reader:u32()
    local finish = reader.pos + size

    if chunk == 'VERS' then
      assert(reader:u32() == 800, 'Only MDX 800 is supported')

    elseif chunk == 'SEQS' then
      model.sequences = parseSequenceChunk(reader, finish)

    elseif chunk == 'GEOS' then
      while reader.pos < finish do
        model.geosets[#model.geosets + 1] = parseGeoset(reader)
      end

    elseif chunk == 'BONE' then
      parseNodeChunk(reader, finish, model.nodes, true)

    elseif chunk == 'HELP' then
      parseNodeChunk(reader, finish, model.nodes, false)

    elseif chunk == 'PIVT' then
      local id = 0

      while reader.pos + 12 <= finish do
        model.pivots[id] = {
          reader:f32(),
          reader:f32(),
          reader:f32()
        }

        id = id + 1
      end
    end

    reader.pos = finish
  end

  assert(#model.geosets > 0, 'No geosets found')
  assert(#model.sequences > 0, 'No animations found')

  return model
end

-- Animation -------------------------------------------------------------------

local function copyVector(value)
  local result = {}

  for i = 1, #value do
    result[i] = value[i]
  end

  return result
end

local function normalizeQuaternion(q)
  local length = math.sqrt(
    q[1] * q[1] +
    q[2] * q[2] +
    q[3] * q[3] +
    q[4] * q[4]
  )

  if length == 0 then
    return { 0, 0, 0, 1 }
  end

  return {
    q[1] / length,
    q[2] / length,
    q[3] / length,
    q[4] / length
  }
end

local function interpolateLinear(a, b, amount)
  local result = {}

  for i = 1, #a do
    result[i] = a[i] + (b[i] - a[i]) * amount
  end

  return result
end

local function slerp(a, b, amount)
  local dot = a[1] * b[1] + a[2] * b[2]
    + a[3] * b[3] + a[4] * b[4]

  local target = copyVector(b)

  if dot < 0 then
    dot = -dot

    for i = 1, 4 do
      target[i] = -target[i]
    end
  end

  if dot > .9995 then
    return normalizeQuaternion(interpolateLinear(a, target, amount))
  end

  dot = math.max(-1, math.min(1, dot))

  local angle = math.acos(dot)
  local divisor = math.sin(angle)

  return {
    (a[1] * math.sin((1 - amount) * angle)
      + target[1] * math.sin(amount * angle)) / divisor,

    (a[2] * math.sin((1 - amount) * angle)
      + target[2] * math.sin(amount * angle)) / divisor,

    (a[3] * math.sin((1 - amount) * angle)
      + target[3] * math.sin(amount * angle)) / divisor,

    (a[4] * math.sin((1 - amount) * angle)
      + target[4] * math.sin(amount * angle)) / divisor
  }
end

local function interpolateHermite(a, outTan, b, inTan, t)
  local t2 = t * t
  local t3 = t2 * t

  local h1 = 2 * t3 - 3 * t2 + 1
  local h2 = -2 * t3 + 3 * t2
  local h3 = t3 - 2 * t2 + t
  local h4 = t3 - t2

  local result = {}

  for i = 1, #a do
    result[i] = h1 * a[i] + h2 * b[i]
      + h3 * outTan[i] + h4 * inTan[i]
  end

  return result
end

local function interpolateBezier(a, outTan, b, inTan, t)
  local inverse = 1 - t
  local result = {}

  for i = 1, #a do
    result[i] =
      inverse^3 * a[i] +
      3 * inverse^2 * t * outTan[i] +
      3 * inverse * t^2 * inTan[i] +
      t^3 * b[i]
  end

  return result
end

local function sampleTrack(track, time, sequence, default, quaternion)
  if not track then
    return copyVector(default)
  end

  local previous
  local following

  for _, key in ipairs(track.keys) do
    if key.time >= sequence.start and key.time <= sequence.finish then
      if key.time <= time then
        previous = key
      end

      if key.time >= time then
        following = key
        break
      end
    end
  end

  if not previous and not following then
    return copyVector(default)
  elseif not previous then
    return copyVector(following.value)
  elseif not following then
    return copyVector(previous.value)
  elseif previous == following or previous.time == following.time then
    return copyVector(previous.value)
  end

  local amount =
    (time - previous.time) / (following.time - previous.time)

  local result

  if track.interpolation == 0 then
    result = copyVector(previous.value)

  elseif track.interpolation == 1 then
    if quaternion then
      result = slerp(previous.value, following.value, amount)
    else
      result = interpolateLinear(previous.value, following.value, amount)
    end

  elseif track.interpolation == 2 then
    result = interpolateHermite(
      previous.value,
      previous.outTan,
      following.value,
      following.inTan,
      amount
    )

  else
    result = interpolateBezier(
      previous.value,
      previous.outTan,
      following.value,
      following.inTan,
      amount
    )
  end

  return quaternion and normalizeQuaternion(result) or result
end

-- Affine matrices -------------------------------------------------------------

local IDENTITY_MATRIX = {
  1, 0, 0,
  0, 1, 0,
  0, 0, 1
}

local function quaternionMatrix(q)
  local x, y, z, w = q[1], q[2], q[3], q[4]

  return {
    1 - 2 * y * y - 2 * z * z,
    2 * x * y - 2 * z * w,
    2 * x * z + 2 * y * w,

    2 * x * y + 2 * z * w,
    1 - 2 * x * x - 2 * z * z,
    2 * y * z - 2 * x * w,

    2 * x * z - 2 * y * w,
    2 * y * z + 2 * x * w,
    1 - 2 * x * x - 2 * y * y
  }
end

local function multiplyMatrix(a, b)
  local result = {}

  for row = 0, 2 do
    for column = 0, 2 do
      result[row * 3 + column + 1] =
        a[row * 3 + 1] * b[column + 1] +
        a[row * 3 + 2] * b[column + 4] +
        a[row * 3 + 3] * b[column + 7]
    end
  end

  return result
end

local function transformDirection(matrix, value)
  return {
    matrix[1] * value[1] + matrix[2] * value[2] + matrix[3] * value[3],
    matrix[4] * value[1] + matrix[5] * value[2] + matrix[6] * value[3],
    matrix[7] * value[1] + matrix[8] * value[2] + matrix[9] * value[3]
  }
end

local function transformPoint(transform, value)
  local result = transformDirection(transform.matrix, value)

  result[1] = result[1] + transform.offset[1]
  result[2] = result[2] + transform.offset[2]
  result[3] = result[3] + transform.offset[3]

  return result
end

local function composeTransform(parent, child)
  local offset = transformDirection(parent.matrix, child.offset)

  return {
    matrix = multiplyMatrix(parent.matrix, child.matrix),

    offset = {
      offset[1] + parent.offset[1],
      offset[2] + parent.offset[2],
      offset[3] + parent.offset[3]
    }
  }
end

local function buildPose(model, sequence, time)
  local cache = {}

  local function getTransform(id)
    if cache[id] then
      return cache[id]
    end

    local node = model.nodes[id]

    if not node then
      return {
        matrix = IDENTITY_MATRIX,
        offset = { 0, 0, 0 }
      }
    end

    local translation = sampleTrack(
      node.tracks.translation,
      time,
      sequence,
      { 0, 0, 0 },
      false
    )

    local rotation = sampleTrack(
      node.tracks.rotation,
      time,
      sequence,
      { 0, 0, 0, 1 },
      true
    )

    local scale = sampleTrack(
      node.tracks.scale,
      time,
      sequence,
      { 1, 1, 1 },
      false
    )

    local matrix = quaternionMatrix(rotation)

    -- rotation * scale
    matrix[1], matrix[4], matrix[7] =
      matrix[1] * scale[1],
      matrix[4] * scale[1],
      matrix[7] * scale[1]

    matrix[2], matrix[5], matrix[8] =
      matrix[2] * scale[2],
      matrix[5] * scale[2],
      matrix[8] * scale[2]

    matrix[3], matrix[6], matrix[9] =
      matrix[3] * scale[3],
      matrix[6] * scale[3],
      matrix[9] * scale[3]

    local pivot = model.pivots[id] or { 0, 0, 0 }
    local transformedPivot = transformDirection(matrix, pivot)

    local localTransform = {
      matrix = matrix,

      offset = {
        translation[1] + pivot[1] - transformedPivot[1],
        translation[2] + pivot[2] - transformedPivot[2],
        translation[3] + pivot[3] - transformedPivot[3]
      }
    }

    if node.parent ~= 0xffffffff and model.nodes[node.parent] then
      localTransform = composeTransform(
        getTransform(node.parent),
        localTransform
      )
    end

    cache[id] = localTransform
    return localTransform
  end

  for id in pairs(model.nodes) do
    getTransform(id)
  end

  return cache
end

local function normalize(value)
  local length = math.sqrt(
    value[1] * value[1] +
    value[2] * value[2] +
    value[3] * value[3]
  )

  if length == 0 then
    return { 0, 0, 1 }
  end

  return {
    value[1] / length,
    value[2] / length,
    value[3] / length
  }
end

local function skinGeoset(geoset, pose)
  local result = {
    vertices = {},
    normals = {}
  }

  for index, vertex in ipairs(geoset.vertices) do
    local groupIndex = geoset.vertexGroups[index] + 1
    local bones = geoset.boneGroups[groupIndex] or {}

    local position = { 0, 0, 0 }
    local normal = { 0, 0, 0 }
    local count = 0

    for _, boneId in ipairs(bones) do
      local transform = pose[boneId]

      if transform then
        local p = transformPoint(transform, vertex)
        local n = transformDirection(transform.matrix, geoset.normals[index])

        position[1] = position[1] + p[1]
        position[2] = position[2] + p[2]
        position[3] = position[3] + p[3]

        normal[1] = normal[1] + n[1]
        normal[2] = normal[2] + n[2]
        normal[3] = normal[3] + n[3]

        count = count + 1
      end
    end

    if count == 0 then
      position = copyVector(vertex)
      normal = copyVector(geoset.normals[index])
    else
      position[1] = position[1] / count
      position[2] = position[2] / count
      position[3] = position[3] / count

      normal[1] = normal[1] / count
      normal[2] = normal[2] / count
      normal[3] = normal[3] / count
    end

    result.vertices[index] = {
      position[1] * SCALE,
      position[2] * SCALE,
      position[3] * SCALE
    }

    result.normals[index] = normalize(normal)
  end

  return result
end

local function bakeSequence(model, sequence)
  local duration = sequence.finish - sequence.start
  local frameCount = math.floor(duration * FPS / 1000 + .5) + 1

  assert(frameCount <= 1024,
    sequence.name .. ' exceeds MD3 frame limit')

  local frames = {}

  for frame = 1, frameCount do
    local amount = frameCount == 1 and 0
      or (frame - 1) / (frameCount - 1)

    local time = sequence.start + duration * amount
    local pose = buildPose(model, sequence, time)

    local baked = {
      geosets = {},
      minimum = { math.huge, math.huge, math.huge },
      maximum = { -math.huge, -math.huge, -math.huge },
      radius = 0
    }

    for geosetIndex, geoset in ipairs(model.geosets) do
      local skinned = skinGeoset(geoset, pose)
      baked.geosets[geosetIndex] = skinned

      for _, vertex in ipairs(skinned.vertices) do
        for axis = 1, 3 do
          baked.minimum[axis] = math.min(baked.minimum[axis], vertex[axis])
          baked.maximum[axis] = math.max(baked.maximum[axis], vertex[axis])
        end

        baked.radius = math.max(baked.radius, math.sqrt(
          vertex[1]^2 + vertex[2]^2 + vertex[3]^2
        ))
      end
    end

    frames[frame] = baked
  end

  return frames
end

-- MD3 writer ------------------------------------------------------------------

local function encodeNormal(normal)
  local latitude = math.floor(
    math.atan2(normal[2], normal[1]) * 255 / (2 * math.pi)
  ) % 256

  local longitude = math.floor(
    math.acos(math.max(-1, math.min(1, normal[3])))
      * 255 / (2 * math.pi)
  ) % 256

  return latitude * 256 + longitude
end

local function md3Coordinate(value)
  assert(value == value and value ~= math.huge and value ~= -math.huge,
    'Invalid MD3 vertex coordinate: ' .. tostring(value))

  local scaled = value * 64
  local encoded

  if scaled >= 0 then
    encoded = math.floor(scaled + 0.5)
  else
    encoded = math.ceil(scaled - 0.5)
  end

  assert(
    encoded >= -32768 and encoded <= 32767,
    string.format(
      'Vertex coordinate %.6f is outside MD3 range [-512, 511.984375]; reduce SCALE',
      value
    )
  )

  return encoded
end

local function createSurface(geoset, frames, geosetIndex)
  local frameCount = #frames
  local vertexCount = #geoset.vertices
  local triangleCount = math.floor(#geoset.indices / 3)

  local triangleOffset = 108
  local shaderOffset = triangleOffset + triangleCount * 12
  local uvOffset = shaderOffset + 68
  local vertexOffset = uvOffset + vertexCount * 8
  local endOffset = vertexOffset + frameCount * vertexCount * 8

  local writer = Writer.new()

  writer:bytes('IDP3')
  writer:fixedString(string.format('geoset_%02d', geoset.originalIndex or geosetIndex), 64)
  writer:u32(0)
  writer:u32(frameCount)
  writer:u32(1)
  writer:u32(vertexCount)
  writer:u32(triangleCount)
  writer:u32(triangleOffset)
  writer:u32(shaderOffset)
  writer:u32(uvOffset)
  writer:u32(vertexOffset)
  writer:u32(endOffset)

  for triangle = 1, triangleCount do
    local offset = (triangle - 1) * 3
    local a = geoset.indices[offset + 1]
    local b = geoset.indices[offset + 2]
    local c = geoset.indices[offset + 3]

    if REVERSE_WINDING then
      b, c = c, b
    end

    writer:u32(a)
    writer:u32(b)
    writer:u32(c)
  end

  writer:fixedString(TEXTURE, 64)
  writer:u32(0)

  local uvs = geoset.uvs[1] or {}

  for vertex = 1, vertexCount do
    local uv = uvs[vertex] or { 0, 0 }

    writer:f32(uv[1])
    writer:f32(FLIP_V and 1 - uv[2] or uv[2])
  end

  for _, frame in ipairs(frames) do
    local geometry = frame.geosets[geosetIndex]

    for vertex = 1, vertexCount do
      local position = geometry.vertices[vertex]
      local normal = geometry.normals[vertex]

      writer:u16(md3Coordinate(position[1]))
      writer:u16(md3Coordinate(position[2]))
      writer:u16(md3Coordinate(position[3]))
      writer:u16(encodeNormal(normal))
    end
  end

  return writer:result()
end

local function createMD3(model, sequence, frames)
  local surfaces = {}
  local surfaceBytes = 0

  for index, geoset in ipairs(model.geosets) do
    surfaces[index] = createSurface(geoset, frames, index)
    surfaceBytes = surfaceBytes + #surfaces[index]
  end

  local framesOffset = 108
  local tagsOffset = framesOffset + #frames * 56
  local surfacesOffset = tagsOffset
  local endOffset = surfacesOffset + surfaceBytes

  local writer = Writer.new()

  writer:bytes('IDP3')
  writer:u32(15)
  writer:fixedString('MODEL_' .. sequence.name, 64)
  writer:u32(0)
  writer:u32(#frames)
  writer:u32(0)
  writer:u32(#surfaces)
  writer:u32(0)
  writer:u32(framesOffset)
  writer:u32(tagsOffset)
  writer:u32(surfacesOffset)
  writer:u32(endOffset)

  for index, frame in ipairs(frames) do
    for axis = 1, 3 do writer:f32(frame.minimum[axis]) end
    for axis = 1, 3 do writer:f32(frame.maximum[axis]) end

    writer:f32(0)
    writer:f32(0)
    writer:f32(0)
    writer:f32(frame.radius)

    writer:fixedString(
      string.format('%s_%04d', sequence.name, index - 1),
      16
    )
  end

  for _, surface in ipairs(surfaces) do
    writer:bytes(surface)
  end

  return writer:result()
end

local function safeName(name)
  return name:lower():gsub('[^%w_%-]', '_')
end

local function writeBinary(path, data)
  local file, errorMessage = io.open(path, 'wb')
  assert(file, 'Cannot write ' .. path .. ': ' .. tostring(errorMessage))

  file:write(data)
  file:close()
end


local function swapRedBlue(image)
  local width, height = image:getDimensions()

  for y = 0, height - 1 do
    for x = 0, width - 1 do
      local r, g, b, a = image:getPixel(x, y)
      image:setPixel(x, y, b, g, r, a)
    end
  end
end



local MD3_MAX_COORDINATE = 32767 / 64

local function getLargestCoordinate(frames)
  local largest = 0

  for _, frame in ipairs(frames) do
    for _, geometry in ipairs(frame.geosets) do
      for _, vertex in ipairs(geometry.vertices) do
        for axis = 1, 3 do
          local value = vertex[axis]

          assert(
            value == value and value ~= math.huge and value ~= -math.huge,
            'Animation produced an invalid vertex coordinate'
          )

          largest = math.max(largest, math.abs(value))
        end
      end
    end
  end

  return largest
end

local function scaleBakedFrames(frames, factor)
  for _, frame in ipairs(frames) do
    for _, geometry in ipairs(frame.geosets) do
      for _, vertex in ipairs(geometry.vertices) do
        vertex[1] = vertex[1] * factor
        vertex[2] = vertex[2] * factor
        vertex[3] = vertex[3] * factor
      end
    end

    for axis = 1, 3 do
      frame.minimum[axis] = frame.minimum[axis] * factor
      frame.maximum[axis] = frame.maximum[axis] * factor
    end

    frame.radius = frame.radius * factor
  end
end
-----------

local function filterGeosets(model)
  local filtered = {}

  print('')
  print('=== MDX GEOSET MAP ===')

  for index, geoset in ipairs(model.geosets) do
    geoset.originalIndex = index

    local geosetName = string.format('geoset_%02d', index)
    local skipped = SKIP_GEOSETS[geosetName] == true
    local status = skipped and 'SKIPPED' or 'INCLUDED'

    print(string.format(
      '%s | material=%d | vertices=%d | triangles=%d | %s',
      geosetName,
      geoset.material,
      #geoset.vertices,
      math.floor(#geoset.indices / 3),
      status
    ))

    if not skipped then
      filtered[#filtered + 1] = geoset
    end
  end

  print('======================')
  print('')

  assert(#filtered > 0, 'All geosets were excluded')
  model.geosets = filtered
end

local function convertBLPtoPNG(inputPath, outputPath)
  local data, readError = lovr.filesystem.read(inputPath)
  assert(data, 'Cannot read BLP: ' .. tostring(readError))

  local reader = Reader.new(data)

  assert(reader:tag() == 'BLP1', 'Only BLP1 is supported')

  local compression = reader:u32()
  local flags = reader:u32()
  local width = reader:u32()
  local height = reader:u32()

  reader:u32() -- picture type
  reader:u32() -- picture subtype

  local mipOffsets = {}
  local mipSizes = {}

  for i = 1, 16 do
    mipOffsets[i] = reader:u32()
  end

  for i = 1, 16 do
    mipSizes[i] = reader:u32()
  end

  assert(compression == 0,
    'This converter currently supports JPEG-compressed BLP1 only')

  local jpegHeaderSize = reader:u32()
  local jpegHeader = data:sub(
    reader.pos,
    reader.pos + jpegHeaderSize - 1
  )

  local mipOffset = mipOffsets[1]
  local mipSize = mipSizes[1]

  assert(mipOffset > 0 and mipSize > 0, 'BLP has no mip level 0')

  -- BLP offsets are zero-based.
  local jpegBody = data:sub(
    mipOffset + 1,
    mipOffset + mipSize
  )

  local jpegData = jpegHeader .. jpegBody
  local jpegBlob = lovr.data.newBlob(jpegData, 'Ballista.jpg')
  local image = lovr.data.newImage(jpegBlob)
  swapRedBlue(image)
  local pngBlob = image:encode()

  writeBinary(outputPath, pngBlob:getString())

  print(string.format(
    'Created %s (%dx%d, flags=%d)',
    outputPath,
    width,
    height,
    flags
  ))
end


-- LÖVR entry point -------------------------------------------------------------

function lovr.load()
  local source, errorMessage = lovr.filesystem.read(INPUT)

  assert(
    source,
    'Cannot read ' .. INPUT .. ': ' .. tostring(errorMessage)
  )

  local model = parseMDX(source)
  filterGeosets(model)

  local md3Limit = 32767 / 64
  local largestCoordinate = 0

  ---------------------------------------------------------------------------
  -- Первый проход: определяем максимальную координату.
  -- Кадры разных анимаций одновременно в памяти не хранятся.
  ---------------------------------------------------------------------------

  print('')
  print('Analyzing model scale...')

  for _, sequence in ipairs(model.sequences) do
    print('Analyzing: ' .. sequence.name)

    local frames = bakeSequence(model, sequence)

    for _, frame in ipairs(frames) do
      for _, geometry in ipairs(frame.geosets) do
        for _, vertex in ipairs(geometry.vertices) do
          for axis = 1, 3 do
            local value = vertex[axis]

            assert(
              value == value
                and value ~= math.huge
                and value ~= -math.huge,
              string.format(
                'Invalid coordinate in animation "%s"',
                sequence.name
              )
            )

            largestCoordinate = math.max(
              largestCoordinate,
              math.abs(value)
            )
          end
        end
      end
    end

    frames = nil
    collectgarbage('collect')
  end

  local fitScale = 1

  if largestCoordinate > md3Limit then
    fitScale = md3Limit / largestCoordinate * 0.999

    print(string.format(
      'Largest coordinate: %.6f',
      largestCoordinate
    ))

    print(string.format(
      'Applying global MD3 scale: %.8f',
      fitScale
    ))
  end

  ---------------------------------------------------------------------------
  -- Второй проход: запекаем и сразу сохраняем каждую анимацию.
  ---------------------------------------------------------------------------

  print('')
  print('Creating MD3 files...')

  for _, sequence in ipairs(model.sequences) do
    print('Baking: ' .. sequence.name)

    local frames = bakeSequence(model, sequence)

    if fitScale < 1 then
      for _, frame in ipairs(frames) do
        for _, geometry in ipairs(frame.geosets) do
          for _, vertex in ipairs(geometry.vertices) do
            vertex[1] = vertex[1] * fitScale
            vertex[2] = vertex[2] * fitScale
            vertex[3] = vertex[3] * fitScale
          end
        end

        for axis = 1, 3 do
          frame.minimum[axis] =
            frame.minimum[axis] * fitScale

          frame.maximum[axis] =
            frame.maximum[axis] * fitScale
        end

        frame.radius = frame.radius * fitScale
      end
    end

    local md3 = createMD3(model, sequence, frames)
    local filename =
      'MODEL_' .. safeName(sequence.name) .. '.md3'

    local path = OUTPUT_DIR .. '\\' .. filename

    writeBinary(path, md3)

    print(string.format(
      'Created %s: %d frames',
      path,
      #frames
    ))

    frames = nil
    md3 = nil
    collectgarbage('collect')
  end

  convertBLPtoPNG(BLP_INPUT, PNG_OUTPUT)

  source = nil
  collectgarbage('collect')

  print('Conversion complete')
end