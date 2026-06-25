local e=require("Modules/Battle/BattleUtil")
local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local a={}
for o=3,23 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
if e[28]>0 then
local i=e[24]
local n=e[25]
local a={}
for o=26,29 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
end
return nil
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
local o=e[30]
local i=e[31]
local n={e[32],e[33],e[34],e[35]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,n)
end
local a=e[36]
local i=e[37]
local o={e[38],o}
t:AddBuff(t,a,i,o)
return{
duration=e[38],
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
