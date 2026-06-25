local i=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,n,s,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[6],t[7])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[8],t[9])
elseif o.buffTriggerTime==BuffTriggerTime.afterAttacked then
if e.CurrHeroCtrl.HeroId~=s.HeroId then
return
end
if n:IsPet()then
return
end
local o=a.hurtData
if o==nil then
return
end
local a=a.hurtValue
if a<=0 then
return
end
if t[1]==0 then
return
end
local a=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
if t[12]~=a then
t[11]=0
t[12]=a
end
if t[11]>=t[4]then
return
end
t[11]=t[11]+1
local s=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local n=math.floor(a*t[1]*MillionCoe)
local a=t[2]
local a=math.min(n,a)
local n=math.floor(a*t[3]*MillionCoe)
i:AddSepsisHp(s,e.CurrHeroCtrl,n,true,true)
local t=math.floor((o.needReduceShield+a)*t[5]*MillionCoe)
local o=e.CurrHeroCtrl:GetLastAttackHeroId()
e.CurrHeroCtrl.HeroBattleInfo:ReduceShield(t,o)
e.CurrHeroCtrl:RealHurtWithBuff(a,e)
end
end
function a.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

