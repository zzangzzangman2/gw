local a={
}
local s=a
function a.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,15 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local o=e[16]
local a=e[17]
local e={e[18]}
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
t:AddBuff(t,o,a,e)
return nil
end
function a.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function a.DoAfterAction(t,e)
local a=t:JudgeSkillPreView(e)
local n=a[19]
local i=a[20]
local e={}
local o=302108709
local o=t.HeroBattleInfo:GetBuff(o)
if o then
local t=o:GetBuffData()
table.insert(e,a[3])
table.insert(e,t[1])
table.insert(e,t[2])
else
for t=3,5 do
table.insert(e,a[t])
end
end
t:AddBuff(t,n,i,e)
return{
duration=0,
success=true
}
end
return s 
