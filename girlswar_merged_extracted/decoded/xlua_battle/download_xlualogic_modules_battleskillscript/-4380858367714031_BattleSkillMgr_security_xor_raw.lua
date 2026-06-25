local e=1
local t={
skillFileCfg={1,2,3,8},
BattleSkills={}
}
local e=t
function t.Init()
for t=1,#e.skillFileCfg do
local t=e.skillFileCfg[t]
local t="Modules/BattleSkillScript/BattleSkillData"..t
local t=require(t)
t.Init()
local t=t.BattleSkills
for a,t in pairs(t)do
e.BattleSkills[a]=t
end
end
end
function t.GetSkillScript(t)
local e=e.BattleSkills[t]
if(e==nil)then
GameInit.LogError("GetSkillScript is nil skillId=%s",t)
end
return e
end
return t

