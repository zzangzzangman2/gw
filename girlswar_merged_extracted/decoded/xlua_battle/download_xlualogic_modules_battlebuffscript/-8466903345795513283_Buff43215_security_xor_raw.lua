local h=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:ClearDamageConvertData(e.buffId)
end
function e.DoAction(e,a,t,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t:IsPet()==false then
s.CheckAddDamageConvert(e,t.HeroId)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.OnDamageConvert(t,a,s)
local r=t:GetBuffData()
if a<=0 then
return
end
t.CurrHeroCtrl:ClearDamageConvertData(t.buffId)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=t.CurrHeroCtrl:GetMiddlePointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.Battle258UnderWearAbsorbDamageEffect,e.x,e.y,e.z,3,0,false,function()
end)
end
local n=1916101
local i=t.teamId
local o=t.CurrHeroCtrl:GetFinalAtk()
local o=math.floor(o*r[3]*MillionCoe)
a=math.min(a,o)
local a={defHeroId=s,reduceHpConvert=a}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndTeamId(n,i)
if o then
local t=o.skillData.damageList
local e=e.FindDamageData(t,a.defHeroId)
if e then
e.reduceHpConvert=e.reduceHpConvert+a.reduceHpConvert
else
table.insert(o.skillData.damageList,a)
end
else
local e={
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
teamId=t.teamId,
damageList={a},
insertLevel=ETriggerSkillInsertLevel.SysAttack,
}
h:AddTriggerTeamAttackTask(i,n,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function e.FindDamageData(e,a)
for t=1,#e do
local e=e[t]
if e.defHeroId==a then
return e
end
end
end
function e.CheckAddDamageConvert(e,a)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageConvertData(e.buffId)
if t[1]>=RandomMgr:GetBattleRandom()then
local t={
buffId=e.buffId,
reduceHpConvertRate=t[2],
damageResHeroId=e.CurrHeroCtrl.HeroId,
atkHeroId=a,
}
e.CurrHeroCtrl:AddDamageConvertData(t)
end
end
return s

