local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t.CurrHeroCtrl:CurrHPPer()
if a<e[1]*MillionCoe then
local o=e[2]
local a=e[3]
local e={e[4],e[5],e[6],e[7],0}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
if a<e[8]*MillionCoe then
local n=e[9]
local i=e[10]
local o=e[12]
if a<e[17]*MillionCoe then
o=o+e[18]
end
local o={e[11],o}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,o)
local n=e[13]
local i=e[14]
local o=e[16]
if a<e[17]*MillionCoe then
o=o+e[19]
end
local e={e[15],o}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

