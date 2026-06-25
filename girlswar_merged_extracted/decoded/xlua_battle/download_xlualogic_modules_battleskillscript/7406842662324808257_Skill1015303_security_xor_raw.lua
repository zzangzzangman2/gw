local e={
}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local h=e[1]
local s=e[3]
local n=e[4]
local r=e[5]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local o={}
if(a)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for a,e in ipairs(a)do
local a=require("Modules/Battle/Formula")
if a:CalculateCtrlSuccess(n,s,t,e)then
e:AddBuff(t,n,r,0)
else
table.add(o,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,h)
end
end
if(e[10]>=RandomMgr:GetBattleRandom())then
o=RandomTableWithSeed(o,e[11])
if(o)then
local n=e[12]
local i=e[13]
local e={e[14]}
for o,a in ipairs(o)do
a:AddBuff(t,n,i,e)
end
end
end
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eRandom,e[6])
if(a)then
local o=e[7]
local i=e[8]
local e={e[9]}
for n,a in ipairs(a)do
if(s>=RandomMgr:GetBattleRandom())then
a:AddBuff(t,o,i,e)
end
end
end
return nil
end
return r 
