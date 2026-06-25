local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local o=t[3]
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a~=nil then
local a=a:GetFloors()
local t={
attrId=t[1],
value=t[2]*a,
}
e.CurrHeroCtrl:AddAttrValueInCurAttack(t)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

