local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,a,o,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=e.CurrHeroCtrl.HeroId
if i==a.HeroId then
local a=o.criticalOrBlock
if a==2 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t[12],BuffRemoveType.Expire)
else
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionSmallSkill(t,a)
local e=t:GetBuffData()
local n=e[1]
local i=e[2]
local o={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,o)
local o=e[5]*MillionCoe
local o=t.CurrHeroCtrl.HeroBattleInfo.MaxHP*o
t.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
t.CurrHeroCtrl:AddFuryWithBuff(e[6])
local o=e[7]
local n=e[8]
local i=e[9]
a:CheckAddBuff(o,t.CurrHeroCtrl,n,i,0)
local a=e[10]
local o=e[11]
local e={e[12],e[13],e[14],e[15]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
return s

