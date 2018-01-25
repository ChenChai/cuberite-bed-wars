  -- This file is for any functions we might call to make lives easier due to poor Cuberite API

function StringToWoolColorConstant(MyString)
  
  string.lower(MyString)
  
  local WoolColorArray = { ["black"] = E_META_WOOL_BLACK;
                           ["blue"] = E_META_WOOL_BLUE;
                           ["brown"] = E_META_WOOL_BROWN;
                           ["cyan"] = E_META_WOOL_CYAN;
                           ["gray"] = E_META_WOOL_GRAY;
                           ["green"] = E_META_WOOL_GREEN;
                           ["lightblue"] = E_META_WOOL_LIGHTBLUE;
                           ["lightgray"] = E_META_WOOL_LIGHTGRAY
                           
                           
                            }
  
end

-- Takes a cColor object and applies to to an item
function AddItemColor(Item, Color)
  Item.m_ItemColor = Color
  return Item
end