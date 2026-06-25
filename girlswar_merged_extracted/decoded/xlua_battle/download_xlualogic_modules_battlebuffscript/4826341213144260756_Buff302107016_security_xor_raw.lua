local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
elseif a.buffTriggerTime==BuffTriggerTime.teamHeroDead or a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
local o=t[7]
local a=t[8]
local t={t[9],t[10]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t,1)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.enemyTeamHeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

