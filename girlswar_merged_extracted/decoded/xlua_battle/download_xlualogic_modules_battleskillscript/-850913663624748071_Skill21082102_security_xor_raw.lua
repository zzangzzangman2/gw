local e={
}
local o=e
function e.DoAction(e,a,t,o)
local a=e:JudgeSkillPreView(a)
local a=t.addHp
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
e:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.HeroId,t.buffId)
return nil
end
return o 
