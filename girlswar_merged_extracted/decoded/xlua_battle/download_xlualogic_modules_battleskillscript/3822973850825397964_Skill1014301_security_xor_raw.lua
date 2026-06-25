local e={
}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local n=e[1]
local i=e[4]
local h=e[5]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for s,a in ipairs(a)do
local s=e[3]
local e=require("Modules/Battle/Formula")
if e:CalculateCtrlSuccess(i,s,t,a)then
a:AddBuff(t,i,h,0)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,n)
end
end
if(e[6]>=RandomMgr:GetBattleRandom())then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a)then
local i=e[7]
local o=e[8]
local e={e[9]}
for n,a in ipairs(a)do
a:AddBuff(t,i,o,e)
end
end
end
return nil
end
return r 
