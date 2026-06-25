local e={}
local h=e
function e.DoAction(e,t)
local i=e:JudgeSkillPreView(t)
e:ReduceFury(t.costMp)
local h=i[1]
local s=i[3]
local n=0
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eAttrLow,1,HeroAttrId.hp)
if(a~=nil and#a>0)then
local a=a[1]
local o=(a.HeroBattleInfo.MaxHP-a.HeroBattleInfo.CurrHP)/a.HeroBattleInfo.MaxHP
o=math.min(o,i[4]*MillionCoe)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,t,h+o*OneMillion)
n=e[1]
end
local a=0
if(t.skilltype and t.skilltype==1)then
local t=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(t)then
a=t*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e:HpHealthWithNormalSkill(e,n*s*MillionCoe*(1+a),false,EBattleSrcType.SkillBig)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLowExcludeSelf,1,HeroAttrId.hpPer)
if(t~=nil and#t>0)then
local t=t[1]
t:HpHealthWithNormalSkill(e,n*s*MillionCoe*(1+a),false,EBattleSrcType.SkillBig)
end
return nil
end
return h

