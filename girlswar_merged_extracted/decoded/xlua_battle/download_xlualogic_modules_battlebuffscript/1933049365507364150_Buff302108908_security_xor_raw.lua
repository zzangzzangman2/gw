local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoLimitAction(e,t,t)
local t=e:GetBuffData()
if#t<9 then
return false
end
if(t[7]>=RandomMgr:GetBattleRandom())then
e.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(true,t[8])
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if a then
ModulesInit.ProcedureNormalBattle.StealFury(e.CurrHeroCtrl,e.CurrHeroCtrl,t[9],EBattleSrcType.Buff)
end
return true
end
return false
end
return o

