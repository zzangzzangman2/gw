local a={}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[10]
local n=e[11]
local i={e[12],e[13]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a~=nil)then
local e=#a
for e=1,e do
local e=a[e]
e:AddBuff(t,o,n,i)
end
end
t:AddImmunneBuffId(e[14])
t:AddImmunneBuffId(e[15])
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function a.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a={}
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fBack)
else
a=t.CurrBattleTeam:GetFrontOrBackHeros(false)
end
if#a>0 then
local o=e[1]
local n=e[2]
local i={e[3],e[4],e[5],e[6]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,n,i)
end
local a=e[7]
local i=e[8]
local o={e[9],o}
t:AddBuff(t,a,i,o)
return{
duration=e[9],
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

