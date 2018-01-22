--Uses commands to organize players into teams, hadle spawning and beds

PLUGIN = nil

function Initialize(Plugin)
  Plugin:SetName("Bedwars Main")
  Plugin:SetVersion(1)
  
    -- Basically set up all the hooks for the shop and items which are in separate files
    -- HOT SURE IF IT WORKS
  InitializeShop()
  InitializeItems()
    -- TODO make sure none of these hooks clash, maybe refactor all hook calls into a separate file?
    -- Hooks
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, BrokenBlock)
  cPluginManager:AddHook(cPluginManager.HOOK_TICK, MyOnTick)
  cPluginManager:AddHook(cPluginManager.HOOK_KILLING, MyOnKilling)
  
    -- Vars
  PLUGIN = Plugin
  IronSpawnTimes = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60}
  GoldSpawnTimes = {}
  EmeraldSpawnTimes = {}
  DiamondSpawnTimes = {}
  IronGoldLocate = {{x = 1, y = 41, z = 74}, {x = 1, y = 41, z = -76}}
  DiamondLocate = {{x = 1, y = 41, z = 42}, {x = 1, y = 41, z = -39}}
  EmeraldLocate = {{x = -5, y = 42, z = -1}, {x = 7, y = 42, z = -1}}
  Svamp = cRoot:Get():GetWorld('Svamp')
  Board = Svamp:GetScoreBoard() 
  Board:RegisterTeam('Red', 'Red', 'Red', '')
  Board:RegisterTeam('Blue', 'Blue', 'Blue', '')
  BlueTeam = Board:GetTeam('Blue')
  RedTeam = Board:GetTeam('Red')
  BlueTeam:Reset()
  RedTeam:Reset()
  RedSpawn = {x = 7, y = 42, z = -76}
  BlueSpawn = {x = -5, y = 42, z = 74}
  RedBedCoords = {x = 1, y = 41, z = -69}
  BlueBedCoords = {x = 1, y = 41, z = 67}
  RedAmount = 0
  BlueAmount = 0
  BlueBed = true
  RedBed = true
  Time = nil
  TimeMil = 0
  GameStarted = nil
  
  ArmorArray = { [0] = {cItem(300, 1, 0, "unbreaking=10", ""), cItem(301, 1, 0, "unbreaking=10", "")}, -- Tier 0 leather leggings/boots
                 [1] = {cItem(304, 1, 0, "unbreaking=10", ""), cItem(305, 1, 0, "unbreaking=10", "")},
                 [2] = {cItem(308, 1, 0, "unbreaking=10", ""), cItem(309, 1, 0, "unbreaking=10", "")},
                 [3] = {cItem(312, 1, 0, "unbreaking=10", ""), cItem(313, 1, 0, "unbreaking=10", "")}  }
                 
  PickArray = { [0] =  cItem(),
                [1] = cItem(E_ITEM_WOODEN_PICKAXE, 1, 0, 'unbreaking=10;efficiency=1'),
                [2] = cItem(E_ITEM_STONE_PICKAXE, 1, 0, 'unbreaking=10;efficiency=1'),
                [3] = cItem(E_ITEM_IRON_PICKAXE, 1, 0, 'unbreaking=10;efficiency=2'),
                [4] = cItem(E_ITEM_DIAMOND_PICKAXE, 1, 0, 'unbreaking=10;efficiency=3')  }
                
  AxeArray = { [0] =  cItem(),
                [1] = cItem(E_ITEM_WOODEN_AXE, 1, 0, 'unbreaking=10;efficiency=1'),
                [2] = cItem(E_ITEM_STONE_AXE, 1, 0, 'unbreaking=10;efficiency=1'),
                [3] = cItem(E_ITEM_IRON_AXE, 1, 0, 'unbreaking=10;efficiency=2'),
                [4] = cItem(E_ITEM_DIAMOND_AXE, 1, 0, 'unbreaking=10;efficiency=3')  }
                
  Board:RegisterObjective('Main', 'BED WARS', 0)
  Board:SetDisplay('Main', 1)
  
    -- Commands
  cPluginManager.BindCommand("/join", "bedwars_main.join", JoinTeam, " ~ Lets you join a team. Enter 'red' or 'blue' after to specify a team")
  cPluginManager.BindCommand("/start", "bedwars_main.start", StartGame, " ~ Starts the match")

  LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
  
  return true
end

function OnDisable()
  LOG(PLUGIN:GetName() .. " is shutting down...")
end

      
function BrokenBlock(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta)
  --Checks if a player has broken a bed block, and whos bed it is...
  if BlockType == 26 then
    if BlockX == BlueBedCoords['x'] then 
      if BlockZ == BlueBedCoords['z'] or BlockZ == BlueBedCoords['z'] + 1 then
        if BlockY == BlueBedCoords['y'] then
          if Player:GetTeam():GetName() == 'Blue' then
            Player:SendMessage('THATS YOUR BED!')
            return true
          else
            BlueBed = false
            UpdateScore()
          end
        end
      end
    end
    if BlockX == RedBedCoords['x'] then
      if BlockZ == RedBedCoords['z'] or BlockZ == RedBedCoords['z'] - 1 then
        if BlockY == RedBedCoords['y'] then
          LOG(Player:GetTeam():GetName())
          if Player:GetTeam():GetName() == 'Red' then
            Player:SendMessage('THATS YOUR BED!')
            return true
          else
            RedBed = false
            UpdateScore()
          end
        end
      end
    end
  else
    return CheckBlock(BlockX, BlockY, BlockZ)--Checks if the piece was in the OG world
  end
end

function JoinTeam(Split, Player)
  if Player:GetTeam() == nil then
    if Split[2] == 'red' then
      RedAmount = RedAmount + 1
      Player:SetTeam(RedTeam)
      Player:SendMessage('Success')
      Player.ArmorTier = 0
      Player.PickTier = 0
    elseif Split[2] == 'blue' then
      BlueAmount = BlueAmount + 1 
      Player:SetTeam(BlueTeam)
      Player:SendMessage('Success')
    else
      Player:SendMessage('use /join (red or blue)')
    end
  else
    Player:SendMessage('You are already in a team.')
  end
  return true
end

function StartGame()
  if GameStarted == nil then
    cRoot:Get():ForEachPlayer(StartPlayer)
    Time = 0
    GameStarted = true
  end
  return true
end

function StartPlayer(Player)
  if Player:GetTeam() == nil then
    Kick(Player)
  else
    Player.ArmorTier = 0
    Player.AxeTier = 0
    Player.PickTier = 0
    Player.HasShears = false
    
    if Player:GetTeam():GetName() == 'Red' then
      Respawn(Player, RedSpawn['x'], RedSpawn['y'], RedSpawn['z'])
    end
    if Player:GetTeam():GetName() == 'Blue' then
      Respawn(Player, BlueSpawn['x'], BlueSpawn['y'], BlueSpawn['z'])
    end
  end
end
        
  
function CheckBlock(BlockX, BlockY, BlockZ)
  Is_Valid, BlockType2 = world2:GetBlockInfo(BlockX, BlockY, BlockZ)
  -- Is_Valid = if the chunk has loaded, BlockType2is the block in the other world
  if Is_Valid then--If chunk is loaded, then compare the values of both blocks
    if BlockType == BlockType2 then
      return true--if they are the same, prevent the player from breaking the block
    else
      return false--if they are different, allow player to break it
    end     
  else --if the chunk isnt loaded, call this function again until the chunk has loaded to get an answer
    i = BlockBreak(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta)
    return i
  end
end

function MyOnTick(TimeDelta)
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
      Svamp:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
      loop = loop + 1
    end
  end
end

function SpawnGold()--1 gold
  for pos, coords in ipairs(IronGoldLocate) do
    loot = cItem(E_ITEM_GOLD)
    Svamp:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
  end
end

function SpawnEmerald()-- 1 em
  for pos, coords in ipairs(EmeraldLocate) do
    loot = cItem(E_ITEM_EMERALD)
    Svamp:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
  end
end

function SpawnDiamond()-- 1 diamond
  for pos, coords in ipairs(DiamondLocate) do
    loot = cItem(E_ITEM_EMERALD)
    Svamp:SpawnItemPickup(coords['x'], coords['y'], coords['z'], loot, 0, 0, 0, 3600, true)
  end
end

function MyOnKilling(victim, killer, info)
  if victim:GetClass() == 'cPlayer' then
    UpdateScore()
    Svamp:BroadcastChat(victim:GetName() .. ' has been killed')
    local team = victim:GetTeam()
    if team then
      local vic_team = team:GetName()
    else
      local vic_team = 'None'
    end
    if vic_team == 'Red' then
      if RedBed == true then
        Respawn(victim, RedSpawn['x'], RedSpawn['y'], RedSpawn['z'])
      else
        --finish him!!!
      end
    elseif vic_team == 'Blue' then
      if BlueBed == true then
        Respawn(victim, BlueSpawn['x'], BlueSpawn['y'], BlueSpawn['z'])
      else
        --finish him!!!
      end
    else
      --Let em burn
    end
    vic_team = nil
  end
end

function UpdateScore()
  --Looks at everything and updates scoreboard
  Board:GetObjective('Main'):Reset()
  if RedBed == true then
    Board:GetObjective('Main'):SetScore('Red Bed is Intact', 0)
  else
    Board:GetObjective('Main'):SetScore('Red Players Remaining: ' .. tostring(RedAmount), 0)
  end
  
  if BlueBed == true then
    Board:GetObjective('Main'):SetScore('Blue Bed is Intact', 0)
  else
    Board:GetObjective('Main'):SetScore('Blue Players Remaining: ' .. tostring(BlueAmount), 0)
  end
end

function Respawn(player, x, y, z)
  --Respawns player at spec coords, since the player isnt dead... look it up
  player:Heal(20)
  player:TeleportToCoords(x, y, z)
  local armor = player.ArmorTier
  local pick = player.PickTier
  local axe = player.AxeTier
  local inv = player:GetInventory()
  inv:Clear()
  
  -- Gib Armors ploz
  inv:SetArmorSlot(0, cItem(E_ITEM_LEATHER_CAP, 1, 0, "unbreaking=10"))
  inv:SetArmorSlot(1, cItem(E_ITEM_LEATHER_TUNIC, 1, 0, "unbreaking=10"))
  inv:SetArmorSlot(2, ArmorArray[armor][1])
  inv:SetArmorSlot(3, ArmorArray[armor][2])
  -- Gib Pick
  inv:SetHotbarSlot(1, PickArray[pick])
  --Gib Axe
  inv:SetHotbarSlot(2, AxeArray[axe])
  --
  if player.HasShears == true then
    inv.SetHotbarSlot(3, cItem(E_ITEM_SHEARS, 1, 0, "unbreaking=10"))
  end
end
