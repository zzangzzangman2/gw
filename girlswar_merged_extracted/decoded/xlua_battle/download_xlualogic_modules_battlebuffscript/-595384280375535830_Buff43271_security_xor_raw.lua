local o=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e[5]=e[5]or 0
if e[5]>=e[1]then
return
end
e[5]=e[5]+1
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[2]
a.value=e[3]
i.HeroBattleInfo:AddTempBuffValue(a)
local a=t.CurrHeroCtrl.HeroBattleInfo.SepsisHp
local e=math.floor(a*e[4]*MillionCoe)
o:ReduceSepsisHp(t.CurrHeroCtrl,t.CurrHeroCtrl,e,true,true)
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

