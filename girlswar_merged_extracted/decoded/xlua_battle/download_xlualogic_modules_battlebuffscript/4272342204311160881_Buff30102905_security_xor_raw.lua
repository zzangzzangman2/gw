local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,i,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a==nil then
return
end
local o=a.furyValue or 0
local n=a.operSrcType
local a=a.isDirect
if#t>=3 and i and type(o)=="number"and o>0 and a==true then
local a=t[1]
local n=t[2]
local t={t[3],o}
i:AddBuff(e.CurrHeroCtrl,a,n,t)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.ReduceFury)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return s

