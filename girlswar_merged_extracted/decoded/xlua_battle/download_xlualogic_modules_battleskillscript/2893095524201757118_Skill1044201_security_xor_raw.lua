local e={
}
local i=e
function e.DoAction(e,a)
local o=e:JudgeSkillPreView(a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local n=o[1]
local i=require("Modules/Battle/Formula")
local i=i:GetDefBattleBefore(e)
e:HpHealthWithNormalSkill(e,math.floor(i*o[3]*MillionCoe),false,EBattleSrcType.SkillSmall)
t.HeroBattleInfo:DispelAllGranBuff(true,nil,e.HeroId)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,n)
e:FuryHealth(FuryHealthType.Attack)
end
return i 
