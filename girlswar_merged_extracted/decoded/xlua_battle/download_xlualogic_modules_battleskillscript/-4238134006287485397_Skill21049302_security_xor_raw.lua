local e=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(i==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(i)
t:ReduceFury(n.costMp)
local s=e[1]
local a=t.HeroBattleInfo:GetBuff(302104907)
local u=e[3]
local l=e[4]
local d=e[5]
local r=0
if a then
local e=a:GetBuffData()
l=e[1]
d=e[2]
r={e[3],e[4]}
end
local o=#i
local a=0
if o==1 then
a=e[6]
elseif o==2 then
a=e[7]
elseif o==3 then
a=e[8]
elseif o==4 then
a=e[9]
elseif o==5 then
a=e[10]
elseif o==6 then
a=e[11]
end
s=s+a
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local h=#a
if h>0 then
local e=math.min(n.costMp*e[12]*MillionCoe/h,e[13])
local e=math.max(0,math.floor(e))
if e>0 then
for t=1,#a do
local t=a[t]
t:AddFuryWithSkill(e)
end
end
end
for e=1,o do
local e=i[e]
e:CheckAddBuff(u,t,l,d,r)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,s)
end
return nil
end
return u 
