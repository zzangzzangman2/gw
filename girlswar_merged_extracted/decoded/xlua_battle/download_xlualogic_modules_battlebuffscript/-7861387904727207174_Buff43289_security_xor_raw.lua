local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddImmunneCtrlBuffId(e.buffId)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:RemoveImmunneCtrlBuffId(e.buffId)
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl:AddFuryWithBuff(t[1])
if e:GetFloors()<=1 then
e.isExec=true
return{
ret=true,
remove=true
}
else
e:ReduceFloors(1)
return{
ret=true,
remove=false
}
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuffCheckCtrl)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

