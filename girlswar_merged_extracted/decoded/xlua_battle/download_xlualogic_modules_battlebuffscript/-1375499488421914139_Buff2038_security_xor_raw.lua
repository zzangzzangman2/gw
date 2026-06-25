local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,e,a,t)
if(a==nil or t==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local a=e[1]
if(a>=RandomMgr:GetBattleRandom())then
local e=e[2]
t:ReduceFuryWithSkill(e,ModulesInit.ProcedureNormalBattle.GetHeroCtrl(o.releaseHeroId),EBattleSrcType.Buff,false)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.normalAttack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return o

