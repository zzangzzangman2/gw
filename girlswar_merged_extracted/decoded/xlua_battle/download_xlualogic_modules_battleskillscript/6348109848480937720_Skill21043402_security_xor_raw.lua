local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local s=e[2]
local n={e[4],e[5],e[6],e[7]}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for i=1,#o do
if e[3]>=RandomMgr:GetBattleRandom()then
o[i]:AddBuff(t,a,s,n)
end
end
local i=e[8]
local o=e[9]
local a={e[10],e[11],a}
t:AddBuff(t,i,o,a)
local a=e[12]
local o=e[13]
local e={e[14],e[15]}
t:AddBuff(t,a,o,e)
return nil
end
return h 
