local e=Class("BattleInputMgr")
function e:__init()
self.inputQueue={}
self.currentAuto=false
self.server=nil
end
function e:SetAuto(e)
self.currentAuto=e
end
function e:SetServer(e)
self.server=e
end
function e:SendEventDataRefreshed()
if self.server then
self.server:OnInputRefreshed()
end
end
function e:PopOneInput()
local e=nil
if#self.inputQueue>0 then
e=self.inputQueue[0]
elseif self.currentAuto then
e=self:GenOneInputAuto()
end
return e
end
function e:PushOneInput(e)
table.add(self.inputQueue,e)
self:SendEventDataRefreshed()
end
function e:GenOneInputAuto()
local e=self.battleServer.GetInputRange()
local e=e[0]
self:PushOneInput(e)
end
return e 
