
  -- Save coordinates for spawns, beds and generators
function SaveArena()
  local IniFile = cIniFile()
  
  for i, value in next, LocationArray do
    
    if (LocationArray[i].z ~= nil) then
      IniFile:SetValueI(i, "x", LocationArray[i].x)
      IniFile:SetValueI(i, "y", LocationArray[i].y)
      IniFile:SetValueI(i, "z", LocationArray[i].z)
    end
  end
  
  IniFile:WriteFile(cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/ArenaSaveData.ini")
  
end

function LoadArena()
   -- TODO Catch Errors
  
  local IniFile = cIniFile()
  IniFile:ReadFile(cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/ArenaSaveData.ini")
  
    -- loop through each of the keys and each of the values in each of the keys, writing to the LocationArray
  for k = 0, IniFile:GetNumKeys() - 1 do
    for v = 0, IniFile:GetNumValues(k) - 1 do
      LocationArray[IniFile:GetKeyName(k)][IniFile:GetValueName(k, v)] = IniFile:GetValue(k, v)
    end
    
  end
end
