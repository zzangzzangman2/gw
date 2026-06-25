local e={}
local s=e
function e.DoAction(e,t)
local a=e:JudgeSkillPreView(t)
e:ReduceFury(t.costMp)
local i=a[1]
local n=a[3]
local o=0
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eAttrLow,1,HeroAttrId.hp)
if(a~=nil and#a>0)then
local a=a[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,t,i)
o=e[1]
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLowExcludeSelf,1,HeroAttrId.hpPer)
if(a~=nil and#a>0)then
local i=a[1]
local a=0
if(t.skilltype and t.skilltype==1)then
local t=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(t)then
a=t*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
i:HpHealthWithNormalSkill(e,o*n*MillionCoe*(1+a),false,EBattleSrcType.SkillBig)
end
return nil
end
return s

