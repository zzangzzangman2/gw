local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,s,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if e.CurrHeroCtrl:CurrHPPer()<t[1]*MillionCoe then
local o=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local o=math.floor(o*t[2]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
local n=t[3]
local i=t[4]
local o={t[5],t[6]}
e.CurrHeroCtrl:AddBuff(a,n,i,o)
local n=t[7]
local i=t[8]
local o={t[9],t[10]}
e.CurrHeroCtrl:AddBuff(a,n,i,o)
local o=t[11]
local t=t[12]
e.CurrHeroCtrl:AddBuff(a,o,t,0)
end
elseif o.buffTriggerTime==BuffTriggerTime.afterAttacked then
local a=e.CurrHeroCtrl.HeroId
if a==s.HeroId then
if e.CurrHeroCtrl:CurrHPPer()<t[1]*MillionCoe then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.selfColumn)
if(a)then
for o=1,#a do
local a=a[o]
local o=a.HeroBattleInfo:GetMaxHP()-a.HeroBattleInfo:GetCurrHP()
local o=math.floor(o*t[13]*MillionCoe)
a:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
a:AddFuryWithBuff(t[14])
end
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart or e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

