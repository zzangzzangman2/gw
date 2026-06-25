local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(i,o,t)
local e=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosByTeamId(i.TeamId,BattleHeroType.ourAll)
if(e==nil)then
return nil
end
if(e==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local t=t.skillParam
local h=t[4]
local s=t[5]
local a={}
local n=#e
for n=1,n do
local e=e[n]
e:AddBuff(e,h,s,a)
local a=0
if t[3]==1 or ModulesInit.ProcedureNormalBattle.IsPVE()==false then
local n=e.HeroBattleInfo.CurrHP
a=math.floor(n*t[2]*MillionCoe)
local e=ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(i,e,o,0,0,a)
end
end
return nil
end
return r 
