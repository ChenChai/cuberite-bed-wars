function CheckIfInTrap(Player)
  local Radius = 15
  local X = Player:GetPosX()
  local Z = Player:GetPosZ()
  if Player:GetTeam() then
    if BlueTeam.Upgrades['ItsATrap'] == 1 and Player:GetTeam():GetName() == 'Red' then
      local dX = X - BlueBedCoords['x']
      local dZ = Z - BlueBedCoords['z']
      local Distance = math.sqrt((dX * dX) + (dZ * dZ))
      
      if Distance < Radius then
        Trap(Player)
        BlueTeam.Upgrades['ItsATrap'] = 0
      end
    end
    
    if RedTeam.Upgrades['ItsATrap'] == 1 and Player:GetTeam():GetName() == 'Blue' then
      local dX = X - RedBedCoords['x']
      local dZ = Z - RedBedCoords['z']
      local Distance = math.sqrt((dX * dX) + (dZ * dZ))
      
      if Distance < Radius then
        Trap(Player)
        RedTeam.Upgrades['ItsATrap'] = 0
      end
    end
  end
end

function Trap(Player)
  --Traps player with status
  Player:AddEntityEffect(cEntityEffect.effBlindness, 300, 1, 1)
  Player:AddEntityEffect(cEntityEffect.effSlowness, 300, 2, 1)
end

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



