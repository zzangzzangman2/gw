local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[8]
local a=e[9]
local e={e[10]}
t:AddBuff(t,o,a,e)
return nil
end
function e.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function e.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a={}
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fFront)
else
a=t.CurrBattleTeam:GetFrontOrBackHeros(true)
end
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

