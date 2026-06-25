local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.skillAttackComplete then
local a=e[1]
local o=0
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if i then
o=i:GetFloors()
end
local s=e[2]
local n={e[3],e[4]}
local i=e[5]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,a,s,n,1,i)
if e[6]>0 then
local o=e[6]
local i=e[7]
local a={e[8],e[9]}
local e=e[10]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,o,i,a,1,e)
end
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local i=a:GetFloors()
if i>o and#e>=14 then
for a=11,14,2 do
if e[a]>0 and i==e[a]then
t.CurrHeroCtrl:AddFuryWithBuffImmediately(e[a+1])
break
end
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttackComplete)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

