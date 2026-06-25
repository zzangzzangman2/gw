local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
GameInit.LogError("Buff30103205 heroBuffInfo or heroBuffInfo.CurrHeroCtrl == nil")
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
if#t>=4 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[4],t[5])
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local a={}
for t=1,#e do
if e[t].HeroBattleInfo:HasControlBuff()then
table.insert(a,e[t])
end
end
if#a>0 then
local e=RandomTableWithSeed(a,t[3])
for t=1,#e do
e[t].HeroBattleInfo:RemoveControlBuff()
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

