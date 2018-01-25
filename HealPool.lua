function CheckHealPool(Player)
  local Radius = 15
  local X = Player:GetPosX()
  local Z = Player:GetPosZ()
  if Player:GetTeam() then
    if BlueTeam.Upgrades['HealPool'] == 1 and Player:GetTeam():GetName() == 'Blue' then
      local dX = X - BlueBedCoords['x']
      local dZ = Z - BlueBedCoords['z']
      local Distance = math.sqrt((dX * dX) + (dZ * dZ))
      
      if Distance < Radius then
        HealPoolEffect(Player)
      end
    end
    
    if RedTeam.Upgrades['HealPool'] == 1 and Player:GetTeam():GetName() == 'Red' then
      local dX = X - RedBedCoords['x']
      local dZ = Z - RedBedCoords['z']
      local Distance = math.sqrt((dX * dX) + (dZ * dZ))
      
      if Distance < Radius then
        HealPoolEffect(Player)
      end
    end
  end
end

function HealPoolEffect(Player)
  if Player:HasEntityEffect(cEntityEffect.effRegeneration) == false then
    Player:AddEntityEffect(cEntityEffect.effRegeneration, 60, 1, 1)
  end
end