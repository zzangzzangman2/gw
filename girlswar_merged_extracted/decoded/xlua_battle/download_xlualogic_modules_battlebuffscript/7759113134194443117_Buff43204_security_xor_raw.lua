local a={43206,43207,43208,43209}
local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(t[23]*MillionCoe)
end
function o.OnRemoveSelf(t,e)
t.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(e[23]*MillionCoe)
end
function o.DoAction(t,e,i,i,i,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.skill3Play
or o.buffTriggerTime==BuffTriggerTime.skill2Play
or o.buffTriggerTime==BuffTriggerTime.skillPlay then
if(e[6]>=RandomMgr:GetBattleRandom())then
local o={}
local i={}
for e=1,#a do
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a[e])
if t==nil then
table.insert(o,a[e])
else
table.insert(i,a[e])
end
end
if#o<=0 then
o=i
end
local o=RandomTableWithSeed(o,1)
local o=o[1]
if o==a[1]then
local a=e[7]
local o=e[8]
local e={e[9],e[10]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
elseif o==a[2]then
local o=e[11]
local a=e[12]
local e={e[13],e[14]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
elseif o==a[3]then
local a=e[15]
local o=e[16]
local e={e[17],e[18]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
elseif o==a[4]then
local o=e[19]
local a=e[20]
local e={e[21],e[22]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[24],e[25])
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.selfColumn)
if#a>0 then
for i=1,#a do
local n=43213
local s=2
local o={}
for t=1,5 do
table.insert(o,e[t])
end
a[i]:AddBuff(t.CurrHeroCtrl,n,s,o)
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.now)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

