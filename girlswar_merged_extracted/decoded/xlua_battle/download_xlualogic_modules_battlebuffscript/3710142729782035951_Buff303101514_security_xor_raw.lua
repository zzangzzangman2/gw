local i=require("Modules/Battle/Formula")
local e={}
local r=e
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
function e.DoBeansActionBigSkill(t,a)
local e=t:GetBuffData()
if a.HeroBattleInfo:HasGranOrUnGran(false)then
local o=math.floor(a:GetFinalDef()*e[6]*MillionCoe)
local i=i:GetInjureResData(a)
local i=math.floor(i.defFinalInjureResRate*e[8])
local n=e[1]
local s=e[2]
local h={e[5],o,e[7],e[8],e[9],e[10]}
a:AddBuff(t.CurrHeroCtrl,n,s,h)
local s=e[3]
local n=e[2]
local a={e[5],o}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,s,n,a)
local a=e[4]
local o=e[2]
local e={e[7],i}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
end
return r

