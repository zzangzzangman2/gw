local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local o=t[10]
local i=t[11]
local e={}
for a=12,20 do
local t=t[a]or 0
table.insert(e,t)
end
table.insert(e,0)
a:AddBuff(a,o,i,e)
return nil
end
function e.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function e.DoAfterAction(t,e)
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
local i=e[2]
local n={e[3],e[4],e[5],e[6]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,n)
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
