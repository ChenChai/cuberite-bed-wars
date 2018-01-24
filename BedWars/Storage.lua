
  -- Save coordinates for spawns, beds and generators
function SaveArenas()
  local IniFile = cIniFile()
  
  SpawnLocationArray = {["RedSpawn"] = RedSpawn, ["BlueSpawn"] =  BlueSpawn}
  BedLocationArray = {["RedBedCoords"] = RedBedCoords, ["RedBedCoords"] = BlueBedCoords}
  
  for i, value in next, SpawnLocationArray do
    IniFile:SetValueI(i, "x", SpawnLocationArray[i].x)
    IniFile:SetValueI(i, "y", SpawnLocationArray[i].y)
    IniFile:SetValueI(i, "z", SpawnLocationArray[i].z)
  end
  
  IniFile:WriteFile(cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/ArenaSaveData.ini")
  
end




