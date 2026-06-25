local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,o,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e.CurrHeroCtrl.HeroId
if a==o.HeroId then
local a=i.criticalOrBlock
local i=t[1]
if a==2 then
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if o then
local a=o:GetFloors()
if a>0 then
local t=math.ceil(a*t[6]*MillionCoe)
t=math.min(t,a)
o:ReduceFloors(t)
if a-t<=0 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
end
else
local a=t[2]
local o={t[3],t[4]}
local t=t[5]
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,i,a,o,1,t)
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

