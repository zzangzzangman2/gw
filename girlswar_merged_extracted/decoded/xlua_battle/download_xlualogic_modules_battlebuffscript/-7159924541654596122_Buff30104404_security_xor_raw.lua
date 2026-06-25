local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=0
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[1])
if o~=nil then
a=o:GetFloors()
end
if a<t[5]then
local o=t[1]
local i=t[2]
local t={t[3],t[4]}
local a=a+1
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,t)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

