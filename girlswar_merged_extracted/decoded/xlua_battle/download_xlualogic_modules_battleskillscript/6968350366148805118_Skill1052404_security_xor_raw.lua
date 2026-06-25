local e={}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local a=e[2]
local i={e[3],e[4],e[5],e[6]}
t:AddBuff(t,o,a,i)
local e={
attrId=e[7],
value=e[8],
}
t:AddAttrValueInBattle(e)
return nil
end
return o

