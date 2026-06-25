local e={
}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local n=e[1]
local i=e[4]
local s=e[5]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for r,a in ipairs(a)do
local d=e[3]
local h=require("Modules/Battle/Formula")
if h:CalculateCtrlSuccess(i,d,t,a)then
a:AddBuff(t,i,s,0)
end
if(r==1)then
local i=e[6]
local o=e[7]
local e={e[8]}
a:AddBuff(t,i,o,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,n)
end
end
if(e[9]>=RandomMgr:GetBattleRandom())then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a)then
local o=e[10]
local i=e[11]
local e={e[12]}
for n,a in ipairs(a)do
a:AddBuff(t,o,i,e)
end
end
end
return nil
end
return s 
