local n=require("Modules/Battle/BattleUtil")
local a={}
local r=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,h,a,a,s)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if s.buffTriggerTime==BuffTriggerTime.now then
local o=e[5]
local i=e[6]
local a={e[7],e[8],e[9],0}
t.CurrHeroCtrl:AddBuffAfterRemove(t.CurrHeroCtrl,o,i,a)
local a=n.GetOtherHeroInSameColumn(t.CurrHeroCtrl)
if a then
local n=a.HeroBattleInfo:GetBuff(o)
if n==nil or n.releaseHeroId~=a.HeroId then
local e={e[7],e[8]}
a:AddBuffAfterRemove(t.CurrHeroCtrl,o,i,e)
end
end
local n=43155
local i=-1
local a={}
for o=10,14 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddOpponentTeamBuff(t.CurrHeroCtrl,n,i,a)
elseif s.buffTriggerTime==BuffTriggerTime.attacked then
local o=e[1]
local a=e[2]
local n=e[3]
local i={}
local e=e[4]
h:CheckAddBuff(o,t.CurrHeroCtrl,a,n,i,e)
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return r

