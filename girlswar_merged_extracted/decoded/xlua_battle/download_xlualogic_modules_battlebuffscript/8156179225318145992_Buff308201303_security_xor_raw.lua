local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
if t[1]~=1 then
return
end
e.CurrHeroCtrl.ForbidSmallSkill=true
e.CurrHeroCtrl.FreezeBigSkill=true
end
function t.OnRemoveSelf(e,t)
if ModulesInit.ProcedureNormalBattle.isBattleEnd then
return
end
if t[1]~=1 then
return
end
e.CurrHeroCtrl.ForbidSmallSkill=false
e.CurrHeroCtrl.FreezeBigSkill=false
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[4],t[5])
e.isExec=true
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

