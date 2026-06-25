local e={
}
local o=e
function e.DoAction(t,e)
local a=t:JudgeSkillPreView(e)
local i=a[1]
local o=a[2]
local e={}
for t=3,7 do
table.insert(e,a[t])
end
table.insert(e,0)
table.insert(e,0)
table.insert(e,t.HeroBattleInfo.CurrHP)
t:AddBuff(t,i,o,e)
return nil
end
return o

