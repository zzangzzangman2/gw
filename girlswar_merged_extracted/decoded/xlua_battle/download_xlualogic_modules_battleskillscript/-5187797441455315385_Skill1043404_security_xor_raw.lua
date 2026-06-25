local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local s=e[2]
local i={e[4],e[5],e[6],e[7]}
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
for n=1,#o do
if e[3]>=RandomMgr:GetBattleRandom()then
o[n]:AddBuff(t,a,s,i)
end
end
local i=e[8]
local o=e[9]
local a={e[10],e[11],a}
t:AddBuff(t,i,o,a)
local o=e[12]
local a=e[13]
local i={e[14],e[15]}
t:AddBuff(t,o,a,i)
local e={
attrId=e[16],
value=e[17],
}
t:AddAttrValueInBattle(e)
return nil
end
return n 
