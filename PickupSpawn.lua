function InitPickupSpawn()
  --inits the pickups vars and other things
  IronForgeTier = {
                  [0] = 2;
                  [1] = 3;
                  [2] = 4;
                  [3] = 4;
                  [4] = 6}
  GoldForgeTier = {
                  [0] = 2;
                  [1] = 3;
                  [2] = 4;
                  [3] = 4;
                  [4] = 6}
  EmeraldForgeTier = {
                  [0] = 0;
                  [1] = 0;
                  [2] = 0;
                  [3] = 1;
                  [4] = 3}
  IronSpawnMax = 15
  GoldSpawnMax = 20
  EmeraldSpawnMax = 65
  DiamondSpawnMax = 30
  
  IronCount = IronSpawnMax
  GoldCount = GoldSpawnMax
  EmeraldCount = EmeraldSpawnMax
  DiamondCount  = DiamondSpawnMax
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
        
      --Events
      if Time = 360
        --Upgrade Diamond gen to lvl 2
        DiamondSpawnMax = 25
      end
      if Time = 720 then
        --Em Gen to lvl 2
        EmeraldSpawnMax = 60
      end
      if Time = 1080 then
        --Dia to lvl 3
        DiamondSpawnMax = 20
      end
      if Time = 1440 then
        --Em to lvl 3
        EmeraldSpawnMax = 55
      end
      if Time = 1800 then
        --Destroy Beds
        RedBed = false
        BlueBed = false
        UpdateScore()
      end
      
      --Counters
      IronCount = IronCount - 1
      GoldCount = GoldCount - 1
      EmeraldCount = EmeraldCount - 1
      DiamondCount = DiamondCount - 1
      
      if IronCount == 0 then
        SpawnIron()
        IronCount = IronSpawnMax
      end
      if GoldCount == 0 then
        SpawnGold()
        GoldCount = GoldSpawnMax
      end
      if EmeraldCount == 0 then
        SpawnEmerald()
        EmeraldCount = EmeraldSpawnMax
      end
      if DiamondCount == 0 then
        SpawnDiamond()
        DiamondCount = DiamondSpawnMax
      end
    end
    --EXECUTED EVERY TICK
    --nothing LUL
  end
end

function SpawnIron()--spawns iron
  local loot = cItem(E_ITEM_IRON)
  --Red Spawn
  coords = IronGoldLocate['Red']
  local loop = 0
  while loop ~= IronForgeTier[RedTeam.Upgrades['ForgeTier']] do
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
    loop = loop + 1
  end
  --Blue
  coords = IronGoldLocate['Blue']
  local loop = 0
  while loop ~= IronForgeTier[BlueTeam.Upgrades['ForgeTier']] do
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
    loop = loop + 1
  end
end

function SpawnGold()
  local loot = cItem(E_ITEM_GOLD)
  --Red Spawn
  coords = IronGoldLocate['Red']
  local loop = 0
  while loop ~= GoldForgeTier[RedTeam.Upgrades['ForgeTier']] do
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
    loop = loop + 1
  end
  --Blue
  coords = IronGoldLocate['Blue']
  local loop = 0
  while loop ~= GoldForgeTier[BlueTeam.Upgrades['ForgeTier']] do
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
    loop = loop + 1
  end
end

function SpawnEmerald()-- 1 em
  local loot = cItem(E_ITEM_EMERALD)
  for pos, coords in ipairs(EmeraldLocate) do
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
  end
  --Red Spawn
  coords = IronGoldLocate['Red']
  local loop = 0
  while loop ~= EmeraldForgeTier[RedTeam.Upgrades['ForgeTier']] do
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
    loop = loop + 1
  end
  --Blue
  coords = IronGoldLocate['Blue']
  local loop = 0
  while loop ~= EmeraldForgeTier[BlueTeam.Upgrades['ForgeTier']] do
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
    loop = loop + 1
  end
end

function SpawnDiamond()-- 1 diamond
  for pos, coords in ipairs(DiamondLocate) do
    local loot = cItem(E_ITEM_DIAMOND)
    Arena:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
  end
end