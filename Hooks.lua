  -- TODO Refactor all these hooks into actually readable functions

function BindHooks()
  
    -- map management hooks
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
  cPluginManager:AddHook(cPluginManager.HOOK_KILLING, OnKilling)
  
    -- so far these are the item hooks; doesn't really matter since they'll be used for similar things
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
  cPluginManager:AddHook(cPluginManager.HOOK_EXPLODING, OnExploding)
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_USING_ITEM, OnPlayerUsingItem)
  cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK, OnWorldTick)
  cPluginManager:AddHook(cPluginManager.HOOK_PROJECTILE_HIT_BLOCK, OnProjectileHitBlock)
  cPluginManager:AddHook(cPluginManager.HOOK_PROJECTILE_HIT_ENTITY, OnProjectileHitEntity)
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_EATING, OnPlayerEating)
    -- Gee we're lucky none of these have clashed actually  
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_TOSSING_ITEM, OnPlayerTossingItem)
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICKING_ENTITY, OnPlayerRightClickingEntity)
  cPluginManager:AddHook(cPluginManager.HOOK_SPAWNING_ENTITY, OnSpawningEntity)
  
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
      --Let em spectate
      victim:SetGameMode(gmSpectator)
    end
    vic_team = nil
  end
end

function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockType, BlockMeta)
  if BlockType == E_BLOCK_TNT then
    PlaceInstantTNT(Player, BlockX, BlockY, BlockZ) -- See Items: Places primed tnt and removes it from player's inventory
    return true
  end
  
  
    -- Used for setup tools setting up the arena
  local Item = Player:GetInventory():GetEquippedItem()
  local ToolUsed = SetupToolsArray[Item.m_CustomName]
  
  if ToolUsed == nil then
    return false
  end
  
  if Item.m_CustomName == ToolUsed.ToolItem.m_CustomName then
    SpawnLocationArray[ToolUsed.SetVariable] = {x = BlockX, y = BlockY, z = BlockZ}
    Player:SendMessage(ToolUsed.ConfirmMessage)
    return false
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
    SpawnTeamMob(mtSilverfish, "Bedbug", Thrower:GetTeam(), 1000, BlockX, BlockY, BlockZ, World, BedbugArray)
  end

end

function OnProjectileHitEntity(ProjectileEntity, Entity)
  
end

function OnWorldTick(World, TimeDelta)
  SpawnItemClock(TimeDelta) -- goes to pickup spawn
  TickSpawnedMobs(World) -- Items.Lua
  Arena:ForEachPlayer(CheckIfInTrap) --goes to ItsATrap.lua
  Arena:ForEachPlayer(CheckHealPool) -- HealPool.lua
  return
end

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
    local HeldItem = cItem(Player:GetInventory():GetEquippedItem())
    local World = Player:GetWorld()

  
    if HeldItem.m_CustomName == "§6Fireball" and HeldItem.m_ItemType == E_ITEM_FIRE_CHARGE then --Check if player is holding fireball
      ThrowFireball(Player)
      return true
    end
    
    if HeldItem.m_CustomName == "§rBridge Egg" and HeldItem.m_ItemType == E_ITEM_EGG then --Check if the player is holding bridge egg
      ThrowBridgeEgg(Player)
      return true
    end
    
    return false
end

function OnExploding(World, ExplosionSize, CanCauseFire, X, Y, Z, Source, SourceData)
  
  if Source == esGhastFireball then --Check if  source is a ghast fireball
    return false, true, 0.5 -- Lets explosion happen, can light things on fire, explosion size 0.5
  end
end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta)
  --Checks if a player has broken a bed block, and whos bed it is...
  return BrokenBlock(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta) --in main.lua
end

function OnPlayerEating(Player)
  
  if Player:GetInventory():GetEquippedItem().m_ItemType == E_ITEM_POTION then
    DrinkCustomPotion(Player) -- Items.lua
  end
  
end

function OnPlayerRightClickingEntity(Player, Entity)
  if Entity:IsMob() == false then
    return false
  end

  if Entity:GetMobType() == mtVillager and Entity:GetCustomName() == "§e§lItem Shop" then
    OpenShop(Player) -- Shop.lua
  end
  
  if Entity:GetMobType() == mtVillager and Entity:GetCustomName() == "§e§lTeam Shop" then
    OpenTeamShop(Player) -- TeamShop.lua
  end
end

function OnPlayerTossingItem(Player)  ---We don't want players exchanging armor. This doesn't actually prevent items from being dropped through the inventory window, only hotbar
                                      ---This means that we'll have to just delete the item if they toss it... 
  if Player:GetGameMode() ~= eGameMode_Survival then -- If they aren't in survival mode then let them toss the item.
    return false -- Lets them toss item
  end

  
  if TransferableItemsArray[Player:GetDraggingItem().m_ItemType] == false then -- Is it in the list of nontransferable items?

    return true -- If so, cancel the action.
  end
  
  if TransferableItemsArray[Player:GetEquippedItem().m_ItemType] == false then 
    return true
  end
  
  return false
end

function OnSpawningEntity(World, Entity) --- Trying to delete the item if they manage to actually toss it!
  if Entity:IsPickup() then
    if TransferableItemsArray[Entity:GetItem().m_ItemType] == false then
      return true
    else
      return false
    end
  end
  return false
end






