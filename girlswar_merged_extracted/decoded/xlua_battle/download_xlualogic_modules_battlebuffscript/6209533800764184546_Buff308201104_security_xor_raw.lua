local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.DoLimitAction(e,t)
local a=t[1]*e:GetFloors()
local i=t[2]
local o=t[3]
local t={t[4],t[5],t[6]}
if a>0 then
local t=e.CurrHeroCtrl:CheckAddBuff(a,e.CurrHeroCtrl,i,o,t)
if t then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleAllBuffEffect()
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
return t
end
end
return false
end
return o

