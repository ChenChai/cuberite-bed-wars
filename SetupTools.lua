function InitializeSetupTools()
  
  SetupToolsArray = { ["§4Set Red Team Bed"] = {ToolItem = cItem(E_ITEM_BED, 1, 0, "", "§4Set Red Team Bed"), ToolLore = {"§7Place this bed to set the starting bed location!"}, 
                             SetVariable = "RedBedCoords", ConfirmMessage = "Red team bed set!"}
                      -- Sets red spawn
                      -- Sets blue bed
                      -- Sets Red bed
                      }
  
  cPluginManager.BindCommand("/tools", "", ToolsCommand, " ~ /tools <give/delete>")
end

function ToolsCommand(Split, Player)
  
  if Split[2] == "give" then
    for i, ToolData in next, SetupToolsArray do
      local Item = ToolData.ToolItem
      
      Item.m_LoreTable = ToolData.ToolLore
      Player:GetInventory():AddItem(Item)
      return false
    end
  end
  
end
  -- TODO Un hardcode these when we un hardcode teams
function SetRedBed()

end








