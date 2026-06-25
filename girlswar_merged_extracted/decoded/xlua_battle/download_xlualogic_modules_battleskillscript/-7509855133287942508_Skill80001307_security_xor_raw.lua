local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFrontMinHpPercentWithCount)
local a=a[1]
if(a==nil)then
return nil
end
local i=e[1]
local n=e[3]
local h=e[4]
local s={e[5],e[6]}
a:AddBuff(t,n,h,s)
a:ReduceFuryWithSkill(e[7],t,EBattleSrcType.PetFightSkill,true)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
return nil
end
return r 
