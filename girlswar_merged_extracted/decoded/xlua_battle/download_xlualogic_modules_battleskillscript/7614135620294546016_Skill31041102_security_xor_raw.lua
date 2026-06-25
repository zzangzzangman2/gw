local n=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(a,t,o)
local e=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(t)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosByTeamId(a.TeamId,BattleHeroType.ourAll)
if(e==nil)then
return nil
end
if(e==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local o=o.skillParam
local i=#e
for i=1,i do
local e=e[i]
local i=math.floor(e.HeroBattleInfo.MaxHP*o[1]*MillionCoe)
local t=ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(a,e,t,0,0,i)
local t=t[3]
local t=t.reduceHpValue
local a=o[2]
local t=math.floor(t*a*MillionCoe)
n:AddSepsisHp(nil,e,t)
end
return nil
end
return s 
