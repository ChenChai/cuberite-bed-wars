-- This file handles item hooks

function InitializeItems()

  DreamDefenderArray = {}
  BridgeEggArray = {}
  BedbugArray = {}
  
  cPluginManager.BindCommand("/empower", "", EmpowerAdd, " ~ /empower <power>")

  
  LOG("Initialised Bedwars Item Handling!")

end

  --- THIS IS JUST FOR DEBUGGING, REMOVE WHEN PUSHING TO PRODUCTION
function EmpowerAdd(Split, Player) -- Callback to use commands to give items (WIP) Depreciated
    
    --if Split.getn ~= 2 then return false end --Check if there are 2 parameters
    local EmpowerType = Split[2]
    if EmpowerType == "firecharge" then

        local FireBall = cItem(385, 1, 0, "", "§6Fireball") -- assigns Firecharge item

        FireBall.m_LoreTable = {"§7§oRight Click to Throw!"}
        Player:GetInventory():AddItem(FireBall)
    
        return true
    else
        return true
    end
end
  
  -- TODO Move this into a different file for organization
  -- This function updates the time left on Dream Defenders and Bedbugs
function TickSpawnedMobs(World)
  
  for i, value in next, DreamDefenderArray do
    DreamDefenderArray[i].TimeLeft = DreamDefenderArray[i].TimeLeft - 1 -- Subtracts elapsed tick
    --updates name of Dream Defender, using health, name and time left.
    DreamDefenderArray[i]:SetCustomName("§c" .. DreamDefenderArray[i]:GetHealth() .." §9§lDream Defender §r§e" .. math.ceil(DreamDefenderArray[i].TimeLeft / 60) .. " s")
    
    if DreamDefenderArray[i].TimeLeft <= 0 then -- Removes the Dream Defender when its time runs out
      DreamDefenderArray[i]:TeleportToCoords(-100, -100, -100) 
      table.remove(DreamDefenderArray, i)
    end
  end
  
  for i, value in next, BedbugArray do
    BedbugArray[i].TimeLeft = BedbugArray[i].TimeLeft - 1 --Subtracts elapsed ticks from the duration remaining on the bedbug
    --updates name of bedbug, using health, name and timeleft
    BedbugArray[i]:SetCustomName("§c" .. value:GetHealth() .. " Bedbug §r§e" .. math.ceil(BedbugArray[i].TimeLeft / 60) .. " s")
    
    if BedbugArray[i].TimeLeft <= 0 then -- Removes the Bedbug when time runs out
      BedbugArray[i]:TeleportToCoords(-100, -100, -100)
      table.remove(BedbugArray, i) 
    end
  end
  
  return
end
  

function PlaceInstantTNT(Player, BlockX, BlockY, BlockZ)
    Player:GetInventory():RemoveOneEquippedItem()
    Player:GetWorld():SpawnPrimedTNT(Vector3d(BlockX, BlockY, BlockZ), 70, 5)
    return
end

  -- Throws a fireball in the direction the player is looking and removes one held item
function ThrowFireball(Player)
    local HeldItem = cItem(Player:GetInventory():GetEquippedItem())
    local World = Player:GetWorld()

    HeldItem.m_ItemCount = 1
    
    local PosX = Player:GetPosX()
    local PosY = Player:GetPosY()
    local PosZ = Player:GetPosZ()
    
      -- Remove fireball from inventory and make fireball
    Player:GetInventory():RemoveOneEquippedItem()
    World:CreateProjectile(Player:GetPosX(), Player:GetPosY() + 0.9, Player:GetPosZ(), cProjectileEntity.pkGhastFireball, Player, HeldItem, Vector3d(Player:GetLookVector()) * 10)
    return
end

  -- Throws a bridge egg in the direction the player is looking and removes one held item
function ThrowBridgeEgg(Player)
  local HeldItem = cItem(Player:GetInventory():GetEquippedItem())
  local World = Player:GetWorld()
  
  World:CreateProjectile(Player:GetPosX(), Player:GetPosY() + 1.85, Player:GetPosZ(), cProjectileEntity.pkEgg, Player, HeldItem, Vector3d(Player:GetLookVector()) * 20)
  
  local EggID
  
  --Finds the EggID by checking every entity, slight delay to allow for once egg is thrown
  World:ScheduleTask(0, function(World)
    World:ForEachEntity(function(Entity)
      if Entity:GetEntityType() == cEntity.etProjectile then

        if Entity:GetProjectileKind() == cProjectileEntity.pkEgg and Entity.BridgeEggActivated ~= true then
           EggID = Entity:GetUniqueID()
           Entity.BridgeEggActivated = true
           ScheduleEggBlockSet(Entity)
       
        end
      end
    end)
  end)
 

  Player:GetInventory():RemoveOneEquippedItem()
end

  -- Schedules the egg to start setting wool blocks
function ScheduleEggBlockSet(Entity)
  local World = Entity:GetWorld()
  local EggID = Entity:GetUniqueID()
  
  for i=1,70,1 do -- constantly setting blocks for like 70 ticks
  
    World:ScheduleTask(i, function(World) 
    
      World:DoWithEntityByID(EggID, function(Entity)
      
        local World = Entity:GetWorld()
        local PX = Entity:GetPosX()
        local PY = Entity:GetPosY() - 1.2
        local PZ = Entity:GetPosZ()
        
        World:ScheduleTask(3, function(World)  
          if World:GetBlock(PX, PY, PZ) == 0 then -- Checking if the block is air
            World:SetBlock(PX, PY, PZ, 35, 1, true) --Set wool block at the egg position
          end
          if World:GetBlock(PX, PY - 1, PZ) == 0 then
            World:SetBlock(PX, PY - 1, PZ, 35, 1, true)
          end
          if World:GetBlock(PX + 1, PY, PZ) == 0 then
            World:SetBlock(PX + 1, PY, PZ, 35, 1, true)
          end
          if World:GetBlock(PX, PY, PZ + 1) == 0 then
            World:SetBlock(PX, PY, PZ + 1, 35, 1, true)
          end
          if World:GetBlock(PX + 1, PY, PZ + 1) == 0 then
            World:SetBlock(PX + 1, PY, PZ + 1, 35, 1, true)
          end
          
        end)
      end)
    end)
  end
  
  return
end

  -- Called Spawns a Mob keyed to a team at a location
  -- PARAMETERS: Mobtype constant, string, team object (i.e. of a player), mob lifespan in ticks, locations, and the array the mob will be held in.
function SpawnTeamMob(MobType, MobName, Team, Lifespan, BlockX, BlockY, BlockZ, World, MobArray)

  local MobID = World:SpawnMob(BlockX, BlockY, BlockZ, MobType, false) --Spawns a non baby mob at the location specified and gets that entity's ID
  World:DoWithEntityByID(MobID, --Does stuff to the Mob
    function(Entity)
      Entity:SetCustomName(MobName) -- Assigns the name
      Entity:SetCustomNameAlwaysVisible(true) -- Name always visible
      Entity.TimeLeft = Lifespan -- How much time the bedbug will live
      if Team ~= nil then Entity.Team = Team end -- Assigns the Mob a team based on the thrower's team
      table.insert(MobArray, Entity) -- puts the bedbug in the next element in array 
      
    end)
end