local e=require("Modules/Battle/BattleUtil")
local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local o=e[2]
local i={e[3],e[4]}
local n=e[5]
t:AddBuff(t,a,o,i,n)
local a=e[6]
local i=e[7]
local o={e[1],e[2],e[3],e[4],e[8],e[9]}
t:AddBuff(t,a,i,o)
if t.rankLevel>=e[10]then
local a=e[11]
local o=e[12]
local e={e[13],e[14]}
t:AddBuff(t,a,o,e)
end
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function a.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a={}
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fFront)
else
a=t.CurrBattleTeam:GetFrontOrBackHeros(true)
end
if#a>0 then
local o=e[15]
local n=e[16]
local i={e[17],e[18],e[19],e[20],e[21]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,n,i)
end
local i=e[22]
local n=e[23]
local a={e[24],o}
t:AddBuff(t,i,n,a)
return{
duration=e[24],
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
