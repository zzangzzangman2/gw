local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,i)
local a=t:JudgeSkillPreView(i)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local n=a[1]
local o=#e
for o=1,o do
local e=e[o]
local o=0
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or a[3]==1 then
local e=e.HeroBattleInfo.MaxHP
o=math.floor(e*a[4]*MillionCoe)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,n,0,o)
end
return nil
end
return n 
