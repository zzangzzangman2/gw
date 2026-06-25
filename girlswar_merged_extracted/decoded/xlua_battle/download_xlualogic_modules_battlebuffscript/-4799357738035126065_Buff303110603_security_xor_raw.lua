local s=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,h,a,n)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if n.buffTriggerTime==BuffTriggerTime.attacked then
o.GeneratePowerPerseus(t,e[1],0)
o.AddBuffBloodThorn(t,i,1,e[5])
if t.CurrHeroCtrl.HeroBattleInfo:HasControlBuff()then
o.AddBuffThornBlade(t)
local n=e[4]
local a=0
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#i do
local e=i[e].HeroBattleInfo:GetBuff(n)
if e then
local e=e:GetFloors()
a=a+e
end
end
o.GeneratePowerPerseus(t,a*e[10],0)
end
elseif n.buffTriggerTime==BuffTriggerTime.hpChange then
if e[11]>0 and e[12]>0 then
if a.hpchangeType==EBattleHpChangeType.ReduceHp and s:IsNormalHurtType(a.heroHurtType)then
if a.currHP<a.oldHP then
e[19]=e[19]+(a.oldHP-a.currHP)
local a=math.floor(t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[11]*MillionCoe)
if e[19]>=a then
local i=math.floor(e[19]/a)
o.GeneratePowerPerseus(t,i*e[12],0)
e[19]=e[19]-i*a
end
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked
or e==BuffTriggerTime.afterSufferDmg)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GeneratePowerPerseus(e,a,l)
local t=e:GetBuffData()
if a<=0 then
return
end
if l~=1 then
if t[13]>0 then
local t=a/100*e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[13]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
local i=t[2]
local d=t[3]
local h={}
local r=0
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if n then
r=n:GetFloors()
end
local n=r+a
if n>=t[14]then
local a=math.floor(n/t[14])
o.GenerateSwordPerseus(e,1*a)
if l==1 then
local t=n-t[14]*a
if t>0 then
e.CurrHeroCtrl:AddBuffWithFinalFloor(e.CurrHeroCtrl,i,d,h,t)
end
else
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[15])
if a then
local a=a:GetFloors()
if(t[18]*a>=RandomMgr:GetBattleRandom())then
local t=e.CurrHeroCtrl.HeroId
local e=e.CurrHeroCtrl.BigSkillId
local o={
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
costMp=false,
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if a==nil then
local a={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
s:AddTriggerAttackTask(t,e,o,a)
end
end
end
end
else
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,d,h,a)
end
end
function a.GenerateSwordPerseus(e,a)
local t=e:GetBuffData()
local n=t[15]
local i=t[16]
local s={}
local t=t[17]
local o=o.GetSwordPerseusCount(e)
local o=math.max(0,o+a-t)
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,n,i,s,a,t)
return o
end
function a.GetSwordPerseusCount(e)
local a=e:GetBuffData()
local t=0
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a[15])
if e then
t=e:GetFloors()
end
return t
end
function a.ConsumeAllSwordPerseus(e)
local t=e:GetBuffData()
local t=t[15]
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
function a.AddBuffBloodThorn(t,a,o,i)
local e=t:GetBuffData()
local n=e[4]
local e={e[6],e[7]}
a:AddBuff(t.CurrHeroCtrl,n,i,e,o)
end
function a.AddBuffThornBlade(e)
local o=e:GetBuffData()
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eRandom,1)
local a=t[1]
if a then
local t=math.floor(a.HeroBattleInfo.MaxHP*o[8]*MillionCoe)
local o=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*o[9]*MillionCoe)
t=math.min(t,o)
a:RealHurtWithBuff(t,e,nil,0)
end
end
return o

