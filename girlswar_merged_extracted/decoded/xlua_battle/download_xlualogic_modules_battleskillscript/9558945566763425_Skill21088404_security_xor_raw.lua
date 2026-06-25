local t={
}
local s=t
function t.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local i=t[1]
local o=t[2]
local e={}
for a=3,31 do
table.insert(e,t[a])
end
table.insert(e,{})
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
table.insert(e,t[41])
table.insert(e,{})
a:AddBuff(a,i,o,e)
return nil
end
function t.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function t.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if#a>0 then
local o=e[32]
local i=e[33]
local n={e[34],e[35],e[36],e[37]}
for e=1,#a do
local e=a[e]
e:AddBuff(t,o,i,n)
end
local a=e[38]
local i=e[39]
local o={e[40],o}
t:AddBuff(t,a,i,o)
return{
duration=e[40],
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
