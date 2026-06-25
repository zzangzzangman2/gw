local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local i=e[2]
local o={e[3],e[4],e[5],e[6],e[7],e[8],e[9],e[10]}
t:AddBuff(t,a,i,o)
local i=e[11]
local o=e[12]
local a={e[13],e[14],e[15],e[16]}
t:AddBuff(t,i,o,a)
local i=e[17]
local o=e[18]
local a={e[19],e[20],e[21],e[22],e[23]}
t:AddBuff(t,i,o,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if a and#a>1 then
local a=e[24]
local o=e[25]
local e={e[26],e[27],e[28],0}
t:AddBuff(t,a,o,e)
end
local a=e[29]
local o=e[30]
local e={e[31],e[32],e[33],e[34],e[35]}
t:AddBuff(t,a,o,e)
return nil
end
return n

