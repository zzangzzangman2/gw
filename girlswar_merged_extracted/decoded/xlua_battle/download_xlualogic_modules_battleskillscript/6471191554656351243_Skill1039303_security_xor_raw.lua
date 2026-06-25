local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local s=t[1]*MillionCoe
local h=e:GetFinalAtk()
local i=0
local o=30103905
local o=e.HeroBattleInfo:GetBuff(30103905)
if o then
local e=o:GetFloors()
local t=o:GetBuffData()
i=t[1]*e
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if(o~=nil)then
local n=#o
for n=1,n do
local o=o[n]
if(t[3]+i>=RandomMgr:GetBattleRandom())then
o.HeroBattleInfo:DispelGranBuff(false,1,true)
end
local i=ModulesInit.BattleBuffMgr.GetBuffScript(30103903)
i.CheckAddBuffAction(e,o)
e:ResetAttrValuesInCurAttack()
if(o:CurrHPPer()<t[4]*MillionCoe)then
local a={
attrId=t[5],
value=t[6],
}
e:AddAttrValueInCurAttack(a)
local t={
attrId=t[7],
value=t[8],
}
e:AddAttrValueInCurAttack(t)
end
local t=0
if(a.skilltype and a.skilltype==1)then
local a=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(a)then
t=a*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local a=e:GetIsCrtRemedy()
o:HpHealthWithBigSkill(e,h*(1+t),s,a,EBattleSrcType.SkillBig)
end
end
return nil
end
return s 
