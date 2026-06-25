local e={
}
local n=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
local n=t[1]
local i=t[2]
local a={}
local o=math.floor(t[3]*e.HeroBattleInfo.MaxHP*MillionCoe)
table.insert(a,o)
for o=4,8 do
table.insert(a,t[o])
end
e:AddBuff(e,n,i,a)
return nil
end
function e.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function e.DoAfterAction(e,t)
local a=e:JudgeSkillPreView(t)
local t=302110121
local t=e.HeroBattleInfo:GetBuff(t)
if t then
local t=t:GetBuffData()
local e=math.floor(a[3]*e.HeroBattleInfo.MaxHP*MillionCoe)
t[1]=e
end
return{
duration=0,
success=true
}
end
return n

