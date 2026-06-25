local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,t)
local o=e:JudgeSkillPreView(t)
e:ReduceFury(t.costMp)
local s=o[1]*MillionCoe
local n=e:GetFinalAtk()
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if(a~=nil)then
local i=#a
for i=1,i do
local a=a[i]
if(o[3]>=RandomMgr:GetBattleRandom())then
a.HeroBattleInfo:DispelGranBuff(false,1)
end
local o=ModulesInit.BattleBuffMgr.GetBuffScript(30103903)
o.CheckAddBuffAction(e,a)
local o=0
if(t.skilltype and t.skilltype==1)then
local t=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(t)then
o=t*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local t=e:GetIsCrtRemedy()
a:HpHealthWithBigSkill(e,n*(1+o),s,t,EBattleSrcType.SkillBig)
end
end
return nil
end
return h 
