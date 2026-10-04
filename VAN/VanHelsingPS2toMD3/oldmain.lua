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