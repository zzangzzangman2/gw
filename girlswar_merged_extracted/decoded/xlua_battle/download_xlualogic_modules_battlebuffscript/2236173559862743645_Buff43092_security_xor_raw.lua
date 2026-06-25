local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if#e>=2 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
end
if#e>=4 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
end
elseif a.buffTriggerTime==BuffTriggerTime.skillAttack then
if#e>=7 then
if t.CurrHeroCtrl:CurrHPPer()>=e[5]*MillionCoe then
if(e[6]>=RandomMgr:GetBattleRandom())then
t.CurrHeroCtrl:AddFuryWithBuff(e[7])
end
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.skillAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

