local e=require("Modules/Battle/BattleUtil")
local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[12]
local i=e[13]
local a={}
for o=14,19 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
if e[20]>0 then
local n=e[21]
local s=e[13]
local a={}
for t=14,19 do
table.insert(a,e[t])
end
table.insert(a,e[22])
local i={}
for e=1,#o do
local t=o[e]
local t=t.HeroBattleInfo:GetBuff(n)
if t==nil then
table.insert(i,o[e])
end
end
local e=RandomTableWithSeed(i,e[20])
for o=1,#e do
local e=e[o]
e:AddBuff(t,n,s,a)
end
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
local o=e[1]
local i=e[2]
local n={e[3],e[4],e[5],e[6],e[7],e[8]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,n)
end
local a=e[9]
local i=e[10]
local o={e[11],o}
t:AddBuff(t,a,i,o)
return{
duration=e[11],
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
