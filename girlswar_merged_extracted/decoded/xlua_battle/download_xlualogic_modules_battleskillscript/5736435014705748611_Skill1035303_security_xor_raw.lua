local e={
}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
t:ReduceFury(i.costMp)
local o=e[1]
local l=e[3]
local r=e[4]
local h=e[5]
local n={e[6],e[7],e[8],e[9]}
local s=ModulesInit.BattleBuffMgr.GetBuffScript(r)
local d=s.GetBuffValue(t,h,n)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=#a
for n=1,n do
local a=a[n]
local n=o
local o=a.HeroBattleInfo:GetBuff(30103501)
if o~=nil then
n=n+e[10]
local e=o:GetBuffData()
s.DoAllHurt(o,e)
end
a:CheckAddBuff(l,t,r,h,d)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,n)
end
return nil
end
return d 
