local Economy = {}
Economy.__index = Economy


-- Создаёт экономику игрока.
function Economy.new(settings)
  settings = settings or {}

  local self =
    setmetatable({}, Economy)

  self.gold =
    settings.startingGold or 0

  self.incomeAmount =
    settings.incomeAmount or 0

  self.incomeInterval =
    settings.incomeInterval or 1

  self.incomeTimer = 0

  return self
end


-- Проверяет достаточность золота.
function Economy:canAfford(amount)
  return self.gold >= amount
end


-- Пытается списать золото.
function Economy:spend(amount)
  if
    amount < 0
    or not self:canAfford(amount)
  then
    return false
  end

  self.gold = self.gold - amount

  return true
end


-- Начисляет золото игроку.
function Economy:addGold(amount)
  self.gold =
    math.max(
      0,
      self.gold + amount
    )
end


-- Возвращает текущее золото.
function Economy:getGold()
  return self.gold
end


-- Обновляет периодический доход.
function Economy:update(dt)
  if self.incomeInterval <= 0 then
    return
  end

  self.incomeTimer =
    self.incomeTimer + dt

  while
    self.incomeTimer >=
    self.incomeInterval
  do
    self.incomeTimer =
      self.incomeTimer -
      self.incomeInterval

    self:addGold(
      self.incomeAmount
    )
  end
end


return Economy