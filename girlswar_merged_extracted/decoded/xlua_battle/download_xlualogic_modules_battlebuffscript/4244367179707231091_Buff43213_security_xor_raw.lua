local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.removeBuff then
local o=a[1]
local o=a[2]
local a=a[3]
if o==BuffRemoveType.Dispel and a then
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a and a:CheckHeroCanDoAction()and a:GetTeamId()~=e.CurrHeroCtrl:GetTeamId()then
local o=t[1]
local i=t[2]
local n={t[3],t[4]}
local t=t[5]
a:AddBuffWithMaxFloor(e.CurrHeroCtrl,o,i,n,1,t)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.removeBuff)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

