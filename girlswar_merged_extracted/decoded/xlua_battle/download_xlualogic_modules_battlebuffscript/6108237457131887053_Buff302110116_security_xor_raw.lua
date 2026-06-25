local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(t[1]*MillionCoe)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
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
function t.AddGuardBuff(t,a)
local e=t:GetBuffData()
local i=e[4]
local n=e[5]
local o={e[6],e[7],e[8],e[9]}
local s=e[10]
for e=1,#a do
local e=a[e]
local e=e:AddBuffWithMaxFloor(t.CurrHeroCtrl,i,n,o,1,s)
if e then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(302110108,BuffRemoveType.Expire)
end
end
end
return h

