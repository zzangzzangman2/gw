local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMinHpPercentWithCount)
local a=a[1]
if(a==nil)then
return nil
end
local s=e[1]
local i=e[6]
local n=e[3]
local h=e[4]
local e={e[5],i}
a:AddBuff(t,n,h,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,s)
return nil
end
return h 
