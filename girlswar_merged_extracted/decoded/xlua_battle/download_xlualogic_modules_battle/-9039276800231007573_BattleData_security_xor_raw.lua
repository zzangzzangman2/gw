local e=Class("BattleData")
function e:__init()
self.data={}
self.refreshedCallback=nil
end
function e:SetRefreshedCallback(e)
self.refreshedCallback=e
end
function e:SendEventDataRefreshed()
if self.refreshedCallback then
self.refreshedCallback()
end
end
return e 
