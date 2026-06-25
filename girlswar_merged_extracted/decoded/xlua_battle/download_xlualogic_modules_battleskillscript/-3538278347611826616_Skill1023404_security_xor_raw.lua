local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a={
attrId=e[1],
value=e[2],
}
t:AddAttrValueInBattle(a)
local a={
attrId=e[3],
value=e[4],
}
t:AddAttrValueInBattle(a)
local a={
attrId=e[5],
value=e[6],
}
t:AddAttrValueInBattle(a)
local i=e[7]
local o=e[8]
local a={e[9]}
t:AddBuff(t,i,o,a)
local a=e[12]
if(a>=RandomMgr:GetBattleRandom())then
local a=e[10]
local o=e[11]
local e={e[13],e[14],e[15],e[16]}
t:AddBuff(t,a,o,e)
end
return nil
end
return n 
