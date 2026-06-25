local e={}
local s=e
function e.DoAction(e,t)
local a=e:JudgeSkillPreView(t)
e:ReduceFury(t.costMp)
local i=a[1]*MillionCoe
local s=e:GetFinalAtk()
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local n=e:GetIsCrtRemedy()
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if(a~=nil)then
local o=#a
for o=1,o do
local o=a[o]
local a=0
if(t.skilltype and t.skilltype==1)then
local t=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(t)then
a=t*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
o:HpHealthWithBigSkill(e,s*(1+a),i,n,EBattleSrcType.SkillBig)
end
end
return nil
end
return s

