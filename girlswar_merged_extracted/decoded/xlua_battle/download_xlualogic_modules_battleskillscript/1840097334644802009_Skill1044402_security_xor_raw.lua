local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if a~=nil then
for o=1,#a do
local n=e[1]
local i=e[2]
local e={e[3],e[4]}
a[o]:AddBuff(t,n,i,e)
end
end
local i=e[5]
local o=e[6]
local a={e[1]}
t:AddBuff(t,i,o,a)
local i=e[7]
local a=e[8]
local o={e[9],e[10],e[11],e[12],e[13]}
t:AddBuff(t,i,a,o)
t:AddImmunneBuffId(e[14])
if t.rankLevel>=e[15]then
local e={
attrId=e[16],
value=e[17],
}
t:AddAttrValueInBattle(e)
end
local a=e[18]
local o=e[19]
local e={e[20]}
t:AddBuff(t,a,o,e)
return nil
end
return n 
