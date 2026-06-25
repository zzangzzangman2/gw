local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[1])
local a=0
if(o)then
a=o:GetFloors()
end
if a<t[5]then
local o=t[1]
local a=t[2]
local t={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
end
function a.GetCanTrigger(e)
return false
end
function a.SetLogicData(e,e)
end
return i

