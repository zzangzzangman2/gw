local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local n=e[2]
local a={}
for o=3,14 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local i=e[15]
local o=e[16]
local a={}
for t=17,20 do
table.insert(a,e[t])
end
table.insert(a,e[72])
t:AddBuff(t,i,o,a)
local o=e[21]
local i=e[22]
local a={}
for o=23,27 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local i=e[28]
local o=e[29]
local a={}
for t=30,33 do
table.insert(a,e[t])
end
local n=t.CurrBattleTeam:GetAllEnemyHerosCountInBattle()
local n=math.floor(n/e[34])
table.insert(a,n)
t:AddBuff(t,i,o,a)
local n=e[35]
local i=e[36]
local a={}
for o=37,41 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local o=e[49]
local i=e[50]
local a={0}
t:AddBuff(t,o,i,a)
local i=e[51]
local n=e[52]
local a={}
for o=53,58 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local o=e[59]
local i=e[60]
local a={}
for o=61,68 do
table.insert(a,e[o])
end
t:AddTeamBuff(t,o,i,a)
local i=e[69]
local o=e[70]
local a={}
for t=59,68 do
table.insert(a,e[t])
end
table.insert(a,e[71])
t:AddBuff(t,i,o,a)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function a.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
if e.CurrBattleTeam~=nil and e.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a={}
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fBack)
else
a=e.CurrBattleTeam:GetFrontOrBackHeros(false)
end
if#a>0 then
local o=t[45]
local i=e.HeroBattleInfo:GetBuff(302107826)
if i then
local e=i:GetBuffData()
o=e[5]
else
local e=e.HeroBattleInfo:GetBuff(302107819)
if e then
local e=e:GetBuffData()
o=e[7]
end
end
local i=t[42]
local n=t[43]
local o={t[44],o}
for t=1,#a do
local t=a[t]
t:AddBuff(e,i,n,o)
end
local a=t[46]
local o=t[47]
local i={t[48],i}
e:AddBuff(e,a,o,i)
return{
duration=t[48],
success=true
}
end
return{
duration=0,
success=true
}
end
return{
duration=0,
success=false
}
end
return s

