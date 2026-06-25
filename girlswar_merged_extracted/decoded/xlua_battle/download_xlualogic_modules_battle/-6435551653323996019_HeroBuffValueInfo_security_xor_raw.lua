HeroBuffValueInfo={}
function HeroBuffValueInfo:New()
local e={
buffId=0,
attrId=0,
value=0
}
setmetatable(e,self)
self.__index=self
return e
end

