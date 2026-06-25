local i=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionBigSkill(e)
local t=e:GetBuffData()
local a=e.CurrHeroCtrl:GetFinalAtk()
local o=math.floor(a*t[1]*MillionCoe)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for t=1,#a do
local t=a[t]
t:HpHealthWithBuff(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
if e.CurrHeroCtrl:IsRealFirstRowHero()then
local o=t[2]
local a=t[3]
local t={t[4],t[5],t[6],t[7]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
local a=i:GetConCtrlHeroInTeam(e.CurrHeroCtrl,t[8])
for e=1,#a do
a[e].HeroBattleInfo:DispelAllGranBuff(false)
end
local e=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local e=math.floor(e*t[9]*MillionCoe)
return e
end
return n

