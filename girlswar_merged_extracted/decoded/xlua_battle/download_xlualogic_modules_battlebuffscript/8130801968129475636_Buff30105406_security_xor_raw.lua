local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,e)
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if#e>=2 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
end
if#e>=4 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
end
if#e>=6 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[5],e[6])
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if e[7]and e[7]>0 then
if t.CurrHeroCtrl:IsUseSkillByRoundAndSkillType(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound,EBattleSkillType.SkillBig)==false then
t.CurrHeroCtrl:AddFuryWithBuff(e[7])
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

