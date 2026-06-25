local e={
}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local s=t[1]
local n=t[3]
local o=t[4]
local i=t[5]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
for h,t in ipairs(t)do
local h=require("Modules/Battle/Formula")
if h:CalculateCtrlSuccess(o,n,e,t)then
t:AddBuff(e,o,i,0)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,s)
end
end
return nil
end
return s 
