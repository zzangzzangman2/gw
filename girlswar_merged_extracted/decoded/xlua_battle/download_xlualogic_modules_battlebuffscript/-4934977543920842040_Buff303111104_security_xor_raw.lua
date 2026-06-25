local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a={
attrId=t[1],
value=t[2],
}
e.CurrHeroCtrl:AddAttrValueInCurAttack(a)
local t={
attrId=t[3],
value=t[4],
}
e.CurrHeroCtrl:AddAttrValueInCurAttack(t)
local e={
isOper=true,
isRemoveFloor=1,
}
return e
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skill2Play)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

