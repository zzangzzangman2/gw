local e={
}
local s=e
function e.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local n=t[1]
local i=t[2]
local e={}
for a=3,23 do
table.insert(e,t[a])
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.all)
local o=#o
if o>=t[24]then
table.insert(e,t[25])
else
table.insert(e,t[26])
end
for a=27,34 do
table.insert(e,t[a])
end
table.insert(e,0)
table.insert(e,0)
a:AddBuff(a,n,i,e)
return nil
end
return s

