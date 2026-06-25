local r=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,n,o,h,s,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.afterAttacked then
local t=e.CurrHeroCtrl.HeroId
if t==o.HeroId then
elseif t==h.HeroId then
if a.CheckCondition(e,n)then
local a=e.CurrHeroCtrl.HeroId
local t=31012102
local o={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
defHeroIds={o.HeroId},
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if e==nil then
r:AddTriggerAttackTask(a,t,o,s)
end
end
end
elseif i.buffTriggerTime==BuffTriggerTime.now then
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddEnergyByPercent(t,i)
local e=t:GetBuffData()
local o=e[8]
local o=math.floor(o*i*MillionCoe)
a.AddEnergy(t,e,o)
end
function e.AddEnergy(o,e,a)
local t=e[8]
e[9]=math.min(e[9]+a,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function e.ReduceEnergy(t,e,o)
local i=e[8]
local a=e[9]
e[9]=math.max(a-o,0)
local a=a-e[9]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return a
end
function e.CheckCondition(t,e)
local t=e[7]
if e[10]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[10]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[11]=0
end
if e[11]<t then
return true
else
return false
end
end
function e.HandleOnDoAction(t,e)
if a.CheckCondition(t,e)==false then
return false
end
e[11]=e[11]+1
return true
end
function e.ConsumeEnergyToAddHp(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o.CurrHeroCtrl,BattleHeroType.fMinHpPercentWithCount)
if#e>0 then
local i=e[1]
local e=o:GetBuffData()
if i:CurrHPPer()<e[3]*MillionCoe then
local t=i.HeroBattleInfo.MaxHP
local t=math.floor(t*e[5]*MillionCoe)
local n=i.HeroBattleInfo:GetCanRecoveryHp()
t=math.min(t,n)
if t>0 then
local n=math.floor(t*e[4]*MillionCoe)
if n>0 then
local t=a.ReduceEnergy(o,e,t)
if t>0 then
local e=math.floor(t/e[4]*OneMillion)
if e>0 then
i:HpHealthWithBuff(e,EBattleSrcType.Buff,o.releaseHeroId,o.buffId,false,{fobidHealRate=true})
end
end
end
end
end
end
end
return a

