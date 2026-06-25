local e={
}
local h=e
function e.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local i=t[1]
local n=t[2]
local e={}
for a=3,22 do
table.insert(e,t[a])
end
table.insert(e,0)
for o=23,29 do
table.insert(e,t[o])
end
a:AddBuff(a,i,n,e)
return nil
end
function e.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function e.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if#a>0 then
local o=e[24]
local i=e[25]
local n={e[26],e[27],e[28],e[29]}
local s=e[23]
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,n,s)
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
