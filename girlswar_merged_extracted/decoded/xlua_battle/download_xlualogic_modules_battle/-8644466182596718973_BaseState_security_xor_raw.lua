local e={
}
function e:New(t)
self.__index=self
local e=setmetatable({},self)
e.state=t
return e
end
function e:OnEnter()
end
function e:OnUpdate()
end
function e:OnLeave()
end
return e 
