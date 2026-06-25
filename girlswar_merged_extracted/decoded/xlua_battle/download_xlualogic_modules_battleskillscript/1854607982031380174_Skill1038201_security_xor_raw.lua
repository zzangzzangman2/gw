local e={
}
local s=e
function e.DoAction(e,i)
local o=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local n=o[1]
local a=o[3]
if(e:CurrHPPer()>t:CurrHPPer())then
a=o[4]
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:AddFuryWithSkill(a)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,n)
e:FuryHealth(FuryHealthType.Attack)
end
return s 
