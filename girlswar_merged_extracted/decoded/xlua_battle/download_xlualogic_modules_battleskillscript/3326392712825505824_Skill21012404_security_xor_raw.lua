local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6]}
t:AddBuff(t,i,o,a)
local n=e[7]
local i=e[8]
local a={}
for o=9,15 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local a=e[16]
local o=e[17]
local e={e[18]}
t:AddBuff(t,a,o,e)
return nil
end
return s 
