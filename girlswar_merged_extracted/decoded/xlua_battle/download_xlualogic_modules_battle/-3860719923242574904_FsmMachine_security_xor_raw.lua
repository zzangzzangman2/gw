local e={}
function e:New()
self.__index=self
local e=setmetatable({},self)
e.states={}
e.curState=nil
e.curStateEnum=nil
e.ParamDic={}
return e
end
function e:AddState(e)
self.states[e.state]=e
end
function e:AddInitState(e)
self.curState=e
self.curState:OnEnter()
end
function e:OnUpdate()
if(self.curState~=nil)then
self.curState:OnUpdate()
end
end
function e:ChangeState(e)
if(self.curState~=nil)then
self.curState:OnLeave(e)
end
self.curStateEnum=e
self.curState=self.states[e]
self.curState:OnEnter()
end
return e 
