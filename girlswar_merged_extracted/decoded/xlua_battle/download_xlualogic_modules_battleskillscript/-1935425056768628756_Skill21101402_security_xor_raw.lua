local e=require("Modules/Battle/BattleUtil")
local t={
}
local s=t
function t.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local o=t[1]
local i=t[2]
local e={}
for a=3,25 do
table.insert(e,t[a])
end
table.insert(e,0)
table.insert(e,0)
a:AddBuff(a,o,i,e)
return nil
end
function t.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function t.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a={}
if ModulesInit.ProcedureNormalBattle.BattleMode==EBattleMode.formation1v1 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fFront)
else
a=t.CurrBattleTeam:GetFrontOrBackHeros(true)
end
if#a>0 then
local o=e[26]
local i=e[27]
local n={e[28],e[29],e[30],e[31]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,n)
end
local a=e[32]
local i=e[33]
local o={e[34],o}
t:AddBuff(t,a,i,o)
return{
duration=e[34],
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
