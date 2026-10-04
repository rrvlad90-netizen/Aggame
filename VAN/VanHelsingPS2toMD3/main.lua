local OUTPUT_DIR = [[D:\VanConverted]]

local ARCHIVES = {
  { path = 'VAN/BANSHE~1.BIN', prefix = 'B1' },
  { path = 'VAN/BANSHE~2.BIN', prefix = 'B2' }
}

local WRITE_RAW_FILES = true
local DECODE_TEXTURES = true

-- PS2 texture options
local UNSWIZZLE_8_BIT = true
local UNSWIZZLE_CLUT = true
local DOUBLE_PS2_ALPHA = true
local FLIP_TEXTURE_Y = false

local CREATE_STATIC_MD3 = true
local MODEL_SCALE = 1.0
local SWAP_Y_Z = true
local REVERSE_WINDING = true
local FLIP_MD3_V = false

local status = 'Starting...'

-- Binary reader ---------------------------------------------------------------

local Reader = {}
Reader.__index = Reader

function Reader.new(data)
  return setmetatable({
    data = data,
    pos = 1
  }, Reader)
end

function Reader:u8()
  local value = self.data:byte(self.pos)
  assert(value, 'Unexpected end of data')
  self.pos = self.pos + 1
  return value
end

function Reader:u32()
  local a, b, c, d = self.data:byte(self.pos, self.pos + 3)
  assert(d, 'Unexpected end of data')

  self.pos = self.pos + 4

  return a
    + b * 256
    + c * 65536
    + d * 16777216
end

function Reader:skip(count)
  self.pos = self.pos + count
end

local function u32At(data, offset)
  local a, b, c, d = data:byte(offset + 1, offset + 4)
  assert(d, 'Invalid u32 offset: ' .. offset)

  return a
    + b * 256
    + c * 65536
    + d * 16777216
end

local function cStringAt(data, offset)
  local finish = data:find('\0', offset + 1, true)
  assert(finish, 'Unterminated archive filename')

  return data:sub(offset + 1, finish - 1)
end

-- Files -----------------------------------------------------------------------

local function joinPath(directory, filename)
  local last = directory:sub(-1)

  if last == '\\' or last == '/' then
    return directory .. filename
  end

  return directory .. '\\' .. filename
end

local function safeName(name)
  return name:gsub('[\\/:*?"<>|]', '_')
end

local function writeBinary(path, data)
  local file, message = io.open(path, 'wb')
  assert(file, 'Cannot create ' .. path .. ': ' .. tostring(message))

  file:write(data)
  file:close()
end

-- VAN BIN archive -------------------------------------------------------------

local function parseArchive(data)
  assert(#data >= 12, 'Archive is too small')

  local fileCount = u32At(data, 0)
  local dataOffset = u32At(data, 4)
  local blockSize = u32At(data, 8)

  local recordOffset = 12
  local recordSize = 36

  assert(fileCount > 0 and fileCount < 100000, 'Invalid file count')
  assert(blockSize > 0 and blockSize <= 4096, 'Invalid block size')
  assert(dataOffset < #data, 'Invalid archive data offset')

  local archive = {
    entries = {},
    dataOffset = dataOffset,
    blockSize = blockSize
  }

  for index = 0, fileCount - 1 do
    local record = recordOffset + index * recordSize

    assert(record + recordSize <= #data, 'Truncated archive table')

    -- +0  = reserved
    -- +4  = filename offset
    -- +8  = filename hash
    -- +12 = exact resource size
    -- +16 = reserved
    -- +20 = first data block
    -- +24 = allocated block count
    -- +28 = parent/reference
    -- +32 = reserved

    local nameOffset = u32At(data, record + 4)
    local hash = u32At(data, record + 8)
    local size = u32At(data, record + 12)
    local blockOffset = u32At(data, record + 20)
    local blockCount = u32At(data, record + 24)

    local payloadOffset =
      dataOffset + blockOffset * blockSize

    assert(
      payloadOffset + size <= #data,
      string.format(
        'Resource %d (%s) lies outside archive',
        index,
        cStringAt(data, nameOffset)
      )
    )

    assert(
      blockCount * blockSize >= size,
      'Resource exceeds allocated blocks'
    )

    archive.entries[#archive.entries + 1] = {
      name = cStringAt(data, nameOffset),
      hash = hash,
      size = size,
      offset = payloadOffset,
      blocks = blockCount
    }
  end

  return archive
end

local function byteArrayToString(values)
  local parts = {}
  local chunkSize = 4096

  for first = 1, #values, chunkSize do
    local last = math.min(first + chunkSize - 1, #values)

    parts[#parts + 1] = string.char(
      unpack(values, first, last)
    )
  end

  return table.concat(parts)
end

local function extractEntry(archiveData, entry)
  return archiveData:sub(
    entry.offset + 1,
    entry.offset + entry.size
  )
end

-- PS2 TEX decoder -------------------------------------------------------------

local bit = require 'bit'
local band = bit.band
local rshift = bit.rshift

local function unswizzle8(source, width, height)
  if width % 16 ~= 0 or height % 16 ~= 0 then
    print('Texture cannot be unswizzled safely; using linear pixels')
    return source
  end

  local output = {}

  for y = 0, height - 1 do
    for x = 0, width - 1 do
      local blockLocation =
        band(y, 0xfffffff0) * width
        + band(x, 0xfffffff0) * 2

      local swapSelector =
        band(rshift(y + 2, 2), 1) * 4

      local positionY =
        band(
          rshift(band(y, 0xfffffffc), 1) + band(y, 1),
          7
        )

      local columnLocation =
        positionY * width * 2
        + band(x + swapSelector, 7) * 4

      local byteNumber =
        band(rshift(y, 1), 1)
        + band(rshift(x, 2), 2)

      local sourceIndex =
        blockLocation + columnLocation + byteNumber

      output[y * width + x + 1] =
        source:byte(sourceIndex + 1) or 0
    end
  end

  return byteArrayToString(output)
end

local function clutIndex(index)
  if not UNSWIZZLE_CLUT then
    return index
  end

  local group = math.floor(index / 32) * 32
  local position = index % 32

  if position >= 8 and position < 16 then
    position = position + 8
  elseif position >= 16 and position < 24 then
    position = position - 8
  end

  return group + position
end

local function ps2Alpha(value)
  if not DOUBLE_PS2_ALPHA then
    return value
  end

  return math.min(255, value * 2)
end

local function setImagePixel(image, x, y, width, height, r, g, b, a)
  if FLIP_TEXTURE_Y then
    y = height - y - 1
  end

  image:setPixel(
    x,
    y,
    r / 255,
    g / 255,
    b / 255,
    a / 255
  )
end

local function decodeIndexedTexture(data, width, height)
  local pixelCount = width * height
  local pixelOffset = 32
  local paletteOffset = pixelOffset + pixelCount

  assert(
    #data >= paletteOffset + 1024,
    'Indexed TEX has no complete 256-color palette'
  )

  local indices = data:sub(
    pixelOffset + 1,
    pixelOffset + pixelCount
  )

  if UNSWIZZLE_8_BIT then
    indices = unswizzle8(indices, width, height)
  end

  local image = lovr.data.newImage(width, height)

  for y = 0, height - 1 do
    for x = 0, width - 1 do
      local pixel = y * width + x
      local index = indices:byte(pixel + 1)
      local paletteIndex = clutIndex(index)
      local color = paletteOffset + paletteIndex * 4

      local r = data:byte(color + 1)
      local g = data:byte(color + 2)
      local b = data:byte(color + 3)
      local a = ps2Alpha(data:byte(color + 4))

      setImagePixel(
        image, x, y, width, height,
        r, g, b, a
      )
    end
  end

  return image
end

local function decodeRGBA32Texture(data, width, height)
  local pixelCount = width * height
  local pixelOffset = 32

  assert(
    #data >= pixelOffset + pixelCount * 4,
    'RGBA TEX pixel data is truncated'
  )

  local image = lovr.data.newImage(width, height)

  for y = 0, height - 1 do
    for x = 0, width - 1 do
      local pixel = y * width + x
      local offset = pixelOffset + pixel * 4

      local r = data:byte(offset + 1)
      local g = data:byte(offset + 2)
      local b = data:byte(offset + 3)
      local a = ps2Alpha(data:byte(offset + 4))

      setImagePixel(
        image, x, y, width, height,
        r, g, b, a
      )
    end
  end

  return image
end

local function decodeTEX(data)
  assert(#data >= 32, 'TEX file is too small')

  local reader = Reader.new(data)

  local width = reader:u32()
  local height = reader:u32()
  local bitsPerPixel = reader:u32()
  local format = reader:u32()

  assert(width > 0 and width <= 4096, 'Invalid TEX width')
  assert(height > 0 and height <= 4096, 'Invalid TEX height')

  local image

  if bitsPerPixel == 8 and format == 19 then
    image = decodeIndexedTexture(data, width, height)
  elseif bitsPerPixel == 32 then
    image = decodeRGBA32Texture(data, width, height)
  else
    error(string.format(
      'Unsupported TEX format: %dx%d, bpp=%d, format=%d',
      width,
      height,
      bitsPerPixel,
      format
    ))
  end

  return image, {
    width = width,
    height = height,
    bitsPerPixel = bitsPerPixel,
    format = format
  }
end

local function isTexture(name)
  return name:upper():match('%.TEX$') ~= nil
end


-- VAN MDL -> static MD3 --------------------------------------------------------

local MODEL_TEXTURES = {
  'B2__BA_ARMHAIRLEG.png',
  'B2__BA_FACE.png',
  'B2__BA_TORSONECKEYE.png',
  'B2__BA_HANDFOOT.png',
  'B2__BA_EDGE.png',
  'B2__BA_TRANSCLOTH.png'
}

local function f32At(data, offset)
  local bits = u32At(data, offset)
  local sign = 1

  if bits >= 0x80000000 then
    sign = -1
    bits = bits - 0x80000000
  end

  local exponent = math.floor(bits / 0x800000)
  local mantissa = bits % 0x800000

  if exponent == 0 then
    return sign * mantissa * 2^-149
  elseif exponent == 255 then
    return mantissa == 0 and sign * math.huge or 0 / 0
  end

  return sign
    * (1 + mantissa / 0x800000)
    * 2^(exponent - 127)
end

local function normalize3(value)
  local length = math.sqrt(
    value[1]^2 + value[2]^2 + value[3]^2
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

local function convertVector(x, y, z, scale)
  scale = scale or 1

  if SWAP_Y_Z then
    return {
      x * scale,
      -z * scale,
      y * scale
    }
  end

  return {
    x * scale,
    y * scale,
    z * scale
  }
end

local function parseVanMDL(data)
  assert(#data >= 128, 'MDL is too small')

  local surfaceTable = u32At(data, 0x40)
  local surfaceCount = u32At(data, 0x3c)

  assert(surfaceCount > 0 and surfaceCount <= 32,
    'Invalid MDL surface count')

  assert(surfaceTable + surfaceCount * 96 <= #data,
    'Invalid MDL surface table')

  local model = {
    surfaces = {}
  }

  for surfaceIndex = 0, surfaceCount - 1 do
    local descriptor = surfaceTable + surfaceIndex * 96

    local typeValue = u32At(data, descriptor)
    local totalVertices = u32At(data, descriptor + 4)
    local packetCount = u32At(data, descriptor + 20)
    local packetCapacity = u32At(data, descriptor + 24)

    local positionTable = u32At(data, descriptor + 28)
    local normalTable = u32At(data, descriptor + 32)
    local skinTable = u32At(data, descriptor + 36)
    local uvTable = u32At(data, descriptor + 40)

    assert(typeValue == 5,
      'Unsupported MDL surface type: ' .. typeValue)

    assert(packetCapacity > 0 and packetCapacity <= 256,
      'Invalid MDL packet capacity')

    local surface = {
      vertices = {},
      normals = {},
      uvs = {},
      indices = {},
      skin = {},
      texture = MODEL_TEXTURES[surfaceIndex + 1]
        or 'texture.png'
    }

    local verticesRemaining = totalVertices

    for packetIndex = 0, packetCount - 1 do
      local vertexCount = math.min(
        packetCapacity,
        verticesRemaining
      )

      assert(vertexCount > 0,
        'MDL packet has no vertices')

      local positionOffset = u32At(
        data,
        positionTable + packetIndex * 4
      )

      local normalOffset = u32At(
        data,
        normalTable + packetIndex * 4
      )

      local skinOffset = u32At(
        data,
        skinTable + packetIndex * 4
      )

      local uvOffset = u32At(
        data,
        uvTable + packetIndex * 4
      )

      local firstVertex = #surface.vertices

      for vertexIndex = 0, vertexCount - 1 do
        local positionRecord =
          positionOffset + vertexIndex * 16

        local normalRecord =
          normalOffset + vertexIndex * 16

        local uvRecord =
          uvOffset + vertexIndex * 8

        assert(positionRecord + 16 <= #data,
          'Position lies outside MDL')

        assert(normalRecord + 16 <= #data,
          'Normal lies outside MDL')

        assert(uvRecord + 8 <= #data,
          'UV lies outside MDL')

        local position = convertVector(
          f32At(data, positionRecord),
          f32At(data, positionRecord + 4),
          f32At(data, positionRecord + 8),
          MODEL_SCALE
        )

        local normal = normalize3(convertVector(
          f32At(data, normalRecord),
          f32At(data, normalRecord + 4),
          f32At(data, normalRecord + 8),
          1
        ))

        local stripFlags = u32At(
          data,
          positionRecord + 12
        )

        surface.vertices[#surface.vertices + 1] = position
        surface.normals[#surface.normals + 1] = normal

        surface.uvs[#surface.uvs + 1] = {
          f32At(data, uvRecord),
          f32At(data, uvRecord + 4)
        }

        -- Сохраняем адрес skin-данных для этапа анимации.
        surface.skin[#surface.skin + 1] =
          skinOffset + vertexIndex * 4

        if vertexIndex >= 2
          and band(stripFlags, 0x8000) == 0
        then
          local a = firstVertex + vertexIndex - 2
          local b = firstVertex + vertexIndex - 1
          local c = firstVertex + vertexIndex

          -- Triangle strip меняет winding каждый треугольник.
          if vertexIndex % 2 == 1 then
            a, b = b, a
          end

          if REVERSE_WINDING then
            b, c = c, b
          end

          surface.indices[#surface.indices + 1] = a
          surface.indices[#surface.indices + 1] = b
          surface.indices[#surface.indices + 1] = c
        end
      end

      verticesRemaining =
        verticesRemaining - vertexCount
    end

    assert(verticesRemaining == 0,
      'MDL vertex count does not match packets')

    model.surfaces[#model.surfaces + 1] = surface

    print(string.format(
      'MDL surface %d: %d vertices, %d triangles, %d packets',
      surfaceIndex + 1,
      #surface.vertices,
      math.floor(#surface.indices / 3),
      packetCount
    ))
  end

  return model
end

-- MD3 writer ------------------------------------------------------------------

local Writer = {}
Writer.__index = Writer

function Writer.new()
  return setmetatable({
    parts = {},
    size = 0
  }, Writer)
end

function Writer:bytes(value)
  self.parts[#self.parts + 1] = value
  self.size = self.size + #value
end

function Writer:u16(value)
  if value < 0 then
    value = value + 65536
  end

  self:bytes(string.char(
    value % 256,
    math.floor(value / 256) % 256
  ))
end

function Writer:u32(value)
  if value < 0 then
    value = value + 4294967296
  end

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
    fraction = math.floor(
      (mantissa * 2 - 1) * 0x800000 + .5
    )

    if fraction >= 0x800000 then
      fraction = 0
      exponent = exponent + 1
    end
  end

  self:u32(
    sign + exponent * 0x800000 + fraction
  )
end

function Writer:fixedString(value, length)
  value = value:sub(1, length - 1)

  self:bytes(
    value .. string.rep('\0', length - #value)
  )
end

function Writer:result()
  return table.concat(self.parts)
end

local function md3Coordinate(value)
  local scaled = value * 64

  local encoded

  if scaled >= 0 then
    encoded = math.floor(scaled + .5)
  else
    encoded = math.ceil(scaled - .5)
  end

  assert(
    encoded >= -32768 and encoded <= 32767,
    string.format(
      'Coordinate %.4f exceeds MD3 range',
      value
    )
  )

  return encoded
end

local function encodeMD3Normal(normal)
  local latitude = math.floor(
    math.atan2(normal[2], normal[1])
      * 255 / (2 * math.pi)
  ) % 256

  local longitude = math.floor(
    math.acos(math.max(
      -1,
      math.min(1, normal[3])
    )) * 255 / (2 * math.pi)
  ) % 256

  return latitude * 256 + longitude
end

local function createStaticSurface(surface, index)
  local vertexCount = #surface.vertices
  local triangleCount =
    math.floor(#surface.indices / 3)

  assert(vertexCount <= 4096,
    'MD3 surface exceeds vertex limit')

  assert(triangleCount <= 8192,
    'MD3 surface exceeds triangle limit')

  local triangleOffset = 108
  local shaderOffset =
    triangleOffset + triangleCount * 12

  local uvOffset = shaderOffset + 68
  local vertexOffset =
    uvOffset + vertexCount * 8

  local endOffset =
    vertexOffset + vertexCount * 8

  local writer = Writer.new()

  writer:bytes('IDP3')
  writer:fixedString(
    string.format('surface_%02d', index),
    64
  )

  writer:u32(0)
  writer:u32(1)
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

    writer:u32(surface.indices[offset + 1])
    writer:u32(surface.indices[offset + 2])
    writer:u32(surface.indices[offset + 3])
  end

  writer:fixedString(surface.texture, 64)
  writer:u32(0)

  for vertex = 1, vertexCount do
    local uv = surface.uvs[vertex]

    writer:f32(uv[1])
    writer:f32(
      FLIP_MD3_V and 1 - uv[2] or uv[2]
    )
  end

  for vertex = 1, vertexCount do
    local position = surface.vertices[vertex]
    local normal = surface.normals[vertex]

    writer:u16(md3Coordinate(position[1]))
    writer:u16(md3Coordinate(position[2]))
    writer:u16(md3Coordinate(position[3]))
    writer:u16(encodeMD3Normal(normal))
  end

  return writer:result()
end

local function createStaticMD3(model)
  local minimum = {
    math.huge,
    math.huge,
    math.huge
  }

  local maximum = {
    -math.huge,
    -math.huge,
    -math.huge
  }

  local radius = 0
  local surfaces = {}
  local surfaceBytes = 0

  for index, surface in ipairs(model.surfaces) do
    for _, vertex in ipairs(surface.vertices) do
      for axis = 1, 3 do
        minimum[axis] = math.min(
          minimum[axis],
          vertex[axis]
        )

        maximum[axis] = math.max(
          maximum[axis],
          vertex[axis]
        )
      end

      radius = math.max(radius, math.sqrt(
        vertex[1]^2
          + vertex[2]^2
          + vertex[3]^2
      ))
    end

    surfaces[index] =
      createStaticSurface(surface, index)

    surfaceBytes =
      surfaceBytes + #surfaces[index]
  end

  local frameOffset = 108
  local tagOffset = frameOffset + 56
  local surfaceOffset = tagOffset
  local endOffset = surfaceOffset + surfaceBytes

  local writer = Writer.new()

  writer:bytes('IDP3')
  writer:u32(15)
  writer:fixedString('BANSHEE_STATIC', 64)
  writer:u32(0)
  writer:u32(1)
  writer:u32(0)
  writer:u32(#surfaces)
  writer:u32(0)
  writer:u32(frameOffset)
  writer:u32(tagOffset)
  writer:u32(surfaceOffset)
  writer:u32(endOffset)

  for axis = 1, 3 do
    writer:f32(minimum[axis])
  end

  for axis = 1, 3 do
    writer:f32(maximum[axis])
  end

  writer:f32(0)
  writer:f32(0)
  writer:f32(0)
  writer:f32(radius)
  writer:fixedString('static_0000', 16)

  for _, surface in ipairs(surfaces) do
    writer:bytes(surface)
  end

  return writer:result()
end


-- Conversion ------------------------------------------------------------------

local function processArchive(definition, manifest)
  print('Reading ' .. definition.path)

  local data, message = lovr.filesystem.read(definition.path)
  assert(data, 'Cannot read archive: ' .. tostring(message))

  local archive = parseArchive(data)

  print(string.format(
    '%s: %d resources',
    definition.path,
    #archive.entries
  ))

  for index, entry in ipairs(archive.entries) do
    local payload = extractEntry(data, entry)
	
	if CREATE_STATIC_MD3
		  and entry.name:upper() == 'BN_MODEL.MDL'
		then
		  print('Parsing VAN model geometry...')

		  local model = parseVanMDL(payload)
		  local md3 = createStaticMD3(model)

		  local path = joinPath(
			OUTPUT_DIR,
			'BANSHEE_STATIC.md3'
		  )

		  writeBinary(path, md3)

		  print(string.format(
			'Created %s (%d bytes)',
			path,
			#md3
		  ))
		end

    local outputBase =
      definition.prefix .. '__' .. safeName(entry.name)

    manifest[#manifest + 1] = string.format(
      '%s\t%d\t%d\t%08X',
      entry.name,
      entry.size,
      entry.offset,
      entry.hash
    )

    if WRITE_RAW_FILES then
      writeBinary(
        joinPath(OUTPUT_DIR, outputBase),
        payload
      )
    end

    if DECODE_TEXTURES and isTexture(entry.name) then
      local success, image, information = pcall(
        decodeTEX,
        payload
      )

      if success then
        local png = image:encode()

        local pngName = outputBase:gsub(
          '%.TEX$',
          '.png'
        )

        writeBinary(
          joinPath(OUTPUT_DIR, pngName),
          png:getString()
        )

        print(string.format(
          '[%d/%d] %s -> PNG (%dx%d, %d-bit)',
          index,
          #archive.entries,
          entry.name,
          information.width,
          information.height,
          information.bitsPerPixel
        ))
      else
        print(
          'TEX warning for '
          .. entry.name
          .. ': '
          .. tostring(image)
        )
      end
    end
  end
end

local function convert()
  local manifest = {
    'name\tsize\toffset\thash'
  }

  for _, definition in ipairs(ARCHIVES) do
    manifest[#manifest + 1] =
      '\n[' .. definition.path .. ']'

    processArchive(definition, manifest)
  end

  writeBinary(
    joinPath(OUTPUT_DIR, 'manifest.txt'),
    table.concat(manifest, '\r\n')
  )

  status = 'Extraction complete: ' .. OUTPUT_DIR

  print('')
  print(status)
  print('Main model: B2__BN_MODEL.MDL')
  print('Skeleton: B2__BN_MODEL_SKELETON.SKL')
  print('Animations: B1__BN_*.SKA')
end

-- LÖVR ------------------------------------------------------------------------

function lovr.load()
  local success, message = xpcall(
    convert,
    debug.traceback
  )

  if not success then
    status = 'Conversion failed:\n' .. tostring(message)
    print(status)
  end
end

function lovr.draw(pass)
  pass:text(status, 0, 1.7, -3, .12)
end