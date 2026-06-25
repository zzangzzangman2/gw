local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(i,e,a,t)
if(a==nil or t==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local o=e[1]
if(o>=RandomMgr:GetBattleRandom())then
local e=e[2]
t:ReduceFuryWithSkill(e,ModulesInit.ProcedureNormalBattle.GetHeroCtrl(i.releaseHeroId),EBattleSrcType.Buff,false)
end
local o=e[3]
if(o>=RandomMgr:GetBattleRandom())then
local o=e[4]
local i=e[5]
local e={e[6]}
t:AddBuff(a,o,i,e)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return n

