local t={
}
local s=t
function t.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local i=t[1]
local o=t[2]
local e={}
for a=3,17 do
table.insert(e,t[a])
end
for a=51,56 do
table.insert(e,t[a])
end
table.insert(e,0)
a:AddBuff(a,i,o,e)
return nil
end
function t.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function t.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
if e.CurrBattleTeam~=nil and e.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local n=t[18]
local i=t[19]
local a={}
for o=20,47 do
table.insert(a,t[o])
end
e:AddBuff(e,n,i,a)
local a=t[48]
local o=t[49]
local i={t[50],303112004}
e:AddBuff(e,a,o,i)
return{
duration=t[50],
success=true
}
end
return{
duration=0,
success=false
}
end
return s 
