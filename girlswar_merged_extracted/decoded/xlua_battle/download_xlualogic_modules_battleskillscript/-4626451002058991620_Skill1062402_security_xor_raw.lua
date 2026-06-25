local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local a=e[2]
local o={e[3],e[4]}
t:AddBuff(t,i,a,o)
local a=e[5]
local i=e[6]
local o={e[7],e[8]}
t:AddBuff(t,a,i,o)
local o=e[9]
local i=e[10]
local a={e[11],e[12]}
t:AddBuff(t,o,i,a)
local i=e[13]
local o=e[14]
local a={e[15],e[16]}
t:AddBuff(t,i,o,a)
local n=e[17]
local i=e[18]
local a={}
for o=19,22 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[23]
local o=e[24]
local a={}
for o=25,29 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local i=e[30]
local o=e[31]
local a={}
for o=32,37 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local i=e[38]
local o=e[39]
local a={}
for t=40,45 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
t:AddBuff(t,i,o,a)
t:ShowRageBar(true)
local e=ModulesInit.BattleBuffMgr.GetBuffScript(30106214)
e.RefreshRageBar(t)
return nil
end
return s

