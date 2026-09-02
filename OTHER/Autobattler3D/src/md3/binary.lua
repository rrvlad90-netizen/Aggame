local Binary = {}
Binary.__index = Binary


-- Создаёт объект чтения бинарных данных.
function Binary.new(data)
  return setmetatable({
    data = data
  }, Binary)
end


-- Читает беззнаковый байт.
function Binary:u8(offset)
  return string.byte(self.data, offset + 1)
end


-- Читает 16-битное беззнаковое число.
function Binary:u16(offset)
  local a, b = string.byte(
    self.data,
    offset + 1,
    offset + 2
  )

  return a + b * 256
end


-- Читает 16-битное знаковое число.
function Binary:i16(offset)
  local value = self:u16(offset)

  if value >= 32768 then
    value = value - 65536
  end

  return value
end


-- Читает 32-битное беззнаковое число.
function Binary:u32(offset)
  local a, b, c, d = string.byte(
    self.data,
    offset + 1,
    offset + 4
  )

  return
    a +
    b * 256 +
    c * 65536 +
    d * 16777216
end


-- Читает 32-битное знаковое число.
function Binary:i32(offset)
  local value = self:u32(offset)

  if value >= 2147483648 then
    value = value - 4294967296
  end

  return value
end


-- Читает IEEE-754 float.
function Binary:f32(offset)
  local bits = self:u32(offset)

  local sign = 1

  if bits >= 2147483648 then
    sign = -1
    bits = bits - 2147483648
  end

  local exponent = math.floor(bits / 8388608)
  local mantissa = bits % 8388608

  if exponent == 0 then
    if mantissa == 0 then
      return sign * 0
    end

    return sign *
      (mantissa / 8388608) *
      2 ^ -126
  end

  if exponent == 255 then
    return sign * math.huge
  end

  return sign *
    (1 + mantissa / 8388608) *
    2 ^ (exponent - 127)
end


-- Читает строку фиксированной длины.
function Binary:string(offset, length)
  local value = self.data:sub(
    offset + 1,
    offset + length
  )

  local zero = value:find('\0', 1, true)

  if zero then
    value = value:sub(1, zero - 1)
  end

  return value
end


return Binary