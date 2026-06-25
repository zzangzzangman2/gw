local e={
}
local i=e
function e.DoAction(e,o)
local a=e:JudgeSkillPreView(o)
local i=a[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,i)
local t=a[3]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e:CurrHPPer()<a[4]*MillionCoe)then
t=a[5]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e:HpHealthWithNormalSkill(e,e.HeroBattleInfo.MaxHP*t*MillionCoe,false,EBattleSrcType.SkillSmall)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return i 
