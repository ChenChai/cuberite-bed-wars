function InitializeTeamShop()
  
  ItemShopWindow = cLuaWindow(cWindow.wtChest, 9, 4, "Team Shop")
  return true
end

function OpenTeamShop(Player)
  TeamShopWindow = cLuaWindow(cWindow.wtChest, 9, 4, "Team Shop")
  
  for i=0, 35, 1 do--Clears any previous items
    Window:SetSlot(Player, i, cItem(0, 1, 0, "", ""))
  end
  
  local TeamShopContents = {
                          [11] = {cItem(E_BLOCK_FURNACE, 1, 0, "", "§aArmor"), {"§7Avalible:", "§8-Chainmail Boots", "§8-Chainmail Leggings", "§8-Iron Boots", "§8-Iron Leggings", "§8-Diamond Boots", "§8-Diamond Leggings", "", "§eClick to Browse!"}};
                          [12] = {cItem(283, 1, 0, "", "§aMelee"), {"§7Avalible:", "§8-Stone Sword", "§8-Iron Sword", "§8-Diamond Sword", "§8-Stick (Knockback I)", "", "§eClick to Browse!"}};
                          [13] = {cItem(172, 1, 0, "", "§aBlocks"), {"§7Avaliable:", "§8-Wool", "§8-Hardened Clay", "§8-Blast-Proof Glass", "§8-End Stone", "§8-Ladder", "§8-Oak Wood Planks", "§8-Obsidian", "", "§eClick to Browse!"}};
                          [14] = {cItem(261, 1, 0, "", "§aRanged"), {"§7Available:", "§8-Arrow", "§8-Bow", "§8-Bow (Power I)", "§8-Bow (Power I, Punch I)", "", "§eClick to Browse!"}};
                          [20] = {cItem(274, 1, 0, "", "§aTools"), {"§7Available:", "§8-Shears", "§8-Pickaxe Upgrades", "§8-Axe Upgrades", "", "§eClick to Browse!"}};
                          [21] = {cItem(373, 1, 6, "", "§aPotions"),{"§7Available:", "§8-Speed II Potion (0:45)", "§8-Jump Boost V Potion (0:45)", "§8-Invisibility Potion (0:30)", "", "§eClick to Browse!"}};
                          [22] = {cItem(46, 1, 0, "", "§aUtility"), {"§7Avaliable:", "§8-Golden Apple", "§8-Bedbug", "§8-Dream Defender", "§8-Fireball", "§8-TNT", "§8-Ender Pearl", "§8-Water Bucket", "§8-Bridge Egg", "", "§eClick to Browse!"}} --Sets TNT Item (ID 46)
                          
                          }

  for i, value in next, TeamShopContents do -- Sets up table with items in slot
    value[1].m_LoreTable = value[2] -- sticks lore table on from array 
    Window:SetSlot(Player, i, value[1]) -- puts item in window
  end
  
  
  ItemShopWindow:SetOnClicked(TeamShopClickedCallback)
  Player:OpenWindow(TeamShopWindow)
  Player:SendMessage("Shop Opened!")
end


function ItemShopClickedCallback(Window, Player, SlotNum, ClickAction, ClickedItem)
  
  
  
  
  return
end


