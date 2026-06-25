local a=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.UsePotion(e)
local t=e:GetBuffData()
local o=e.CurrHeroCtrl.HeroBattleInfo.SepsisHp
local o=math.floor(o*t[1]*t[3]*MillionCoe)
a:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,o,true,true)
local t=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[2]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
return i

