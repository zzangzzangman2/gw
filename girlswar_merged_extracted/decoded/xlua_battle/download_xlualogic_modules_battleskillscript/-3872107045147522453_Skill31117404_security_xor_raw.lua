local a={
}
local n=a
function a.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local o=t[1]
local i=t[2]
local e={}
for a=3,14 do
table.insert(e,t[a])
end
for a=20,27 do
table.insert(e,t[a])
end
table.insert(e,0)
table.insert(e,0)
a:AddBuff(a,o,i,e)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function a.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
if e.CurrBattleTeam~=nil and e.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.selfRow)
if#a>0 then
local o={}
for e=1,#a do
table.insert(o,a[e].HeroId)
end
local a=t[15]
local o=t[16]
local i={}
e:AddBuff(e,a,o,i)
local a=t[17]
local o=t[18]
local i={t[19],303111701}
e:AddBuff(e,a,o,i)
return{
duration=t[19],
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
