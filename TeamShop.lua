function InitializeTeamShop()
  ItemShopWindow = cLuaWindow(cWindow.wtChest, 9, 4, "Team Shop")
  return true
end

function OpenTeamShop(Player)
  TeamShopWindow = cLuaWindow(cWindow.wtChest, 9, 4, "Team Shop")
  
  for i=0, 35, 1 do--Clears any previous items
    TeamShopWindow:SetSlot(Player, i, cItem(0, 1, 0, "", ""))
  end
  
  
  
  
  
  RedTeam.Upgrades = { ["Effects"] = {
                                      ["effHaste"] = 0
                                      
                                      };
                       
                       
                       ["ForgeTier"] = 0;
                       
                       ["SharpenedSwords"] = 0;
                       ["ReinforcedArmor"] = 0;
                     }
                     
  Player:SetTeam(RedTeam)
  
  
  
  local TeamShopContents = {
                          [11] = {UpgradeType = "ForgeTier";
                                  MaxTier = 4;
                                  [1] = {DisplayItem = cItem(E_BLOCK_FURNACE, 1, 0, "", "§aIron Forge"),    DisplayLore = {"§7Increases the spawn rate of", "§7iron and gold by 50%!" },  
                                         CostLore = "Cost: 4 Diamond", Cost = cItem(E_ITEM_DIAMOND, 4, 0, "")};
                                         
                                  [2] = {DisplayItem = cItem(E_BLOCK_FURNACE, 1, 0, "", "§aGold Forge"),    DisplayLore = {"§7Increases the spawn rate of", "§7iron and gold by 100%!" }, 
                                         CostLore = "Cost: 8 Diamond", Cost = cItem(E_ITEM_DIAMOND, 8, 0, "")};
                                         
                                  [3] = {DisplayItem = cItem(E_BLOCK_FURNACE, 1, 0, "", "§aEmerald Forge"), DisplayLore = {"§7Activates the Emerald spawner", "§7in your team's Forge!" }, 
                                         CostLore = "Cost: 12 Diamond", Cost = cItem(E_ITEM_DIAMOND, 12, 0, "")};
                                         
                                  [4] = {DisplayItem = cItem(E_BLOCK_FURNACE, 1, 0, "", "§aGold Forge"),    DisplayLore = {"§7Increases the spawn rate of", "§7iron, gold, and emerald by 200%!" }, 
                                         CostLore = "Cost: 16 Emerald", Cost = cItem(E_ITEM_DIAMOND, 16, 0, "")}
                                  };
                                  
                          [12] = {UpgradeType = "Effects";
                                  MaxTier = 2;
                                  EffectType = "effHaste";
                                  [1] = {DisplayItem = cItem(E_ITEM_GOLD_PICKAXE, 1, 0, "", "§aManiac Miner I"),  DisplayLore = {"§7Give permanent Haste I", "§7to all players on your team!"}, 
                                         CostLore = "Cost: 4 Diamond", Cost = cItem(E_ITEM_DIAMOND, 4, 0, "")};
                                         
                                  [2] = {DisplayItem = cItem(E_ITEM_GOLD_PICKAXE, 1, 0, "", "§aManiac Miner II"), DisplayLore = {"§7Give permanent Haste II", "§7to all players on your team!"}, 
                                         CostLore = "Cost: 6 Diamond", Cost = cItem(E_ITEM_DIAMOND, 6, 0, "")};
                                 };
                          
                          [13] = {UpgradeType = "SharpenedSwords";
                                  MaxTier = 1;
                                  [1] = {DisplayItem = cItem(E_ITEM_IRON_SWORD, 1, 0, "", "§aManiac Miner I"),  DisplayLore = {"§7Give permanent Haste I to all players on your team!"}, 
                                  [1] = {DisplayItem = cItem(E_ITEM_IRON_SWORD, 1, 0, "", "§aSharpened Swords"),  DisplayLore = {"§7Enchant swords with Sharpness I", "for all players on your team!"}, 
                                         CostLore = "Cost: 8 Diamond", Cost = cItem(E_ITEM_DIAMOND, 8, 0, "")}
                                 };
                                 
                          [14] = {UpgradeType = "ReinforcedArmor";
                                  MaxTier = 4;
                                  [1] = {DisplayItem = cItem(E_ITEM_IRON_CHESTPLATE, 1, 0, "", "§aReinforced Armor I"),  DisplayLore = {"§7Enchant Armor with Protection I", "for all players on your team!"}, 
                                         CostLore = "Cost: 5 Diamond", Cost = cItem(E_ITEM_DIAMOND, 5, 0, "")};
                                  
                                  [2] = {DisplayItem = cItem(E_ITEM_IRON_CHESTPLATED, 1, 0, "", "§aReinforced Armor II"),  DisplayLore = {"§7Enchant Armor with Protection II", "for all players on your team!"}, 
                                         CostLore = "Cost: 10 Diamond", Cost = cItem(E_ITEM_DIAMOND, 10, 0, "")};
                                  
                                  [3] = {DisplayItem = cItem(E_ITEM_IRON_CHESTPLATE, 1, 0, "", "§aReinforced Armor III"),  DisplayLore = {"§7Enchant Armor with Protection III", "for all players on your team!"}, 
                                         CostLore = "Cost: 20 Diamond", Cost = cItem(E_ITEM_DIAMOND, 20, 0, "")};
                                  
                                  [4] = {DisplayItem = cItem(E_ITEM_IRON_CHESTPLATE, 1, 0, "", "§aReinforced Armor IV"),  DisplayLore = {"§7Enchant Armor with Protection IV", "for all players on your team!"}, 
                                         CostLore = "Cost: 30 Diamond", Cost = cItem(E_ITEM_DIAMOND, 30, 0, "")};
                                 }            
                          
                          
                          
                          
                          
                          
                          }
  
  for i, Upgrade in next, TeamShopContents do -- Sets up table with display items in slot
    
    local Item
    local Tier
    local DisplayTier
    
    if Upgrade.UpgradeType == "Effects" then
      Tier = Player:GetTeam().Upgrades.Effects[Upgrade.EffectType]
      DisplayTier = math.max(Tier + 1, Upgrade.MaxTier)
      
      Item = Upgrade[DisplayTier].DisplayItem
    else
      Tier = Player:GetTeam().Upgrades[Upgrade.UpgradeType]
      DisplayTier = math.max(Tier + 1, Upgrade.MaxTier)
      
      Item = Upgrade[DisplayTier].DisplayItem
    end
    
    Item.m_LoreTable = Upgrade[DisplayTier].DisplayLore -- sticks lore table on from array 
    table.insert(Item.m_LoreTable, Upgrade.CostLore)
    TeamShopWindow:SetSlot(Player, i, Item) -- puts item in window
    
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


