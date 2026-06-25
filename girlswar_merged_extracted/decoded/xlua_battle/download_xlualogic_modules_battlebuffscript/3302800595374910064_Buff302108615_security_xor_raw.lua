local a={}
local l=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a,a,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
local o=e[2]
local a=e[4]
if t.CurrHeroCtrl:IsRealLastRowHero()then
o=math.floor(e[2]*e[5]*MillionCoe)
a=math.floor(e[4]*e[5]*MillionCoe)
end
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],o)
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],a)
elseif i.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local i=e[6]
local n=e[7]
local o={}
for t=8,13 do
table.insert(o,e[t])
end
for e=1,#a do
local e=a[e]
e:AddBuff(t.CurrHeroCtrl,i,n,o)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local o=e[15]
local h=e[16]
local s={e[17],e[18]}
local r=e[20]
local d=e[21]
local n={e[22],e[23]}
for i=1,#a do
local a=a[i]
if e[14]==a.profession then
a:AddBuff(t.CurrHeroCtrl,o,h,s)
elseif e[19]==a.profession then
a:AddBuff(t.CurrHeroCtrl,r,d,n)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return l

