local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneAvoidDeath(e.buffId)
e.CurrHeroCtrl:AddImmuneResurgence(e.buffId)
e.CurrHeroCtrl:AddImmuneLockHp(e.buffId)
end
function t.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:RemoveImmuneAvoidDeath(e.buffId)
e.CurrHeroCtrl:RemoveImmuneResurgence(e.buffId)
e.CurrHeroCtrl:RemoveImmuneLockHp(e.buffId)
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if e and e.HeroBattleInfo then
local a=t[1]
local t=e.HeroBattleInfo:GetBuff(a)
if t then
local o=t:GetFloors()
if o<=1 then
e.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
else
t:ReduceFloors(1)
end
end
end
end
end
function t.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

