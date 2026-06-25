local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,e)
end
function a.OnRemoveSelf(t,e)
local a=e[5]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
for a=1,#t do
local e=e[5]
t[a].HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
end
function a.DoAction(t,e,i,i,o,a)
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
elseif a.buffTriggerTime==BuffTriggerTime.beCriticalOrBlocked then
local a=o
if(a==1)then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
for o=1,#a do
local i=e[5]
local n=e[6]
local e={e[7],e[8]}
a[o]:AddBuff(t.CurrHeroCtrl,i,n,e)
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.beCriticalOrBlocked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

