function InitializeSetupTools()
  
  SetupToolsArray = { ["§4Set Red Team Bed"] = {ToolItem = cItem(E_ITEM_BED, 1, 0, "", "§4Set Red Team Bed"), ToolLore = {"§7Place this bed to set the starting bed location!"}, 
                             SetVariable = "RedBedCoords", ConfirmMessage = "§4Red team bed set!", KeepBlock = true};
                             
                      ["§1Set Blue Team Bed"] = {ToolItem = cItem(E_ITEM_BED, 1, 0, "", "§1Set Blue Team Bed"), ToolLore = {"§7Place this bed to set the starting bed location!"}, 
                             SetVariable = "BlueBedCoords", ConfirmMessage = "§1Blue team bed set!", KeepBlock = true};
                      
                      ["§4Set Red Team Spawn"] = {ToolItem = cItem(E_BLOCK_WOOL, 1, E_META_WOOL_RED, "", "§4Set Red Team Spawn"), ToolLore = {"§7Place this block to set the starting spawn location!"}, 
                             SetVariable = "RedSpawn", ConfirmMessage = "§4Red team spawn set!", KeepBlock = false};
                      
                      ["§1Set Blue Team Spawn"] = {ToolItem = cItem(E_BLOCK_WOOL, 1, 0, "", "§1Set Blue Team Spawn"), ToolLore = {"§7Place this bed to set the starting spawn location!"}, 
                             SetVariable = "BlueSpawn", ConfirmMessage = "§1Blue team spawn set!", KeepBlock = false}
                      
                      }
  
  cPluginManager.BindCommand("/tools", "", ToolsCommand, " ~ /tools <give/delete>")
end

function ToolsCommand(Split, Player)
  
  if Split[2] == "give" then
    for i, ToolData in next, SetupToolsArray do
      local Item = ToolData.ToolItem
      
      Item.m_LoreTable = ToolData.ToolLore
      Player:GetInventory():AddItem(Item)
    end
    return true
  end
  
end
  -- TODO Un hardcode these when we un hardcode teams
function SetRedBed()

end








