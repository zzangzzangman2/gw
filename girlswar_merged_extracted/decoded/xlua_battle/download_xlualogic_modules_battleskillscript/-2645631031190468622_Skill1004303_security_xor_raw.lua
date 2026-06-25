local e={
}
local r=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local s=t[1]*MillionCoe
local n=e:GetFinalAtk()
local h=t[3]
local i=e:GetIsCrtRemedy()
local a=0
if(o.skilltype and o.skilltype==1)then
local t=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(t)then
a=t*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e:HpHealthWithBigSkill(e,n*(1+a),s,i,EBattleSrcType.SkillBig)
e:AddFuryWithSkill(h)
local r=e.CurrBattleTeam:GetAllHerosCount()
if(r==1)then
local o=t[4]
local a=t[5]
local t={t[6]}
e:AddBuff(e,o,a,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(e:CurrHPPer()<t[7]*MillionCoe)then
local o=t[8]
local a=t[9]
local t={t[10]}
e:AddBuff(e,o,a,t)
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLow,1,HeroAttrId.hpPer)
if(t~=nil and#t>0)then
local t=t[1]
a=0
if(o.skilltype and o.skilltype==1)then
local t=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(t)then
a=t*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(t.HeroId==e.HeroId)then
t:HpHealthWithBigSkill(e,n*(1+a),s,i,EBattleSrcType.SkillBig)
else
t:HpHealthWithBigSkill(e,n*(1+a),s,i,EBattleSrcType.SkillBig)
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.hpHealthWith1004,e,t)
end
t:AddFuryWithSkill(h)
end
return nil
end
return r 
