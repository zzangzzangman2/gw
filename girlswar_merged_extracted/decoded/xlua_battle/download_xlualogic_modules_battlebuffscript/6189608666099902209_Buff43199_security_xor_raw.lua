local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,o,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.attack then
local a=o:CurrHPPer()
if a<e[1]*MillionCoe then
local a=e[2]
local n=e[3]
local i={e[4],e[5]}
o:AddBuff(t.CurrHeroCtrl,a,n,i)
local a=o.HeroBattleInfo:GetGranBuff(false)
local a=#a
if(a>0)then
local n=e[6]
local i=e[7]
local o={e[8],e[9]}
local e=e[10]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,n,i,o,a,e)
end
end
if a<e[11]*MillionCoe then
local i=e[12]
local n=e[13]
local o=e[15]
if a<e[20]*MillionCoe then
o=o+e[21]
end
local o={e[14],o}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,n,o)
local n=e[16]
local i=e[17]
local o=e[19]
if a<e[20]*MillionCoe then
o=o+e[22]
end
local e={e[18],o}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

