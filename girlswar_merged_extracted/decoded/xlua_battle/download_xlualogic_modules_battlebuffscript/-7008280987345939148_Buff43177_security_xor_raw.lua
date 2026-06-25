local i=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,n,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.attack then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(43175)
if a then
local a=a:GetBuffData()
if a[10]<=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
if(t[1]>=RandomMgr:GetBattleRandom())then
local o=e.CurrHeroCtrl:GetFinalAtk()
local a=e.CurrHeroCtrl.HeroId
local e=1911101
local o={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
realhurt=math.floor(o*t[2]*MillionCoe),
skillParam=t
}
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,a)
if t==nil then
i:AddTriggerAttackTask(a,e,o,n)
end
end
end
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if(e.CurrHeroCtrl:CurrHPPer()<t[9]*MillionCoe)then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local t=math.floor(a*t[10]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attack
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

