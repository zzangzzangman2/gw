local a=require("Modules/Battle/Formula")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffTotargetHero(n,e,t)
local o=a:GetInjureResData(n.CurrHeroCtrl)
local a=a:GetInjureResData(t)
local o=o.defFinalInjureResRate
local i=a.defFinalInjureResRate
local a=e[3]
if o>i then
local t=(o-i)*OneMillion*e[5]/e[4]
t=math.min(e[6],t)
a=a+t
end
local o=t.HeroBattleInfo:GetMaxHP()
local o=math.floor(o*a*MillionCoe)
local i=e[1]
local a=e[2]
local e={o,e[7]}
t:AddBuff(n.CurrHeroCtrl,i,a,e)
end
return s

