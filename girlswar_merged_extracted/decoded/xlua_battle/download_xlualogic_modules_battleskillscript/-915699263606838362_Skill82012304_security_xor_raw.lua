local s=require("Modules/Battle/BattleUtil")
local i={
}
local r=i
function i.DoAction(t,n)
local o=t:JudgeSkillPreView(n)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
local a=table.lightCopyList(e)
a=RandomTableWithSeed(a,o[2])
if(a==nil)then
return nil
end
local h=o[1]
local i=t:GetFinalAtk()
local i=s:GetHeroListByGran(t,BattleHeroType.enemyAll,true,true)
local i=RandomTableWithSeed(i,o[3])
for t=1,#i do
local e=i[t].HeroBattleInfo:DispelGranBuff(true,o[4])
end
e=a
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local a=#e
for a=1,a do
local e=e[a]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,h,0,0)
end
return nil
end
function i.DoPassiveAction(e,t)
local e=e:JudgeSkillPreView(t)
return nil
end
return r 
