local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local o=e[2]
local i={e[3],e[4],e[5],e[6]}
t:AddBuff(t,a,o,i)
local o=e[7]
local i=e[8]
local a={e[9],e[15],e[24]}
t:AddBuff(t,o,i,a)
local n=e[16]
local i=e[17]
local a={}
table.insert(a,e[18])
for t=10,14 do
table.insert(a,e[t])
end
for o=25,26 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local a=e[19]
local o=e[20]
local i={e[21],e[22],0,0}
t:AddBuff(t,a,o,i)
t:AddImmuneBuff(e[23])
local o=e[27]
local i=e[28]
local a={}
for t=29,44 do
table.insert(a,e[t])
end
table.insert(a,0)
t:AddBuff(t,o,i,a)
local a=302107711
local e=t.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.CheckResetState(e)
end
return nil
end
return n

