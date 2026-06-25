local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6],e[7]}
t:AddBuff(t,i,o,a)
local a=e[10]
if(a>=RandomMgr:GetBattleRandom())then
local o=e[8]
local i=e[9]
local a={}
for o=11,20 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
end
return nil
end
return n

