local e={
}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a={
attrId=e[1],
value=e[2],
}
t:AddAttrValueInBattle(a)
local a=e[5]
if(a>=RandomMgr:GetBattleRandom())then
local a=e[3]
local o=e[4]
local e={e[6],e[7],e[8],e[9]}
t:AddBuff(t,a,o,e)
end
return nil
end
return o 
