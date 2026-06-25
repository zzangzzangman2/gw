local e={
}
local o=e
function e.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local i=t[1]
local o=t[2]
local e={}
for a=3,30 do
table.insert(e,t[a])
end
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.ourAll)
if#n>1 then
table.insert(e,0)
else
table.insert(e,-1)
end
table.insert(e,t[31])
a:AddBuff(a,i,o,e)
return nil
end
return o

