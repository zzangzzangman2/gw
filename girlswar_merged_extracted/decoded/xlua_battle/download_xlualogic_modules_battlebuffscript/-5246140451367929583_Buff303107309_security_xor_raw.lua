local a={}
local d=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,r)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=303107312
local s=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
local a=t[4]
local o=t[6]
local h=t[7]
local n=t[8]
local i=t[9]
if s then
local e=s:GetBuffData()
a=e[9]
o=e[10]
h=e[11]
n=e[12]
i=e[13]
end
if t[10]<i then
t[10]=t[10]+1
local i=t[1]
local s=t[2]
local t={t[3],a,t[5],o}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,s,t,1)
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=math.floor(t*h*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
local t=r.HeroBattleInfo.CurrFury
local t=math.floor(t*n*MillionCoe)
e.CurrHeroCtrl:AddFuryWithBuff(t)
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.teamHeroFakeDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return d

