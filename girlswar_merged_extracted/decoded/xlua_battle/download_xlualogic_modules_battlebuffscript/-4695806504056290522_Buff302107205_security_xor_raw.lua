local h=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,r,i,n,s)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if s.buffTriggerTime==BuffTriggerTime.afterAttacked then
local o=e.CurrHeroCtrl.HeroId
if o==r.HeroId then
local o=n.reduceHpValue
local o=math.floor(o*t[1]*MillionCoe)
a.AddEnergy(e,t,o)
elseif o==i.HeroId then
if a.CheckBaseCondition(e,t)then
local o=t[4]
local o=e.CurrHeroCtrl.HeroId
local i=21072102
local t=a.GetSkillData(e,t)
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(i,o)
if e==nil then
h:AddTriggerAttackTask(o,i,t,n)
end
end
end
elseif s.buffTriggerTime==BuffTriggerTime.now then
a.AddEnergyByPercent(e,t[5])
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
local o=e[2]
local o=math.floor(o*i*MillionCoe)
a.AddEnergy(t,e,o)
end
function e.AddEnergy(a,e,t)
local o=e[2]
e[16]=math.min(e[16]+t,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function e.ReduceEnergy(a,e,t)
local i=e[2]
local o=e[16]
e[16]=math.max(o-t,0)
local o=o-e[16]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return o
end
function e.CheckBaseCondition(t,e)
if e[16]>0 then
return true
else
return false
end
end
function e.CheckCondition(t,e)
if a.CheckBaseCondition(t,e)then
if(t.CurrHeroCtrl:CurrHPPer()<e[3]*MillionCoe)then
return true
end
end
return false
end
function e.GetSkillData(e,t)
local e={
buffId=e.buffId,
}
return e
end
function e.HandleOnDoAction(t,e)
if a.CheckCondition(t,e)==false then
return false
end
return true
end
function e.ConsumeEnergyToAddHp(t)
local e=t:GetBuffData()
local s=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local i=t.CurrHeroCtrl.HeroBattleInfo.CurrHP
local n=math.max(0,math.floor(s*e[4]*MillionCoe)-i)
local o=false
if n>0 then
local a=a.ReduceEnergy(t,e,n)
if e[16]==0 then
local t=e[15]
if e[17]<t then
local t=math.max(0,math.floor(s*e[12]*MillionCoe)-i)
a=t
e[17]=e[17]+1
o=true
end
end
t.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,t.releaseHeroId,t.buffId,false,{fobidHealRate=true})
end
if o then
local o=e[6]
local n=e[7]
local i={e[8],e[9],e[10],e[11]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,n,i)
t.CurrHeroCtrl:AddFuryWithBuff(e[13])
a.AddEnergyByPercent(t,e[14])
end
end
return a

