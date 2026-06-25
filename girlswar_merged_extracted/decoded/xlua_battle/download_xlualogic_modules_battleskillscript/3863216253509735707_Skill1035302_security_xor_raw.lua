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
local h=e[1]
local r=e[3]
local s=e[4]
local n=e[5]
local d={e[6],e[7],e[8],e[9]}
local i=ModulesInit.BattleBuffMgr.GetBuffScript(s)
local d=i.GetBuffValue(t,n,d)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=#a
for i=1,i do
local i=a[i]
local a=h
local h=i.HeroBattleInfo:GetBuff(30103501)
if h~=nil then
a=a+e[10]
end
i:CheckAddBuff(r,t,s,n,d)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,i,o,a)
end
return nil
end
return r 
