local e={}
local i=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a=e[5]
local o={e[3],e[4],a}
t:AddBuff(t,n,i,o,a)
local e={
attrId=e[6],
value=e[7],
}
t:AddAttrValueInBattle(e)
end
return i

