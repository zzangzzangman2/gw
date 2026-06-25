local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=t[1]
local a=t[2]
local t={t[3],t[4]}
i:AddBuff(e.CurrHeroCtrl,o,a,t)
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return n

