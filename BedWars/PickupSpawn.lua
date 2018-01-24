function InitPickupSpawn()
  --inits the pickups vars and other things
  
  IronSpawnTimes = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60}
  GoldSpawnTimes = {}
  EmeraldSpawnTimes = {}
  DiamondSpawnTimes = {}
  
  IronGoldLocate = {{x = 1, y = 41, z = 74}, {x = 1, y = 41, z = -76}}
  DiamondLocate = {{x = 1, y = 41, z = 42}, {x = 1, y = 41, z = -39}}
  EmeraldLocate = {{x = -5, y = 42, z = -1}, {x = 7, y = 42, z = -1}}
end

function SpawnItemClock(TimeDelta)
  if Time == nil then
    --do nothing
  else
    TimeMil = TimeMil + TimeDelta
    if TimeMil >= 1000 then
      TimeMil = TimeMil - 1000
      Time = Time + 1
      --EXECUTED EVERY SECOND
      for i, SpawnTime in ipairs(IronSpawnTimes) do
        if Time == SpawnTime then
          SpawnIron()
        end
      end
      for i, SpawnTime in ipairs(GoldSpawnTimes) do
        if Time == SpawnTime then
          SpawnGold()
        end
      end
      for i, SpawnTime in ipairs(EmeraldSpawnTimes) do
        if Time == SpawnTime then
          SpawnEmerald()
        end
      end
      for i, SpawnTime in ipairs(DiamondSpawnTimes) do
        if Time == SpawnTime then
          SpawnDiamond()
        end
      end
    end
    --EXECUTED EVERY TICK
    --nothing LUL
  end
end

function SpawnIron()--spawns 5 iron
  for pos, coords in ipairs(IronGoldLocate) do
    loot = cItem(E_ITEM_IRON)
    local loop = 0
    while loop ~= 5 do
      Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
      loop = loop + 1
    end
  end
end

function SpawnGold()--1 gold
  for pos, coords in ipairs(IronGoldLocate) do
    loot = cItem(E_ITEM_GOLD)
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
  end
end

function SpawnEmerald()-- 1 em
  for pos, coords in ipairs(EmeraldLocate) do
    loot = cItem(E_ITEM_EMERALD)
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
  end
end

function SpawnDiamond()-- 1 diamond
  for pos, coords in ipairs(DiamondLocate) do
    loot = cItem(E_ITEM_EMERALD)
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
  end
end