function InitializeTeamShop()
  ItemShopWindow = cLuaWindow(cWindow.wtChest, 9, 4, "Team Shop")
  return true
end

function OpenTeamShop(Player)
  TeamShopWindow = cLuaWindow(cWindow.wtChest, 9, 4, "Team Shop")
  ResetTeamShopWindow(Player, TeamShopWindow)
  
  Player:OpenWindow(TeamShopWindow)
  Player:SendMessage("Shop Opened!")
end

function TeamShopClickedCallback(Window, Player, SlotNum, ClickAction, ClickedItem)

  if ClickedItem.m_ItemType == 0 or ClickedItem.m_ItemType == -1 then --Checks if you're clicking on air
    return true
  end
  
  if SlotNum < 0 or SlotNum > 35 then --Checks if you're clicking the shop
    return true
  end
  
  if ClickAction == caShiftLeftClick then --Checks if you're trying to shift click
    return true
  end
  
  local UpgradeBuying = TeamShopContents[SlotNum]
  
    -- find the current tier of the upgrade
  local Tier = Player:GetTeam().Upgrades[UpgradeBuying.UpgradeType]
  local DisplayTier = math.min(Tier + 1, UpgradeBuying.MaxTier)
  
  if Tier >= UpgradeBuying.MaxTier then
    Player:SendMessage("§6Upgrade already bought!")
    return true
  end
  
  if Player:GetInventory():HasItems(UpgradeBuying[DisplayTier].Cost) then-- Check if player has resources
    Player:GetInventory():RemoveItem(UpgradeBuying[DisplayTier].Cost) -- removes resources from their inventory
    Player:SendMessage("Upgrade bought!")
    
    Player:GetTeam().Upgrades[UpgradeBuying.UpgradeType] = DisplayTier
    ResetTeamShopWindow(Player, Window)
    return true
  else
    Player:SendMessage("§6Not enough resources!")
  end
  
  
  return true
end

function ResetTeamShopWindow(Player, Window)

  for i=0, 35, 1 do--Clears any previous items
    TeamShopWindow:SetSlot(Player, i, cItem(0, 1, 0, "", ""))
  end
  
  TeamShopContents = {
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
                                  
                          [12] = {UpgradeType = "ManiacMiner";
                                  MaxTier = 2;
                                  [1] = {DisplayItem = cItem(E_ITEM_GOLD_PICKAXE, 1, 0, "", "§aManiac Miner I"),  DisplayLore = {"§7Give permanent Haste I", "§7to all players on your team!"}, 
                                         CostLore = "Cost: 4 Diamond", Cost = cItem(E_ITEM_DIAMOND, 4, 0, "")};
                                         
                                  [2] = {DisplayItem = cItem(E_ITEM_GOLD_PICKAXE, 1, 0, "", "§aManiac Miner II"), DisplayLore = {"§7Give permanent Haste II", "§7to all players on your team!"}, 
                                         CostLore = "Cost: 6 Diamond", Cost = cItem(E_ITEM_DIAMOND, 6, 0, "")};
                                 };
                          
                          [13] = {UpgradeType = "SharpenedSwords";
                                  MaxTier = 1;
                                  [1] = {DisplayItem = cItem(E_ITEM_IRON_SWORD, 1, 0, "", "§aSharpened Swords"),  DisplayLore = {"§7Enchant swords with Sharpness I", "§7for all players on your team!"}, 
                                         CostLore = "Cost: 8 Diamond", Cost = cItem(E_ITEM_DIAMOND, 8, 0, "")}
                                 };
                                 
                          [14] = {UpgradeType = "ReinforcedArmor";
                                  MaxTier = 4;
                                  [1] = {DisplayItem = cItem(E_ITEM_IRON_CHESTPLATE, 1, 0, "", "§aReinforced Armor I"),  DisplayLore = {"§7Enchant Armor with Protection I", "§7for all players on your team!"}, 
                                         CostLore = "Cost: 5 Diamond", Cost = cItem(E_ITEM_DIAMOND, 5, 0, "")};
                                  
                                  [2] = {DisplayItem = cItem(E_ITEM_IRON_CHESTPLATE, 1, 0, "", "§aReinforced Armor II"),  DisplayLore = {"§7Enchant Armor with Protection II", "§7for all players on your team!"}, 
                                         CostLore = "Cost: 10 Diamond", Cost = cItem(E_ITEM_DIAMOND, 10, 0, "")};
                                  
                                  [3] = {DisplayItem = cItem(E_ITEM_IRON_CHESTPLATE, 1, 0, "", "§aReinforced Armor III"),  DisplayLore = {"§7Enchant Armor with Protection III", "§7for all players on your team!"}, 
                                         CostLore = "Cost: 20 Diamond", Cost = cItem(E_ITEM_DIAMOND, 20, 0, "")};
                                  
                                  [4] = {DisplayItem = cItem(E_ITEM_IRON_CHESTPLATE, 1, 0, "", "§aReinforced Armor IV"),  DisplayLore = {"§7Enchant Armor with Protection IV", "§7for all players on your team!"}, 
                                         CostLore = "Cost: 30 Diamond", Cost = cItem(E_ITEM_DIAMOND, 30, 0, "")};
                                 };
                          
                          
                          [15] = {UpgradeType = "ItsATrap";
                                  MaxTier = 1;
                                  [1] = {DisplayItem = cItem(E_BLOCK_TRIPWIRE_HOOK, 1, 0, "", "§aIt's A Trap!"),  DisplayLore = {"§7The next enemy to enter your base will", "§7receive blindness and slowness!"}, 
                                         CostLore = "Cost: 1 Diamond", Cost = cItem(E_ITEM_DIAMOND, 1, 0, "")}
                                 };
                                 
                          [20] = {UpgradeType = "MiningFatigue";
                                  MaxTier = 1;
                                  [1] = {DisplayItem = cItem(E_ITEM_IRON_PICKAXE, 1, 0, "", "§aMining Fatigue"),  DisplayLore = {"§7The next enemy to enter your base will", "§7Mining Fatigue!"}, 
                                         CostLore = "Cost: 3 Diamond", Cost = cItem(E_ITEM_DIAMOND, 3, 0, "")}
                                 };
                          
                          [21] = {UpgradeType = "HealPool";
                                  MaxTier = 1;
                                  [1] = {DisplayItem = cItem(E_BLOCK_BEACON, 1, 0, "", "§aHeal Pool"),  DisplayLore = {"§7Allied players near your bed", "§7will be given regeneration!"}, 
                                         CostLore = "Cost: 3 Diamond", Cost = cItem(E_ITEM_DIAMOND, 3, 0, "")}
                                 }
                          
                          }
  
  for i, Upgrade in next, TeamShopContents do -- Sets up table with display items in slot
    
      -- Tier of upgrade the player already has
    local Tier = Player:GetTeam().Upgrades[Upgrade.UpgradeType]
      -- Tier of upgrade the shop will shop to them
    local DisplayTier = math.min(Tier + 1, Upgrade.MaxTier)
      
    local Item = Upgrade[DisplayTier].DisplayItem
    
    local LoreTable = Upgrade[DisplayTier].DisplayLore
    table.insert(LoreTable, Upgrade[DisplayTier].CostLore)
    
    Item.m_LoreTable = LoreTable-- sticks lore table on
    TeamShopWindow:SetSlot(Player, i, Item) -- puts item in window
    
  end
  
  
  TeamShopWindow:SetOnClicked(TeamShopClickedCallback)
  
  return Window
end
