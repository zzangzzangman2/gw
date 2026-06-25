local a={
}
local n=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local o=e[2]
local i={e[3],e[4],e[5]}
t:AddBuff(t,a,o,i)
local o=e[6]
local i=e[7]
local a={}
for o=8,26 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local i=e[27]
local n=e[28]
local a={}
for o=29,34 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.CampionFront
end
function a.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
if t.CurrBattleTeam~=nil and t.CurrBattleTeam:IsSkillAfterActionRunning(EBattleSkillAfterActionType.CampionFront)==false then
local a=e[27]
local o=t.HeroBattleInfo:GetBuff(a)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.AddGirlFight(o)
end
local o=e[29]
local a=e[35]
local i=e[36]
local o={e[37],o}
t:AddBuff(t,a,i,o)
return{
duration=e[37],
success=true
}
end
return{
duration=0,
success=false
}
end
return n 
