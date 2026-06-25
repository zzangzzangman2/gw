local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(i,o,e)
local t=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(o)
local t=e.skillParam
local a=e.enemyCount
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosByTeamId(i.TeamId,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
local e=RandomTableWithSeed(e,a)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local a=#e
for a=1,a do
local e=e[a]
local a=0
local n=e.HeroBattleInfo.MaxHP
a=math.floor(n*t[1]*MillionCoe)
local a=ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(i,e,o,0,0,a)
local a=a[3]
local a=a.reduceHpValue
local t=t[2]
local t=math.floor(a*t*MillionCoe)
s:AddSepsisHp(nil,e,t)
end
return nil
end
return h 
