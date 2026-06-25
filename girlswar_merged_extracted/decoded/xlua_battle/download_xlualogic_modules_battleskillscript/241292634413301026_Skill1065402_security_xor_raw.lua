local a={
}
local n=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[10]
local i=e[11]
local a={e[12],e[13],e[14],e[15]}
t:AddBuff(t,o,i,a)
local a=e[16]
local i=e[17]
local o={e[18],e[19],e[20],e[21],e[22],e[23]}
t:AddBuff(t,a,i,o)
local o=e[24]
local i=e[25]
local a={}
for o=26,34 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
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
return n

