
  -- Save coordinates for spawns, beds and generators
function SaveArena()
  local IniFile = cIniFile()
  
  for i, value in next, SpawnLocationArray do
    
    if (SpawnLocationArray[i].z ~= nil) then
      IniFile:SetValueI(i, "x", SpawnLocationArray[i].x)
      IniFile:SetValueI(i, "y", SpawnLocationArray[i].y)
      IniFile:SetValueI(i, "z", SpawnLocationArray[i].z)
    end
  end
  
  IniFile:WriteFile(cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/ArenaSaveData.ini")
  
end

function LoadArena()
   -- TODO Catch Errors
  
  local IniFile = cIniFile()
  IniFile:ReadFile(cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/ArenaSaveData.ini")
  
    -- loop through each of the keys and each of the values in each of the keys, writing to the SpawnLocationArray
  for k = 0, IniFile:GetNumKeys() - 1 do
    for v = 0, IniFile:GetNumValues(k) - 1 do
      LOG(SpawnLocationArray[IniFile:GetKeyName(k)][IniFile:GetValueName(k, v)])
      SpawnLocationArray[IniFile:GetKeyName(k)][IniFile:GetValueName(k, v)] = IniFile:GetValue(k, v)
    end
    
  end
end
