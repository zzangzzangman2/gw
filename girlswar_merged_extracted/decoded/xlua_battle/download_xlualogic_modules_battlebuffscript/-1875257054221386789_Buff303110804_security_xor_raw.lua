local s=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e[22]*MillionCoe)
end
function a.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(t[22]*MillionCoe)
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart
or a.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
if s.IsBigRoundStart(a.buffTriggerTime,t.CurrHeroCtrl)then
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[7]==1 then
n.hurtEnemey(t,e)
end
local i=e[14]
local o=e[15]
local a={}
local e=e[16]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,i,o,a,e,e)
end
elseif a.buffTriggerTime==BuffTriggerTime.skillComplete
or a.buffTriggerTime==BuffTriggerTime.buffDamageComplete then
if e[18]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[18]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[17]=0
end
local o=e[13]
local a=303110814
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local e=a:GetBuffData()
o=e[9]
end
if e[17]<o then
e[17]=e[17]+1
local a=e[10]
local i=e[11]
local o={math.floor(e[12]*e[19]*MillionCoe)}
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddShield(e)
else
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,o)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.enemyRoundStart
or e==BuffTriggerTime.skillComplete
or e==BuffTriggerTime.buffDamageComplete)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.hurtEnemey(a,e)
local r=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.enemyAll)
local t=e[19]
local o=math.floor(t*e[8]*MillionCoe)
if o<=e[20]then
return
end
local i=0
local h=e[5]
local t=303110813
local t=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local e=t:GetBuffData()
h=e[6]
end
local t=RandomTableWithSeed(r,h)
for h=1,#t do
local n=t[h]
local t=n.HeroBattleInfo:GetMaxHP()
local t=math.floor(t*e[6]*MillionCoe)
if o<=e[20]then
break
end
local o=o-e[20]
t=math.min(t,o)
if t>0 then
local a=s:AddSepsisHp(a.CurrHeroCtrl,n,t,true,true)
if a then
e[20]=e[20]+t
i=i+t
end
end
end
n.AddMaxHpBySepsis(a,i)
end
function a.AddMaxHpBySepsis(o,e)
local t=o:GetBuffData()
if e>0 then
local a=t[19]
local a=math.floor(a*t[9]*MillionCoe)
if a>t[21]then
local a=a-t[21]
e=math.min(e,a)
if e>0 then
t[21]=t[21]+e
o.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHP(e)
end
end
end
end
return n

