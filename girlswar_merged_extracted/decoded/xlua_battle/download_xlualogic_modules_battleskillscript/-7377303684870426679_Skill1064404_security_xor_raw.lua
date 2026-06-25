local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4]}
t:AddBuff(t,i,o,a)
local a=e[5]
local o=e[6]
local i={e[7],e[8]}
t:AddBuff(t,a,o,i)
local a=e[9]
local i=e[10]
local o={e[11],e[12]}
t:AddBuff(t,a,i,o)
local i=e[13]
local a=e[14]
local o={e[15],e[16]}
t:AddBuff(t,i,a,o)
local i=e[17]
local a=e[18]
local o={e[19],e[20]}
t:AddBuff(t,i,a,o)
local i=e[21]
local n=e[22]
local a={}
for o=23,33 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local a=#a
if a>e[38]then
local a=e[34]
local o=e[35]
local e={e[36],e[37]}
t:AddBuff(t,a,o,e)
end
if a>e[42]then
local o=e[39]
local a=e[40]
local e={e[41]}
t:AddBuff(t,o,a,e)
end
local i=e[43]
local o=e[44]
local a={}
for o=45,48 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local n=e[49]
local i=e[50]
local a={}
for o=51,58 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local a=e[59]
local o=e[60]
local e={e[61],e[62],e[63]}
t:AddBuff(t,a,o,e)
return nil
end
return s 
