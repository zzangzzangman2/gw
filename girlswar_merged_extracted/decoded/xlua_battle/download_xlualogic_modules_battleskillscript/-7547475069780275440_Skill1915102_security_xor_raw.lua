local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(o,t,e)
local a=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(t)
local i=e.skillParam
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosByTeamId(o.TeamId,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local a=#e
for a=1,a do
local e=e[a]
local a=0
local n=e.HeroBattleInfo.MaxHP
a=math.floor(n*i[1]*MillionCoe)
local t=ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(o,e,t,0,0,a)
local t=t[3]
local t=t.reduceHpValue
local a=i[2]
local t=math.floor(t*a*MillionCoe)
s:AddSepsisHp(nil,e,t)
end
return nil
end
return h 
