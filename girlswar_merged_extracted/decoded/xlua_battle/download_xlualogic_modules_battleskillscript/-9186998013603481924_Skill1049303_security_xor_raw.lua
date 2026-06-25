local e={
}
local f=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(n==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(n)
t:ReduceFury(i.costMp)
local s=e[1]
local m=t.HeroBattleInfo:GetBuff(30104907)
local u=e[3]
local c=e[4]
local w=e[5]
local p=e[3]
local y=e[6]
local v=e[7]
local d={e[8],e[9]}
local l=e[18]
local f=e[19]
local r={e[20],e[21]}
local o=#n
local a=0
if o==1 then
a=e[10]
elseif o==2 then
a=e[11]
elseif o==3 then
a=e[12]
elseif o==4 then
a=e[13]
elseif o==5 then
a=e[14]
elseif o==6 then
a=e[15]
end
s=s+a
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local h=#a
if h>0 then
local e=math.min(i.costMp*e[16]*MillionCoe/h,e[17])
local e=math.max(0,math.floor(e))
if e>0 then
for t=1,#a do
local t=a[t]
t:AddFuryWithSkill(e)
end
end
end
for e=1,o do
local e=n[e]
if m==nil then
e:CheckAddBuff(u,t,c,w)
else
e:CheckAddBuff(p,t,y,v,d)
end
local a=e.HeroBattleInfo:GetBuff(30104901)
local o=e.HeroBattleInfo:GetBuff(30104902)
if a==nil and o==nil then
e:AddBuff(t,l,f,r)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,s)
end
return nil
end
return f 
