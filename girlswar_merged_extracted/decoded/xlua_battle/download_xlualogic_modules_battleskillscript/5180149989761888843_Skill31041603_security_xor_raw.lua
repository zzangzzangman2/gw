local e={
}
local o=e
function e.DoAction(e,t)
local a=e:JudgeSkillPreView(t)
local i=a[1]
local o=a[2]
local t={}
for e=3,8 do
table.insert(t,a[e])
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
table.insert(t,#a)
e:AddBuff(e,i,o,t)
return nil
end
return o

