local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil then
GameInit.LogError("Buff30102004 heroBuffInfo or heroBuffInfo.CurrHeroCtrl == nil")
return
end
local a={
attrId=e[1],
value=e[2],
}
t.CurrHeroCtrl:AddAttrValueInBattle(a)
local a={
attrId=e[3],
value=e[4],
}
t.CurrHeroCtrl:AddAttrValueInBattle(a)
local a={
attrId=e[5],
value=e[6],
}
t.CurrHeroCtrl:AddAttrValueInBattle(a)
local e={
attrId=e[7],
value=e[8],
}
t.CurrHeroCtrl:AddAttrValueInBattle(e)
t.isExec=true
end
function a.GetCanTrigger(e)
if e==BuffTriggerTime.now then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

