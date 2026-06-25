local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddReduceSepsisRate(e.buffId,t[17])
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveSepsisReduceRate(e.buffId)
end
function e.DoAction(t,e,i,i,i,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
a.AddBuffDeathCursei(t,e[5])
elseif o.buffTriggerTime==BuffTriggerTime.skill2Play then
e[18]=e[18]+1
if e[18]>=e[14]then
e[18]=0
a.AddBuffDeathCursei(t,e[15])
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skill2Play)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffDeathCursei(t,o)
local e=t:GetBuffData()
local a=e[16]
local a=a-e[19]
if a<=0 then
return
end
local a=math.min(o,a)
e[19]=e[19]+a
local e=t:GetBuffData()
local o=e[6]
local i=e[7]
local e={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,e,a)
end
function e.CheckCanRemain(e)
local t=false
local a=303111201
local a=e.HeroBattleInfo:GetBuff(303111201)
if a then
local a=303111205
local e=e.HeroBattleInfo:GetBuff(a)
if e then
t=true
end
end
return t
end
function e.CheckRefreshRemainsState(e)
local t=false
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for e=1,#o do
local e=o[e]
if a.CheckCanRemain(e)then
t=true
break
end
end
a.RefreshRemainsStae(e,t)
end
function e.RefreshRemainsStae(e,a)
local t=303111206
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for o=1,#e do
local e=e[o]
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.CheckSetPreviewRemainsState(e,a)
end
end
end
return a

