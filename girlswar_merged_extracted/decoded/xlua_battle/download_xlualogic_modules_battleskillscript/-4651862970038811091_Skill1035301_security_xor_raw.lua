local e={
}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
t:ReduceFury(o.costMp)
local s=e[1]
local r=e[3]
local n=e[4]
local i=e[5]
local h={e[6],e[7],e[8],e[9]}
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
local h=e.GetBuffValue(t,i,h)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(r,t,n,i,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,s)
end
return nil
end
return r 
