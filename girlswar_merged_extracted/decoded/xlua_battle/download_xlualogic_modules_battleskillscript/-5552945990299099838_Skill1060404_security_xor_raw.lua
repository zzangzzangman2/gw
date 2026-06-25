local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[8]
local a=e[9]
local o={e[10],e[11]}
t:AddBuff(t,i,a,o)
local a=e[12]
local o=e[13]
local i={e[14],e[15]}
t:AddBuff(t,a,o,i)
local a=e[16]
local o=e[17]
t:AddBuff(t,a,o,0)
local n=e[18]
local i=e[19]
local a={}
for o=20,30 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[31]
local o=e[32]
local a={e[33],e[34],e[35]}
t:AddBuff(t,i,o,a)
local i=e[36]
local o=e[37]
local a={}
for t=38,47 do
table.insert(a,e[t])
end
for o=20,23 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
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
local n=e[2]
local i={e[3],e[4]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,n,i)
end
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

