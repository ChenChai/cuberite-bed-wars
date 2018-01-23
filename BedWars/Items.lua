-- This file handles item hooks

function InitializeItems()

  DreamDefenderArray = {}
  BridgeEggArray = {}
  BedbugArray = {}
  
  cPluginManager.BindCommand("/empower", "", EmpowerAdd, " ~ /empower <power>")

  
  LOG("Initialised Bedwars Item Handling!")

end

  --- THIS IS JUST FOR DEBUGGING, REMOVE WHEN PUSHING TO PRODUCTION
function EmpowerAdd(Split, Player) -- Callback to use commands to give items (WIP) Depreciated
    
    --if Split.getn ~= 2 then return false end --Check if there are 2 parameters
    local EmpowerType = Split[2]
    if EmpowerType == "firecharge" then

        local FireBall = cItem(385, 1, 0, "", "§6Fireball") -- assigns Firecharge item

        FireBall.m_LoreTable = {"§7§oRight Click to Throw!"}
        Player:GetInventory():AddItem(FireBall)
    
        return true
    else
        return true
    end
end
  

function PlaceInstantTNT(Player, BlockX, BlockY, BlockZ)
    Player:GetInventory():RemoveItem(cItem(E_BLOCK_TNT, 1, 0, "", "§rInstant TNT"))
    Player:GetWorld():SpawnPrimedTNT(Vector3d(BlockX, BlockY, BlockZ), 70, 5)
    return
end



