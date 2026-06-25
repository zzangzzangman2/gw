local t=require("Modules/Battle/HeroState/BaseState")
local e={}
function e:New(a)
self.__index=self
local e=t:New(HeroState.Run)
e.HeroCtrl=a
setmetatable(e,self)
return e
end
function e:OnEnter()
if(IsNil(self.HeroCtrl.spineboy))then
return
end
self.HeroCtrl:SetSpineAnimation(0,"run",true)
end
function e:OnUpdate()
end
function e:OnLeave()
end
return e

