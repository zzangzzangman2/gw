BattleEffectInfo={
}
function BattleEffectInfo:New()
local e={
battleEffectType=nil,
buffId=0,
heroBuffInfo=nil,
round=0,
}
setmetatable(e,self)
self.__index=self
return e
end
function BattleEffectInfo:Dispose()
self.battleEffectType=nil
self.buffId=0
self.heroBuffInfo=nil
self.round=0
end 
