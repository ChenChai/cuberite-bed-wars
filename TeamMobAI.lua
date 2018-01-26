function MobSearchForTarget(Monster, SearchDistance, AttackDistance)
  
  local ClosestDistance = 1000
  Monster:GetWorld():ForEachPlayer(function(Player)
  
                                    local VectorSum = Monster:GetPosition() - Player:GetPosition()
                                    -- XZ pythagorean distance
                                    local Distance = VectorSum:Length()
                                    
                                    if ClosestDistance > Distance then 
                                      ClosestDistance = Distance
                                    else
                                      return
                                    end
                                    
                                    if Monster.Team == nil then return end
                                    if Player:GetTeam == nil then return end
                                    
                                    
                                      -- Comparing team names should be more reliable than comparing the whole team object
                                    if Player:GetTeam().GetName() ~= Entity:GetTeam():GetName() then
                                    
                                      if Distance <= SearchDistance then
                                        Monster:MoveToPosition(Player:GetPosition())
                                        LOG(Monster:GetUniqueID() .. " is tracking " .. Player:GetName() .. " at " .. Distance .. " range!")
                                      end
                                    
                                      if Distance <= AttackDistance then
                                        Player:TakeDamage(dtEntityAttack, Monster, 8, 20)
                                      end
                                      
                                    end
                                  end)
  return
  
end