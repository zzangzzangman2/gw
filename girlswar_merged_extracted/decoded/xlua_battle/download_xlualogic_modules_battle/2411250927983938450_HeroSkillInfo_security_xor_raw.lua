HeroSkillInfo={
}
function HeroSkillInfo:New()
local e={
SkillType=0,
SkillDid=0,
}
setmetatable(e,self)
self.__index=self
return e
end
function HeroSkillInfo:SetSkill(e)
self.SkillType=e.skillType
self.SkillDid=e.skillDid==nil and 0 or e.skillDid
end 
