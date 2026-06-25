local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local i=t[1]
local o=t[2]
local a=303101513
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(a)then
local e=a:GetBuffData()
o=e[9]
end
local t={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,t)
end
function t.GetCanTrigger(e)
return false
end
function t.SetLogicData(e,e)
end
return n

