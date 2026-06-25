local e={}
local r=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local h=t[1]
local s=t[3]
local a=t[4]
local n=t[5]
local i={t[6],t[7]}
e:AddBuff(e,a,n,i)
local a=t[8]
local i=t[9]
local n={t[10]}
e:AddBuff(e,a,i,n)
local i=0
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eAttrLow,1,HeroAttrId.hp)
if(a~=nil and#a>0)then
local a=a[1]
local n=(a.HeroBattleInfo.MaxHP-a.HeroBattleInfo.CurrHP)/a.HeroBattleInfo.MaxHP
n=math.min(n,t[11]*MillionCoe)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,h+n*OneMillion)
i=e[1]
end
local t=0
if(o.skilltype and o.skilltype==1)then
local a=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(a)then
t=a*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e:HpHealthWithNormalSkill(e,i*s*MillionCoe*(1+t),false,EBattleSrcType.SkillBig)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLowExcludeSelf,1,HeroAttrId.hpPer)
if(a~=nil and#a>0)then
local a=a[1]
a:HpHealthWithNormalSkill(e,i*s*MillionCoe*(1+t),false,EBattleSrcType.SkillBig)
end
return nil
end
return r

