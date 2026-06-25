local n=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(a,o)
local e=a:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local s=e[1]
local i=#t
for i=1,i do
local t=t[i]
local i=0
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[3]==1 then
local t=t.HeroBattleInfo.MaxHP
i=math.floor(t*e[4]*MillionCoe)
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,o,s,0,i)
local o=o[3]
local o=o.reduceHpValue
local e=e[5]
local e=math.floor(o*e*MillionCoe)
n:AddSepsisHp(a,t,e)
end
return nil
end
return s 
