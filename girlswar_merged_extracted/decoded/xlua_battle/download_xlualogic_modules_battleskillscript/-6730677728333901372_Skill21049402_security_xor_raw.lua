local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
local n=t[1]
local i=t[2]
local a={}
for o=3,14 do
table.insert(a,t[o])
end
e:AddBuff(e,n,i,a)
return nil
end
return s 
