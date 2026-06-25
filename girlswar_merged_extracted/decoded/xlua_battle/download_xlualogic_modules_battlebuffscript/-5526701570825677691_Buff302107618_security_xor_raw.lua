local t=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,a)
t:ShowBgEffectByBuff(e)
end
function e.OnRemoveSelf(e,a)
t:RemoveBgEffectByBuff(e)
end
function e.DoAction(e,e,e,e)
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
return a

