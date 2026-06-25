local t=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,i,a,a,a,a)
local a=n.DoTreasureAction(e,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=t.GetOtherHeroInSameColumn(e.CurrHeroCtrl)
if t then
local o=92360
local e=t.HeroBattleInfo:GetBuff(o)
if(e)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
if t and t.DoTreasureAction then
local o=e:GetBuffData()
local e=t.DoTreasureAction(e,o)
a=a+e
end
end
end
if a>0 then
local o={}
if e and e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo and e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
table.insert(o,e.CurrHeroCtrl)
end
if t and t.HeroBattleInfo and t.HeroBattleInfo.CurrHP>0 then
table.insert(o,t)
end
for t=1,#o do
local t=o[t]
local o=t.HeroBattleInfo:GetMaxHP()
local a=math.floor(o*i[4]*a*MillionCoe)
t:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoTreasureAction(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return 0
end
if t[6]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return 0
end
t[6]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local a=t[5]
if a==0 or ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-a>=t[3]then
if(t[1]>=RandomMgr:GetBattleRandom())then
local e=e.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,t[2],true)
if#e>0 then
t[5]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
end
end
end
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return 0
end
local e=t[5]
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-e>=t[3]then
return 1
end
return 0
end
return n

