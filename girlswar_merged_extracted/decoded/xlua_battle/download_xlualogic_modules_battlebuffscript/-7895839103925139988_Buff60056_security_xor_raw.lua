local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,o,i,e,t)
if t==nil or t.hurtValue==nil then
return
end
local i=t.hurtValue
local t=e.HeroBattleInfo.CurrHP
local t=t-i
if(t<=0)then
return nil
end
if(e:CurrHPPer()<o[1]*MillionCoe)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
local e=e:CurrHPPer()

end
e:ImmediatelyDeath()
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return n

