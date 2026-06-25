local e={
}
local i=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local i=e[2]
local o={e[3],e[4],e[5]}
t:AddBuff(t,a,i,o)
local n=e[6]
local i=e[7]
local a={}
for t=8,14 do
table.insert(a,e[t])
end
local o=math.floor(t.HeroBattleInfo.OriginalHP*e[8]*MillionCoe)
table.insert(a,o)
local e=math.floor(t.HeroBattleInfo.OriginalHP*e[9]*MillionCoe)
e=math.min(e,o)
table.insert(a,e)
t:AddBuff(t,n,i,a)
return nil
end
return i

