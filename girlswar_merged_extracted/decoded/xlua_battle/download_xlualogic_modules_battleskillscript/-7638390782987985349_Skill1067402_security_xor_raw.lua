local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[8]
local i=e[9]
local a={}
for o=10,17 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local i=e[18]
local o=e[19]
local a={}
for o=20,22 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local n=e[23]
local i=e[24]
local a={}
for o=25,28 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
t:AddImmunneBuffId(e[29])
local n=e[30]
local i=e[31]
local a={}
for o=32,35 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function a.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if#a>0 then
local o=e[1]
local i=e[2]
local n={e[3],e[4]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,n)
end
local a=e[5]
local i=e[6]
local o={e[7],o}
t:AddBuff(t,a,i,o)
return{
duration=e[7],
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

