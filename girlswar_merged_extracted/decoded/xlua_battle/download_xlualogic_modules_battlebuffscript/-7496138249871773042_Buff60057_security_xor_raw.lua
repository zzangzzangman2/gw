local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
local a=t[1]
local o=t[2]
local t={t[3]}
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.firstBigSkillEnd)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

