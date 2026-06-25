local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[1]
local t=t[2]
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,0)
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
end
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
return o

