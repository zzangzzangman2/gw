local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetSkillFireCount()
if a>t[2]then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(3132)
if a then
e.CurrHeroCtrl:ReduceFuryWithBuffImmediately(t[1])
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(3132,BuffRemoveType.Expire)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

