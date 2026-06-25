local e={}
local h=e
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
function e.AddSuperIsolatedBuff(t,o,i)
local e=t:GetBuffData()
local s=e[2]
local n=e[3]
local a={}
for t=4,7 do
table.insert(a,e[t])
end
local e=o:CheckAddBuff(i,t.CurrHeroCtrl,s,n,a)
if e then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(302109002,BuffRemoveType.Expire)
end
end
return h

