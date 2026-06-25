local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,t,e,a)
if(e==nil or a==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local a=t[1]
if(a>=RandomMgr:GetBattleRandom())then
local t=t[2]
e:ReduceFuryWithSkill(t,ModulesInit.ProcedureNormalBattle.GetHeroCtrl(o.releaseHeroId),EBattleSrcType.Buff,false)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.normalAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]
end
return i

