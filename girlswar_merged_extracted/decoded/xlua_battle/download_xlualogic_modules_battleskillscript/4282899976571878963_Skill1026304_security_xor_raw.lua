local i=require("Modules/BattleSkillScript/1026/SkillUtil1026")
local e={}
local r=e
function e.DoAction(t,o,a)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=e[1]
local n=#a
for n=1,n do
local a=a[n]
local n=e[3]
local i=i.GetBuffData(e,e[4],5,16)
for e=1,#i do
local e=i[e]
local o=e.buffId
local e=e.buffData
a:AddBuff(t,o,n,e)
end
local i=e[17]
local h=e[18]
local s=e[19]
local n={t.HeroId,e[20],e[21],e[22],e[23]}
a:CheckAddBuff(i,t,h,s,n)
local i=e[24]
local n=e[25]
local e=e[26]
a:CheckAddBuff(i,t,n,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,r)
end
return nil
end
return r

