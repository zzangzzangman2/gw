local e={
}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[3]
if(a>=RandomMgr:GetBattleRandom())then
local a=e[1]
local o=e[2]
local e={e[4],e[5],e[6],e[7]}
t:AddBuff(t,a,o,e)
end
return nil
end
return o 
