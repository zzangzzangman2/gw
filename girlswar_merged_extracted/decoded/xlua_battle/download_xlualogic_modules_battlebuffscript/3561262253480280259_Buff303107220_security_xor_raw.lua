local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(e.CurrHeroCtrl:CurrHPPer()<t[1]*MillionCoe)then
local o=t[2]
local a=t[3]
local t={t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skillEndBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

