local e={}
local n=e
function e.DoAction(e,a)
local o=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local i=o[1]*MillionCoe
local s=e:GetFinalAtk()
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local n=e:GetIsCrtRemedy()
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if(t~=nil)then
local o=#t
for o=1,o do
local o=t[o]
local t=0
if(a.skilltype and a.skilltype==1)then
local a=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(a)then
t=a*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
o:HpHealthWithBigSkill(e,s*(1+t),i,n,EBattleSrcType.SkillBig)
end
end
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrHigh,1,HeroAttrId.hp)
if(t)then
local i=o[3]
local a=o[4]
local o={o[5]}
for n,t in ipairs(t)do
t:AddBuff(e,i,a,o)
end
end
return nil
end
return n

