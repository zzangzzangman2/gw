local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local a={}
for o=3,24 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
return nil
end
function e.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function e.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local a=RandomTableWithSeed(a,e[18])
if#a>0 then
local o=e[19]
local i=e[20]
local n={e[21],e[22],e[23],e[24]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,n)
end
local a=e[25]
local i=e[26]
local o={e[27],o}
t:AddBuff(t,a,i,o)
return{
duration=e[27],
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
