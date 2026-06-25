local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.CheckPlayBird(e)
local t=true
local e=e.HeroBattleInfo:GetBuff(302107315)
if e then
local e=e:GetBuffData()
if e and e[1]==1 then
t=false
end
end
return t
end
function e.RecordSmall(e,t)
local o=302107315
local a=e.HeroBattleInfo:GetBuff(o)
if a then
local e=a:GetBuffData()
e[1]=t
else
local a=-1
local t={t}
e:AddBuff(e,o,a,t)
end
end
return i

