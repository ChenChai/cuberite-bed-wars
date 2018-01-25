function MobSearchForTarget(Monster, SearchDistance, AttackDistance)
  
  Monster:GetWorld():ForEachPlayer(function(Player)
  
                                    local VectorSum = Monster:GetPosition() - Player:GetPosition()
                                    -- XZ pythagorean distance
                                    local Distance = VectorSum:Length()
                                    
                                    
                                    if Distance <= SearchDistance then
                                      Monster:MoveToPosition(Player:GetPosition())
                                      LOG(Monster:GetUniqueID() .. " is tracking " .. Player:GetName() .. " at " .. Distance .. " range!")
                                    end
                                    
                                    if Distance <= AttackDistance then
                                      Player:TakeDamage(dtEntityAttack, Monster, 8, 20)
                                    end
                                    
--                                    if Player:GetTeam():GetName ~= Entity:GetTeam():GetName()
                                  end)
  return
  
end