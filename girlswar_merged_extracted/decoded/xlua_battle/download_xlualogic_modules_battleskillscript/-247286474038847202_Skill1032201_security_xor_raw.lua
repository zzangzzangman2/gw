local e={
}
local n=e
function e.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local o=a[1]
if(e.HeroBattleInfo:GetCurrFury()>=a[3])then
o=o+a[4]
else
local o=t.HeroBattleInfo:GetCurrFury()
local a=math.min(a[5],o)
if(a>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:AddFuryWithSkill(a)
t:ReduceFuryWithSkill(a,e,EBattleSrcType.SkillSmall,true)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,o)
e:FuryHealth(FuryHealthType.Attack)
end
return n 
