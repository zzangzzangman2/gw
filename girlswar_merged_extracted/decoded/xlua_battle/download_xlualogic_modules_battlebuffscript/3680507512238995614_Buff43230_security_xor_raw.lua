local n=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ReduceMoonPhaseFloors(e,a)
local t=e:GetBuffData()
local i=t[1]
for a=1,a do
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if a then
local a=a:GetFloors()
if a==1 then
if t[29]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return
end
end
n:ReduceHeroBuffFloor(e.CurrHeroCtrl,i,1)
o.HandleMoonBuff(e,t)
end
end
end
function e.InitMoonPhase(e)
local t=e:GetBuffData()
local s=t[1]
local a=t[2]
local i={}
local n=t[3]
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,s,a,i,n)
o.HandleMoonBuff(e,t)
end
function e.HandleMoonBuff(t,e)
local i=e[5]
local s=e[9]
local o=e[14]
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(s,BuffRemoveType.Expire)
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
local a=e[1]
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetFloors()
if a==e[13]then
local a=e[15]
local i={e[16],e[17]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local a=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=math.floor(a*e[18]*MillionCoe)
n:ReduceSepsisHp(t.CurrHeroCtrl,t.CurrHeroCtrl,a,true,true)
e[29]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
elseif a>=e[4]then
local a=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,e)
else
local a=e[10]
local e={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,s,a,e)
end
if a==e[19]then
local e=e[20]*MillionCoe
local e=t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e
t.CurrHeroCtrl:HpHealthWithBuffImmediately(e,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
elseif a==e[21]then
t.CurrHeroCtrl:AddFuryWithBuff(e[22])
elseif a==e[23]then
t.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
local a=e[24]
local o=e[25]
local e={e[26],e[27],e[28]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
end
end
return o

