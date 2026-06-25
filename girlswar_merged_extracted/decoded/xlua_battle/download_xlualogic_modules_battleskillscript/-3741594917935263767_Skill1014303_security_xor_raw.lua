local e={
}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local o=e[1]
local n=e[4]
local r=e[5]
local h=e[6]
local d=e[7]
local l={e[8]}
local a=t.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
if(a==1)then
o=o+e[13]
local a=e[14]
local o=e[15]
local e={e[16]}
t:AddBuff(t,a,o,e)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for s,a in ipairs(a)do
local e=e[3]
local s=require("Modules/Battle/Formula")
if s:CalculateCtrlSuccess(n,e,t,a)then
a:AddBuff(t,n,r,0)
end
a:AddBuff(t,h,d,l)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
end
end
if(e[9]>=RandomMgr:GetBattleRandom())then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a)then
local i=e[10]
local o=e[11]
local e={e[12]}
for n,a in ipairs(a)do
a:AddBuff(t,i,o,e)
end
end
end
return nil
end
return d 
