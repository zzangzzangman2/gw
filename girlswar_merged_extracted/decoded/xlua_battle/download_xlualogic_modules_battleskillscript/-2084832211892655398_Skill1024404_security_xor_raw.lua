local e=require("Modules/Battle/BattleUtil")
local t={
}
local s=t
function t.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[9]
local i=e[10]
local o=e[11]
local e={e[12],e[13],e[14],e[15],e[16]}
if t.rankLevel>=a then
t:AddBuff(t,i,o,e)
end
return nil
end
function t.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function t.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
if e.CurrBattleTeam~=nil and e.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a={}
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fBack)
else
a=e.CurrBattleTeam:GetFrontOrBackHeros(false)
end
if#a>0 then
local o=t[1]
local i=t[2]
local n={t[3],t[4]}
for t=1,#a do
local t=a[t]
t:AddBuff(e,o,i,n)
end
e:AddFuryWithBuff(t[5])
local a=t[6]
local i=t[7]
local o={t[8],o}
e:AddBuff(e,a,i,o)
return{
duration=t[8],
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
