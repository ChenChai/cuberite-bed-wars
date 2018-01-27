--Uses commands to organize players into teams, hadle spawning and beds

PLUGIN = nil

function Initialize(Plugin)
  Plugin:SetName("Bedwars Main")
  Plugin:SetVersion(1.1)
  

  GetConfig()
  InitializeTeams()

  
  InitializeShop()
  InitializeItems()
  InitializePickupSpawn()
  InitializeSetupTools()
  

  
  BindHooks()
  
  LocationArray = {["BlueBedCoords"] = {x, y, z}, ["RedBedCoords"] = {x, y, z}, ["RedSpawn"] = {x, y, z}, ["BlueSpawn"] = {x, y, z}}
  LoadArena() -- Storage.lua
  
  
  PLUGIN = Plugin
  return true
end

function OnDisable()
  LOG(PLUGIN:GetName() .. " is shutting down...")
  
  SaveArena() -- Storage.lua 
end