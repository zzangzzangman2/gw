local o={
}
local s=o
function o.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[5]
local i=e[6]
local a={}
for t=28,33 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
for o=7,14 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local o=e[1]
local i=e[2]
local a={}
for t=3,4 do
table.insert(a,e[t])
end
for t=15,27 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
table.insert(a,0)
t:AddBuff(t,o,i,a)
local o=e[34]
local a=e[35]
local e={e[36]}
t:AddBuff(t,o,a,e)
return nil
end
function o.GetAfterActionType()
return EBattleSkillAfterActionType.CampionAfter
end
function o.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionAfter)==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if#a>0 then
local o=e[37]
local i=e[38]
local n={e[39],e[40]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,n)
end
local a=e[41]
local i=e[42]
local o={e[43],o}
t:AddBuff(t,a,i,o)
return{
duration=e[43],
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
