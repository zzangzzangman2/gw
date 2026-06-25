local i=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,h,s,a,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if n.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
if t[7]>0 then
o.GainPowerBuff(e,t[7],a)
end
elseif n.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
if h.IsOurHero==e.CurrHeroCtrl.IsOurHero then
local n={302109002,302109003,302109014,302109016}
if i:CheckHasOneBuff(s,n)then
o.GainPursuitOrderBuff(e,t[11],s,a)
end
end
elseif n.buffTriggerTime==BuffTriggerTime.addBuff then
if a.buffHeroId==e.CurrHeroCtrl.HeroId then
local n=a.addBuffId
if(i:IsCtlBuff(n))then
local o=t[5]
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local a=a:GetFloors()
if a>=t[8]then
local a=e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(n,BuffRemoveType.Dispel)
if a then
i:ReduceHeroBuffFloor(e.CurrHeroCtrl,o,t[8])
end
end
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.anyHeroSkillBeAttack
or e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GainPowerBuff(e,a,n)
local t=e:GetBuffData()
local s=t[5]
local h=t[6]
local r={}
local s=e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,s,h,r,a)
if s then
t[20]=t[20]+a
end
if n and o.CheckConditionBigSkill(e,t)then
local a=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.BigSkillId
if t and t>0 then
local o={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
costMp=false
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if e==nil then
i:AddTriggerAttackTask(a,t,o,n)
end
end
end
end
function a.GainPursuitOrderBuff(t,d,h,a)
local e=t:GetBuffData()
local r=e[9]
local n=e[10]
local s={}
local s=t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,r,n,s,d)
if a and o.CheckConditionSmallSkill(t,e)then
local o=t.CurrHeroCtrl.HeroId
local e=t.CurrHeroCtrl.SmallSkillId
if e and e>0 then
local t={
buffId=t.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
defHeroIds={h.HeroId},
}
local n=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,o)
if n==nil then
i:AddTriggerAttackTask(o,e,t,a)
end
end
end
if s then
e[19]=e[19]+1
if e[19]>e[13]then
e[19]=0
local i=e[14]
local o=e[15]
local a={}
for o=16,17 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
end
end
end
function a.CheckConditionSmallSkill(a,e)
local t=e[9]
local t=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
local a=0
if t then
a=t:GetFloors()
end
if a>=e[12]then
return true
end
return false
end
function a.CheckConditionBigSkill(t,e)
if e[20]>=e[18]then
return true
end
return false
end
function a.HandleOnDoAction(e,t,a)
if a.skillDid==e.CurrHeroCtrl.SmallSkillId then
if o.CheckConditionSmallSkill(e,t)then
local t=t[9]
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
local t=302109011
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local t={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
o.GainPowerBuff(e,1,t)
end
return true
end
elseif a.skillDid==e.CurrHeroCtrl.BigSkillId then
if o.CheckConditionBigSkill(e,t)then
t[20]=t[20]-t[18]
e.CurrHeroCtrl:ReduceMaxFury()
return true
end
end
return false
end
return o

