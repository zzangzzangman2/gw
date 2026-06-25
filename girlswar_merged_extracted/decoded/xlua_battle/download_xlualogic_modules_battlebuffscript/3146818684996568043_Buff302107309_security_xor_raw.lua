local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=302107312
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a or o.IsSupplementHero==false then
local i=t[1]
local n=t[2]
local o={t[3],t[4],t[5],t[6]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,n,o,1)
local o=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local o=math.floor(o*t[7]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
local t=t[8]
if a then
local e=a:GetBuffData()
t=e[1]
end
local a=e.CurrHeroCtrl.HeroBattleInfo.CurrFury
local t=math.floor(a*t*MillionCoe)
e.CurrHeroCtrl:AddFuryWithBuff(t)
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.teamHeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

