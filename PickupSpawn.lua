  -- NOTE: All numbers in ticks!
function InitializePickupSpawn()
  --inits the pickups vars and other things
  ForgeTier = {["Iron"] = {
                              [0] = 2;
                              [1] = 3;
                              [2] = 4;
                              [3] = 4;
                              [4] = 6;
                              };
               ["Gold"] = {
                              [0] = 2;
                              [1] = 3;
                              [2] = 4;
                              [3] = 4;
                              [4] = 6;
                              };
               ["ForgeEmerald"] = {
                              [0] = 0;
                              [1] = 0;
                              [2] = 0;
                              [3] = 1;
                              [4] = 3;
                              };
              }
  
  ResourceLocations = { Forges        = {
                                       {x = 1, y = 41, z = 74, Team = BlueTeam};
                                       {x = 1, y = 41, z = -39, Team = RedTeam};
                                      }; 
                      
                      DiamondSpawns = {
                                       {x = 1, y = 41, z = 42, Team = nil};
                                       {x = 1, y = 41, z = -39, Team = nil};
                                      };
                      
                      
                      EmeraldSpawns = {
                                       {x = -5, y = 42, z = -1, Team = nil};
                                       {x = 7, y = 42, z = -1, Team = nil};
                                      };
                    }
  
  ResourceSpawnArray =  {Iron =         {Item = cItem(E_ITEM_IRON),     NextSpawnTime = 0, SpawnDelay = 5 * 1000,  Locations = ResourceLocations.Forges};
                         Gold =         {Item = cItem(E_ITEM_GOLD),     NextSpawnTime = 0, SpawnDelay = 20 * 1000, Locations = ResourceLocations.Forges};
                         ForgeEmerald = {Item = cItem(E_ITEM_EMERALD),  NextSpawnTime = 0, SpawnDelay = 5 * 1000,  Locations = ResourceLocations.Forges};
                         Emerald =      {Item = cItem(E_ITEM_EMERALD),  NextSpawnTime = 0, SpawnDelay = 65 * 1000, Locations = ResourceLocations.EmeraldSpawns};
                         Diamond =      {Item = cItem(E_ITEM_DIAMOND),  NextSpawnTime = 0, SpawnDelay = 30 * 1000, Locations = ResourceLocations.DiamondSpawns};
                         }
  
end

function SpawnItemClock()
  --Events
  if GameTime >= 360 * 1000 then
    --Upgrade Diamond gen to lvl 2
    ResourceSpawnArray.Diamond.SpawnDelay = 25 * 1000
  end
  if GameTime >= 720 * 1000 then
    --Em Gen to lvl 2
    ResourceSpawnArray.Emerald.SpawnDelay = 60 * 1000
  end
  if GameTime >= 1080 * 1000 then
    --Dia to lvl 3
    ResourceSpawnArray.Diamond.SpawnDelay = 20 * 1000
  end
  if GameTime >= 1440 * 1000 then
    --Em to lvl 3
    ResourceSpawnArray.Emerald.SpawnDelay = 55 * 1000
  end
  
  if GameTime == 1800 * 1000 then
    --Destroy Beds
    RedBed = false
    BlueBed = false
  end
  
  for ResourceName, Resource in next, ResourceSpawnArray do
    if GameTime >= Resource.NextSpawnTime then
      SpawnResource(ResourceName, Resource.Item, Resource.Locations)
      Resource.NextSpawnTime = GameTime + Resource.SpawnDelay
    end
  end
  
  return
end

  -- A list of locations to spawn that resource at 
function SpawnResource(ResourceName, Item, Locations)
  for i, Location in next, Locations do
    local ItemStack = Item
    
    if Location.Team ~= nil and ForgeTier[ResourceName] ~= nil then
      local Tier = Location.Team.Upgrades.ForgeTier
      ItemStack.m_ItemCount = ForgeTier[ResourceName][Tier]
      if ItemStack.m_ItemCount == 0 then return end
    end
    
    Arena:SpawnItemPickup(Location.x, Location.y, Location.z, ItemStack, 0, 0, 0, 3600, true)
  end
  
  return
end
