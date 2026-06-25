local l=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,h,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local o=e[1]
local n=e[2]
local a={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,n,a)
local a=e[5]
local n=e[6]
local o={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,n,o)
i.AddBuffDragonEye(t,e[14])
i.AddBuffDragonEyeListener(t)
t.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
elseif a.buffTriggerTime==BuffTriggerTime.removeMyMate
or a.buffTriggerTime==BuffTriggerTime.addEnemy then
i.AddBuffDragonEyeListener(t)
elseif a.buffTriggerTime==BuffTriggerTime.allHeroAfterSufferDmg then
local a=303102503
local n=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if n then
local s=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local a=h.HeroId
local o=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if o then
local i=o:CurrHPPer()
if e[22][a]~=true and i<=e[9]*MillionCoe then
s.RecordDeadCountWithCount(n,e[10])
e[22][a]=true
end
if e[23][a]~=true and i<=e[11]*MillionCoe then
s.RecordDeadCountWithCount(n,e[12])
e[23][a]=true
end
if o.IsOurHero==t.CurrHeroCtrl.IsOurHero and e[24][a]~=true and i<=e[13]*MillionCoe then
e[24][a]=true
local a=303102506
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local i=e:GetBuffData()
local a={
fury=o.HeroBattleInfo.CurrFury,
atk=o:GetFinalAtk()
}
t.TriggerInheritAction(e,i,a,ETriggerSkillAtkType.PursuitAttack)
end
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.removeMyMate
or e==BuffTriggerTime.addEnemy
or e==BuffTriggerTime.allHeroAfterSufferDmg)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffDragonEye(e,i)
local t=e:GetBuffData()
local o=t[15]
local n=t[16]
local a={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,n,a,i)
e.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,t[21],true)
end
function a.AddBuffDragonEyeWhenInherit(e)
local t=e:GetBuffData()
i.AddBuffDragonEye(e,t[20])
end
function a.AddBuffDragonEyeListener(e)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local o=303102523
local a=-1
local i={e.CurrHeroCtrl.HeroId}
for n=1,#t do
local t=t[n]
t:AddBuff(e.CurrHeroCtrl,o,a,i)
end
end
function a.DragonEyeDoLimitAction(e,i)
local o=e:GetBuffData()
local h=303102517
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(h)
if(t)then
local a=o[18]
local s=t:GetFloors()
if s>=a then
if(o[17]>=RandomMgr:GetBattleRandom())then
local r=e.CurrHeroCtrl.HeroId
local n=31025102
local o={
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
realhurt=math.floor(e.CurrHeroCtrl:GetFinalAtk()*o[19]*MillionCoe),
targetHeroId=i,
insertLevel=ETriggerSkillInsertLevel.DisruptAttack,
}
local d=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(n,r)
if d==nil then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
t:ReduceFloors(a)
l:AddTriggerAttackTask(r,n,o,e)
end
local t=303102518
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.AddBuffEvilEnergy(o,i)
end
local t=s-a
if t<=0 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(h,BuffRemoveType.Expire)
end
return true
end
end
end
return false
end
return i

