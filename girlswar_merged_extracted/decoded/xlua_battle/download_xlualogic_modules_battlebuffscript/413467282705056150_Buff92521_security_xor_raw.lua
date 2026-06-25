local n=require("Modules/Battle/BattleUtil")
local a={}
local d=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,o,s,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime~=BuffTriggerTime.afterAttacked then
return
end
if a==nil or o==nil then
return
end
if e.CurrHeroCtrl.HeroId==o.HeroId then
if a:IsPet()then
return
end
local o=e:GetFloors()
if o<=0 then
return
end
local r=t[1]
local h=t[2]
local o=t[5]
if o>=RandomMgr:GetBattleRandom()then
local i=t[3]
local s=t[4]
local h={}
a:AddBuff(e.CurrHeroCtrl,i,s,h)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t[5]=r
n:ReduceHeroBuffFloor(e.CurrHeroCtrl,e.buffId,1)
else
t[5]=math.min(o*2,h)
end
end
end
function a.GetCanTrigger(e)
if e==BuffTriggerTime.afterAttacked then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return d

