function InitializeTeamShop()
  
  ItemShopWindow = cLuaWindow(cWindow.wtChest, 9, 4, "Team Shop")
  return true
end

function OpenTeamShop(Player)
  TeamShopWindow = cLuaWindow(cWindow.wtChest, 9, 4, "Team Shop")
  
  for i=0, 35, 1 do--Clears any previous items
    Window:SetSlot(Player, i, cItem(0, 1, 0, "", ""))
  end
  
  local TeamUpgradesList = { ["Iron Forge"] = { [0] = }
                             [""]
                              
                              
                              
                              
                              }  
  
  RedTeam.Upgrades = { ["Effects"] = { ["effHaste"] = 0};
                       ["ForgeTier"] = 0;
                     }
  
  
  
  
  local TeamShopContents = {
                          [11] = {UpgradeType = "ForgeTier";
                                  MaxTier = 4;
                                  [1] = {DisplayItem = cItem(E_BLOCK_FURNACE, 1, 0, "", "§aIron Forge"),    DisplayLore = {"§7Increases the spawn rate of iron and gold by 50%!" },  
                                         CostLore = "Cost: 4 Diamond", Cost = cItem(E_ITEM_DIAMOND, 4, 0, "")};
                                         
                                  [2] = {DisplayItem = cItem(E_BLOCK_FURNACE, 1, 0, "", "§aGold Forge"),    DisplayLore = {"§7Increases the spawn rate of iron and gold by 100%!" }, 
                                         CostLore = "Cost: 8 Diamond", Cost = cItem(E_ITEM_DIAMOND, 8, 0, "")};
                                         
                                  [3] = {DisplayItem = cItem(E_BLOCK_FURNACE, 1, 0, "", "§aEmerald Forge"), DisplayLore = {"§7Activates the Emerald spawner in your team's Forge!" }, 
                                         CostLore = "Cost: 12 Diamond", Cost = cItem(E_ITEM_DIAMOND, 12, 0, "")};
                                         
                                  [4] = {DisplayItem = cItem(E_BLOCK_FURNACE, 1, 0, "", "§aGold Forge"),    DisplayLore = {"§7Increases the spawn rate of iron, gold, and emerald by 200%!" }, 
                                         CostLore = "Cost: 16 Emerald", Cost = cItem(E_ITEM_DIAMOND, 16, 0, "")}
                                  };
                                  
                          [12] = {UpgradeType = "Effects";
                                  MaxTier = 2;
                                  EffectType = "effHaste"
                                  [1] = {DisplayItem = cItem(E_ITEM_GOLD_PICKAXE, 1, 0, "", "§aManiac Miner I"),  DisplayLore = {"§7Give permanent Haste I to all players on your team!"}, 
                                         CostLore = "Cost: 4 Diamond", Cost = cItem(E_ITEM_DIAMOND, 4, 0, "")};
                                         
                                  [2] = {DisplayItem = cItem(E_ITEM_GOLD_PICKAXE, 1, 0, "", "§aManiac Miner II"), DisplayLore = {"§7Give permanent Haste II to all players on your team!"}, 
                                         CostLore = "Cost: 6 Diamond", Cost = cItem(E_ITEM_DIAMOND, 6, 0, "")};
                                 };
                          
                          
                          
                          
                          [13] = {cItem(172, 1, 0, "", "§aBlocks"), {"§7Avaliable:", "§8-Wool", "§8-Hardened Clay", "§8-Blast-Proof Glass", "§8-End Stone", "§8-Ladder", "§8-Oak Wood Planks", "§8-Obsidian", "", "§eClick to Browse!"}};
                          [14] = {cItem(261, 1, 0, "", "§aRanged"), {"§7Available:", "§8-Arrow", "§8-Bow", "§8-Bow (Power I)", "§8-Bow (Power I, Punch I)", "", "§eClick to Browse!"}};
                          [20] = {cItem(274, 1, 0, "", "§aTools"), {"§7Available:", "§8-Shears", "§8-Pickaxe Upgrades", "§8-Axe Upgrades", "", "§eClick to Browse!"}};
                          [21] = {cItem(373, 1, 6, "", "§aPotions"),{"§7Available:", "§8-Speed II Potion (0:45)", "§8-Jump Boost V Potion (0:45)", "§8-Invisibility Potion (0:30)", "", "§eClick to Browse!"}};
                          [22] = {cItem(46, 1, 0, "", "§aUtility"), {"§7Avaliable:", "§8-Golden Apple", "§8-Bedbug", "§8-Dream Defender", "§8-Fireball", "§8-TNT", "§8-Ender Pearl", "§8-Water Bucket", "§8-Bridge Egg", "", "§eClick to Browse!"}} --Sets TNT Item (ID 46)
                          
                          }
  
  for i, Upgrade in next, TeamShopContents do -- Sets up table with items in slot
    
    local Item
    
    if Upgrade.UpgradeType == "Effects" then
      local CurrentEffectTier = Player:GetTeam().Effects[EffectType]
      Item = Upgrade[math.max(CurrentEffectTier + 1, Upgrade.MaxTier)].DisplayItem
    else
      
    end
    
    
    
    Item.m_LoreTable = Upgrade.DisplayLore -- sticks lore table on from array 
    table.insert(Item.m_LoreTable, Upgrade.CostLore)
    Window:SetSlot(Player, i, Item) -- puts item in window
    
  end
  
  
  ItemShopWindow:SetOnClicked(TeamShopClickedCallback)
  Player:OpenWindow(TeamShopWindow)
  Player:SendMessage("Shop Opened!")
end


function TeamShopClickedCallback(Window, Player, SlotNum, ClickAction, ClickedItem)
  
  if a_ClickedItem.m_ItemType == 0 or a_ClickedItem.m_ItemType == -1 then --Checks if you're clicking on air
    return true
  end
  
  if a_SlotNum < 0 or a_SlotNum > 35 then --Checks if you're clicking the shop
    return true
  end
  
  if a_ClickAction == caShiftLeftClick then --Checks if you're trying to shift click
    return true
  end
  
  if ClickedItem.m_ItemType == E_BLOCK_FURNACE then
    
  end
  
  
  
  
  
  return
end


