local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6],e[7],e[8],e[9],e[10]}
t:AddBuff(t,i,o,a)
local i=e[11]
local o=e[12]
local a={e[13],e[14],e[15],e[16],e[17]}
t:AddBuff(t,i,o,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if a and#a>1 then
local a=e[18]
local o=e[19]
local e={e[20],e[21],e[22],0}
t:AddBuff(t,a,o,e)
end
local a=e[23]
local o=e[24]
local e={e[25],e[26],e[27],e[28],e[29]}
t:AddBuff(t,a,o,e)
return nil
end
return n

