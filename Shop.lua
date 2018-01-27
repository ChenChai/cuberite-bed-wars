-- TODO Burn this code

function InitializeShop()
  
  --Items you can't drop.   --All armor sets
  TransferableItemsArray = {[298] = false, [299] = false, [300] = false, [301] = false, [302] = false, [303] = false, [304] = false, [305] = false,
                            [306] = false, [307] = false, [308] = false, [309] = false, [310] = false,  [311] = false, [312] = false, [313] = false,
                            [314] = false, [315] = false, [316] = false, [317] = false, 
                            --Pickaxes
                            [270] = false, [274] = false, [257] = false, [285] = false, [278] = false,
                            --Axes
                            [271] = false, [275] = false, [258] = false, [279] = false, [286] = false,
                            --Swords
                            [268] = false, [272] = false, [267] = false, [276] = false, [283] = false,
                            --Shears
                            [359] = false
                            }
  

  cPluginManager.BindCommand("/shop", "", ShopCommand, " ~ /Shop <item>")
  cPluginManager.BindCommand("/resetarmor", "", ResetArmorCommand, "/resetarmor")
  ItemShopWindow = cLuaWindow(cWindow.wtChest, 9, 4, "Item Shop")
  LOG("Initialised Bedwars Shop!")
  
  return true
end

  -- Debugging Command
function ResetArmorCommand (Split, Player)
  --Player:SendMessage(ItemToFullString(Player:GetInventory():GetEquippedItem()))
  Player:GetInventory():AddItem(ArmorArray[0][1])
  Player:GetInventory():AddItem(ArmorArray[0][2])
  ArmorTier[Player:GetName()] = 0
  return true
end

function ShopCommand(Split, Player)
  
  if Split[2] == "item" then
    
    local MobID = Player:GetWorld():SpawnMob(Player:GetPosX(), Player:GetPosY(), Player:GetPosZ(), mtVillager) -- initialises Variable and spawns villager
    local World = Player:GetWorld()
    
    --give shop some characteristics
    
    Player:GetWorld():DoWithEntityByID(MobID,
      function(Entity)
        Entity:SetRelativeWalkSpeed(0)
        Entity:SetCustomName("§e§lItem Shop")
        Entity:SetCustomNameAlwaysVisible(true)
      end)
    
    return true
  end
  
  if Split[2] == "team" then
    local MobID = Player:GetWorld():SpawnMob(Player:GetPosX(), Player:GetPosY(), Player:GetPosZ(), mtVillager) -- initialises Variable and spawns villager
    local World = Player:GetWorld()
    
    --give shop some characteristics
    
    Player:GetWorld():DoWithEntityByID(MobID,
      function(Entity)
        Entity:SetRelativeWalkSpeed(0)
        Entity:SetCustomName("§e§lTeam Shop")
        Entity:SetCustomNameAlwaysVisible(true)
      end)
    
    return true
  
  end
  
  return false
  
end

function OpenShop(Player)
  ItemShopWindow = cLuaWindow(cWindow.wtChest, 9, 4, "Item Shop")
  ResetItemShopWindow(Player, ItemShopWindow)
  ItemShopWindow:SetOnClicked(ItemShopClickedCallback)
  Player:OpenWindow(ItemShopWindow)
  Player:SendMessage("Shop Opened!")
end

function ItemShopClickedCallback(a_Window, Player, a_SlotNum, a_ClickAction, a_ClickedItem)

  if a_ClickedItem.m_ItemType == 0 or a_ClickedItem.m_ItemType == -1 then --Checks if you're clicking on air
    return true
  end
  
  if a_SlotNum < 0 or a_SlotNum > 35 then --Checks if you're clicking the shop
    return true
  end

  
  if a_ClickAction == caShiftLeftClick then --Checks if you're trying to shift click
    return true
  end
  
  local WoolColor 
  if Player:GetTeam() == nil then WoolColor = E_META_WOOL_WHITE else WoolColor = Player:GetTeam().WoolColor end
  
  
  ------ The Shop Stock
  if a_ClickedItem.m_ItemType == 46 then --Checks if you're clicking on Utility Items TNT
  
    ItemShopWindow:SetWindowTitle("Utility Items")
    ItemCategoryArray = { [10] = {cItem(322, 1, 0, "", "§rGolden Apple")     ,{""                                                                               } , "Cost: 2 Gold", 2, 266},
                          [11] = {cItem(332, 1, 0, "", "§rBedbug")           ,{"§7§oThrow to distract your enemies!"                                          } , "Cost: 50 Iron", 50, 265},
                          [12] = {cItem(383, 1, 0, "", "§rDream Defender")   ,{"§7§oSpawns an Iron Golem"               , "§7§othat lasts for 240 Seconds." } , "Cost: 120 Iron", 120, 265},
                          [13] = {cItem(385, 1, 0, "", "§6Fireball")         ,{"§7§oRight Click to Throw!"                                                    } , "Cost: 50 Iron", 50, 265},
                          [14] = {cItem(46, 1, 0, "", "§rInstant TNT")       ,{"§7§oPlaces primed TNT!"                                                       } , "Cost: 8 Gold", 8, 266},
                          [15] = {cItem(368, 1, 0, "", "§rEnder Pearl")      ,{""                                                                               } , "Cost: 4 Emerald", 4, 388},
                          [16] = {cItem(326, 1, 0, "", "§rWater Bucket")     ,{""                                                                               } , "Cost: 1 Emerald", 1, 388},
                          [19] = {cItem(344, 1, 0, "", "§rBridge Egg")       ,{"§7§oForms a bridge of wool when thrown."                                      } , "Cost: 4 Emerald", 4, 388},
                          }
  end
  
  if a_ClickedItem.m_ItemType == 283 then
    ItemShopWindow:SetWindowTitle("Melee")
    ItemCategoryArray = { [10] = {cItem(272, 1, 0, "", "§rStone Sword")        ,{                                                                                } , "Cost: 10 Iron", 10, 265},
                          [11] = {cItem(267, 1, 0, "", "§rIron Sword")         ,{                                                                                } , "Cost: 7 Gold", 7, 266},
                          [12] = {cItem(276, 1, 0, "", "§rDiamond Sword")      ,{                                                                                } , "Cost: 4 Emerald", 4, 388},
                          [13] = {cItem(280, 1, 0, "knockback=1", "§rStick")   ,{                                                                                } , "Cost: 10 Gold", 10, 266},
                          }
    for i, value in next, ItemCategoryArray do
      if Player:GetTeam() ~= nil and Player:GetTeam().Upgrades.SharpenedSwords > 0 then
        value[1]:AddEnchantment(cEnchantments.enchSharpness, Player:GetTeam().Upgrades.SharpenedSwords, false)
      end
    end
    
  end
  
  
  if a_ClickedItem.m_ItemType == 172 then
    ItemShopWindow:SetWindowTitle("Blocks")
    ItemCategoryArray = { [10] = {cItem(35, 16, WoolColor, "", "§rWool")                ,{                                                                               } , "Cost: 4 Iron", 4, 265},
                          [11] = {cItem(172, 16, 0, "", "§rHardened Clay")      ,{                                                                               } , "Cost: 12 Iron", 12, 265},
                          [12] = {cItem(20, 4, 0, "", "§rBlast-Proof Glass")    ,{                                                                               } , "Cost: 12 Iron", 12, 265},
                          [13] = {cItem(121, 12, 0, "", "§rEnd Stone")          ,{                                                                               } , "Cost: 24 Iron", 24, 265},
                          [14] = {cItem(65, 16, 0, "", "§rLadder")              ,{                                                                               } , "Cost: 4 Iron", 4, 265},
                          [15] = {cItem(5, 4, 0, "", "§rWood Planks")           ,{                                                                               } , "Cost: 4 Gold", 4, 266},
                          [12] = {cItem(49, 4, 0, "", "§rObsidian")             ,{                                                                               } , "Cost: 4 Emerald", 4, 388},
                          }
  end
  
  if a_ClickedItem.m_ItemType == 274 then -- Checks if they're clicking on a pick
    if PickTier[Player:GetName()] == nil then -- Initializes their tiers if they don't already have one
      PickTier[Player:GetName()] = 0
    end
    if AxeTier[Player:GetName()] == nil then
      AxeTier[Player:GetName()] = 0
    end
    
    ItemShopWindow:SetWindowTitle("Tools")  
                          --    PickArray and AxeArray are formatted like shop listings                            
    ItemCategoryArray = { [10] = PickArray[math.min(PickTier[Player:GetName()] + 1, 4)]; -- Makes sure that the pickarray isn't going past diamond!
                          [11] = AxeArray[math.min(PickTier[Player:GetName()] + 1, 4)];
                          [12] = {cItem(359, 1, 0, "", "")  ,{} , "Cost: 30 Iron", 30, 265} -- Shears
                          }
  end
  
  if a_ClickedItem.m_ItemType == 305 then --Checks if you're clicking on the chainmail boots 
  ItemShopWindow:SetWindowTitle("Armor")-- These items appear as boots in the table
  ---If editing any values, also edit the section that gives them the armor below.
  ItemCategoryArray = { [10] = {cItem(305, 1, 0, "", "§rPermanent Chainmail Armor"), {"Leggings and Boots", "Not lost on death!"}, "Cost: 40 Iron", 40, 265, 1},
                        [11] = {cItem(309, 1, 0, "", "§rPermanent Iron Armor"),      {"Leggings and Boots", "Not lost on death!"}, "Cost: 12 Gold", 12, 266, 2},
                        [12] = {cItem(313, 1, 0, "", "§rPermanent Diamond Armor"),   {"Leggings and Boots", "Not lost on death!"}, "Cost: 6 Emerald", 6, 388, 3},
                        }
    
    for i, value in next, ItemCategoryArray do
      if Player:GetTeam() ~= nil and Player:GetTeam().Upgrades.ReinforcedArmor > 0 then
        value[1]:AddEnchantment(cEnchantments.enchProtection, Player:GetTeam().Upgrades.ReinforcedArmor, false)
      end
    end
                        
  end
  
  if a_ClickedItem.m_ItemType == 373 then -- Checks if it's a potion
    ItemShopWindow:SetWindowTitle("Potions")

 --- TODO: Make custom potion brew function

  
    ItemCategoryArray = { [10] = {cItem(373, 1, 0, "", "§rPotion of Invisibility"), {"Invisibility", "30 Seconds", "", cEntityEffect.effInvisibility, 30, 0}, "Cost: 1 Emerald", 1, 388};
                          [11] = {cItem(373, 1, 0, "", "§rPotion of Speed"),        {"Speed II", "45 Seconds"    , "", cEntityEffect.effSpeed, 45, 1       }, "Cost: 1 Emerald", 1, 388};
                          [12] = {cItem(373, 1, 0, "", "§rPotion of Leaping"),      {"Jump Boost V", "45 Seconds", "", cEntityEffect.effJumpBoost, 45, 4   }, "Cost: 1 Emerald", 1, 388}
                          
                          }
  end
  
  if a_ClickedItem.m_ItemType == 261 then -- Ranged shop!
    ItemShopWindow:SetWindowTitle("Ranged")
    ItemCategoryArray = { [10] = {cItem(E_ITEM_ARROW, 8, 0, "", "§rArrow"),         {                                                       }, "Cost: 2 Gold", 2, 266};
                          [11] = {cItem(E_ITEM_BOW, 1, 0, "unbreaking=10", "§rBow"), {                                                       }, "Cost: 12 Gold", 12, 266};
                          [12] = {cItem(E_ITEM_BOW, 1, 0, "power=1;unbreaking=10", "§rBow"), {                                               }, "Cost: 24 Gold", 24, 266};
                          [13] = {cItem(E_ITEM_BOW, 1, 0, "power=1;punch=1;unbreaking=10", "§rBow"), {                                       }, "Cost: 6 Emerald", 6, 388}
                         }
  end
  
  
  
  for i=0, 35, 1 do-- clears the window
    ItemShopWindow:SetSlot(Player, i, cItem(0, 1, 0, "", ""))
  end 
  
  
  for i, value in next, ItemCategoryArray do -- loads the category array up!
    table.insert(ItemCategoryArray[i][2], ItemCategoryArray[i][3])-- Sticks the price on at the end
    value[1].m_LoreTable = ItemCategoryArray[i][2]
    ItemShopWindow:SetSlot(Player, i, value[1])
    
    table.remove(ItemCategoryArray[i][2]) -- Takes the price back off 
  end

  ItemShopWindow:SetSlot(Player, 31, cItem(262, 1, 0, "", "§aGo Back"))
  ItemShopWindow:SetOnClicked(ItemShopCategoryClickedCallBack) --Sets a different callback function, but same window!
  Player:OpenWindow(ItemShopWindow)
  
  return true
end

function ItemShopCategoryClickedCallBack(Window, Player, SlotNum, ClickAction, ClickedItem)

  if ClickedItem.m_ItemType == -1 then --Checks if you're clicking on air
    return true
  end
  
  if SlotNum < 0 or SlotNum > 35 then --Checks if you're not clicking the shop
    return true
  end

  
  if ClickAction == caShiftLeftClick then --Checks if you're trying to shift click
    return true
  end

  local ItemCost = cItem(0, 1, 0, "")
  local ItemBuying
  
  --Back Arrow
  if ClickedItem.m_ItemType == 262 and ClickedItem.m_CustomName == "§aGo Back" then
    ResetItemShopWindow(Player, ItemShopWindow)
    
    return true
  end
  
  
  
  
  ItemCost = cItem(ItemCategoryArray[SlotNum][5], ItemCategoryArray[SlotNum][4], 0, "") --Get Item Cost itemstack based on hash
  ItemBuying = ItemCategoryArray[SlotNum][1] -- Get itembuying based on hash
  ItemBuying.m_LoreTable = ItemCategoryArray[SlotNum][2]
  
   ---DOESN'T WORK!
   -- 4, 39 represents from the start of their inventory to the end of the hotbar (no armor slots)
  if Player:GetInventory():HowManyCanFit(ItemBuying, 4, 39, true) < ItemBuying.m_ItemCount then
    Player:SendMessage("§4Not enough inventory space!")--Check if player has any space in their main inventory/hotbar
    return true
  end
  
  --- THIS SECTION IS FOR ARMOR ONLY 
  if (ClickedItem.m_ItemType == 305 or ClickedItem.m_ItemType == 309 or ClickedItem.m_ItemType == 313) and Window:GetWindowTitle() == "Armor" then -- Makes sure they're buying armor 
    local BuyingTier = ItemCategoryArray[SlotNum][6] --The tier of the item that the player is buying
    
    if BuyingTier == ArmorTier[Player:GetName()] then
      return true
    end
    
    if Player:GetInventory():HasItems(ItemCost) then --Checks if player has the resources.
      Player:GetInventory():RemoveItem(ItemCost)
      
      if ArmorTier[Player:GetName()] == nil then
        ArmorTier[Player:GetName()] = 0
      end
      LOG(ArmorTier[Player:GetName()])

      LOG(BuyingTier)
      
      Player:GetInventory():RemoveItem(ArmorArray[ArmorTier[Player:GetName()]][1])-- Removes the previous tiers of armor
      Player:GetInventory():RemoveItem(ArmorArray[ArmorTier[Player:GetName()]][2])
      
      Player:GetInventory():AddItem(ArmorArray[BuyingTier][1]) -- Sets boots from ArmorArray based on tier in ItemCategoryArray
      Player:GetInventory():AddItem(ArmorArray[BuyingTier][2]) -- Sets leggings from ArmorArray based on tier in ItemCategoryArray
      ArmorTier[Player:GetName()] = BuyingTier -- Sets armor tier (1=chainmail, 2=iron, 3=diamond)
      
      --Player:TakeDamage(dtProjectile, nil, 2, 0) -- Applies some damage to render armor correctly
      return true
    end
    
  end
  ---END ARMOR ONLY SECTION
  if ItemBuying.m_ItemType == 359 and  HasShears[Player:GetName()] == true then-- These are shears. If the player already has shears don't buy another set!
   Player:SendMessage("§6You already have shears.")
   return true
  end
  
  if ItemBuying == PickArray[4][1] and PickTier[Player:GetName()] == 4 then -- If the player already has the diamond pickaxe
    Player:SendMessage("§6You already the maximum tier pickaxe.")
    return true
  end
  
  if ItemBuying == AxeArray[4][1] and AxeTier[Player:GetName()] == 4 then -- If the player already has the diamond axe.
    Player:SendMessage("§6You already the maximum tier axe.")
    return true
  end
  

  if Player:GetInventory():HasItems(ItemCost) then-- Check if player has resources
     Player:GetInventory():RemoveItem(ItemCost) -- removes resources from their inventory
     Player:GetInventory():AddItem(ItemBuying) -- Adds item to their inventory
     
    if Window:GetWindowTitle() == "Tools" then
      
      if ItemBuying.m_ItemType == 359 then
        HasShears[Player:GetName()] = true -- If they bought shears set it so!
        return true
      end
    
      

      for i, value in next, PickArray do
        
        if PickArray[i][1] == ItemBuying then
          PickTier[Player:GetName()] = i -- Updates their new pick tier
          Window:SetSlot(Player, SlotNum, PickArray[math.min(PickTier[Player:GetName()] + 1, 4)][1]) -- Updates the shop window with the next tier
          ItemCategoryArray[10] = PickArray[math.min(PickTier[Player:GetName()] + 1, 4)] -- Need to update the shop tables too
          return true
        end
      end
      
      for i, value in next, AxeArray do 
        if AxeArray[i][1] == ItemBuying then
          AxeTier[Player:GetName()] = i -- Updates their new axe tier
          Window:SetSlot(Player, SlotNum, AxeArray[math.min(AxeTier[Player:GetName()] + 1, 4)][1]) -- Updates the shop window with the next tier
          ItemCategoryArray[11] = AxeArray[math.min(AxeTier[Player:GetName()] + 1, 4)] -- Need to update the shop tables too
          return true
        end
      end
    end
     
     
     
  else
      Player:SendMessage("§4Not enough resources!")
  end
  
  return true
end

  -- Sets the shop window back to the main
function ResetItemShopWindow(Player, Window)

  for i=0, 35, 1 do--Clears any previous items
    Window:SetSlot(Player, i, cItem(0, 1, 0, "", ""))
  end
  
  local ItemShopCategories = {
                          [11] = {cItem(305, 1, 0, "", "§aArmor"), {"§7Avalible:", "§8-Chainmail Boots", "§8-Chainmail Leggings", "§8-Iron Boots", "§8-Iron Leggings", "§8-Diamond Boots", "§8-Diamond Leggings", "", "§eClick to Browse!"}};
                          [12] = {cItem(283, 1, 0, "", "§aMelee"), {"§7Avalible:", "§8-Stone Sword", "§8-Iron Sword", "§8-Diamond Sword", "§8-Stick (Knockback I)", "", "§eClick to Browse!"}};
                          [13] = {cItem(172, 1, 0, "", "§aBlocks"), {"§7Avaliable:", "§8-Wool", "§8-Hardened Clay", "§8-Blast-Proof Glass", "§8-End Stone", "§8-Ladder", "§8-Oak Wood Planks", "§8-Obsidian", "", "§eClick to Browse!"}};
                          [14] = {cItem(261, 1, 0, "", "§aRanged"), {"§7Available:", "§8-Arrow", "§8-Bow", "§8-Bow (Power I)", "§8-Bow (Power I, Punch I)", "", "§eClick to Browse!"}};
                          [20] = {cItem(274, 1, 0, "", "§aTools"), {"§7Available:", "§8-Shears", "§8-Pickaxe Upgrades", "§8-Axe Upgrades", "", "§eClick to Browse!"}};
                          [21] = {cItem(373, 1, 6, "", "§aPotions"),{"§7Available:", "§8-Speed II Potion (0:45)", "§8-Jump Boost V Potion (0:45)", "§8-Invisibility Potion (0:30)", "", "§eClick to Browse!"}};
                          [22] = {cItem(46, 1, 0, "", "§aUtility"), {"§7Avaliable:", "§8-Golden Apple", "§8-Bedbug", "§8-Dream Defender", "§8-Fireball", "§8-TNT", "§8-Ender Pearl", "§8-Water Bucket", "§8-Bridge Egg", "", "§eClick to Browse!"}} --Sets TNT Item (ID 46)
                          
                          }
  
  for i, value in next, ItemShopCategories do -- Sets up table with items in slot
    value[1].m_LoreTable = value[2] -- sticks lore table on from array 
    Window:SetSlot(Player, i, value[1]) -- puts item in window
  end
  
  Window:SetOnClicked(ItemShopClickedCallback)
  
  return Window
  
end

function CreateCustomPotion()

end