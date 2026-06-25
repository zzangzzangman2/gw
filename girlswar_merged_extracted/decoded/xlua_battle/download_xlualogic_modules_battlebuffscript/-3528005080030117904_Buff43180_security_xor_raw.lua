local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e[4]*MillionCoe)
end
function t.OnRemoveSelf(e,a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
if t~=nil then
for o=1,#t do
local o=t[o]
local t=o.HeroBattleInfo:GetBuff(a[7])
if t then
local t=t:GetBuffData()
local t=t[1]
for a=1,#t do
local o=t[a]
if o[1]==e.CurrHeroCtrl.HeroId then
table.remove(t,a)
break
end
end
if#t<=0 then
o.HeroBattleInfo:RemoveBuffWithId(a[7],BuffRemoveType.Expire)
end
end
end
end
e.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(a[4]*MillionCoe)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a[5],BuffRemoveType.Expire)
end
function t.DoAction(e,t,n,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for i=1,#a do
o.AddHaloBuff(e,t,a[i])
end
local a=t[5]
local o=t[6]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
elseif a.buffTriggerTime==BuffTriggerTime.addEnemy then
o.AddHaloBuff(e,t,n)
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.addEnemy then
return true
end
return false
end
function t.AddHaloBuff(t,e,o)
local a=o.HeroBattleInfo:GetBuff(e[7])
if a then
local a=a:GetBuffData()
table.insert(a[1],{t.CurrHeroCtrl.HeroId,e[8]})
else
local n=e[7]
local i=e[9]
local a={{{t.CurrHeroCtrl.HeroId,e[8]}}}
for t=10,28 do
table.insert(a,e[t])
end
o:AddBuff(t.CurrHeroCtrl,n,i,a)
end
end
function t.SetLogicData(e,e)
end
return o 
