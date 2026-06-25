local s=require('Modules/BattleBuffScript/BuffPairTools')
local h=require("Modules/Battle/BattleUtil")
local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffShare(t)
local a=t:GetBuffData()
local e=t.CurrHeroCtrl.CurrBattleTeam:GetFrontOrBackHeros(false)
for o=1,#e do
local o=e[o]
if o.HeroId~=t.CurrHeroCtrl.HeroId then
local i=a[1]
local e=o.HeroBattleInfo:GetBuff(i)
if e==nil then
local n=a[2]
local e=s.GetDefaultHpChainData()
e.assumedamagePercent=a[3]
e.reduceDamagePercent=0
e.minHpPercent=a[4]
e.defHeroId=t.CurrHeroCtrl.HeroId
e.defBuffId=303112018
local e={e}
o:AddBuff(t.CurrHeroCtrl,i,n,e)
end
end
end
end
function e.RemoveBuffShare(e)
local o=e:GetBuffData()
local t=e.CurrHeroCtrl.CurrBattleTeam:GetFrontOrBackHeros(false)
for a=1,#t do
local t=t[a]
if t.HeroId~=e.CurrHeroCtrl.HeroId then
local e=o[1]
t.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
end
end
function e.OnAddBuffAlert(t)
local e=t:GetBuffData()
local o=e[5]
local a=e[6]
local i={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local o=e[9]
local a=e[10]
local e={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
n.OnRemoveSepsis(t)
end
function e.OnRemoveSepsis(e)
local t=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroBattleInfo.SepsisHp
local t=math.floor(a*t[13]*MillionCoe)
h:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,t,true,true)
end
return n

