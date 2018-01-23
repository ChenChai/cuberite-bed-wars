  -- TODO Refactor all these hooks into actually readable functions

function BindHooks()
  
    -- map management hooks
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
  cPluginManager:AddHook(cPluginManager.HOOK_TICK, OnTick)
  cPluginManager:AddHook(cPluginManager.HOOK_KILLING, OnKilling)
  
    -- so far these are the item hooks; doesn't really matter since they'll be used for similar things
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
  cPluginManager:AddHook(cPluginManager.HOOK_EXPLODING, OnExploding)
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_USING_ITEM, OnPlayerUsingItem)
  cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK, OnWorldTick)
  cPluginManager:AddHook(cPluginManager.HOOK_PROJECTILE_HIT_BLOCK, OnProjectileHitBlock)
  cPluginManager:AddHook(cPluginManager.HOOK_PROJECTILE_HIT_ENTITY, OnProjectileHitEntity)
  
end

function OnTick(TimeDelta)
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

function OnKilling(victim, killer, info)
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


function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockType, BlockMeta)
  if BlockType == E_BLOCK_TNT then 
      -- TODO figure out why TNT isn't removed from the inventory properly
    PlaceInstantTNT(Player, BlockX, BlockY, BlockZ) -- See Items: Places primed tnt and removes it from player's inventory
    
    return true
  end

end

function OnPlayerUsingItem(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)
  local World = Player:GetWorld()
  local HeldItem = cItem(Player:GetInventory():GetEquippedItem())
  
  if HeldItem.m_ItemType == 383 and HeldItem.m_CustomName == "§rDream Defender" then -- Checks if holding a spawn egg and is a dream defender!
    local BX = BlockX
    local BY = BlockY
    local BZ = BlockZ
    
    if BlockFace == 1 then    --Adjusts spawn location based on which face the player clicks
    BY = BY + 1
    end
    
    if BlockFace == 2 then
    BZ = BZ - 1
    end
    
    if BlockFace == 3 then
    BZ = BZ + 1
    end
    
    if BlockFace == 4 then
    BX = BX - 1
    end
    
    if BlockFace == 5 then
    BX = BX + 1
    end
    
    if BlockFace == 0 then
    BY = BY - 2
    end
    
    local MobID = Player:GetWorld():SpawnMob(BX, BY, BZ, mtIronGolem) --Gets ID of Iron Golem and spawns it
    
    Player:GetWorld():DoWithEntityByID(MobID,
      function(Entity)
       -- Entity:SetCustomName(Player:GetTeam():GetDisplayName() .. "Dream Defender")
        Entity:SetCustomName("Dream Defender")
        Entity:SetCustomNameAlwaysVisible(true)
        Entity.TimeLeft = 12000
        if Player:GetTeam() ~= nil then Entity.Team = Player:GetTeam() end -- Assigns the Dream Defender a team based on the thrower's team
        table.insert(DreamDefenderArray, Entity)
      end)
    Player:GetInventory():RemoveOneEquippedItem() -- Takes a spawn egg away
    return true

  end
    
  if HeldItem.m_ItemType == 373 and HeldItem.m_ItemDamage == 0 then -- Checks if they're using a Water bottle (damage == 0 is water bottle)
                           --takes the effect type from lore, effect duration from lore, effect intensity from lore.
    
    Player:AddEntityEffect(HeldItem.m_LoreTable[4], HeldItem.m_LoreTable[5] * 20, HeldItem.m_LoreTable[6], 1) -- Last argument is distance modifier, doesn't matter,
                                                                                                             -- only for splash potions
                                                                                                             
    Player:GetInventory():RemoveOneEquippedItem() -- Takes the potion away
    return true
  end

  return false
end



function OnProjectileHitBlock(ProjectileEntity, BlockX, BlockY, BlockZ, BlockFace, BlockHitPos)
  local World = ProjectileEntity:GetWorld() 
  local ThrowerID = ProjectileEntity:GetCreatorUniqueID() -- ID of the thrower
  local Thrower
  
  World:DoWithEntityByID(ThrowerID, -- Finds the Entity itself that threw the projectile
    function(Entity)
      Thrower = Entity
    end)
  
  
  
  if ProjectileEntity:GetProjectileKind() == cProjectileEntity.pkSnowball then -- Check if projectile is snowball
    
    local MobID = World:SpawnMob(BlockX, BlockY, BlockZ, mtSilverfish, false) --Spawns a non baby silverfish at the location snowball hit and gets that entity's ID
    
    World:DoWithEntityByID(MobID, --Does stuff to the bedbug
      function(Entity)
        Entity:SetCustomName("Bedbug") -- Assigns the name
        Entity:SetCustomNameAlwaysVisible(true) -- Name always visible
        Entity.TimeLeft = 1000 -- How much time the bedbug will live
        if Thrower:GetTeam() ~= nil then Entity.Team = Thrower:GetTeam() end -- Assigns the bedbug a team based on the thrower's team
        table.insert(BedbugArray, Entity) -- puts the bedbug in the next element in array 
        
      end)
    
    
  end

end


function OnProjectileHitEntity(ProjectileEntity, Entity)
  
end


function OnWorldTick (World, TimeDelta)
  
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


function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
    local HeldItem = cItem(Player:GetInventory():GetEquippedItem())
    local World = Player:GetWorld()


    if HeldItem.m_CustomName == "§6Fireball" and HeldItem.m_ItemType == 385 then --Check if player is holding fireball
      HeldItem.m_ItemCount = 1
      
      local PosX = Player:GetPosX()
      local PosY = Player:GetPosY()
      local PosZ = Player:GetPosZ()
      
      Player:GetInventory():RemoveOneEquippedItem()
      World:CreateProjectile(Player:GetPosX(), Player:GetPosY() + 0.9, Player:GetPosZ(), cProjectileEntity.pkGhastFireball, Player, HeldItem, Vector3d(Player:GetLookVector()) * 10)
    return true
    end
    
    if HeldItem.m_CustomName == "§rBridge Egg" and HeldItem.m_ItemType == 344 then --Check if the player is holding bridge egg
      World:CreateProjectile(Player:GetPosX(), Player:GetPosY() + 1.85, Player:GetPosZ(), cProjectileEntity.pkEgg, Player, HeldItem, Vector3d(Player:GetLookVector()) * 20)
      
      local EggID
      
      --Finds the EggID by checking every entity
      World:ScheduleTask(0, function(World)
        World:ForEachEntity(function(Entity)
            if Entity:GetEntityType() == cEntity.etProjectile then

              if Entity:GetProjectileKind() == cProjectileEntity.pkEgg and Entity.BridgeEggActivated ~= true then
                 EggID = Entity:GetUniqueID()
                 Entity.BridgeEggActivated = true
                 
                   --Schedules the egg to start setting wool blocks
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

              end
            end
          end)
        end)
 

      Player:GetInventory():RemoveOneEquippedItem()
      return true
    end

    
    return false
end



function OnExploding(World, ExplosionSize, CanCauseFire, X, Y, Z, Source, SourceData)
  
  if Source == 2 then --Check if  source is a ghast fireball
    
    return false, true, 0.5
    
  end

end


function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta)
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