local e=require("Modules/Battle/Formula")
local n=0.0001
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,o,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2])
elseif a.buffTriggerTime==BuffTriggerTime.attack then
local i=e.CurrHeroCtrl
local a=e:GetFloors()
local a=a*t[3]
if a>=RandomMgr:GetBattleRandom()then
local a=i:GetFinalAtk()
local t=math.floor(a*t[4]*n)
o:RealHurtWithBuff(t,e)
end
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.attack then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

