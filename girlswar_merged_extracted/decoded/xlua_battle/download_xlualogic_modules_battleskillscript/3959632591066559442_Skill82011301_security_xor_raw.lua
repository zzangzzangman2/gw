local i=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(e,o)
local a=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
local t=i:GetMaxFuryHeroArrByHeroArr(t,1)
local t=t[1]
if(t==nil)then
return
end
local i=a[1]
t:ReduceFuryWithSkill(a[3],e,EBattleSrcType.PetFightSkill,true)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,i,0,0)
return nil
end
return n 
