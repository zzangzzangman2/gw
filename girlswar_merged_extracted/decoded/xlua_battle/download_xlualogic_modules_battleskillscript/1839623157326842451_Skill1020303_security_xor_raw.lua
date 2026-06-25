local e={
}
local l=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
local i=#a
if(i==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[16])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local d=e[1]
local l=e[3]
local u=e[4]
local c=e[5]
local i=ModulesInit.BattleBuffMgr.GetBuffScript(30102003)
local r=i.GetBuffValue(t,e)
local n=e[8]
local s=e[9]
local i={e[10]}
t:AddBuff(t,n,s,i)
local n=e[11]
local s=e[12]
local h={e[13]}
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(i)then
for a,e in ipairs(i)do
if e.HeroId~=t.HeroId and e.profession==ProfessionType.Warrior then
e:AddBuff(t,n,s,h)
end
end
end
local i=#a
for i=1,i do
local a=a[i]
a:CheckAddBuff(l,t,u,c,r)
local i=d
local n=e[14]
if a.HeroBattleInfo:GetBuff(n)~=nil then
i=i+e[15]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
end
return nil
end
return l 
