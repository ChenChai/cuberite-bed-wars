  -- NOTE: All numbers in ticks!
function InitializePickupSpawn()
  --inits the pickups vars and other things

  
    -- This is a list of locations where pickups will spawn; associated with their team
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
  
    -- This is a list of items that will spawn, how frequently they spawn (SpawnDelay) and a list of locations they will spawn at
  ResourceSpawnArray =  {Iron =         {Item = cItem(E_ITEM_IRON),     NextSpawnTime = 0, SpawnDelay = 5 * 1000,  Locations = ResourceLocations.Forges};
                         Gold =         {Item = cItem(E_ITEM_GOLD),     NextSpawnTime = 0, SpawnDelay = 20 * 1000, Locations = ResourceLocations.Forges};
                         ForgeEmerald = {Item = cItem(E_ITEM_EMERALD),  NextSpawnTime = 0, SpawnDelay = 5 * 1000,  Locations = ResourceLocations.Forges};
                         Emerald =      {Item = cItem(E_ITEM_EMERALD),  NextSpawnTime = 0, SpawnDelay = 65 * 1000, Locations = ResourceLocations.EmeraldSpawns};
                         Diamond =      {Item = cItem(E_ITEM_DIAMOND),  NextSpawnTime = 0, SpawnDelay = 30 * 1000, Locations = ResourceLocations.DiamondSpawns};
                         }
    -- How much resource is spawned at each forge tier
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
  
end

function SpawnItemClock()
  --UpdateScores() is now called in Hooks
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
    -- Loop through each resource in the array, checking if it is time to spawn yet
  for ResourceName, Resource in next, ResourceSpawnArray do
    if GameTime >= Resource.NextSpawnTime then
        -- Loops through each of the locations, spawning pickups at each one
      SpawnResource(ResourceName, Resource.Item, Resource.Locations)
        -- Set up the next resource spawn time
      Resource.NextSpawnTime = Resource.NextSpawnTime + Resource.SpawnDelay
    end
  end
  
  return
end

  -- TODO Make more independent of other arrays, values could be passed into this function instead of accessed globally
function SpawnResource(ResourceName, Item, Locations)
    -- Loop through the locations
  for i, Location in next, Locations do
    local ItemStack = Item
    
      -- If the location is associated with a team (i.e. a forge) then use ForgeTier table to determine how much stuff they should spawn
    if Location.Team ~= nil and ForgeTier[ResourceName] ~= nil then
    
        -- Finds the forge tier of the team associated with the forge
      local Tier = Location.Team.Upgrades.ForgeTier
      ItemStack.m_ItemCount = ForgeTier[ResourceName][Tier]
        -- Some things, like ForgeEmeralds, do not spawn at lower tiers
      if ItemStack.m_ItemCount == 0 then return end
      
    end
    
    Arena:SpawnItemPickup(Location.x, Location.y, Location.z, ItemStack, 0, 0, 0, 3600, true)
  end
  
  return
end
