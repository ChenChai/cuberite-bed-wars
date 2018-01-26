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
function TickSpawnedMobs(World, TimeDelta)
  

  
  
  for i, value in next, DreamDefenderArray do
    -- Removes the Dream Defender when its time runs out or it is dead
    if DreamDefenderArray[i].TimeLeft <= 0 or DreamDefenderArray[i]:IsTicking() == false then 
      DreamDefenderArray[i]:TeleportToCoords(-100, -100, -100) 
      table.remove(DreamDefenderArray, i)
    else
  
  
    DreamDefenderArray[i].TimeLeft = DreamDefenderArray[i].TimeLeft - TimeDelta -- Subtracts elapsed tick
    --updates name of Dream Defender, using health, name and time left.
    DreamDefenderArray[i]:SetCustomName("§c" .. DreamDefenderArray[i]:GetHealth() .." §9§lDream Defender §r§e" .. math.ceil(DreamDefenderArray[i].TimeLeft / 60) .. " s")
    
    -- Every few ticks, Dream defender searches for target
    local SearchDistance = 10
    local AttackDistance = 3
    MobSearchForTarget(DreamDefenderArray[i], SearchDistance, AttackDistance, 8, 20) -- TeamMobAI.lua
    end
  end
  
  for i, value in next, BedbugArray do
    
    
    if BedbugArray[i].TimeLeft <= 0 or BedbugArray[i]:IsTicking() == false then -- Removes the Bedbug when time runs out
      BedbugArray[i]:TeleportToCoords(-100, -100, -100)
      table.remove(BedbugArray, i) 
    else
    
    BedbugArray[i].TimeLeft = BedbugArray[i].TimeLeft - TimeDelta --Subtracts elapsed ticks from the duration remaining on the bedbug
    --updates name of bedbug, using health, name and timeleft
    BedbugArray[i]:SetCustomName("§c" .. value:GetHealth() .. " Bedbug §r§e" .. math.ceil(BedbugArray[i].TimeLeft / 60) .. " s")
    
    local SearchDistance = 10
    local AttackDistance = 2
    MobSearchForTarget(BedbugArray[i], SearchDistance, AttackDistance, 2, 5) -- TeamMobAI.lua
    end

  end
  
  return
end
  
function DrinkCustomPotion(Player) -- TODO Make these global
  for i, value in next, { [10] = {cItem(373, 1, 0, "", "§rPotion of Invisibility"), {"Invisibility", "30 Seconds", "", cEntityEffect.effInvisibility, 30, 0}, "Cost: 1 Emerald", 1, 388};
                          [11] = {cItem(373, 1, 0, "", "§rPotion of Speed"),        {"Speed II", "45 Seconds"    , "", cEntityEffect.effSpeed, 45, 1       }, "Cost: 1 Emerald", 1, 388};
                          [12] = {cItem(373, 1, 0, "", "§rPotion of Leaping"),      {"Jump Boost V", "45 Seconds", "", cEntityEffect.effJumpBoost, 45, 4   }, "Cost: 1 Emerald", 1, 388}
                          } do
    if Player:GetInventory():GetEquippedItem().m_CustomName == value[1].m_CustomName then
      Player:AddEntityEffect(value[2][3], value[2][4], value[2][5])
    end
  end
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
           
           local Color 
           if Player:GetTeam() == nil then Color = E_META_WOOL_WHITE else Color = Player:GetTeam().WoolColor end
           
           ScheduleEggBlockSet(Entity, Color)
       
        end
      end
    end)
  end)
 

  Player:GetInventory():RemoveOneEquippedItem()
end

  -- Schedules the egg to start setting wool blocks
function ScheduleEggBlockSet(Entity, Color)
  local World = Entity:GetWorld()
  local EggID = Entity:GetUniqueID()
  
  if Color == nil then Color = E_META_DYE_WHITE end
  
  for i=1,70,1 do -- constantly setting blocks for like 70 ticks
  
    World:ScheduleTask(i, function(World) 
    
      World:DoWithEntityByID(EggID, function(Entity)
      
        local World = Entity:GetWorld()
        local PX = Entity:GetPosX()
        local PY = Entity:GetPosY() - 1.2
        local PZ = Entity:GetPosZ()
        
        World:ScheduleTask(3, function(World)  
          if World:GetBlock(PX, PY, PZ) == 0 then -- Checking if the block is air
            World:SetBlock(PX, PY, PZ, 35, Color, true) --Set wool block at the egg position
          end
          if World:GetBlock(PX, PY - 1, PZ) == 0 then
            World:SetBlock(PX, PY - 1, PZ, 35, Color, true)
          end
          if World:GetBlock(PX + 1, PY, PZ) == 0 then
            World:SetBlock(PX + 1, PY, PZ, 35, Color, true)
          end
          if World:GetBlock(PX, PY, PZ + 1) == 0 then
            World:SetBlock(PX, PY, PZ + 1, 35, Color, true)
          end
          if World:GetBlock(PX + 1, PY, PZ + 1) == 0 then
            World:SetBlock(PX + 1, PY, PZ + 1, 35, Color, true)
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