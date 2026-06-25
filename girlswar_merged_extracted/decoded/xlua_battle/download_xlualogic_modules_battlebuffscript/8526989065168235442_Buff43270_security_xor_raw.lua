local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[2],e[3])
t.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[4],e[5])
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
e[9]=e[9]+1
if e[9]>=e[6]then
e[9]=0
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.fHollow)
table.insert(a,t.CurrHeroCtrl)
local o=RandomTableWithSeed(a,e[7])
for n=1,#o do
local s=t.buffId
local i=e[1]
local a={}
for t=1,8 do
table.insert(a,e[t])
end
table.insert(a,0)
local e=e[8]
o[n]:AddBuff(t.CurrHeroCtrl,s,i,a,e)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

