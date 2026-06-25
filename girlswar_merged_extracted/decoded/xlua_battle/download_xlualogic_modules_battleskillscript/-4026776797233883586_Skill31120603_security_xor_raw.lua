local e={
}
local a=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local a=e[2]
local e={e[3],e[4],e[5]}
table.insert(e,0)
table.insert(e,0)
t:AddBuff(t,o,a,e)
return nil
end
return a

