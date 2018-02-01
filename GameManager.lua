
function InitializeTeams()
  HasShears = {}
  ArmorTier = {}
  PickTier = {}
  AxeTier = {}
  
  Arena = cRoot:Get():GetWorld(WorldName) -- TODO figure out how to let people select the world properly and de-hardcode
  ArenaOriginal = cRoot:Get():GetWorld(WorldNameOriginal)
  
  Board = Arena:GetScoreBoard() 
  Board:RegisterTeam('Red', 'Red', 'Red', '')
  Board:RegisterTeam('Blue', 'Blue', 'Blue', '')
  BlueTeam = Board:GetTeam('Blue')
  RedTeam = Board:GetTeam('Red')
  BlueTeam:Reset()
  RedTeam:Reset()
  BlueTeam.WoolColor = E_META_WOOL_BLUE
  RedTeam.WoolColor = E_META_WOOL_RED
  BlueTeam:SetPrefix("§1")
  RedTeam:SetPrefix("§4")
  
  
    -- cColor objects can be attached to armor!
  BlueTeam.Color = cColor(0, 0, 255)
  RedTeam.Color = cColor(255, 0, 0)
  
  
  RedAmount = 0
  BlueAmount = 0
  
  BlueBed = true
  RedBed = true
  
  RedTeam.Upgrades = {  ["ForgeTier"] = 0;
                        ["ManiacMiner"] = 0;
                        ["SharpenedSwords"] = 0;
                        ["ReinforcedArmor"] = 0;
                        ["ItsATrap"] = 0;
                        ["MiningFatigue"] = 0;
                        ["HealPool"] = 0}
  BlueTeam.Upgrades = { ["ForgeTier"] = 0;
                        ["ManiacMiner"] = 0;
                        ["SharpenedSwords"] = 0;
                        ["ReinforcedArmor"] = 0;
                        ["ItsATrap"] = 0;
                        ["MiningFatigue"] = 0;
                        ["HealPool"] = 0}
                      
  GameTime = nil
  TimeMil = 0
  GameStarted = nil
  
  
  
   -- The Arrays are like this for easier access in the shop. Format is {Item, lore array of strings, cost string, cost number, cost item}
  ArmorArray = { [0] = {cItem(300, 1, 0, "unbreaking=10", ""), cItem(301, 1, 0, "unbreaking=10", "")}, -- Tier 0 leather leggings/boots
                 [1] = {cItem(304, 1, 0, "unbreaking=10", ""), cItem(305, 1, 0, "unbreaking=10", "")},
                 [2] = {cItem(308, 1, 0, "unbreaking=10", ""), cItem(309, 1, 0, "unbreaking=10", "")},
                 [3] = {cItem(312, 1, 0, "unbreaking=10", ""), cItem(313, 1, 0, "unbreaking=10", "")}
                }
                
                --the arrays in this array are structured after the ItemCategoryArrays later, which list the items you buy and the prices.
  PickArray =  { [0] = {cItem()},
                 [1] = {cItem(E_ITEM_WOODEN_PICKAXE, 1, 0, "unbreaking=10;efficiency=1", ""),     {}, "Cost: 10 Iron", 10, 265};
                 [2] = {cItem(E_ITEM_STONE_PICKAXE, 1, 0, "unbreaking=10;efficiency=1", ""),      {}, "Cost: 10 Iron", 10, 265};
                 [3] = {cItem(E_ITEM_IRON_PICKAXE, 1, 0, "unbreaking=10;efficiency=2", ""),      {}, "Cost: 3 Gold", 3, 266};
                 [4] = {cItem(E_ITEM_DIAMOND_PICKAXE, 1, 0, "unbreaking=10;efficiency=3", ""),      {}, "Cost: 6 Gold", 6, 266};
                }
  
  
  AxeArray  =  { [0] = {cItem()},
                 [1] = {cItem(E_ITEM_WOODEN_AXE, 1, 0, "unbreaking=10;efficiency=1", ""),     {}, "Cost: 10 Iron", 10, 265};
                 [2] = {cItem(E_ITEM_STONE_AXE, 1, 0, "unbreaking=10;efficiency=1", ""),      {}, "Cost: 10 Iron", 10, 265};
                 [3] = {cItem(E_ITEM_IRON_AXE, 1, 0, "unbreaking=10;efficiency=2", ""),      {}, "Cost: 3 Gold", 3, 266};
                 [4] = {cItem(E_ITEM_DIAMOND_AXE, 1, 0, "unbreaking=10;efficiency=3", ""),      {}, "Cost: 6 Gold", 6, 266};
                }
  Board:RegisterObjective('Main', 'BED WARS', 0)
  Board:SetDisplay('Main', 1)
  
    -- Commands
  cPluginManager.BindCommand("/join", "bedwars_main.join", JoinTeam, " ~ Lets you join a team. Enter 'red' or 'blue' after to specify a team")
  cPluginManager.BindCommand("/start", "bedwars_main.start", StartGame, " ~ Starts the match")

  LOG("Initialised Teams")
end



function JoinTeam(Split, Player)
  if Player:GetTeam() == nil then
    if Split[2] == 'red' then
      RedAmount = RedAmount + 1
      Player:SetTeam(RedTeam)
      Player:SendMessage('Success')
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
    GameTime = 0   
    GameStarted = true
    
    -- Loads ArenaOriginal
    LoadChunks()
  end
  return true
end

function LoadChunks()
  LowX = -1
  HighX = 2 --add 1 to num for while loop
  
  LowZ = -6
  HighZ = 6 -- add 1 to num for while loop
  
  local CountX = LowX
  while CountX ~= HighX do
    local CountZ = LowZ
    while CountZ ~= HighZ do
      ArenaOriginal:SetChunkAlwaysTicked(CountX, CountZ, true)
      CountZ = CountZ + 1
    end
    CountX = CountX + 1
  end
end

function StartPlayer(Player)
  if Player:GetTeam() == nil then
    Player:SetGameMode(gmSpectator)
  else
    local PlayerName = Player:GetName()
    ArmorTier[PlayerName] = 0
    AxeTier[PlayerName] = 0
    PickTier[PlayerName] = 0
    HasShears[PlayerName] = false
    
    if Player:GetTeam():GetName() == 'Red' then
      Respawn(Player, RedSpawn['x'], RedSpawn['y'], RedSpawn['z'])
    end
    if Player:GetTeam():GetName() == 'Blue' then
      Respawn(Player, BlueSpawn['x'], BlueSpawn['y'], BlueSpawn['z'])
    end
  end
end

function BrokenBlock(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta)
  --Checks if a player has broken a bed block, and whos bed it is...
  if BlockType == 26 then-- if its a bed
    LOG(BlockX .. BlockY .. BlockZ)
    LOG(BlueBedCoords.x .. " " .. BlueBedCoords.y .. " " .. BlueBedCoords.z)
    if BlockX == BlueBedCoords['x'] or BlockX == BlueBedCoords['x'] + 1 or BlockX == BlueBedCoords['x'] - 1 then
      if BlockY == BlueBedCoords['y'] then
        if BlockZ == BlueBedCoords['z'] or BlockZ == BlueBedCoords['z'] + 1 or BlockZ == BlueBedCoords['z'] - 1 then
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
  
   if BlockX == RedBedCoords['x'] or BlockX == RedBedCoords['x'] + 1 or BlockX == RedBedCoords['x'] - 1 then
      if BlockY == RedBedCoords['y'] then
        if BlockZ == RedBedCoords['z'] or BlockZ == RedBedCoords['z'] + 1 or BlockZ == RedBedCoords['z'] - 1 then
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
    return CheckBlock(BlockType, BlockX, BlockY, BlockZ)--Checks if the piece was in the OG world
  end
end

function CheckBlock(BlockType, BlockX, BlockY, BlockZ)
  local Is_Valid = false
  while Is_Valid == false do
    Is_Valid, BlockType2 = ArenaOriginal:GetBlockInfo(BlockX, BlockY, BlockZ)  
  end
  if BlockType == BlockType2 then
    return true--if they are the same, prevent the player from breaking the block
  else
    return false--if they are different, allow player to break it
  end     
end

function UpdateScore()
  --Looks at everything and updates scoreboard
  Board:GetObjective('Main'):Reset()
  --GameTime
  local GameTime = GameTime
  local MinCount = GameTime / 60
  local TimeMin = 0
  while MinCount >= 1 do
    MinCount = MinCount - 1
    TimeMin = TimeMin + 1
  end
  Board:GetObjective('Main'):SetScore('GameTime ' .. math.floor(GameTime / 60000) .. ':' .. (math.floor(GameTime / 1000) % 60) .. " " .. GameTime, 0)
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

function Respawn(Player, x, y, z)
  --Respawns player at spec coords, since the player isnt dead... look it up
  local PlayerName = Player:GetName()
  Player:Heal(20)
  Player:TeleportToCoords(x, y, z)
  local armor = ArmorTier[PlayerName]
  local pick = PickTier[PlayerName]
  local axe = AxeTier[PlayerName]
  local inv = Player:GetInventory()
  inv:Clear()
  
  -- Gib Armors ploz
  
  -- See Utilities.lua for add item color; it takes RGB values and colors the armor with that
  local ColorArmorArray = {AddItemColor(cItem(E_ITEM_LEATHER_CAP, 1, 0, "unbreaking=10"), Player:GetTeam().Color), 
                      AddItemColor(cItem(E_ITEM_LEATHER_TUNIC, 1, 0, "unbreaking=10"), Player:GetTeam().Color),
                      AddItemColor(ArmorArray[armor][1], Player:GetTeam().Color), 
                      AddItemColor(ArmorArray[armor][2], Player:GetTeam().Color)
                      }
  
  for i, value in next, ArmorArray do
    if Player:GetTeam() ~= nil and Player:GetTeam().Upgrades.ReinforcedArmor > 0 then
      value:AddEnchantment(cEnchantments.enchProtection, Player:GetTeam().Upgrades.ReinforcedArmor, false)
    end
  end
            
  inv:SetArmorSlot(0, ColorArmorArray[1])
  inv:SetArmorSlot(1, ColorArmorArray[2])
  inv:SetArmorSlot(2, ColorArmorArray[3])
  inv:SetArmorSlot(3, ColorArmorArray[4])
  -- Gib Pick
  inv:SetHotbarSlot(1, PickArray[pick][1])
  --Gib Axe
  inv:SetHotbarSlot(2, AxeArray[axe][1])
  --
  if HasShears[PlayerName] == true then
    inv.SetHotbarSlot(3, cItem(E_ITEM_SHEARS, 1, 0, "unbreaking=10"))
  end
end
