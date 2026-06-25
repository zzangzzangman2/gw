local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fMinHpPercentWithCount)
for o=1,#a do
local a=a[o]
if a.HeroId~=e.CurrHeroCtrl.HeroId then
if a:CurrHPPer()<t[1]*MillionCoe and e.CurrHeroCtrl:CurrHPPer()>t[2]*MillionCoe then
local i=t[3]*MillionCoe
local o=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=o*i
local t=o*t[4]*MillionCoe
local t=a:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,false,{fobidHealRate=true,healResultLimit=EHealResultType.Heal})
if t and t.resultType==EHealResultType.Heal then
e.CurrHeroCtrl:ReduceHPSimple(o)
break
end
else
break
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

