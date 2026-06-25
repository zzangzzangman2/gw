local a={}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[14]
local a=e[15]
local i={e[16],e[17]}
t:AddBuff(t,o,a,i)
local a=e[18]
local o=e[19]
local i={e[20],e[21],e[22],e[23],e[24]}
t:AddBuff(t,a,o,i)
t:AddImmunneBuffId(e[25])
t:AddImmunneBuffId(e[26])
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
local i={e[3],e[4],e[5],e[6],e[7],e[8],e[9],e[10]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,n,i)
end
local a=e[11]
local i=e[12]
local o={e[13],o}
t:AddBuff(t,a,i,o)
return{
duration=e[13],
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

