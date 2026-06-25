local t={
}
local s=t
function t.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local o=t[1]
local i=t[2]
local e={}
for a=3,19 do
table.insert(e,t[a])
end
table.insert(e,0)
table.insert(e,0)
a:AddBuff(a,o,i,e)
return nil
end
function t.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function t.DoAfterAction(t,e)
local a=t:JudgeSkillPreView(e)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local o=#e
for o=1,o do
local s=e[o]
local i=a[10]
local n=a[11]
local e={}
for t=12,15 do
table.insert(e,a[t])
end
local a=303111211
local a=t.HeroBattleInfo:GetBuff(a)
if(a)then
local a=a:GetBuffData()
local o=math.floor(t.HeroBattleInfo.MaxHP*a[1]*MillionCoe)
local t=t:GetFinalAtk()
local t=math.floor(t*a[2]*MillionCoe)
local t=math.min(o,t)
table.insert(e,t)
for t=3,10 do
table.insert(e,a[t])
end
else
table.insert(e,0)
for t=3,10 do
table.insert(e,0)
end
end
local a=303111216
local a=t.HeroBattleInfo:GetBuff(a)
if(a)then
table.insert(e,1)
local t=a:GetBuffData()
for a=12,18 do
table.insert(e,t[a])
end
else
table.insert(e,0)
for t=12,18 do
table.insert(e,0)
end
end
s:AddBuff(t,i,n,e)
end
return{
duration=0,
success=true
}
end
return s 
