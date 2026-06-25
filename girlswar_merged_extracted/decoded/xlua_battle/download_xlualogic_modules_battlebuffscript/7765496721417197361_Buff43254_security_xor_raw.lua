local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.attacked then
local i=e[1]
local a=e[2]
local o={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,o)
local o=e[5]
local a=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
elseif a.buffTriggerTime==BuffTriggerTime.afterSufferDmg then
local a=t.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local o=i.hurtValue
e[12]=e[12]+o
if e[12]>=a*e[11]*MillionCoe then
e[12]=0
local a=e[13]
local o=e[14]
local e={e[15],e[16],0}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked
or e==BuffTriggerTime.afterSufferDmg)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

