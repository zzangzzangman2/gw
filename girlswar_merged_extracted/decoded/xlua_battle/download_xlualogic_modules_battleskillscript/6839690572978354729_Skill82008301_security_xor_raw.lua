local e=require("Modules/Battle/BattleUtil")
local o={
}
local h=o
function o.DoAction(t,o)
local a=t:JudgeSkillPreView(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local n=a[1]
local i=t:GetFinalAtk()
local s=math.floor(i*a[4]*MillionCoe)
local i=#e
for i=1,i do
local i=e[i]
local e=i.HeroBattleInfo.CurrHP
local e=math.floor(e*a[3]*MillionCoe)
e=math.min(e,s)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,i,o,n,0,e)
end
return nil
end
function o.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
return nil
end
return h 
