local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6],e[7]}
t:AddBuff(t,i,o,a)
local n=e[11]
local i=e[12]
local a={}
for o=13,20 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function a.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[8]
local o=e[9]
local i={e[10]}
t:AddBuff(t,a,o,i)
return{
duration=e[10],
success=true
}
end
return s

