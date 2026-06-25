local e={
}
local h=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=e[1]
local d=e[3]
local l=e[4]
local r=e[5]
local n=ModulesInit.BattleBuffMgr.GetBuffScript(30102003)
local h=n.GetBuffValue(t,e)
local s=e[8]
local n=e[9]
local e={e[10]}
t:AddBuff(t,s,n,e)
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(d,t,l,r,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,i)
end
return nil
end
return h 
