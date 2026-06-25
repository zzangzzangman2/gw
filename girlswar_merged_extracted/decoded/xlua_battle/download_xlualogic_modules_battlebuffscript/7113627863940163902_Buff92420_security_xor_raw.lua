local e=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
o.CheckHpChange(t,e)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
o.CheckHpChange(t,e)
if e[24]<e[21]then
local a=e[21]-e[24]
local a=math.min(e[20],a)
if e[23]==0 or e[23]+e[18]<=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[23]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
if a>0 then
local o=e[19]*MillionCoe*a*MillionCoe
e[24]=e[24]+a
t.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(o)
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.hpChange then
o.CheckHpChange(t,e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.hpChange)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.CheckHpChange(t,e)
local o=t.CurrHeroCtrl:CurrHPPer()
local a=nil
if o>=e[1]*MillionCoe then
a=1
else
a=2
end
if a~=e[22]then
if e[22]==1 then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e[2],BuffRemoveType.Expire)
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e[6],BuffRemoveType.Expire)
elseif e[22]==2 then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e[10],BuffRemoveType.Expire)
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e[14],BuffRemoveType.Expire)
end
if a==1 then
local o=e[2]
local a=e[3]
local i={e[4],e[5]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local o=e[6]
local a=e[7]
local e={e[8],e[9]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
elseif a==2 then
local i=e[10]
local o=e[11]
local a={e[12],e[13]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local o=e[14]
local a=e[15]
local e={e[16],e[17]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
e[22]=a
end
end
return o

