local e={
}
local i=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local i=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
local a=t[3]
if(e:CurrHPPer()<t[4]*MillionCoe)then
a=t[5]
end
e:HpHealthWithNormalSkill(e,e.HeroBattleInfo.MaxHP*a*MillionCoe,false,EBattleSrcType.SkillSmall)
e:AddFuryWithSkill(t[6])
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return i 
