local e=require("Modules/Battle/BattleUtil")
local e={
}
local c=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(n==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(n)
t:ReduceFury(i.costMp)
local s=e[1]
local u=t.HeroBattleInfo:GetBuff(30104907)
local m=e[3]
local w=e[4]
local f=e[5]
local d=e[3]
local l=e[6]
local c=e[7]
local r={e[8],e[9]}
local a=#n
local o=0
if a==1 then
o=e[10]
elseif a==2 then
o=e[11]
elseif a==3 then
o=e[12]
elseif a==4 then
o=e[13]
elseif a==5 then
o=e[14]
elseif a==6 then
o=e[15]
end
s=s+o
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local h=#o
if h>0 then
local e=math.min(i.costMp*e[16]*MillionCoe/h,e[17])
local e=math.max(0,math.floor(e))
if e>0 then
for t=1,#o do
local t=o[t]
t:AddFuryWithSkill(e)
end
end
end
for e=1,a do
local e=n[e]
if u==nil then
e:CheckAddBuff(m,t,w,f)
else
e:CheckAddBuff(d,t,l,c,r)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,s)
end
return nil
end
return c 
