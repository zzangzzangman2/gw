local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[8]
local i=e[9]
local o={e[10],e[11]}
t:AddBuff(t,a,i,o)
local o=e[12]
local a=e[13]
local e={e[14],e[15],e[16]}
t:AddBuff(t,o,a,e)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function a.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ePriorBackMaxFinalAtk)
if a~=nil then
local o=e[1]
local n=e[2]
local i={e[3],e[4]}
a:AddBuff(t,o,n,i)
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

