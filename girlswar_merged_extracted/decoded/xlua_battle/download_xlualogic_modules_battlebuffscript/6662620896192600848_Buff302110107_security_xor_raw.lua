local n=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
local a=n.GetOtherHeroInSameColumn(e.CurrHeroCtrl)
if e.CurrHeroCtrl:IsRealFirstRowHero()then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[3])
if a then
a.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[5])
end
else
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
if a then
a.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[4])
end
end
elseif i.buffTriggerTime==BuffTriggerTime.skillComplete
or i.buffTriggerTime==BuffTriggerTime.buffDamageComplete then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
o.AddGuardBuff(e,t)
o.AddImprovingCapacityBuff(e,t)
o.ImprovingHp(e,t)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillComplete
or e==BuffTriggerTime.buffDamageComplete)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddGuardBuff(a,e)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
local t={}
if#o>0 then
t=RandomTableWithSeed(o,e[6])
end
if#t<e[6]then
table.insert(t,a.CurrHeroCtrl)
end
local o=302110116
local i=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.AddGuardBuff(i,t)
else
local n=e[7]
local s=e[8]
local o={e[9],e[10],e[11],e[12]}
local i=e[13]
for e=1,#t do
local e=t[e]
local t=e.HeroBattleInfo:GetBuff(302110117)
if t==nil then
e:AddBuffWithMaxFloor(a.CurrHeroCtrl,n,s,o,1,i)
end
end
end
end
function a.AddImprovingCapacityBuff(t,e)
local a=t.CurrHeroCtrl:CurrHPPer()
if a<=e[14]*MillionCoe then
local o=e[15]
local a=e[16]
local e={e[17],e[18],e[19],e[20]}
t.CurrHeroCtrl:AddBuffAfterRemove(t.CurrHeroCtrl,o,a,e)
end
end
function a.ImprovingHp(t,e)
local a=t.CurrHeroCtrl:CurrHPPer()
if a<=e[21]*MillionCoe then
if e[25]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[25]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[24]=0
end
local a=e[23]
if(e[24]>=a)then
return nil
end
e[24]=e[24]+1
t.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
local a=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local e=math.floor(a*e[22]*MillionCoe)
t.CurrHeroCtrl:HpHealthWithBuffImmediately(e,EBattleSrcType.Buff,t.releaseHeroId,t.buffId,true)
end
end
return o

