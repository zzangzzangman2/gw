local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneDebuffWithBuffList(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmuneDebuffWithBuffList(e.buffId)
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ImmuneDebuff(e)
local t=e:GetBuffData()
e:ReduceFloors(1)
if e:GetFloors()<=0 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
return true
end
return t

