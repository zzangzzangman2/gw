local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={}
for t=3,18 do
table.insert(a,e[t])
end
table.insert(a,e[26])
t:AddBuff(t,i,o,a)
local n=e[19]
local i=e[20]
local a={}
for o=21,25 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function a.DoAfterAction(e,t)
local t=e:JudgeSkillPreView(t)
local t=303112104
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddBuffLightlessPearOnStart(e)
end
return{
duration=0,
success=true
}
end
return s 
