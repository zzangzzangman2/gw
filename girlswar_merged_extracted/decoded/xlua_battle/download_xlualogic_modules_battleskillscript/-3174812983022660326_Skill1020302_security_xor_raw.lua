local e={
}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local h=e[1]
local r=e[3]
local i=e[4]
local l=e[5]
local n=ModulesInit.BattleBuffMgr.GetBuffScript(30102003)
local u=n.GetBuffValue(t,e)
local d=e[8]
local n=e[9]
local s={e[10]}
t:AddBuff(t,d,n,s)
local d=e[11]
local s=e[12]
local n={e[13]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(e)then
for a,e in ipairs(e)do
if e.HeroId~=t.HeroId and e.profession==ProfessionType.Warrior then
e:AddBuff(t,d,s,n)
end
end
end
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(r,t,i,l,u)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,h)
end
return nil
end
return r 
