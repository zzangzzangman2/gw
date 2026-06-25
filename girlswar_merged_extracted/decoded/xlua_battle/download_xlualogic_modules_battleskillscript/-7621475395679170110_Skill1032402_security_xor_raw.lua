local o=require("Modules/Battle/BattleUtil")
local i=require("Modules/BattleBuffScript/BuffSoulMgr")
local a={
}
local h=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[8]
local n=e[9]
local s={e[10],e[11],e[12]}
t:AddBuff(t,a,n,s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local a=o:GetTotalCountPerTeamSoulCategory(a)
for a,o in pairs(a)do
if o>e[13]then
i.AddSoulBuff(t,a,-1)
end
end
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function a.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
if e.CurrBattleTeam~=nil and e.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a={}
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fFront)
else
a=e.CurrBattleTeam:GetFrontOrBackHeros(true)
end
if#a>0 then
local o=t[1]
local n=t[2]
local s={t[3],t[4],e.soulId}
for t=1,#a do
local t=a[t]
t:AddBuff(e,o,n,s)
i.AddSoulBuff(t,e.soulId,n)
end
local a=t[5]
local i=t[6]
local o={t[7],o}
e:AddBuff(e,a,i,o)
return{
duration=t[7],
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
