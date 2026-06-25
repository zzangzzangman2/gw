local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,a,e,e)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local e=0
if#o==1 then
e=a[2]
end
local e=a[1]*(1+e*MillionCoe)
e=DataUtil.GetBattleAttrCoe(HeroAttrId.tenacityRate,e)
e=DataUtil.BattleAttrClamp(HeroAttrId.tenacityRate,e*OneMillion)*MillionCoe
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,HeroAttrId.tenacityRate,e)
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return o

