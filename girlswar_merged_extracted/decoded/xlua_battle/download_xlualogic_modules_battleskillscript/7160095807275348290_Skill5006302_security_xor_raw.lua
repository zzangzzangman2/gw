local e={
}
local n=e
function e.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local s=a[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=a[3]
local n=a[4]
for a,t in ipairs(t)do
local a=t.HeroBattleInfo:GetBuff(2030)
if(a)then
local a=require("Modules/Battle/Formula")
local i=10000
if a:CalculateCtrlSuccess(o,i,e,t)then
t:AddBuff(e,o,n,0)
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,s)
end
end
return nil
end
return n 
