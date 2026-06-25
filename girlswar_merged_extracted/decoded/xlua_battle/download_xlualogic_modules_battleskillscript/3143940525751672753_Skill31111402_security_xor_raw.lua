local e={
}
local a={
}
local h=a
function a.DoAction(a,e)
local e=a:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local t={}
for a=3,22 do
table.insert(t,e[a])
end
table.insert(t,0)
for o=23,29 do
table.insert(t,e[o])
end
a:AddBuff(a,o,i,t)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function a.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if#a>0 then
local o=e[24]
local i=e[25]
local s={e[26],e[27],e[28],e[29]}
local n=e[23]
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,s,n)
end
local a=e[30]
local i=e[31]
local o={e[32],o}
t:AddBuff(t,a,i,o)
return{
duration=e[32],
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
return h 
