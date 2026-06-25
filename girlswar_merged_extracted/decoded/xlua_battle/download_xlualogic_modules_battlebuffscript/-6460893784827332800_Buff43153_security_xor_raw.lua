local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,o,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if t then
local e=t.HeroBattleInfo:GetBuff(e.buffId)
if e then
local e=e:GetBuffData()
if e[4]>=e[3]then
return
end
e[4]=e[4]+1
if(a[1]>=RandomMgr:GetBattleRandom())then
o:ReduceFuryWithBuffImmediately(a[2])
end
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

