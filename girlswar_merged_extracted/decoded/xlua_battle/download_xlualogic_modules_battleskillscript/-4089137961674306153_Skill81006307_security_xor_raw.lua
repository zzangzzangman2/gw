local i=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(a,o)
local e=a:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
local t=i:FindMostBigAtk(t)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local h=e[1]
local s=e[3]
local i=e[4]
local n=e[5]
t:CheckAddBuff(s,a,i,n)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,o,h)
local o=e[6]
local i=e[7]
local e={e[8]}
t:AddBuff(a,o,i,e)
return nil
end
return r 
