local e={
}
local m=e
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
local f=e[3]
local r=e[4]
local h=e[5]
local d=0
if a then
local e=a:GetBuffData()
r=e[1]
h=e[2]
d={e[3],e[4]}
end
local u=e[14]
local c=e[15]
local m={e[16],e[17]}
local a=#i
local o=0
if a==1 then
o=e[6]
elseif a==2 then
o=e[7]
elseif a==3 then
o=e[8]
elseif a==4 then
o=e[9]
elseif a==5 then
o=e[10]
elseif a==6 then
o=e[11]
end
s=s+o
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local l=#o
if l>0 then
local e=math.min(n.costMp*e[12]*MillionCoe/l,e[13])
local e=math.max(0,math.floor(e))
if e>0 then
for t=1,#o do
local t=o[t]
t:AddFuryWithSkill(e)
end
end
end
for e=1,a do
local e=i[e]
e:CheckAddBuff(f,t,r,h,d)
local a=e.HeroBattleInfo:GetBuff(302104901)
local o=e.HeroBattleInfo:GetBuff(302104902)
if a==nil and o==nil then
e:AddBuff(t,u,c,m)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,s)
end
return nil
end
return m 
