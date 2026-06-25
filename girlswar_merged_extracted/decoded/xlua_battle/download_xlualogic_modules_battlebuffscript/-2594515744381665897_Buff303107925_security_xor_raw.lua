local n=require("Modules/Battle/BattleUtil")
local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(e,t)
local t=303107924
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.RemoveMonmentAttr(e)
end
end
function t.DoAction(e,t,s,a,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=e:GetFloors()
if i.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if o<t[5]then
local o=a*t[3]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.CurrHeroCtrl.HeroId,e.buffId)
local t=math.floor(a*t[4]*MillionCoe)
n:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,t,true,true)
end
elseif i.buffTriggerTime==BuffTriggerTime.attacked then
if o>=t[5]then
local o=t[10]
local i=t[11]
local t=a*t[12]*MillionCoe
local t={t}
s:AddBuff(e.CurrHeroCtrl,o,i,t)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return h

