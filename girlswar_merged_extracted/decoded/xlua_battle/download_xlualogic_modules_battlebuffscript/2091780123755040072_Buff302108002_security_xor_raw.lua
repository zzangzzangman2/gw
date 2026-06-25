local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.DoLimitAction(e,t)
local o=t[1]
local a=t[2]
local i=t[3]
local n=0
local o=e.CurrHeroCtrl:CheckAddBuff(o,e.CurrHeroCtrl,a,i,n)
if o then
if e.CurrHeroCtrl then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
end
return false
else
if e.CurrHeroCtrl then
e.CurrHeroCtrl:RealHurtWithBuff(t[4],e,nil,nil,nil,nil,{notDead=true})
end
return true
end
end
return s

