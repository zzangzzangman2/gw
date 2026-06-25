local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=t[1]
e.CurrHeroCtrl:HpHealthSimpleImmediately(e.CurrHeroCtrl,t,EBattleSrcType.LockHp)
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skillComplete)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

