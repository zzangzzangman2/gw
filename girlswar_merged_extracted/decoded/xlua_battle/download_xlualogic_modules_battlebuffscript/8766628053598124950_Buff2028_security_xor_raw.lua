local e={}
local t=e
function e.OnAdd(e,t)
e.CurrHeroCtrl.WillEndImmuneNormalAndSmallSkill=false
e.CurrHeroCtrl.ImmuneNormalAndSmallSkill=true
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.IsZeroFloors=false
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl.WillEndImmuneNormalAndSmallSkill=true
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function e.OnOverlap(e,t)
e.CurrHeroCtrl.WillEndImmuneNormalAndSmallSkill=false
e.CurrHeroCtrl.ImmuneNormalAndSmallSkill=true
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.IsZeroFloors=false
end
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a)
local a=e.isFirstAdd==nil and true or e.isFirstAdd
if(a)then
e.isFirstAdd=false
end
t.CheckRemove(e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.afterNormalOrSmallSkillAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
function e.CheckRemove(e)
if(e.floors==0)then
local t=e.IsZeroFloors==nil and false or e.IsZeroFloors
if(not t)then
e.IsZeroFloors=true
e.CurrHeroCtrl.WillEndImmuneNormalAndSmallSkill=true
e.CurrHeroCtrl.HeroBattleInfo:TriggerBuff(BuffTriggerTime.removeBuff,nil,nil,{e.buffId,BuffRemoveType.Expire})
end
end
end
return t

