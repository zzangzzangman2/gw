local a={
}
local i=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[8]
local o=e[9]
local i={e[10],e[11]}
t:AddBuff(t,a,o,i)
local a=e[12]
local i=e[13]
local o={e[14],e[15]}
t:AddBuff(t,a,i,o)
local a=e[16]
local o=e[17]
t:AddBuff(t,a,o,0)
local i=e[18]
local o=e[19]
local a={}
for o=20,30 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local a=e[31]
local o=e[32]
local e={e[33],e[34],e[35]}
t:AddBuff(t,a,o,e)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function a.DoAfterAction(e,t)
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
return i 
