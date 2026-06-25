local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
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
local i=e[9]
local o=e[10]
local a={e[11],e[12]}
t:AddBuff(t,i,o,a)
local i=e[13]
local o=e[14]
local a={e[15],e[16]}
t:AddBuff(t,i,o,a)
local i=e[17]
local o=e[18]
local a={e[19],e[20]}
t:AddBuff(t,i,o,a)
local i=e[21]
local o=e[22]
local a={}
for o=23,33 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local a=#a
if a>e[38]then
local a=e[34]
local o=e[35]
local e={e[36],e[37]}
t:AddBuff(t,a,o,e)
end
local a=e[39]
local o=e[40]
local e={e[41],e[42],e[43]}
t:AddBuff(t,a,o,e)
return nil
end
return n

