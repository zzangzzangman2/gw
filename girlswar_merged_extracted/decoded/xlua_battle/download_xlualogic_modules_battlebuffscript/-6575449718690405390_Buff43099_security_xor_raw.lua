local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,e)
end
function a.OnRemoveSelf(e,e)
end
function a.DoAction(e,t,o,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=e.CurrHeroCtrl.HeroId
if i==o.HeroId and a then
local a=a.criticalOrBlock
if a==0 then
local a=t[1]
local o=t[2]
local i={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,i)
local a=t[5]
local o=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

